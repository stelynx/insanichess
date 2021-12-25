part of 'splash_screen_bloc.dart';

@immutable
abstract class _SplashScreenEvent {
  const _SplashScreenEvent();
}

class _Initialize extends _SplashScreenEvent {
  const _Initialize();
}

class _TimerTick extends _SplashScreenEvent {
  const _TimerTick();
}
