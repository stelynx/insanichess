part of 'connectivity_bloc.dart';

@immutable
abstract class _ConnectivityEvent {
  const _ConnectivityEvent();
}

class _UpdateInternetConnection extends _ConnectivityEvent {
  final bool ignorePop;
  final bool? hasConnection;

  const _UpdateInternetConnection({this.hasConnection, this.ignorePop = false});
}

class _ServerUnreachable extends _ConnectivityEvent {
  const _ServerUnreachable();
}
