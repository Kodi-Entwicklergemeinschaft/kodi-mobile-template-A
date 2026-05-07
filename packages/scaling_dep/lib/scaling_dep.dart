import 'package:flutter/material.dart';

late SizeUtils _sizeUtilsInstance;

class SizeUtils {
  late final Size _screenSize;
  final double _refH;
  final double _refW;

  SizeUtils(this._screenSize, this._refH, this._refW) {
    _sizeUtilsInstance = this;
  }

  Size get screenSize => _screenSize;

  double get height => _screenSize.height;

  double get width => _screenSize.width;

  double iX(double refVal) => width * (refVal / _refW);

  double iY(double refVal) => height * (refVal / _refH);

  double fractionX(double refVal) => width * refVal;

  double fractionY(double refVal) => height * refVal;
}