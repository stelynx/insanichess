import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

import '../../services/local_storage_service.dart';

part 'game_history_event.dart';
part 'game_history_state.dart';

class GameHistoryBloc extends Bloc<_GameHistoryEvent, GameHistoryState> {
  final LocalStorageService _localStorageService;

  GameHistoryBloc({
    required LocalStorageService localStorageService,
  })  : _localStorageService = localStorageService,
        super(const GameHistoryState.initial()) {
    on<_LoadGames>(_onLoadGames);

    add(const _LoadGames());
  }

  // Handlers

  FutureOr<void> _onLoadGames(
    _LoadGames event,
    Emitter<GameHistoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final List<InsanichessGame> games =
        await _localStorageService.getPlayedGames();

    emit(state.copyWith(isLoading: false, games: games));
  }
}
