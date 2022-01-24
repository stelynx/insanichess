import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../services/backend_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';

part 'join_game_with_id_event.dart';
part 'join_game_with_id_state.dart';

class JoinGameWithIdBloc
    extends Bloc<_JoinGameWithIdEvent, JoinGameWithIdState> {
  final BackendService _backendService;

  JoinGameWithIdBloc({
    required BackendService backendService,
  })  : _backendService = backendService,
        super(const JoinGameWithIdState.initial()) {
    on<_IdChanged>(_onIdChanged);
    on<_Join>(_onJoin);
  }

  // Public API

  void changeId(String value) => add(_IdChanged(value));
  void join() => add(const _Join());

  // Handlers

  FutureOr<void> _onIdChanged(
    _IdChanged event,
    Emitter<JoinGameWithIdState> emit,
  ) async {
    emit(state.copyWith(gameId: event.value));
  }

  FutureOr<void> _onJoin(
    _Join event,
    Emitter<JoinGameWithIdState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final Either<BackendFailure, void> nullOrFailure =
        await _backendService.acceptChallenge(state.gameId);
    if (nullOrFailure.isError()) {
      emit(state.copyWith(
        isLoading: false,
        backendFailure: nullOrFailure.error,
        joiningSuccessful: false,
      ));
      return;
    }

    emit(state.copyWith(isLoading: false, joiningSuccessful: true));
  }
}
