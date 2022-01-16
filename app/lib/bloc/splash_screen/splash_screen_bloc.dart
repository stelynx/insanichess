import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

import '../../router/routes.dart';
import '../../services/backend_service.dart';
import '../../services/local_storage_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../global/global_bloc.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

const double _maxLogoDeltaSize = 20.0;
const double _speed = 0.6;
const double _sinArgMultiplier = 2 * pi * _speed * 10 / 1000;

class SplashScreenBloc extends Bloc<_SplashScreenEvent, SplashScreenState> {
  final GlobalBloc _globalBloc;
  final BackendService _backendService;
  final LocalStorageService _localStorageService;

  late final Timer _timer;

  SplashScreenBloc({
    required GlobalBloc globalBloc,
    required BackendService backendService,
    required LocalStorageService localStorageService,
  })  : _globalBloc = globalBloc,
        _backendService = backendService,
        _localStorageService = localStorageService,
        super(const SplashScreenState.initial()) {
    on<_Initialize>(_onInitialize);
    on<_TimerTick>(_onTimerTick);

    _timer = Timer.periodic(
      const Duration(milliseconds: 10),
      (_) => add(const _TimerTick()),
    );

    add(const _Initialize());
  }

  @override
  Future<void> close() async {
    _timer.cancel();
    return super.close();
  }

  // Handlers

  FutureOr<void> _onInitialize(
    _Initialize event,
    Emitter<SplashScreenState> emit,
  ) async {
    final List results = await Future.wait(<Future>[
      _initialize(),
      Future.delayed(const Duration(seconds: 2)),
    ]);
    _timer.cancel();
    emit(state.copyWith(
      initialized: true,
      pushRoute: results.first,
    ));
  }

  FutureOr<void> _onTimerTick(
    _TimerTick event,
    Emitter<SplashScreenState> emit,
  ) async {
    emit(state.copyWith(
      deltaLogoSize:
          _maxLogoDeltaSize * 0.5 * (2 + sin(_sinArgMultiplier * _timer.tick)),
    ));
  }

  // Helpers

  Future<String> _initialize() async {
    String? jwtToken = await _localStorageService.readJwtToken();
    if (jwtToken == null) {
      return ICRoute.signIn;
    }
    _globalBloc.updateJwtToken(jwtToken);

    final Either<BackendFailure, InsanichessPlayer?> playerOrFailure =
        await _backendService.getPlayerMyself();
    if (playerOrFailure.isError()) return ICRoute.signIn;
    if (!playerOrFailure.hasValue()) return ICRoute.playerRegistration;
    _globalBloc.updatePlayerMyself(playerOrFailure.value!);

    final Either<BackendFailure, InsanichessSettings> settingsOrFailure =
        await _backendService.getSettings();
    if (settingsOrFailure.isError()) {
      _globalBloc.reset();
      return ICRoute.signIn;
    }
    _globalBloc.changeSettings(settingsOrFailure.value);

    return ICRoute.home;
  }
}
