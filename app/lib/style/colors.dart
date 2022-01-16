import 'package:flutter/cupertino.dart';

/// Provides color palette for Insanichess app.
abstract class ICColor {
  /// Color for white chessboard squares.
  static const Color chessboardWhite = Color.fromRGBO(245, 245, 220, 1.0);

  /// Color for black chessboard squares.
  static const Color chessboardBlack = Color.fromRGBO(123, 63, 0, 1.0);

  /// Color for selected chessboard square.
  static const Color chessboardSelectedSquare =
      Color.fromRGBO(204, 255, 0, 1.0);

  /// Primary color. Used for filled buttons.
  static const CupertinoDynamicColor primary =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xff000000),
    darkColor: Color(0xffffffff),
  );

  static const CupertinoDynamicColor primaryContrastingColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xffffffff),
    darkColor: Color(0xff000000),
  );

  static const CupertinoDynamicColor highlightColor =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xffcccccc),
    darkColor: Color(0xff333333),
  );

  /// Color used for filled buttons that confirm actions and for success.
  static const Color confirm = CupertinoColors.activeGreen;

  /// Color used for filled buttons that confirm destructive actions and for
  /// failure.
  static const Color danger = CupertinoColors.destructiveRed;

  static const Color transparent = Color(0x00000000);
}
