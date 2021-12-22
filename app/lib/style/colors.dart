import 'package:flutter/widgets.dart';

/// Provides color palette for Insanichess app.
abstract class ICColor {
  /// Color for white chessboard squares.
  static const Color chessboardWhite = Color.fromRGBO(245, 245, 220, 1.0);

  /// Color for black chessboard squares.
  static const Color chessboardBlack = Color.fromRGBO(123, 63, 0, 1.0);

  /// Color for selected chessboard square.
  static const Color chessboardSelectedSquare =
      Color.fromRGBO(204, 255, 0, 1.0);
}
