import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insanichess/insanichess.dart' as insanichess;

import '../style/colors.dart';
import '../util/extensions/piece.dart';

class ICBoard extends StatefulWidget {
  final insanichess.Game game;
  final void Function(insanichess.Square, insanichess.Square) onMove;
  final bool isWhiteBottom;
  final bool mirrorTopPieces;
  final int scaleResetAnimationDuration;
  final Stream<void>? resetZoomStream;
  final ValueChanged<double>? onZoomChanged;

  const ICBoard({
    Key? key,
    required this.game,
    required this.onMove,
    required this.isWhiteBottom,
    required this.mirrorTopPieces,
    this.scaleResetAnimationDuration = 0,
    this.resetZoomStream,
    this.onZoomChanged,
  }) : super(key: key);

  @override
  State<ICBoard> createState() => _ICBoardState();
}

class _ICBoardState extends State<ICBoard> with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late AnimationController _controllerReset;
  Animation<Matrix4>? _animationReset;

  StreamSubscription<void>? _resetZoomSubscription;

  insanichess.Square? _selectedSquare;
  double _zoomValue = 1.0;

  @override
  void initState() {
    super.initState();

    _controllerReset = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.scaleResetAnimationDuration),
    );

    if (widget.resetZoomStream != null) {
      _resetZoomSubscription = widget.resetZoomStream!.listen((_) {
        _animateResetInitialize();
      });
    }
  }

  @override
  Future<void> dispose() async {
    _transformationController.dispose();
    _controllerReset.dispose();
    await _resetZoomSubscription?.cancel();
    super.dispose();
  }

  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(_controllerReset);
    _animationReset!.addListener(_onAnimateReset);
    _controllerReset.forward();
  }

  void _onAnimateReset() {
    if (_animationReset == null) return;

    _transformationController.value = _animationReset!.value;
    if (!_controllerReset.isAnimating) {
      _animationReset!.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset.reset();
    }
  }

  Widget _generateSquare(int row, int col, {required BuildContext context}) {
    final Size screenSize = MediaQuery.of(context).size;
    final double maxSquareSize = (screenSize.width < screenSize.height
            ? screenSize.width
            : screenSize.height) /
        insanichess.Board.size;

    final bool shouldMirror = !widget.mirrorTopPieces
        ? false
        : (widget.isWhiteBottom
            ? (widget.game.board.at(row, col)?.isBlack ?? false)
            : (widget.game.board.at(row, col)?.isWhite ?? false));

    return GestureDetector(
      onTap: widget.game.isGameOver || widget.game.canGoForward
          ? null
          : () {
              if (_selectedSquare == null) {
                if (widget.game.playerOnTurn == insanichess.PieceColor.white &&
                        (widget.game.board.at(row, col)?.isWhite ?? false) ||
                    widget.game.playerOnTurn == insanichess.PieceColor.black &&
                        (widget.game.board.at(row, col)?.isBlack ?? false)) {
                  setState(
                      () => _selectedSquare = insanichess.Square(row, col));
                }
                return;
              }

              widget.onMove(_selectedSquare!, insanichess.Square(row, col));
              setState(() => _selectedSquare = null);
            },
      child: Container(
        height: maxSquareSize, // might change
        width: maxSquareSize, // might change
        constraints: BoxConstraints(
          maxHeight: maxSquareSize,
          maxWidth: maxSquareSize,
        ),
        decoration: BoxDecoration(
          color: _selectedSquare != null &&
                  _selectedSquare!.row == row &&
                  _selectedSquare!.col == col
              ? ICColor.chessboardSelectedSquare
              : (row + col) % 2 == 0
                  ? ICColor.chessboardBlack
                  : ICColor.chessboardWhite,
        ),
        child: widget.game.board.at(row, col) == null
            ? const SizedBox.expand()
            : SvgPicture.asset(
                widget.game.board
                    .at(row, col)!
                    .getImagePath(mirrored: shouldMirror),
                width: maxSquareSize,
                height: maxSquareSize,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Row> rows = <Row>[];

    if (widget.isWhiteBottom) {
      for (int row = insanichess.Board.size - 1; row >= 0; row--) {
        final List<Widget> children = <Widget>[];
        for (int col = 0; col < insanichess.Board.size; col++) {
          children.add(_generateSquare(row, col, context: context));
        }
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ));
      }
    } else {
      for (int row = 0; row < insanichess.Board.size; row++) {
        final List<Widget> children = <Widget>[];
        for (int col = insanichess.Board.size - 1; col >= 0; col--) {
          children.add(_generateSquare(row, col, context: context));
        }
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ));
      }
    }

    return InteractiveViewer(
      minScale: 1.0,
      transformationController: _transformationController,
      onInteractionStart: (ScaleStartDetails details) {
        if (_controllerReset.status == AnimationStatus.forward) {
          _controllerReset.stop();
          _animationReset?.removeListener(_onAnimateReset);
          _animationReset = null;
          _controllerReset.reset();
        }
      },
      onInteractionUpdate: (ScaleUpdateDetails details) {
        final double newZoomValue =
            _transformationController.value.getMaxScaleOnAxis();
        if ((_zoomValue != 1.0 && newZoomValue == 1.0) ||
            (_zoomValue == 1.0 && newZoomValue != 1.0)) {
          widget.onZoomChanged
              ?.call(_transformationController.value.getMaxScaleOnAxis());
          // Don't set state here.
          _zoomValue = newZoomValue;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rows,
      ),
    );
  }
}
