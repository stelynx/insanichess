/// Adapted from flutter_inner_drawer with Cupertino only support.
/// Original package https://pub.dev/packages/flutter_inner_drawer
import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:insanichess_app/router/router.dart';
import 'package:insanichess_app/router/routes.dart';

import '../style/colors.dart';
import '../style/constants.dart';

/// Signature for the callback that's called when a [ICDrawer] is
/// opened or closed.
typedef ICDrawerCallback = void Function(bool isOpened);

/// Signature for when a pointer that is in contact with the screen and moves to the right or left
/// values between 1 and 0
typedef InnerDragUpdateCallback = void Function(
    double value, ICDrawerDirection? direction);

/// The possible position of a [ICDrawer].
enum ICDrawerDirection {
  start,
  end,
}

/// Animation type of a [ICDrawer].
enum ICDrawerAnimation {
  static,
  linear,
  quadratic,
}

//width before initState
const double _kWidth = 400;
const double _kMinFlingVelocity = 365.0;
const double _kEdgeDragWidth = 20.0;
const Duration _kBaseSettleDuration = Duration(milliseconds: 246);

class ICDrawer extends StatefulWidget {
  const ICDrawer({
    GlobalKey? key,
    required this.scaffold,
    this.offset = const IDOffset.horizontal(0),
    this.scale = const IDOffset.horizontal(1),
    this.proportionalChildArea = true,
    this.duration,
    this.velocity = 1,
    this.colorTransitionChild,
    this.colorTransitionScaffold,
    this.leftAnimationType = ICDrawerAnimation.static,
    this.rightAnimationType = ICDrawerAnimation.static,
    this.backgroundDecoration,
    this.icDrawerCallback,
    this.onDragUpdate,
  }) : super(key: key);

  /// A Scaffold is generally used but you are free to use other widgets
  final Widget scaffold;

  /// When the [ICDrawer] is open, it's possible to set the offset of each of the four cardinal directions
  final IDOffset offset;

  /// When the [ICDrawer] is open to the left or to the right
  /// values between 1 and 0. (default 1)
  final IDOffset scale;

  /// The proportionalChild Area = true dynamically sets the width based on the selected offset.
  /// On false it leaves the width at 100% of the screen
  final bool proportionalChildArea;

  /// edge radius when opening the scaffold
  final double borderRadius = 0;

  /// Closes the open scaffold
  final bool tapScaffoldEnabled = true;

  /// Closes the open scaffold
  final bool onTapClose = true;

  /// activate or deactivate the swipe. NOTE: when deactivate, onTap Close is implicitly activated
  final bool swipe = true;

  /// activate or deactivate the swipeChild. NOTE: when deactivate, onTap Close is implicitly activated
  final bool swipeChild = true;

  /// duration animation controller
  final Duration? duration;

  /// possibility to set the opening and closing velocity
  final double velocity;

  /// BoxShadow of scaffold open
  final List<BoxShadow> boxShadow = kElevatedBoxShadow;

  ///Color of gradient background
  final Color? colorTransitionChild;

  ///Color of gradient background
  final Color? colorTransitionScaffold;

  /// Static or Linear or Quadratic
  final ICDrawerAnimation leftAnimationType;

  /// Static or Linear or Quadratic
  final ICDrawerAnimation rightAnimationType;

  /// Color of the main background
  final Decoration? backgroundDecoration;

  /// Optional callback that is called when a [ICDrawer] is open or closed.
  final ICDrawerCallback? icDrawerCallback;

  /// when a pointer that is in contact with the screen and moves to the right or left
  final InnerDragUpdateCallback? onDragUpdate;

  @override
  ICDrawerState createState() => ICDrawerState();
}

class ICDrawerState extends State<ICDrawer>
    with SingleTickerProviderStateMixin {
  ColorTween _colorTransitionChild = ColorTween(
      begin: ICColor.transparent, end: ICColor.primary.elevatedColor);
  ColorTween _colorTransitionScaffold = ColorTween(
      begin: ICColor.primary.elevatedColor, end: ICColor.transparent);

  double _initWidth = _kWidth;
  Orientation _orientation = Orientation.portrait;
  ICDrawerDirection _position = ICDrawerDirection.start;

  @override
  void initState() {
    _controller = AnimationController(
        value: 1,
        duration: widget.duration ?? _kBaseSettleDuration,
        vsync: this)
      ..addListener(_animationChanged)
      ..addStatusListener(_animationStatusChanged);
    super.initState();
  }

  @override
  void dispose() {
    _historyEntry?.remove();
    _controller.dispose();
    _focusScopeNode.dispose();
    super.dispose();
  }

  void _animationChanged() {
    setState(() {
      // The animation controller's state is our build state, and it changed already.
    });
    if (widget.colorTransitionChild != null) {
      _colorTransitionChild = ColorTween(
          begin: widget.colorTransitionChild!.withOpacity(0.0),
          end: widget.colorTransitionChild);
    }

    if (widget.colorTransitionScaffold != null) {
      _colorTransitionScaffold = ColorTween(
          begin: widget.colorTransitionScaffold,
          end: widget.colorTransitionScaffold!.withOpacity(0.0));
    }

    if (widget.onDragUpdate != null && _controller.value < 1) {
      widget.onDragUpdate!((1 - _controller.value), _position);
    }
  }

  LocalHistoryEntry? _historyEntry;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry!);
        FocusScope.of(context).setFirstFocus(_focusScopeNode);
      }
    }
  }

  void _animationStatusChanged(AnimationStatus status) {
    final bool opened = _controller.value < 0.5 ? true : false;

    switch (status) {
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.forward:
        break;
      case AnimationStatus.dismissed:
        if (_previouslyOpened != opened) {
          _previouslyOpened = opened;
          if (widget.icDrawerCallback != null) {
            widget.icDrawerCallback!(opened);
          }
        }
        _ensureHistoryEntry();
        break;
      case AnimationStatus.completed:
        if (_previouslyOpened != opened) {
          _previouslyOpened = opened;
          if (widget.icDrawerCallback != null) {
            widget.icDrawerCallback!(opened);
          }
        }
        _historyEntry?.remove();
        _historyEntry = null;
    }
  }

  void _handleHistoryEntryRemoved() {
    _historyEntry = null;
    close();
  }

  late AnimationController _controller;

  void _handleDragDown(DragDownDetails details) {
    _controller.stop();
    //_ensureHistoryEntry();
  }

  final GlobalKey _drawerKey = GlobalKey();

  double get _width {
    return _initWidth;
  }

  double get _velocity {
    return widget.velocity;
  }

  /// get width of screen after initState
  void _updateWidth() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final RenderBox? box =
          _drawerKey.currentContext!.findRenderObject() as RenderBox?;
      //final RenderBox box = context.findRenderObject();
      if (box != null && box.hasSize && box.size.width > 300) {
        setState(() {
          _initWidth = box.size.width;
        });
      }
    });
  }

  bool _previouslyOpened = false;

  void _move(DragUpdateDetails details) {
    double delta = details.primaryDelta! / _width;

    if (delta > 0 && _controller.value == 1 && _leftChild != null) {
      _position = ICDrawerDirection.start;
    } else if (delta < 0 && _controller.value == 1 && _rightChild != null) {
      _position = ICDrawerDirection.end;
    }

    double offset = _position == ICDrawerDirection.start
        ? widget.offset.left
        : widget.offset.right;

    double ee = 1;
    if (offset <= 0.2) {
      ee = 1.7;
    } else if (offset <= 0.4) {
      ee = 1.2;
    } else if (offset <= 0.6) {
      ee = 1.05;
    }

    offset = 1 -
        (pow(offset / ee, 1 / 2)
            as double); //(num.parse(pow(offset/2,1/3).toStringAsFixed(1)));

    switch (_position) {
      case ICDrawerDirection.end:
        break;
      case ICDrawerDirection.start:
        delta = -delta;
        break;
    }
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        _controller.value -= delta + (delta * offset);
        break;
      case TextDirection.ltr:
        _controller.value += delta + (delta * offset);
        break;
    }

    final bool opened = _controller.value < 0.5 ? true : false;
    if (opened != _previouslyOpened && widget.icDrawerCallback != null) {
      widget.icDrawerCallback!(opened);
    }
    _previouslyOpened = opened;
  }

  void _settle(DragEndDetails details) {
    if (_controller.isDismissed) return;
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity =
          (details.velocity.pixelsPerSecond.dx + _velocity) / _width;

      switch (_position) {
        case ICDrawerDirection.end:
          break;
        case ICDrawerDirection.start:
          visualVelocity = -visualVelocity;
          break;
      }
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          _controller.fling(velocity: -visualVelocity);
          break;
        case TextDirection.ltr:
          _controller.fling(velocity: visualVelocity);
          break;
      }
    } else if (_controller.value < 0.5) {
      open();
    } else {
      close();
    }
  }

  void open({ICDrawerDirection? direction}) {
    if (direction != null) _position = direction;
    _controller.fling(velocity: -_velocity);
  }

  void close({ICDrawerDirection? direction}) {
    if (direction != null) _position = direction;
    _controller.fling(velocity: _velocity);
  }

  /// Open or Close InnerDrawer
  void toggle({ICDrawerDirection? direction}) {
    if (_previouslyOpened) {
      close(direction: direction);
    } else {
      open(direction: direction);
    }
  }

  final GlobalKey _gestureDetectorKey = GlobalKey();

  /// Outer Alignment
  AlignmentDirectional get _drawerOuterAlignment {
    switch (_position) {
      case ICDrawerDirection.start:
        return AlignmentDirectional.centerEnd;
      case ICDrawerDirection.end:
        return AlignmentDirectional.centerStart;
    }
  }

  /// Inner Alignment
  AlignmentDirectional get _drawerInnerAlignment {
    switch (_position) {
      case ICDrawerDirection.start:
        return AlignmentDirectional.centerStart;
      case ICDrawerDirection.end:
        return AlignmentDirectional.centerEnd;
    }
  }

  /// returns the left or right animation type based on InnerDrawerDirection
  ICDrawerAnimation get _animationType {
    return _position == ICDrawerDirection.start
        ? widget.leftAnimationType
        : widget.rightAnimationType;
  }

  /// returns the left or right scale based on InnerDrawerDirection
  double get _scaleFactor {
    return _position == ICDrawerDirection.start
        ? widget.scale.left
        : widget.scale.right;
  }

  /// returns the left or right offset based on InnerDrawerDirection
  double get _offset {
    return _position == ICDrawerDirection.start
        ? widget.offset.left
        : widget.offset.right;
  }

  /// return width with specific offset
  double get _widthWithOffset {
    return (_width / 2) - (_width / 2) * _offset;
    //NEW
    //return _width  - _width * _offset;
  }

  /// return swipe
  bool get _swipe {
    //NEW
    //if( _offset == 0 ) return false;
    return widget.swipe;
  }

  /// return swipeChild
  bool get _swipeChild {
    //NEW
    //if( _offset == 0 ) return false;
    return widget.swipeChild;
  }

  /// Scaffold
  Widget _scaffold() {
    assert(widget.borderRadius >= 0);

    final Widget? invC = _invisibleCover();

    final Widget scaffoldChild = Stack(
      children: <Widget?>[widget.scaffold, invC]
          .where((a) => a != null)
          .toList()
          .cast<Widget>(),
    );

    Widget container = Container(
        key: _drawerKey,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              widget.borderRadius * (1 - _controller.value)),
          boxShadow: kElevatedBoxShadow,
        ),
        child: widget.borderRadius != 0
            ? ClipRRect(
                borderRadius: BorderRadius.circular(
                    (1 - _controller.value) * widget.borderRadius),
                child: scaffoldChild)
            : scaffoldChild);

    if (_scaleFactor < 1) {
      container = Transform.scale(
        alignment: _drawerInnerAlignment,
        scale: ((1 - _scaleFactor) * _controller.value) + _scaleFactor,
        child: container,
      );
    }

    // Vertical translate
    if (widget.offset.top > 0 || widget.offset.bottom > 0) {
      final double translateY = MediaQuery.of(context).size.height *
          (widget.offset.top > 0 ? -widget.offset.top : widget.offset.bottom);
      container = Transform.translate(
        offset: Offset(0, translateY * (1 - _controller.value)),
        child: container,
      );
    }

    return container;
  }

  ///Disable the scaffolding tap when the drawer is open
  Widget? _invisibleCover() {
    final Container container = Container(
      color: ICColor.transparent,
    );
    if (_controller.value != 1.0 && widget.tapScaffoldEnabled) {
      return BlockSemantics(
        child: GestureDetector(
          // On Android, the back button is used to dismiss a modal.
          excludeFromSemantics: defaultTargetPlatform == TargetPlatform.android,
          behavior: HitTestBehavior.opaque,
          onTap: close,
          child: Semantics(
            label: CupertinoLocalizations.of(context).modalBarrierDismissLabel,
            child: container,
          ),
        ),
      );
    }
    return null;
  }

  Widget? get _leftChild {
    // TODO build menu
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            0,
            MediaQuery.of(context).padding.top == 0 ? 16 : 0,
            0,
            MediaQuery.of(context).padding.bottom == 0 ? 16 : 0,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ICDrawerButton(
                  title: 'Play',
                  icon: const Icon(CupertinoIcons.play),
                  onTap: () {
                    if (!ICRouter.isCurrentRoute(ICRoute.home)) {
                      ICRouter.pushNamed(context, ICRoute.home);
                    }
                    close();
                  },
                ),
                _ICDrawerButton(
                  title: 'Settings',
                  icon: const Icon(CupertinoIcons.settings),
                  onTap: () {
                    if (!ICRouter.isCurrentRoute(ICRoute.settings)) {
                      ICRouter.pushNamed(context, ICRoute.settings);
                    }
                    close();
                  },
                ),
                _ICDrawerButton(
                  title: 'Game history',
                  icon: const Icon(CupertinoIcons.square_stack_3d_up),
                  onTap: () {
                    if (!ICRouter.isCurrentRoute(ICRoute.gameHistory)) {
                      ICRouter.pushNamed(context, ICRoute.gameHistory);
                    }
                    close();
                  },
                ),
                _ICDrawerButton(
                  title: 'Rules',
                  icon: const Icon(CupertinoIcons.info),
                  onTap: () {
                    if (!ICRouter.isCurrentRoute(ICRoute.rules)) {
                      ICRouter.pushNamed(context, ICRoute.rules);
                    }
                    close();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? get _rightChild {
    return null;
  }

  /// return widget with specific animation
  Widget _animatedChild() {
    Widget? child =
        _position == ICDrawerDirection.start ? _leftChild : _rightChild;
    if (_swipeChild) {
      child = GestureDetector(
        onHorizontalDragUpdate: _move,
        onHorizontalDragEnd: _settle,
        child: child,
      );
    }
    final Widget container = SizedBox(
      width: widget.proportionalChildArea ? _width - _widthWithOffset : _width,
      height: MediaQuery.of(context).size.height,
      child: child,
    );

    switch (_animationType) {
      case ICDrawerAnimation.linear:
        return Align(
          alignment: _drawerOuterAlignment,
          widthFactor: 1 - (_controller.value),
          child: container,
        );
      case ICDrawerAnimation.quadratic:
        return Align(
          alignment: _drawerOuterAlignment,
          widthFactor: 1 - (_controller.value / 2),
          child: container,
        );
      default:
        return container;
    }
  }

  /// Trigger Area
  Widget? _trigger(AlignmentDirectional alignment, Widget? child) {
    final bool drawerIsStart = _position == ICDrawerDirection.start;
    final EdgeInsets padding = MediaQuery.of(context).padding;
    double dragAreaWidth = drawerIsStart ? padding.left : padding.right;

    if (Directionality.of(context) == TextDirection.rtl) {
      dragAreaWidth = drawerIsStart ? padding.right : padding.left;
    }
    dragAreaWidth = max(dragAreaWidth, _kEdgeDragWidth);

    if (_controller.status == AnimationStatus.completed &&
        _swipe &&
        child != null) {
      return Align(
        alignment: alignment,
        child: Container(color: ICColor.transparent, width: dragAreaWidth),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// initialize the correct width
    if (_initWidth == 400 ||
        MediaQuery.of(context).orientation != _orientation) {
      _updateWidth();
      _orientation = MediaQuery.of(context).orientation;
    }

    /// wFactor depends of offset and is used by the second Align that contains the Scaffold
    final double offset = 0.5 - _offset * 0.5;
    //NEW
    //final double offset = 1 - _offset * 1;
    final double wFactor = (_controller.value * (1 - offset)) + offset;

    return Container(
      decoration: widget.backgroundDecoration ??
          BoxDecoration(
            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
          ),
      child: Stack(
        alignment: _drawerInnerAlignment,
        children: <Widget>[
          FocusScope(node: _focusScopeNode, child: _animatedChild()),
          GestureDetector(
            key: _gestureDetectorKey,
            onTap: () {},
            onHorizontalDragDown: _swipe ? _handleDragDown : null,
            onHorizontalDragUpdate: _swipe ? _move : null,
            onHorizontalDragEnd: _swipe ? _settle : null,
            excludeFromSemantics: true,
            child: RepaintBoundary(
              child: Stack(
                children: <Widget?>[
                  ///Gradient
                  Container(
                    width: _controller.value == 0 ||
                            _animationType == ICDrawerAnimation.linear
                        ? 0
                        : null,
                    color: _colorTransitionChild.evaluate(_controller),
                  ),
                  Align(
                    alignment: _drawerOuterAlignment,
                    child: Align(
                      alignment: _drawerInnerAlignment,
                      widthFactor: wFactor,
                      child: RepaintBoundary(child: _scaffold()),
                    ),
                  ),

                  ///Trigger
                  _trigger(AlignmentDirectional.centerStart, _leftChild),
                  _trigger(AlignmentDirectional.centerEnd, _rightChild),
                ].where((a) => a != null).toList().cast<Widget>(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///An immutable set of offset in each of the four cardinal directions.
class IDOffset {
  const IDOffset.horizontal(
    double horizontal,
  )   : left = horizontal,
        top = 0.0,
        right = horizontal,
        bottom = 0.0;

  const IDOffset.only({
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
  })  : assert(top >= 0.0 &&
            top <= 1.0 &&
            left >= 0.0 &&
            left <= 1.0 &&
            right >= 0.0 &&
            right <= 1.0 &&
            bottom >= 0.0 &&
            bottom <= 1.0),
        assert(top >= 0.0 && bottom == 0.0 || top == 0.0 && bottom >= 0.0);

  /// The offset from the left.
  final double left;

  /// The offset from the top.
  final double top;

  /// The offset from the right.
  final double right;

  /// The offset from the bottom.
  final double bottom;
}

class _ICDrawerButton extends StatefulWidget {
  final String title;
  final Icon? icon;
  final FutureOr<void> Function()? onTap;

  const _ICDrawerButton({
    Key? key,
    required this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  _ICDrawerButtonState createState() => _ICDrawerButtonState();
}

class _ICDrawerButtonState extends State<_ICDrawerButton> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isTapped
            ? ICColor.highlightColor.resolveFrom(context)
            : ICColor.transparent,
      ),
      child: Row(
        children: <Widget>[
          if (widget.icon != null) ...[
            SizedBox(
              width: 24,
              child: widget.icon!,
            ),
            const SizedBox(width: 12),
          ],
          Text(
            widget.title,
            style: CupertinoTheme.of(context).textTheme.textStyle,
          ),
        ],
      ),
    );

    if (widget.onTap != null) {
      child = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isTapped = true),
        onTapCancel: () => setState(() => _isTapped = false),
        onTap: () async {
          await widget.onTap!.call();
          setState(() => _isTapped = false);
        },
        child: child,
      );
    }

    return child;
  }
}
