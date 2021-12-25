import 'dart:async';

import 'package:insanichess_sdk/insanichess_sdk.dart';

part 'global_state.dart';

class GlobalBloc {
  static GlobalBloc? _instance;
  static GlobalBloc get instance => _instance!;

  GlobalBloc._()
      : _state = const GlobalState.initial(),
        _settingsStreamController =
            StreamController<InsanichessSettings>.broadcast();

  factory GlobalBloc() {
    if (_instance != null) {
      throw StateError('GlobalBloc already created!');
    }

    _instance = GlobalBloc._();
    return _instance!;
  }

  GlobalState _state;
  GlobalState get state => _state;

  final StreamController<InsanichessSettings> _settingsStreamController;
  Stream<InsanichessSettings> get settingsStream =>
      _settingsStreamController.stream;

  // Public API
  void changeSettings(InsanichessSettings settings) {
    _state = _state.copyWith(settings: settings);
    _settingsStreamController.add(settings);
  }
}
