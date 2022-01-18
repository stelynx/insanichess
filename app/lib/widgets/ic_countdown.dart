import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'util/gradient_arc_painter.dart';

const Duration _kAnimationDeltaTime = Duration(milliseconds: 10);

class ICCountdown extends StatefulWidget {
  final Duration expiresIn;
  final VoidCallback onExpired;
  final Duration? periodicFetchDuration;
  final VoidCallback? periodicFetchCallback;

  const ICCountdown({
    Key? key,
    required this.expiresIn,
    required this.onExpired,
    this.periodicFetchDuration,
    this.periodicFetchCallback,
  })  : assert((periodicFetchDuration == null &&
                periodicFetchCallback == null) ||
            (periodicFetchDuration != null && periodicFetchCallback != null)),
        super(key: key);

  @override
  _ICCountdownState createState() => _ICCountdownState();
}

class _ICCountdownState extends State<ICCountdown> {
  late Duration _duration;

  late Timer _animationTimer;
  Timer? _periodicFetchTimer;

  @override
  void initState() {
    _duration = widget.expiresIn;
    _animationTimer = Timer.periodic(_kAnimationDeltaTime, (_) => _update());

    if (widget.periodicFetchDuration != null) {
      _periodicFetchTimer = Timer.periodic(
        widget.periodicFetchDuration!,
        (_) => widget.periodicFetchCallback!(),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    _animationTimer.cancel();
    _periodicFetchTimer?.cancel();
    super.dispose();
  }

  void _update() {
    if (_duration.inMilliseconds == 0) {
      _animationTimer.cancel();
      widget.onExpired();
    }

    if (mounted) {
      setState(() => _duration = _duration - _kAnimationDeltaTime);
    }
  }

  String get _counter {
    return (_duration.inMilliseconds / 1000).ceil().toString();
  }

  @override
  Widget build(BuildContext context) {
    final double size = min(250, MediaQuery.of(context).size.width / 2);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: GradientArcPainter(
          progress: _duration.inMilliseconds / widget.expiresIn.inMilliseconds,
          width: 8,
          startColor: CupertinoTheme.of(context).primaryContrastingColor,
          endColor: CupertinoTheme.of(context).primaryColor,
        ),
        child: Center(
          child: Text(
            _counter,
            style: CupertinoTheme.of(context)
                .textTheme
                .textStyle
                .copyWith(fontSize: max(size / 4, 24)),
          ),
        ),
      ),
    );
  }
}
