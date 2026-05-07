import 'package:flutter/material.dart';

class AppTextColors extends ThemeExtension<AppTextColors> {
  final Color normal;
  final Color inverse;

  AppTextColors({
    required this.normal,
    required this.inverse,
  });

  @override
  AppTextColors copyWith({Color? normal, Color? inverse}) {
    return AppTextColors(
      normal: normal ?? this.normal,
      inverse: inverse ?? this.inverse,
    );
  }

  @override
  AppTextColors lerp(ThemeExtension<AppTextColors>? other, double t) {
    if (other is! AppTextColors) return this;
    return AppTextColors(
      normal: Color.lerp(normal, other.normal, t)!,
      inverse: Color.lerp(inverse, other.inverse, t)!,
    );
  }
}
