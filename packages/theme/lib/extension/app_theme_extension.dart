part of '../theme.dart';

// 1. Create a new extension


@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.successColor,
    required this.cardShadowColor,
    required this.extraSpacing,
  });

  // 1. Define your custom properties
  final Color? successColor;
  final Color? cardShadowColor;
  final double extraSpacing;

  // 2. Implement copyWith method
  @override
  AppThemeExtension copyWith({
    Color? successColor,
    Color? cardShadowColor,
    double? extraSpacing,
  }) {
    return AppThemeExtension(
      successColor: successColor ?? this.successColor,
      cardShadowColor: cardShadowColor ?? this.cardShadowColor,
      extraSpacing: extraSpacing ?? this.extraSpacing,
    );
  }

  // 3. Implement lerp (Linear Interpolation) for smooth theme transitions
  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      successColor: Color.lerp(successColor, other.successColor, t),
      cardShadowColor: Color.lerp(cardShadowColor, other.cardShadowColor, t),
      extraSpacing: lerpDouble(extraSpacing, other.extraSpacing, t),
    );
  }

  // 4. Static method for easy access (Optional but recommended)
  static AppThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<AppThemeExtension>()!;
  }
}

// Helper for double lerp
double lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}
