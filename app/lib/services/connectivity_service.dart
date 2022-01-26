import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  static ConnectivityService? _instance;
  static ConnectivityService get instance => _instance!;

  ConnectivityService._();

  factory ConnectivityService() {
    if (_instance != null) {
      throw StateError('ConnectivityService already created');
    }

    _instance = ConnectivityService._();
    return _instance!;
  }

  StreamSubscription<ConnectivityResult>? _subscription;

  void addOnConnectivityChangedHandler(ValueChanged<bool> handler) {
    _subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        handler(result != ConnectivityResult.none);
      },
    );
  }

  Future<void> stop() async {
    await _subscription?.cancel();
  }

  Future<bool> hasConnection() async =>
      (await Connectivity().checkConnectivity()) != ConnectivityResult.none;
}
