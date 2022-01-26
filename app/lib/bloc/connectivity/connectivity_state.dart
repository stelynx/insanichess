part of 'connectivity_bloc.dart';

class ConnectivityState {
  final bool initial;
  final bool hasConnection;

  const ConnectivityState({
    required this.initial,
    required this.hasConnection,
  });

  const ConnectivityState.initial()
      : initial = true,
        hasConnection = true;

  ConnectivityState copyWith({bool? hasConnection}) {
    return ConnectivityState(
      initial: false,
      hasConnection: hasConnection ?? this.hasConnection,
    );
  }
}
