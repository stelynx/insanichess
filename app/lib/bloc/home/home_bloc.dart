import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import '../../config/config.dart';
import '../../router/router.dart';
import '../../router/routes.dart';
import '../../services/backend_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../widgets/ic_drawer.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<_HomeEvent, HomeState> {
  final BackendService _backendService;

  final GlobalKey<ICDrawerState> drawerKey = GlobalKey<ICDrawerState>();

  late final Timer _refreshTimer;

  HomeBloc({
    required BackendService backendService,
  })  : _backendService = backendService,
        super(const HomeState.initial()) {
    on<_RefreshMiscData>(_onRefreshMiscData);

    _refreshTimer = Timer.periodic(
        Config.miscDataRefreshFrequency, (_) => add(const _RefreshMiscData()));

    add(const _RefreshMiscData());
  }

  @override
  Future<void> close() async {
    _refreshTimer.cancel();
    return super.close();
  }

  // Handlers

  FutureOr<void> _onRefreshMiscData(
    _RefreshMiscData event,
    Emitter<HomeState> emit,
  ) async {
    if (!ICRouter.isCurrentRoute(ICRoute.home)) return;

    final Either<BackendFailure, int> numberOfPlayersOnlineOrFailure =
        await _backendService.getNumberOfPlayersOnline();
    final Either<BackendFailure, int> numberOfGamesInProgressOrFailure =
        await _backendService.getNumberOfGamesInProgress();

    emit(state.copyWith(
      gamesInProgress: numberOfGamesInProgressOrFailure.isError()
          ? null
          : numberOfGamesInProgressOrFailure.value,
      onlinePlayers: numberOfPlayersOnlineOrFailure.isError()
          ? null
          : numberOfPlayersOnlineOrFailure.value,
    ));
  }
}
