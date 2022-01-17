import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../services/local_storage_service.dart';
import '../../widgets/ic_drawer.dart';
import '../global/global_bloc.dart';

part 'online_play_event.dart';
part 'online_play_state.dart';

class OnlinePlayBloc extends Bloc<_OnlinePlayEvent, OnlinePlayState> {
  final LocalStorageService _localStorageService;
  final GlobalBloc _globalBloc;

  final GlobalKey<ICDrawerState> drawerKey = GlobalKey<ICDrawerState>();

  final List<InsanichessTimeControl> availableTimeControls =
      const <InsanichessTimeControl>[
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
    required LocalStorageService localStorageService,
    required GlobalBloc globalBloc,
  })  : _localStorageService = localStorageService,
        _globalBloc = globalBloc,
        super(OnlinePlayState.initial(
          challengePreference: globalBloc.state.challengePreference,
        )) {
    on<_ToggleEditingTimeControl>(_onToggleEditingTimeControl);
    on<_ToggleEditingPreferColor>(_onToggleEditingPreferColor);
    on<_TimeControlChanged>(_onTimeControlChanged);
    on<_PreferredColorChanged>(_onPreferredColorChanged);
    on<_ChallengeCreated>(_onChallengeCreated);
  }

  // Public API

  void toggleEditingTimeControl() => add(const _ToggleEditingTimeControl());
  void toggleEditingPreferColor() => add(const _ToggleEditingPreferColor());
  void changeTimeControl(InsanichessTimeControl value) =>
      add(_TimeControlChanged(value));
  void changePreferredColor(insanichess.PieceColor? value) =>
      add(_PreferredColorChanged(value));
  void createChallenge() => add(const _ChallengeCreated());

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
    final InsanichessChallenge challenge = InsanichessChallenge(
      createdBy: _globalBloc.state.playerMyself!.username,
      timeControl: state.timeControl,
      preferColor: state.preferColor,
      isPrivate: true,
    );

    await _localStorageService.saveChallengePreferences(challenge: challenge);
  }
}
