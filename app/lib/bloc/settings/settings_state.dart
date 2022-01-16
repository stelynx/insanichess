part of 'settings_bloc.dart';

@immutable
class SettingsState {
  final bool otbRotateChessboard;
  final bool otbMirrorTopPieces;
  final bool otbAllowUndo;
  final bool otbAlwaysPromoteToQueen;
  final AutoZoomOutOnMoveBehaviour otbAutoZoomOutOnMove;
  final bool showZoomOutButtonOnLeft;
  final bool showLegalMoves;

  final BackendFailure? backendFailure;

  const SettingsState({
    required this.otbRotateChessboard,
    required this.otbMirrorTopPieces,
    required this.otbAllowUndo,
    required this.otbAlwaysPromoteToQueen,
    required this.otbAutoZoomOutOnMove,
    required this.showZoomOutButtonOnLeft,
    required this.showLegalMoves,
    required this.backendFailure,
  });

  SettingsState.initial(InsanichessSettings settings)
      : otbRotateChessboard = settings.otb.rotateChessboard,
        otbMirrorTopPieces = settings.otb.mirrorTopPieces,
        otbAllowUndo = settings.otb.allowUndo,
        otbAlwaysPromoteToQueen = settings.otb.alwaysPromoteToQueen,
        otbAutoZoomOutOnMove = settings.otb.autoZoomOutOnMove,
        showZoomOutButtonOnLeft = settings.showZoomOutButtonOnLeft,
        showLegalMoves = settings.showLegalMoves,
        backendFailure = null;

  SettingsState copyWith({
    bool? otbRotateChessboard,
    bool? otbMirrorTopPieces,
    bool? otbAllowUndo,
    bool? otbAlwaysPromoteToQueen,
    AutoZoomOutOnMoveBehaviour? otbAutoZoomOutOnMove,
    bool? showZoomOutButtonOnLeft,
    bool? showLegalMoves,
    BackendFailure? backendFailure,
  }) {
    return SettingsState(
      otbRotateChessboard: otbRotateChessboard ?? this.otbRotateChessboard,
      otbMirrorTopPieces: otbMirrorTopPieces ?? this.otbMirrorTopPieces,
      otbAllowUndo: otbAllowUndo ?? this.otbAllowUndo,
      otbAlwaysPromoteToQueen:
          otbAlwaysPromoteToQueen ?? this.otbAlwaysPromoteToQueen,
      otbAutoZoomOutOnMove: otbAutoZoomOutOnMove ?? this.otbAutoZoomOutOnMove,
      showZoomOutButtonOnLeft:
          showZoomOutButtonOnLeft ?? this.showZoomOutButtonOnLeft,
      showLegalMoves: showLegalMoves ?? this.showLegalMoves,
      backendFailure: backendFailure,
    );
  }
}
