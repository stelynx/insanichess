import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

import '../../services/backend_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../util/failures/failure.dart';
import '../../util/failures/validation_failure.dart';
import '../global/global_bloc.dart';

part 'player_registration_event.dart';
part 'player_registration_state.dart';

class PlayerRegistrationBloc
    extends Bloc<_PlayerRegistrationEvent, PlayerRegistrationState> {
  final BackendService _backendService;
  final GlobalBloc _globalBloc;

  PlayerRegistrationBloc({
    required BackendService backendService,
    required GlobalBloc globalBloc,
  })  : _backendService = backendService,
        _globalBloc = globalBloc,
        super(const PlayerRegistrationState.initial()) {
    on<_UsernameChanged>(_onUsernameChanged);
    on<_SubmitRegister>(_onSubmitRegister);
  }

  // Public API

  void changeUsername(String value) => add(_UsernameChanged(value));
  void submit() => add(const _SubmitRegister());

  // Handlers

  FutureOr<void> _onUsernameChanged(
    _UsernameChanged event,
    Emitter<PlayerRegistrationState> emit,
  ) async {
    emit(state.copyWith(username: event.value));
  }

  FutureOr<void> _onSubmitRegister(
    _SubmitRegister event,
    Emitter<PlayerRegistrationState> emit,
  ) async {
    if (!InsanichessValidator.isValidUsername(state.username)) {
      emit(state.copyWith(failure: const UsernameValidationFailure()));
      return;
    }

    emit(state.copyWith(isLoading: true));

    final Either<BackendFailure, InsanichessPlayer> playerOrFailure =
        await _backendService.createPlayer(username: state.username);

    if (playerOrFailure.isError()) {
      emit(state.copyWith(
        isLoading: false,
        isRegistrationSuccessful: false,
        failure: playerOrFailure.error,
      ));
      return;
    }

    _globalBloc.updatePlayerMyself(playerOrFailure.value);

    emit(state.copyWith(isLoading: false, isRegistrationSuccessful: true));

    await _backendService.notifyPlayerOnline(
      playerOrFailure.value,
      isOnline: true,
    );
  }
}
