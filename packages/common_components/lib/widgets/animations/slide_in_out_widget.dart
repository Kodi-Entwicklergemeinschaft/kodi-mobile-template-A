part of '../../common_components.dart';

enum SlideDirection { left, right, up, down }

class SlideInOutWidget extends StatefulWidget {
  final Widget child;

  /// true = Slide IN (visible at end)
  final bool slideIn;

  /// When true, start animation (forward based on slideIn)
  final bool animate;

  final Duration duration;
  final SlideDirection direction;
  final Curve curve;

  /// How far off-screen to move (1.0 = 100% width/height, 2.0 = 200%)
  final double distance;

  const SlideInOutWidget({
    super.key,
    required this.child,
    required this.slideIn,
    required this.animate,
    this.duration = const Duration(milliseconds: 700),
    this.direction = SlideDirection.left,
    this.curve = Curves.easeInOut,
    this.distance = 1.0,
  });

  @override
  State<SlideInOutWidget> createState() => _SlideInOutWidgetState();
}

class _SlideInOutWidgetState extends State<SlideInOutWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    // build tween depending on slideIn flag:
    _offset = _buildTween().animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // If animate is false, snap to start or end state immediately
    if (!widget.animate) {
      // If slideIn==true we want the widget visible (end state) => controller = 1.0
      // If slideIn==false we want the widget hidden (start state) => controller = 0.0
      _controller.value = widget.slideIn ? 1.0 : 0.0;
    } else {
      // If animate true at start, run forward to play the tween (which is created to play in the correct direction)
      WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward(from: 0.0));
    }
  }

  @override
  void didUpdateWidget(covariant SlideInOutWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If direction/distance/duration changed, rebuild animation
    if (oldWidget.direction != widget.direction || oldWidget.distance != widget.distance) {
      _offset = _buildTween().animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    }
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    // When animate toggles from false->true, run the animation
    if (widget.animate && !oldWidget.animate) {
      _controller.forward(from: 0.0);
    }

    // When animate toggles from true->false, snap to the final state based on slideIn
    if (!widget.animate && oldWidget.animate) {
      _controller.value = widget.slideIn ? 1.0 : 0.0;
    }

    // If slideIn changed but animate is false, snap to new final state
    if (!widget.animate && widget.slideIn != oldWidget.slideIn) {
      _controller.value = widget.slideIn ? 1.0 : 0.0;
    }
  }

  /// Create tween that maps forward() to the physical effect we want:
  /// - If slideIn == true  : begin = offscreen, end = on-screen (Offset.zero)
  /// - If slideIn == false : begin = on-screen (Offset.zero), end = offscreen
  Tween<Offset> _buildTween() {
    final d = widget.distance;
    Offset off;
    switch (widget.direction) {
      case SlideDirection.left:
        off = Offset(-d, 0);
        break;
      case SlideDirection.right:
        off = Offset(d, 0);
        break;
      case SlideDirection.up:
        off = Offset(0, -d);
        break;
      case SlideDirection.down:
        off = Offset(0, d);
        break;
    }

    if (widget.slideIn) {
      // forward() => move from OFFSCREEN -> ONSCREEN
      return Tween(begin: off, end: Offset.zero);
    } else {
      // forward() => move from ONSCREEN -> OFFSCREEN
      return Tween(begin: Offset.zero, end: off);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
