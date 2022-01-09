/// Insanichess SDK library.
///
/// This library provides wrappers around core game classes from
/// [`insanichess`](https://pub.dev/packages/insanichess). Classes implemented
/// in this library can be used in client and server applications.

library insanichess_sdk;

export 'src/game.dart';
export 'src/models/settings/game/game.dart';
export 'src/models/settings/game/otb.dart';
export 'src/models/settings/settings.dart';
export 'src/models/user/player.dart';
export 'src/models/user/user.dart';
export 'src/server/routes.dart';
export 'src/time_control.dart';
export 'src/util/enum/auto_zoom_out_on_move_behaviour.dart';
export 'src/util/position.dart';
export 'src/util/validator.dart';
