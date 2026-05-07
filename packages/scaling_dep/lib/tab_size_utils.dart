import 'package:flutter/material.dart';
import 'package:scaling_dep/scaling_dep.dart';

late _TabSizeUtils _tabSizeUtilsInstance;
_TabSizeUtils get TabSizeUtils => _tabSizeUtilsInstance;

const double refH = 600;
const double refW = 1024;
final Size screenSize = Size(Responsive.widthScreen, Responsive.heightScreen);

void initSizeUtils() {
  _tabSizeUtilsInstance = _TabSizeUtils.internal();
}

class _TabSizeUtils extends SizeUtils with Responsive {
  _TabSizeUtils.internal() : super(screenSize, refH, refW);
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
  double get iX => _tabSizeUtilsInstance.iX(toDouble());

  double get iY => _tabSizeUtilsInstance.iY(toDouble());

  double get fractionX => _tabSizeUtilsInstance.fractionX(toDouble());

  double get fractionY => _tabSizeUtilsInstance.fractionY(toDouble());
}

extension DoubleSizeExtension on double {
  double get iX => _tabSizeUtilsInstance.iX(this);

  double get iY => _tabSizeUtilsInstance.iY(this);

  double get fractionX => _tabSizeUtilsInstance.fractionX(this);

  double get fractionY => _tabSizeUtilsInstance.fractionY(this);
}