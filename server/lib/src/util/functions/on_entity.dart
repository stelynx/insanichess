import 'package:insanichess_sdk/insanichess_sdk.dart';

InsanichessSettings? settingsFromDatabase(Map<String, dynamic> data) {
  return InsanichessSettings(
    showZoomOutButtonOnLeft: data['zoom_out_button_left'],
    showLegalMoves: data['show_legal_moves'],
    otb: InsanichessOtbSettings(
      allowUndo: data['otb_allow_undo'],
      rotateChessboard: data['otb_rotate_chessboard'],
      mirrorTopPieces: data['otb_mirror_top_pieces'],
      alwaysPromoteToQueen: data['otb_promote_queen'],
      autoZoomOutOnMove:
          autoZoomOutOnMoveBehaviourFromJson(data['otb_auto_zoom_out']),
    ),
    live: InsanichessLiveGameSettings(
      allowUndo: data['live_allow_undo'],
      alwaysPromoteToQueen: data['live_promote_queen'],
      autoZoomOutOnMove:
          autoZoomOutOnMoveBehaviourFromJson(data['otb_auto_zoom_out']),
    ),
  );
}
