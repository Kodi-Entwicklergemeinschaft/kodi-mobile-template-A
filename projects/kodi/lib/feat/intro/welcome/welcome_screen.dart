import 'package:common_components/common_components.dart';
import 'package:common_components/widgets/animations/slide_common_image_partial.dart';
import 'package:flutter/material.dart';
import 'package:kodi/common_widget.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/utils/app_bar.dart';
import 'package:kodi/utils/widgets/page_count_dotted_ui.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:theme/theme.dart';

import '../../../utils/config/image.dart';
import '../../../utils/routing/routes.dart';

class Welcome extends StatefulWidget {
  final bool? isGoToLoginScreen;
  const Welcome({this.isGoToLoginScreen=false,super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isGoToLoginScreen??false) {
        GoRouter.of(context).push(ScreenPaths.userType, extra: true);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return BaseUI(
      backgroundColor: AppColors.dark,
      appBar: CommonAppBar(
        backgroundColor: AppColors.dark,
      ),
      bodyPadding: EdgeInsets.zero,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: CommonImage(imagePath: Images.wave5Svg),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: onboardingBuildings(
              animate: false,
              initialStart: 0.07,
              finalStart: 0.45,
            ),
          ),
          onboardingBottomInfo(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 60.iX),
                child: CommonImage(imagePath: Images.birdForwardIcon),
              ),
              SizedBox(height: 50.iY),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.iX),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20.iY,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 32.iX,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: ('welcome_header').tr(context),
                            semanticsLabel: ('welcome_header').tr(context),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.iY),
                      child: onboardingKodiLogo(),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 32.iX,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: ('onboarding_title_1').tr(context),
                            semanticsLabel: ('onboarding_title_1').tr(context),
                          ),
                          TextSpan(
                            text: ('onboarding_title_2').tr(context),
                            semanticsLabel: ('onboarding_title_2').tr(context),
                          ),
                          TextSpan(
                            text: ('onboarding_title_3').tr(context),
                            semanticsLabel: ('onboarding_title_3').tr(context),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.iY),
                    AppButton(
                      ('welcome_button').tr(context),
                      type: ButtonType.normal,
                      size: ButtonSize.large,
                      onPressed: () {
                        GoRouter.of(context).push(ScreenPaths.userType);
                      },
                    ),
                    PageCountDottedUI(totalPage: 6, currentPage: 0),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
