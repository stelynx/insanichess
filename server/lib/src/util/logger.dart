import '../../insanichess_server.dart';
import '../config/config.dart';

class Logger {
  static Logger? _instance;
  static Logger get instance => _instance!;

  const Logger._();

  factory Logger() {
    if (_instance != null) {
      throw StateError('Logger already created!');
    }

    _instance = const Logger._();
    return _instance!;
  }

  void debug(String caller, Object? message) {
    if (Config.isDebug) {
      return _log(_LogLevel.debug, caller, message);
    }
  }

  void info(String caller, Object? message) {
    return _log(_LogLevel.info, caller, message);
  }

  void error(String caller, Object? message) {
    return _log(_LogLevel.error, caller, message);
  }

  void _log(_LogLevel level, String caller, Object? message) {
    if (Config.isDebug) {
      // ignore: avoid_print
      print('[${level.str}] $caller : $message');
    }
    DatabaseService.instance.addLog(level.str, caller, '$message');
  }
}

enum _LogLevel { debug, info, error }

extension _LogLevelToString on _LogLevel {
  String get str {
    switch (this) {
      case _LogLevel.debug:
        return 'DEBUG';
      case _LogLevel.error:
        return 'ERROR';
      case _LogLevel.info:
        return 'INFO';
    }
  }
}
