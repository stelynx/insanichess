import 'dart:convert';
import 'dart:io';

import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';

import '../util/logger.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static LocalStorageService get instance => _instance!;

  LocalStorageService._();

  factory LocalStorageService() {
    if (_instance != null) {
      throw StateError('LocalStorageService already created');
    }

    _instance = LocalStorageService._();
    return _instance!;
  }

  Future<String> get _gamesPath async =>
      '${(await getApplicationDocumentsDirectory()).path}/games';

  @Deprecated('Settings are not saved locally anymore.')
  static const String _settingsFile = 'settings.json';

  static const String _dataFile = 'data.json';

  Future<void> saveJwtToken(String jwtToken) async {
    final LocalStorage storage = LocalStorage(_dataFile);
    await storage.ready;

    await storage.setItem('jwt_token', jwtToken);
    Logger.instance.info(
      'LocalStorageService.saveJwtToken',
      'token saved',
    );
  }

  Future<String?> readJwtToken() async {
    final LocalStorage storage = LocalStorage(_dataFile);
    await storage.ready;

    return storage.getItem('jwt_token');
  }

  Future<List<InsanichessGame>> getPlayedGames() async {
    final String directoryPath = await _gamesPath;
    final Directory directory = Directory(directoryPath);
    if (!await directory.exists()) {
      directory.create();
      return const <InsanichessGame>[];
    }

    final List<InsanichessGame> games = <InsanichessGame>[];
    for (final FileSystemEntity fse in directory.listSync(followLinks: false)) {
      games.add(await readGame(fse.path.split(Platform.pathSeparator).last));
    }
    return games;
  }

  Future<void> saveGame(InsanichessGame game) async {
    final String directoryPath = await _gamesPath;
    final Directory directory = Directory(directoryPath);
    if (!await directory.exists()) {
      directory.create();
    }

    final File f = File(
      '$directoryPath${Platform.pathSeparator}${game.id}',
    );

    await f.writeAsString(game.toICString(), flush: true);
    Logger.instance.info(
      'LocalStorageService.saveGame',
      'game ${game.id} saved',
    );
  }

  Future<InsanichessGame> readGame(String id) async {
    final File f = File(
      '${await _gamesPath}${Platform.pathSeparator}$id',
    );

    return InsanichessGame.fromICString(await f.readAsString());
  }

  Future<void> saveChallengePreferences({
    required InsanichessChallenge challenge,
  }) async {
    final LocalStorage storage = LocalStorage(_dataFile);
    await storage.ready;

    await storage.setItem(
      'challenge_preference',
      jsonEncode(challenge.toJson()),
    );
    Logger.instance.info(
      'LocalStorageService.saveChallengePreferences',
      'challenge preference saved',
    );
  }

  Future<InsanichessChallenge?> readChallengePreferences() async {
    final LocalStorage storage = LocalStorage(_dataFile);
    await storage.ready;

    return storage.getItem('challenge_preference') == null
        ? null
        : InsanichessChallenge.fromJson(
            jsonDecode(storage.getItem('challenge_preference')));
  }

  @Deprecated('Settings are now saved on the server. We keep this method for'
      'future reference and potential usage.')
  Future<void> saveSettings(InsanichessSettings settings) async {
    final LocalStorage storage = LocalStorage(_settingsFile);
    await storage.ready;

    await storage.setItem('settings', settings.toJson());
    Logger.instance.info(
      'LocalStorageService.saveSettings',
      'settings saved',
    );
  }

  @Deprecated('Settings are now saved on the server. We keep this method for'
      'future reference and potential usage.')
  Future<InsanichessSettings?> readSettings() async {
    final LocalStorage storage = LocalStorage(_settingsFile);
    await storage.ready;

    final settingsOrNull = storage.getItem('settings');

    return settingsOrNull == null
        ? null
        : InsanichessSettings.fromJson(settingsOrNull);
  }
}
