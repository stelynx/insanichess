// Adapted from https://stackoverflow.com/a/54970376/8536377 and https://github.com/akashgurava/activity_ring

import 'dart:math';

import 'package:flutter/cupertino.dart';

class GradientArcPainter extends CustomPainter {
  const GradientArcPainter({
    required this.progress,
    required this.startColor,
    required this.endColor,
    required this.width,
  }) : super();

  final double progress;
  final Color startColor;
  final Color endColor;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final gradient = SweepGradient(
      startAngle: 3 * pi / 2,
      endAngle: 7 * pi / 2,
      tileMode: TileMode.repeated,
      colors: [startColor, endColor],
    );

    // Arc
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - (width / 2);
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    // Final point
    final double finalPointRadius = width / 2 + 1;
    canvas.drawCircle(
      Offset(
        center.dx + radius * cos(startAngle),
        center.dy + radius * sin(startAngle),
      ),
      finalPointRadius,
      Paint()
        ..color = startColor
        ..style = PaintingStyle.fill,
    );

    // Starting point if needed
    final double alpha = atan(width / (2 * radius));
    final double beta = atan(finalPointRadius / radius);
    final double thetaStop = 2 * pi - (alpha + beta);
    if (sweepAngle > thetaStop) {
      canvas.drawCircle(
        Offset(
          center.dx + radius * cos(startAngle + sweepAngle),
          center.dy + radius * sin(startAngle + sweepAngle),
        ),
        width / 2,
        Paint()
          ..color = Color.lerp(startColor, endColor, progress) ?? endColor
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
