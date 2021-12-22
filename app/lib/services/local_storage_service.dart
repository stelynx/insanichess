import 'dart:io';

import 'package:insanichess/insanichess.dart' as insanichess;
import 'package:insanichess_sdk/insanichess_sdk.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> saveGame(InsanichessGame game) async {
    final File f = File(
      '${await _gamesPath}${Platform.pathSeparator}${game.id}',
    );

    await f.writeAsString(game.toICString(), flush: true);
  }

  Future<InsanichessGame> readGame(String id) async {
    final File f = File(
      '${await _gamesPath}${Platform.pathSeparator}$id',
    );

    final List<String> lines = await f.readAsLines();

    final List<String> timeControlString = lines[2].split(' ');
    final List<String> remainingTimeString = lines[3].split(' ');

    final List<insanichess.Move> moves = <insanichess.Move>[];
    // for (int i = 5; i < lines.length; i++) {
    //   final List<String> splittedLine = lines[i].split(' ');
    //   final insanichess.Move whiteMove = insanichess.Move(insanichess.Square(), insanichess.Square());
    // }

    return InsanichessGame.fromPosition(
      id: lines[0],
      whitePlayer: const InsanichessPlayer.testWhite(),
      blackPlayer: const InsanichessPlayer.testBlack(),
      timeControl: InsanichessTimeControl(
        initialTime: Duration(seconds: int.parse(timeControlString[0])),
        incrementPerMove: Duration(seconds: int.parse(timeControlString[1])),
      ),
      position: positionFromFen(lines[4]),
      remainingTimeWhite:
          Duration(milliseconds: int.parse(remainingTimeString[0])),
      remainingTimeBlack:
          Duration(milliseconds: int.parse(remainingTimeString[1])),
      gameHistory: insanichess.GameHistory.withMoves(moves: moves),
    );
  }
}