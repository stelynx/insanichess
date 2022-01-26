import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../services/connectivity_service.dart';
import '../../services/http_service.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<_ConnectivityEvent, ConnectivityState> {
  static ConnectivityBloc? _instance;
  static ConnectivityBloc get instance => _instance!;

  ConnectivityBloc._({
    required ConnectivityService connectivityService,
    required HttpService httpService,
    required GlobalKey<NavigatorState> navigatorKey,
  })  : _connectivityService = connectivityService,
        _httpService = httpService,
        _navigatorKey = navigatorKey,
        super(const ConnectivityState.initial()) {
    on<_UpdateInternetConnection>(_onUpdateInternetConnection);
    on<_ServerUnreachable>(_onServerUnreachable);

    _connectivityService.addOnConnectivityChangedHandler((bool hasConnection) =>
        add(_UpdateInternetConnection(hasConnection: hasConnection)));

    _httpService.failedRequestStream
        .listen((_) => add(const _ServerUnreachable()));

    add(const _UpdateInternetConnection(ignorePop: true));
  }

  factory ConnectivityBloc({
    required ConnectivityService connectivityService,
    required HttpService httpService,
    required GlobalKey<NavigatorState> navigatorKey,
  }) {
    if (_instance != null) {
      throw StateError('ConnectivityBloc already created');
    }

    _instance = ConnectivityBloc._(
      connectivityService: connectivityService,
      httpService: httpService,
      navigatorKey: navigatorKey,
    );
    return _instance!;
  }

  final ConnectivityService _connectivityService;
  final HttpService _httpService;
  final GlobalKey<NavigatorState> _navigatorKey;

  late final StreamSubscription<void> _serverFailureStreamSubscription;

  @override
  Future<void> close() async {
    await _connectivityService.stop();
    await _serverFailureStreamSubscription.cancel();
    return super.close();
  }

  // Handlers

  FutureOr<void> _onUpdateInternetConnection(
    _UpdateInternetConnection event,
    Emitter<ConnectivityState> emit,
  ) async {
    final bool hasConnection =
        event.hasConnection ?? await _connectivityService.hasConnection();

    if (_navigatorKey.currentContext != null &&
        _navigatorKey.currentState != null) {
      if (hasConnection) {
        if (Platform.isAndroid) {
          if (!event.ignorePop && !state.initial) {
            _navigatorKey.currentState!.pop();
          } else {
            emit(const ConnectivityState.initial());
            return;
          }
        } else {
          if (!event.ignorePop) {
            _navigatorKey.currentState!.pop();
          }
        }
      } else {
        showCupertinoDialog(
          context: _navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (BuildContext context) => const CupertinoAlertDialog(
            title: Text('No internet connection'),
            content: Text('Insanichess requires internet connection to work'),
          ),
        );
      }
    }

    emit(state.copyWith(hasConnection: hasConnection));
  }

  FutureOr<void> _onServerUnreachable(
    _ServerUnreachable event,
    Emitter<ConnectivityState> emit,
  ) async {
    if (_navigatorKey.currentContext != null &&
        _navigatorKey.currentState != null) {
      showCupertinoDialog(
        context: _navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) => const CupertinoAlertDialog(
          title: Text('Server unreachable'),
          content: Text(
            'Server is currently down for maintenance. Please try again later.',
          ),
        ),
      );
    }

    emit(state.copyWith());
  }
}
