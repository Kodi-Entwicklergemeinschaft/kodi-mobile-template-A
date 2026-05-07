import 'package:common_components/common_components.dart';
import 'package:common_components/widgets/animations/slide_common_image_partial.dart';
import 'package:flutter/material.dart';
import 'package:kodi/utils/config/image.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';

import 'feat/dashboard/controller/dashboard_controller.dart';

Widget onboardingKodiLogo() {
  return CommonImage(imagePath: Images.mainKodiLogo, fit: BoxFit.fitHeight);
}

Widget onboardingBuildings({
  required bool animate,
  required double initialStart,
  required double finalStart,
  bool slideForward = true,
}) {
  return AspectRatio(
    aspectRatio: 1200 / 661,
    child: SlideCommonImagePartial(
      slideForward: slideForward,
      animate: animate,
      initialStart: initialStart,
      initialWindowFraction: 0.5,
      finalStart: finalStart,
      duration: Duration(milliseconds: 1200),
      image: CommonImage(
        imagePath: Images.buildings,
        color: Colors.white,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget buildWave({
  required bool animate,
  required String imagePath,
  bool reverse = false,
  Duration duration = const Duration(milliseconds: 1500),
  Curve curve = Curves.easeOutCubic,
}) {
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: AnimatedSlide(
      offset: animate
          ? (reverse ? const Offset(0, 0.4) : Offset.zero)
          : (reverse ? Offset.zero : const Offset(0, 0.4)),
      duration: duration,
      curve: curve,
      child: CommonImage(imagePath: imagePath),
    ),
  );
}

Widget onboardingBottomInfo() {
  return Positioned(
    bottom: 10.iY,
    right: 10.iY,
    child: SizedBox(
      height: 40.iY,
      child: CommonImage(imagePath: Images.bottomInfo, fit: BoxFit.fitHeight),
    ),
  );
}