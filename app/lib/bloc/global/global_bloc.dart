import 'dart:async';

import 'package:insanichess_sdk/insanichess_sdk.dart';

import '../../util/logger.dart';

part 'global_state.dart';

class GlobalBloc {
  static GlobalBloc? _instance;
  static GlobalBloc get instance => _instance!;

  GlobalBloc._({required Logger logger})
      : _logger = logger,
        _state = const GlobalState.initial(),
        _settingsStreamController =
            StreamController<InsanichessSettings>.broadcast();

  factory GlobalBloc({required Logger logger}) {
    if (_instance != null) {
      throw StateError('GlobalBloc already created!');
    }

    _instance = GlobalBloc._(logger: logger);
    return _instance!;
  }

  final Logger _logger;

  GlobalState _state;
  GlobalState get state => _state;

  final StreamController<InsanichessSettings> _settingsStreamController;
  Stream<InsanichessSettings> get settingsStream =>
      _settingsStreamController.stream;

  // Public API

  void changeSettings(InsanichessSettings settings) {
    _state = _state.copyWith(settings: settings);
    _logger.info('GlobalBloc.changeSettings', 'settings updated');
    _settingsStreamController.add(settings);
  }

  void updateJwtToken(String jwtToken) {
    _state = _state.copyWith(jwtToken: jwtToken);
    _logger.info('GlobalBloc.updateJwtToken', 'jwt token updated');
  }

  void updatePlayerMyself(InsanichessPlayer player) {
    _state = _state.copyWith(playerMyself: player);
    _logger.info('GlobalBloc.updatePlayerMyself', 'playerMyself updated');
  }

  void updateChallengePreference(InsanichessChallenge challenge) {
    _state = _state.copyWith(challengePreference: challenge);
    _logger.info(
      'GlobalBloc.updateChallengePreference',
      'challenge preference updated',
    );
  }

  void reset() {
    _state = const GlobalState.initial();
    _logger.info('GlobalBloc.reset', 'state reset');
  }
}
