import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insanichess/insanichess.dart' as insanichess;

import '../style/colors.dart';
import '../style/images.dart';
import '../util/extensions/piece.dart';

class ICBoard extends StatefulWidget {
  final insanichess.Game game;
  final void Function(insanichess.Move) onMove;
  final bool isWhiteBottom;
  final bool mirrorTopPieces;
  final bool showLegalMoves;
  final bool autoPromoteToQueen;
  final int scaleResetAnimationDuration;
  final Stream<void>? resetZoomStream;
  final ValueChanged<double>? onZoomChanged;

  const ICBoard({
    Key? key,
    required this.game,
    required this.onMove,
    required this.isWhiteBottom,
    required this.mirrorTopPieces,
    required this.showLegalMoves,
    required this.autoPromoteToQueen,
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
  double _zoomValue = 1.0;

  insanichess.Square? _selectedSquare;
  Iterable<insanichess.Square>? _legalSquaresFromSelectedSquare;
  insanichess.Square? _squareForPromotion;

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

  void _onSquareTap(int row, int col, {required BuildContext context}) {
    final insanichess.Square selectedSquare = insanichess.Square(row, col);
    final insanichess.Piece? pieceOnSelectedSquare =
        widget.game.board.at(row, col);

    if (_selectedSquare == null ||
        !_legalSquaresFromSelectedSquare!.contains(selectedSquare)) {
      if (widget.game.playerOnTurn == insanichess.PieceColor.white &&
              (pieceOnSelectedSquare?.isWhite ?? false) ||
          widget.game.playerOnTurn == insanichess.PieceColor.black &&
              (pieceOnSelectedSquare?.isBlack ?? false)) {
        _legalSquaresFromSelectedSquare = widget.game.legalMoves
            .where((insanichess.Move move) => move.from == _selectedSquare)
            .map<insanichess.Square>((insanichess.Move move) => move.to);
        setState(() => _selectedSquare = selectedSquare);
      }
      return;
    }

    insanichess.Piece? promoteTo;
    final insanichess.Piece selectedPiece =
        widget.game.board.at(_selectedSquare!.row, _selectedSquare!.col)!;
    if ((selectedPiece is insanichess.WhitePawn &&
            row == insanichess.Board.size - 1) ||
        (selectedPiece is insanichess.BlackPawn && row == 0)) {
      if (widget.autoPromoteToQueen) {
        promoteTo = const insanichess.WhiteQueen();
      } else {
        setState(() => _squareForPromotion = selectedSquare);
        return;
      }
    }

    widget.onMove(insanichess.Move(
      _selectedSquare!,
      selectedSquare,
      promoteTo,
    ));
    _legalSquaresFromSelectedSquare = null;
    setState(() => _selectedSquare = null);
  }

  Widget _generateSquare(
    int row,
    int col, {
    required double maxSquareSize,
    required BuildContext context,
  }) {
    final bool shouldMirror = !widget.mirrorTopPieces
        ? false
        : (widget.isWhiteBottom
            ? (widget.game.board.at(row, col)?.isBlack ?? false)
            : (widget.game.board.at(row, col)?.isWhite ?? false));

    final bool hasLegalMoveIndicator = !widget.showLegalMoves
        ? false
        : _legalSquaresFromSelectedSquare
                ?.contains(insanichess.Square(row, col)) ??
            false;

    return GestureDetector(
      onTap: widget.game.isGameOver || widget.game.canGoForward
          ? null
          : () => _onSquareTap(row, col, context: context),
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
            ? (hasLegalMoveIndicator
                ? Icon(
                    CupertinoIcons.circle_fill,
                    size: maxSquareSize / 3,
                    color: const Color(0xdd888888),
                  )
                : null)
            : Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    widget.game.board
                        .at(row, col)!
                        .getImagePath(mirrored: shouldMirror),
                    width: maxSquareSize,
                    height: maxSquareSize,
                  ),
                  if (hasLegalMoveIndicator)
                    Icon(
                      CupertinoIcons.circle_fill,
                      size: maxSquareSize / 3,
                      color: const Color(0xdd888888),
                    ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double maxSquareSize = (screenSize.width < screenSize.height
            ? screenSize.width
            : screenSize.height) /
        insanichess.Board.size;

    final List<Row> rows = <Row>[];

    if (widget.isWhiteBottom) {
      for (int row = insanichess.Board.size - 1; row >= 0; row--) {
        final List<Widget> children = <Widget>[];
        for (int col = 0; col < insanichess.Board.size; col++) {
          children.add(_generateSquare(
            row,
            col,
            context: context,
            maxSquareSize: maxSquareSize,
          ));
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
          children.add(_generateSquare(
            row,
            col,
            context: context,
            maxSquareSize: maxSquareSize,
          ));
        }
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ));
      }
    }

    Widget child = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rows,
    );
    if (_squareForPromotion != null) {
      final bool isWhitePromoting =
          _squareForPromotion!.row == insanichess.Board.size - 1;
      final double? top;
      final double? bottom;
      final double? left;

      if (isWhitePromoting) {
        if (widget.isWhiteBottom) {
          top = 0.0;
          bottom = null;
          left = _squareForPromotion!.col * maxSquareSize;
        } else {
          top = null;
          bottom = 0.0;
          left = (insanichess.Board.size - 2 - _squareForPromotion!.col) *
              maxSquareSize;
        }
      } else {
        if (widget.isWhiteBottom) {
          top = null;
          bottom = 0.0;
          left = (insanichess.Board.size - 2 - _squareForPromotion!.col) *
              maxSquareSize;
        } else {
          top = 0.0;
          bottom = null;
          left = _squareForPromotion!.col * maxSquareSize;
        }
      }

      final bool queenTop = (isWhitePromoting && widget.isWhiteBottom) ||
          (!isWhitePromoting && !widget.isWhiteBottom);

      child = Stack(
        children: <Widget>[
          child,
          Positioned(
            top: top,
            bottom: bottom,
            left: left,
            child: _PromotionSelectionOverlay(
              isWhitePromoting: isWhitePromoting,
              queenTop: queenTop,
              // Queen is bottom when top player is promoting, therefore pieces
              // are only mirrored when queen is not top and top pieces should
              // be mirrored.
              mirrorPieces: !queenTop && widget.mirrorTopPieces,
              onPromotionSelected: (insanichess.Piece promoteTo) {
                widget.onMove(insanichess.Move(
                  _selectedSquare!,
                  _squareForPromotion!,
                  promoteTo,
                ));
                setState(() {
                  _selectedSquare = null;
                  _squareForPromotion = null;
                  _legalSquaresFromSelectedSquare = null;
                });
              },
            ),
          ),
        ],
      );
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
      child: child,
    );
  }
}

class _PromotionSelectionOverlay extends StatelessWidget {
  final bool isWhitePromoting;
  final bool queenTop;
  final bool mirrorPieces;
  final ValueChanged<insanichess.Piece> onPromotionSelected;

  const _PromotionSelectionOverlay({
    Key? key,
    required this.isWhitePromoting,
    required this.queenTop,
    required this.mirrorPieces,
    required this.onPromotionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width =
        MediaQuery.of(context).size.width / insanichess.Board.size;

    List<Widget> children;
    if (isWhitePromoting) {
      children = mirrorPieces
          ? <Widget>[
              _PromotionPieceButton(
                imagePath: ICImage.pieceWhiteQueenR,
                size: width,
                onTap: () =>
                    onPromotionSelected(const insanichess.WhiteQueen()),
              ),
              _PromotionPieceButton(
                imagePath: ICImage.pieceWhiteRookR,
                size: width,
                onTap: () => onPromotionSelected(const insanichess.WhiteRook()),
              ),
              _PromotionPieceButton(
                imagePath: ICImage.pieceWhiteKnightR,
                size: width,
                onTap: () =>
                    onPromotionSelected(const insanichess.WhiteKnight()),
              ),
              _PromotionPieceButton(
                imagePath: ICImage.pieceWhiteBishopR,
                size: width,
                onTap: () =>
                    onPromotionSelected(const insanichess.WhiteBishop()),
              ),
            ]
          : <Widget>[
              _PromotionPieceButton(
                imagePath: ICImage.pieceWhiteQueen,
                size: width,
                onTap: () =>
                    onPromotionSelected(const insanichess.WhiteQueen()),
              ),
              _PromotionPieceButton(
                imagePath: ICImage.pieceWhiteRook,
                size: width,
                onTap: () => onPromotionSelected(const insanichess.WhiteRook()),
              ),
              _PromotionPieceButton(
                imagePath: ICImage.pieceWhiteKnight,
                size: width,
                onTap: () =>
                    onPromotionSelected(const insanichess.WhiteKnight()),
              ),
              _PromotionPieceButton(
                imagePath: ICImage.pieceWhiteBishop,
                size: width,
                onTap: () =>
                    onPromotionSelected(const insanichess.WhiteBishop()),
              ),
            ];
    } else {
      children = mirrorPieces
          ? <Widget>[
              _PromotionPieceButton(
                imagePath: ICImage.pieceBlackQueenR,
                size: width,
                onTap: () =>
                    onPromotionSelected(const insanichess.BlackQueen()),
              ),
              _PromotionPieceButton(
                imagePath: ICImage.pieceBlackRookR,
                size: width,
                onTap: () => onPromotionSelected(const insanichess.BlackRook()),
              ),
              _PromotionPieceButton(
                imagePath: ICImage.pieceBlackKnightR,
                size: width,
                onTap: () =>
                    onPromotionSelected(const insanichess.BlackKnight()),
              ),
              _PromotionPieceButton(
                imagePath: ICImage.pieceBlackBishopR,
                size: width,
                onTap: () =>
                    onPromotionSelected(const insanichess.BlackBishop()),
              ),
            ]
          : <Widget>[
              _PromotionPieceButton(
                imagePath: ICImage.pieceBlackQueen,
                size: width,
                onTap: () =>
                    onPromotionSelected(const insanichess.BlackQueen()),
              ),
              _PromotionPieceButton(
                imagePath: ICImage.pieceBlackRook,
                size: width,
                onTap: () => onPromotionSelected(const insanichess.BlackRook()),
              ),
              _PromotionPieceButton(
                imagePath: ICImage.pieceBlackKnight,
                size: width,
                onTap: () =>
                    onPromotionSelected(const insanichess.BlackKnight()),
              ),
              _PromotionPieceButton(
                imagePath: ICImage.pieceBlackBishop,
                size: width,
                onTap: () =>
                    onPromotionSelected(const insanichess.BlackBishop()),
              ),
            ];
    }
    if (!queenTop) {
      children = children.reversed.toList(growable: false);
    }

    return Container(
      width: width,
      height: 4 * width,
      color: const Color(0xffffffff),
      child: Column(children: children),
    );
  }
}

class _PromotionPieceButton extends StatelessWidget {
  final String imagePath;
  final double size;
  final VoidCallback onTap;

  const _PromotionPieceButton({
    Key? key,
    required this.imagePath,
    required this.size,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SvgPicture.asset(
        imagePath,
        width: size,
        height: size,
      ),
    );
  }
}
