import 'package:flutter/material.dart';
import 'package:scaling_dep/scaling_dep.dart';

late _MobileSizeUtils _mobileSizeUtilsInstance;

_MobileSizeUtils get MobileSizeUtils => _mobileSizeUtilsInstance;
const double refH = 1075;
const double refW = 496;
final Size screenSize = Size(Responsive.widthScreen, Responsive.heightScreen);

void initSizeUtils() {
  _mobileSizeUtilsInstance = _MobileSizeUtils.internal();
}

class _MobileSizeUtils extends SizeUtils with Responsive {
  _MobileSizeUtils.internal() : super(screenSize, refH, refW);
}

mixin Responsive {
  static final double widthScreen = WidgetsBinding
          .instance.platformDispatcher.views.first.physicalSize.width /
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

  static final double heightScreen = WidgetsBinding
          .instance.platformDispatcher.views.first.physicalSize.height /
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
}

extension IntSizeExtension on int {
  double get iX => _mobileSizeUtilsInstance.iX(toDouble());

  double get iY => _mobileSizeUtilsInstance.iY(toDouble());

  double get fractionX => _mobileSizeUtilsInstance.fractionX(toDouble());

  double get fractionY => _mobileSizeUtilsInstance.fractionY(toDouble());
}

extension DoubleSizeExtension on double {
  double get iX => _mobileSizeUtilsInstance.iX(this);

  double get iY => _mobileSizeUtilsInstance.iY(this);

  double get fractionX => _mobileSizeUtilsInstance.fractionX(this);

  double get fractionY => _mobileSizeUtilsInstance.fractionY(this);
}