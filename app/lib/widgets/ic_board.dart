import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insanichess/insanichess.dart' as insanichess;

import '../style/colors.dart';
import '../util/extensions/piece.dart';

class ICBoard extends StatefulWidget {
  final insanichess.Board board;
  final void Function(insanichess.Square, insanichess.Square) onMove;
  final bool asWhite;
  final int scaleResetAnimationDuration;

  const ICBoard({
    Key? key,
    required this.board,
    required this.onMove,
    this.asWhite = true,
    this.scaleResetAnimationDuration = 0,
  }) : super(key: key);

  @override
  State<ICBoard> createState() => _ICBoardState();
}

class _ICBoardState extends State<ICBoard> with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late AnimationController _controllerReset;
  Animation<Matrix4>? _animationReset;

  insanichess.Square? selectedSquare;

  @override
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.scaleResetAnimationDuration),
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _controllerReset.dispose();
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

  void _onSquareTap(int row, int col) {
    if (selectedSquare == null) {
      if (widget.board.at(row, col) != null) {
        setState(() => selectedSquare = insanichess.Square(row, col));
      }
      return;
    }

    widget.onMove(selectedSquare!, insanichess.Square(row, col));
    setState(() => selectedSquare = null);
  }

  Widget _generateSquare(int row, int col, {required BuildContext context}) {
    final Size screenSize = MediaQuery.of(context).size;
    final double maxSquareSize = (screenSize.width < screenSize.height
            ? screenSize.width
            : screenSize.height) /
        insanichess.Board.size;

    return GestureDetector(
      onTap: () => _onSquareTap(row, col),
      child: Container(
        height: maxSquareSize, // might change
        width: maxSquareSize, // might change
        constraints: BoxConstraints(
          maxHeight: maxSquareSize,
          maxWidth: maxSquareSize,
        ),
        decoration: BoxDecoration(
          color: selectedSquare != null &&
                  selectedSquare!.row == row &&
                  selectedSquare!.col == col
              ? ICColor.chessboardSelectedSquare
              : (row + col) % 2 == 0
                  ? ICColor.chessboardBlack
                  : ICColor.chessboardWhite,
        ),
        child: widget.board.at(row, col) == null
            ? const SizedBox.expand()
            : SvgPicture.asset(
                widget.board.at(row, col)!.getImagePath(),
                width: maxSquareSize,
                height: maxSquareSize,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.board.toStringAsWhite());
    print('');
    final List<Row> rows = <Row>[];

    if (widget.asWhite) {
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

    return GestureDetector(
      // onDoubleTap: _animateResetInitialize,
      child: InteractiveViewer(
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
        onInteractionEnd: (details) {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: rows,
        ),
      ),
    );
  }
}
