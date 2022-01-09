part of 'splash_screen_bloc.dart';

@immutable
class SplashScreenState {
  final bool initialized;
  final bool? authenticated;

  final double deltaLogoSize;

  const SplashScreenState({
    required this.initialized,
    required this.authenticated,
    required this.deltaLogoSize,
  });

  const SplashScreenState.initial()
      : initialized = false,
        authenticated = null,
        deltaLogoSize = 0;

  SplashScreenState copyWith({
    bool? initialized,
    bool? authenticated,
    double? deltaLogoSize,
  }) {
    return SplashScreenState(
      initialized: initialized ?? this.initialized,
      authenticated: authenticated,
      deltaLogoSize: deltaLogoSize ?? this.deltaLogoSize,
    );
  }
}
