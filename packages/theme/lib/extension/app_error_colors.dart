import 'package:flutter/material.dart';

class AppErrorColors extends ThemeExtension<AppErrorColors> {
  final Color normal;
  final Color inverse;

  const AppErrorColors({
    required this.normal,
    required this.inverse,
  });

  @override
  AppErrorColors copyWith({
    Color? error,
    Color? onError,
  }) {
    return AppErrorColors(
      normal: error ?? normal,
      inverse: onError ?? inverse,
    );
  }

  @override
  AppErrorColors lerp(ThemeExtension<AppErrorColors>? other, double t) {
    if (other is! AppErrorColors) return this;
    return AppErrorColors(
      normal: Color.lerp(normal, other.normal, t)!,
      inverse: Color.lerp(inverse, other.inverse, t)!,
    );
  }
}
