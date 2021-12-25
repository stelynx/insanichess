part of 'splash_screen_bloc.dart';

@immutable
class SplashScreenState {
  final bool initialized;

  final double deltaLogoSize;

  const SplashScreenState({
    required this.initialized,
    required this.deltaLogoSize,
  });

  const SplashScreenState.initial()
      : initialized = false,
        deltaLogoSize = 0;

  SplashScreenState copyWith({
    bool? initialized,
    double? deltaLogoSize,
  }) {
    return SplashScreenState(
      initialized: initialized ?? this.initialized,
      deltaLogoSize: deltaLogoSize ?? this.deltaLogoSize,
    );
  }
}
