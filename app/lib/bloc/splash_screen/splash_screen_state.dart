part of 'splash_screen_bloc.dart';

@immutable
class SplashScreenState {
  final bool initialized;
  final String? pushRoute;

  final double deltaLogoSize;

  const SplashScreenState({
    required this.initialized,
    required this.pushRoute,
    required this.deltaLogoSize,
  });

  const SplashScreenState.initial()
      : initialized = false,
        pushRoute = null,
        deltaLogoSize = 0;

  SplashScreenState copyWith({
    bool? initialized,
    String? pushRoute,
    double? deltaLogoSize,
  }) {
    return SplashScreenState(
      initialized: initialized ?? this.initialized,
      pushRoute: pushRoute,
      deltaLogoSize: deltaLogoSize ?? this.deltaLogoSize,
    );
  }
}
