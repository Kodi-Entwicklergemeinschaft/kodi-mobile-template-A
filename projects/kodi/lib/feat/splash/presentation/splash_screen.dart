import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/feat/splash/controller/splash_state.dart';
import 'package:local_storage/preference_manager_impl.dart';
import 'package:locale/locale.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import '../../../utils/app_pref_keys.dart';
import '../../../utils/config/image.dart';
import 'package:theme/theme.dart';

import '../../../utils/routing/routes.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the app when the splash screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashProvider.notifier).initializeApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    final preferenceManager = ref.watch(preferenceManagerProvider);
    final state = ref.watch(splashProvider);

    // Listen to splash state changes
    ref.listen(splashProvider, (previous, current) async {
      if (previous != current) {
        if (current is SplashError) {
          AppSnackBar.showError(context, current.error);
        }

        // Navigate to dashboard when initialization is successful
        if (current is SplashSuccess) {
          final token = preferenceManager.getStringOrEmpty(AppPrefsKeys.token);
          if (token.isNotEmpty) {
            if (!preferenceManager.getBool(
              AppPrefsKeys.isTermsAndConditionAccepted,
            )) {
              context.go(ScreenPaths.termsConditions);
            } else {
              context.go(ScreenPaths.home);
            }
          } else {
            context.go(ScreenPaths.welcome);
          }
        }
      }
    });
    return BaseUI(
      backgroundColor: AppColors.dark,
      body: Stack(
        children: [
          /// Waves area
          Positioned.fill(
            child: Column(
              children: [
                Expanded(flex: 5, child: const SizedBox()),
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CommonImage(
                          imagePath: Images.wave2Svg,
                          fit: BoxFit.cover,
                          width: w,
                        ),
                      ),
                      Positioned(
                        top: h * 0.15,
                        right: w * 0.01,
                        child: CommonImage(
                          imagePath: Images.wave4Svg,
                          width: w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: h * 0.13,
                        left: 0,
                        right: 0,
                        child: CommonImage(
                          imagePath: Images.wave3Svg,
                          width: w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: h * 0.25,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: CommonImage(
                          imagePath: Images.wave1Svg,
                          width: w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Title + text
          Positioned(
            top: h * 0.28,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CommonText(
                  titleText: ('splash_title').tr(context),
                  textStyle: const TextStyle(
                    fontSize: 22,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: h * 0.015),
                SizedBox(
                  width: w,
                  child: Center(
                    child: CommonImage(
                      imagePath: Images.mainKodiLogo,
                      width: 230,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Birds
          Positioned(
            top: h * 0.10,
            right: w * 0.05,
            child: CommonImage(imagePath: Images.birdsSvg, height: h * 0.05),
          ),
          Positioned(
            top: h * 0.14,
            right: w * 0.25,
            child: CommonImage(imagePath: Images.birdsSvg, height: h * 0.05),
          ),

          /// Lighthouse
          Positioned(
            bottom: h * 0.24,
            right: w * 0.1,
            child: CommonImage(
              imagePath: Images.lightHouseSvg,
              height: h * 0.22,
              width: w * 0.22,
            ),
          ),
        ],
      ),
      isStackLoading: state is SplashLoading,
      isSuccess: state is! SplashLoading,
    );
  }
}
