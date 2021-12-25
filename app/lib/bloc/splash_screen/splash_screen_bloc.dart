import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:meta/meta.dart';

import '../../services/local_storage_service.dart';
import '../global/global_bloc.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

const double _maxLogoDeltaSize = 20.0;
const double _speed = 0.6;
const double _sinArgMultiplier = 2 * pi * _speed * 10 / 1000;

class SplashScreenBloc extends Bloc<_SplashScreenEvent, SplashScreenState> {
  final GlobalBloc _globalBloc;
  final LocalStorageService _localStorageService;

  late final Timer _timer;

  SplashScreenBloc({
    required GlobalBloc globalBloc,
    required LocalStorageService localStorageService,
  })  : _globalBloc = globalBloc,
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
    await Future.wait(<Future>[
      Future.delayed(const Duration(seconds: 3)),
      _initialize(),
    ]);
    _timer.cancel();
    emit(state.copyWith(initialized: true));
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
  Future<void> _initialize() async {
    InsanichessSettings? settings = await _localStorageService.readSettings();
    if (settings == null) {
      settings = const InsanichessSettings.defaults();
      await _localStorageService.saveSettings(settings);
    }
    _globalBloc.changeSettings(settings);
  }
}
