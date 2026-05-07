part of '../../common_components.dart';

class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration fadeDuration;
  final Duration startDelay;

  /// The target opacity value. (1.0 = fully visible, 0.0 = fully transparent)
  /// If provided, overrides automatic fade-in behavior.
  final double? targetOpacity;

  const FadeInWidget({
    super.key,
    required this.child,
    this.fadeDuration = const Duration(milliseconds: 200),
    this.startDelay = const Duration(seconds: 1),
    this.targetOpacity,
  });

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget> {
  late double _opacity;

  @override
  void initState() {
    super.initState();
    _opacity = widget.targetOpacity ?? 0.0;

    // If no external opacity is given, do automatic fade-in after delay
    if (widget.targetOpacity == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(widget.startDelay, () {
          if (mounted) setState(() => _opacity = 1.0);
        });
      });
    }
  }

  @override
  void didUpdateWidget(covariant FadeInWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If parent updates opacity externally
    if (widget.targetOpacity != null && widget.targetOpacity != _opacity) {
      setState(() => _opacity = widget.targetOpacity!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: widget.fadeDuration,
      curve: Curves.easeInOut,
      child: widget.child,
    );
  }
}
