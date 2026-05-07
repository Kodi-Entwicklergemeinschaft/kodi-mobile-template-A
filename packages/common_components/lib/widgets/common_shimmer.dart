part of '../common_components.dart';


class CommonShimmer extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final Color? baseColor;
  final Color? highlightColor;

  const CommonShimmer({
    super.key,
    required this.child,
    this.enabled = true,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.darkGrey.withOpacity(0.7),
      highlightColor: highlightColor ?? AppColors.darkShadow,
      child: child,
    );
  }
}
