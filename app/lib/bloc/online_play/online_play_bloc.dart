import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../services/backend_service.dart';
import '../../services/local_storage_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../widgets/ic_drawer.dart';
import '../global/global_bloc.dart';

part 'online_play_event.dart';
part 'online_play_state.dart';

class OnlinePlayBloc extends Bloc<_OnlinePlayEvent, OnlinePlayState> {
  final BackendService _backendService;
  final LocalStorageService _localStorageService;
  final GlobalBloc _globalBloc;

  final GlobalKey<ICDrawerState> drawerKey = GlobalKey<ICDrawerState>();

  static const List<InsanichessTimeControl> availableTimeControls =
      <InsanichessTimeControl>[
    InsanichessTimeControl(
      initialTime: Duration(minutes: 1),
      incrementPerMove: Duration.zero,
    ),
    InsanichessTimeControl(
      initialTime: Duration(minutes: 2),
      incrementPerMove: Duration(seconds: 1),
    ),
    InsanichessTimeControl(
      initialTime: Duration(minutes: 3),
      incrementPerMove: Duration.zero,
    ),
    InsanichessTimeControl(
      initialTime: Duration(minutes: 3),
      incrementPerMove: Duration(seconds: 2),
    ),
    InsanichessTimeControl(
      initialTime: Duration(minutes: 5),
      incrementPerMove: Duration(seconds: 3),
    ),
    InsanichessTimeControl(
      initialTime: Duration(minutes: 10),
      incrementPerMove: Duration.zero,
    ),
    InsanichessTimeControl(
      initialTime: Duration(minutes: 10),
      incrementPerMove: Duration(seconds: 15),
    ),
    InsanichessTimeControl(
      initialTime: Duration(minutes: 15),
      incrementPerMove: Duration(seconds: 10),
    ),
    InsanichessTimeControl(
      initialTime: Duration(minutes: 25),
      incrementPerMove: Duration(seconds: 0),
    ),
  ];

  OnlinePlayBloc({
    required BackendService backendService,
    required LocalStorageService localStorageService,
    required GlobalBloc globalBloc,
  })  : _backendService = backendService,
        _localStorageService = localStorageService,
        _globalBloc = globalBloc,
        super(OnlinePlayState.initial(
          challengePreference: globalBloc.state.challengePreference,
        )) {
    on<_ToggleEditingTimeControl>(_onToggleEditingTimeControl);
    on<_ToggleEditingPreferColor>(_onToggleEditingPreferColor);
    on<_IsPublicToggled>(_onIsPublicToggled);
    on<_TimeControlChanged>(_onTimeControlChanged);
    on<_PreferredColorChanged>(_onPreferredColorChanged);
    on<_ChallengeCreated>(_onChallengeCreated);
    on<_ShowChallengeDeclinedToast>(_onShowChallengeDeclinedToast);
    on<_HideChallengeDeclinedToast>(_onHideChallengeDeclinedToast);
  }

  // Public API

  void toggleEditingTimeControl() => add(const _ToggleEditingTimeControl());
  void toggleEditingPreferColor() => add(const _ToggleEditingPreferColor());
  void toggleIsPublic() => add(const _IsPublicToggled());
  void changeTimeControl(InsanichessTimeControl value) =>
      add(_TimeControlChanged(value));
  void changePreferredColor(insanichess.PieceColor? value) =>
      add(_PreferredColorChanged(value));
  void createChallenge() => add(const _ChallengeCreated());
  void showChallengeDeclinedToast() => add(const _ShowChallengeDeclinedToast());
  void hideChallengeDeclinedToast() => add(const _HideChallengeDeclinedToast());

  // Handlers

  FutureOr<void> _onToggleEditingTimeControl(
    _ToggleEditingTimeControl event,
    Emitter<OnlinePlayState> emit,
  ) async {
    emit(state.copyWith(editingTimeControl: !state.editingTimeControl));
  }

  FutureOr<void> _onToggleEditingPreferColor(
    _ToggleEditingPreferColor event,
    Emitter<OnlinePlayState> emit,
  ) async {
    emit(state.copyWith(editingPreferColor: !state.editingPreferColor));
  }

  FutureOr<void> _onIsPublicToggled(
    _IsPublicToggled event,
    Emitter<OnlinePlayState> emit,
  ) async {
    emit(state.copyWith(isPrivate: !state.isPrivate));
  }

  FutureOr<void> _onTimeControlChanged(
    _TimeControlChanged event,
    Emitter<OnlinePlayState> emit,
  ) async {
    emit(state.copyWith(timeControl: event.value));
  }

  FutureOr<void> _onPreferredColorChanged(
    _PreferredColorChanged event,
    Emitter<OnlinePlayState> emit,
  ) async {
    emit(state.copyWith(
      preferColor: event.value,
      preferNoColor: event.value == null,
    ));
  }

  FutureOr<void> _onChallengeCreated(
    _ChallengeCreated event,
    Emitter<OnlinePlayState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      editingPreferColor: false,
      editingTimeControl: false,
    ));

    final InsanichessChallenge challenge = InsanichessChallenge(
      createdBy: null, // Backend will add this data
      timeControl: state.timeControl,
      preferColor: state.preferColor,
      isPrivate: state.isPrivate,
      status: ChallengeStatus.initiated,
    );

    _globalBloc.updateChallengePreference(challenge);
    await _localStorageService.saveChallengePreferences(challenge: challenge);

    // In case this is a public challenge and the matching challenge was found,
    // this will contain the id of the accepted challenge.
    final Either<BackendFailure, String> createdOrAcceptedChallengeIdOrFailure =
        await _backendService.createChallenge(challenge);
    if (createdOrAcceptedChallengeIdOrFailure.isError()) {
      emit(state.copyWith(
        isLoading: false,
        backendFailure: createdOrAcceptedChallengeIdOrFailure.error,
      ));
      return;
    }

    if (state.isPrivate) {
      emit(state.copyWith(
        isLoading: false,
        createdChallengeId: createdOrAcceptedChallengeIdOrFailure.value,
      ));
      return;
    }

    // Check if the status of the challenge is accepted.
    final Either<BackendFailure, InsanichessChallenge> challengeInfoOrFailure =
        await _backendService
            .getChallenge(createdOrAcceptedChallengeIdOrFailure.value);
    if (challengeInfoOrFailure.isError()) {
      emit(state.copyWith(
        isLoading: false,
        backendFailure: challengeInfoOrFailure.error,
      ));
      return;
    }

    emit(state.copyWith(
      isLoading: false,
      createdChallengeId: createdOrAcceptedChallengeIdOrFailure.value,
      publicChallengePreaccepted:
          challengeInfoOrFailure.value.status == ChallengeStatus.accepted,
    ));
    return;
  }

  FutureOr<void> _onShowChallengeDeclinedToast(
    _ShowChallengeDeclinedToast event,
    Emitter<OnlinePlayState> emit,
  ) async {
    emit(state.copyWith(challengeDeclined: true));
  }

  FutureOr<void> _onHideChallengeDeclinedToast(
    _HideChallengeDeclinedToast event,
    Emitter<OnlinePlayState> emit,
  ) async {
    emit(state.copyWith(challengeDeclined: false));
  }
}
