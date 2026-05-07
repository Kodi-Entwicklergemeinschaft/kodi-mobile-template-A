import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/auth/login/controller/login_controller.dart';
import 'package:kodi/feat/auth/login/controller/login_state.dart';
import 'package:kodi/feat/auth/select_user_type/controller/select_user_type_controller.dart';
import 'package:kodi/feat/auth/select_user_type/controller/select_user_type_state.dart';
import 'package:kodi/feat/auth/select_user_type/presentation/components/user_type_card.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/utils/app_bar.dart' show CommonAppBar;
import 'package:kodi/utils/config/image.dart' show Images;
import 'package:kodi/utils/routing/routes.dart' show ScreenPaths;
import 'package:local_storage/preference_manager_impl.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';
import '../../../../common_widget.dart';
import '../../../../utils/app_pref_keys.dart';
import '../../../../utils/env_config.dart';
import '../../../../utils/widgets/page_count_dotted_ui.dart';
import 'components/select_user_type_ref_logic.dart';

class SelectUserType extends ConsumerStatefulWidget {
  final bool? isHomeUserSelected;
  const SelectUserType({this.isHomeUserSelected=false,super.key});

  @override
  ConsumerState<SelectUserType> createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends ConsumerState<SelectUserType> {
  bool _animate = false;
  final double slideDistance = .5; // 1.0 = exactly one viewport width offscreen
  final Duration slideDuration = const Duration(milliseconds: 800);
  final Curve slideCurve = Curves.easeInOutCubic;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectUserTypeProvider.notifier).resetState();
      ref
          .read(themeServiceProvider.notifier)
          .toggleTheme(false);
      if (mounted) setState(() => _animate = true);

      if (!EnvironmentConfig.isProd) {
        AppSnackBar.showSuccess(context, EnvironmentConfig.environment.name);
      }
      if(widget.isHomeUserSelected??false){
        ref.read(selectUserTypeProvider.notifier).selectUserType(UserTypeEnum.resident.toInt);
        context.push(ScreenPaths.register);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginProvider, (pre, nxt) {
      if (pre != nxt) {
        if (nxt is GuestLoginSuccess) {
          /// Navigate to terms and conditions for only guest user
          context.go(ScreenPaths.termsConditions);
          // if (!ref
          //     .read(preferenceManagerProvider)
          //     .getBool(AppPrefsKeys.isTermsAndConditionAccepted)) {
          //   context.go(ScreenPaths.termsConditions);
          // } else {
          //   context.go(ScreenPaths.home);
          // }
          ref.read(loginProvider.notifier).resetState();
          ref.read(selectUserTypeProvider.notifier).resetState();
        } else if (nxt is GuestLoginError) {
          AppSnackBar.showError(context, nxt.error);
        }
      }
      if (nxt is Logout) {
        context.go(ScreenPaths.login);
      }
    });
    return BaseUI(
      backgroundColor: AppColors.dark,
      appBar: CommonAppBar(
        showBackButton: true,
        backgroundColor: AppColors.dark,
        backButtonColor: AppColors.secondary,
      ),
      bodyPadding: EdgeInsets.zero,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 70.iY),
            child: FadeOutWidget(
              targetOpacity: _animate ? 0.0 : 1.0, // change dynamically
              fadeDuration: const Duration(milliseconds: 600),
              child: CommonImage(
                imagePath: Images.birdsSvg,
                label: ('illustration_related_to_content_label').tr(context),
              ),
            ),
          ),
          buildWave(animate: _animate, imagePath: Images.wave6Svg),
          buildWave(
            animate: _animate,
            imagePath: Images.wave5Svg,
            reverse: true, // 👈 this flips the animation direction
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Semantics(
              label: 'onboarding_buildings_illustration'.tr(context),
              child: onboardingBuildings(
                animate: _animate,
                initialStart: 0.07,
                finalStart: 0.45,
              ),
            ),
          ),

          onboardingBottomInfo(),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            top: (_animate) ? 0 : MediaQuery.of(context).size.height * .09,
            right: 0,
            left: 0,
            child: MoveUpWithFiller(
              animate: _animate,
              child: Padding(
                padding: EdgeInsets.only(top: 5.iY),
                child: Semantics(
                  label: 'kodi_app_logo_label'.tr(context),
                  child: onboardingKodiLogo(),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.iX),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100.iY),
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
                          text: ('user_type_selection_title').tr(
                            context,
                          ),
                          semanticsLabel: ('user_type_selection_title')
                              .tr(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.iY),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10.iX,
                      children: [
                        UserTypeCard(
                          text: ('user_type_home').tr(context),
                          value: UserTypeEnum.resident.toInt,
                          imagePath:
                          "lib/feat/auth/select_user_type/presentation/assets/hause.png",
                          ref: ref,
                          semanticsLabel: 'user_type_home_card_label'.tr(context),
                        ),
                        UserTypeCard(
                          text: ('user_type_guest').tr(context),
                          value: UserTypeEnum.guest.toInt,
                          imagePath:
                          "lib/feat/auth/select_user_type/presentation/assets/gast.png",
                          ref: ref,
                          semanticsLabel: 'user_type_guest_card_label'.tr(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.iY),
                  Consumer(
                    builder: (context, ref, _) {
                      UserTypeEnum? type = userType(ref);
                      final loginState = ref.watch(loginProvider);
                      return AppButton(
                        ('next_button').tr(context),
                        disabled: (type != null) ? false : true,
                        type: ButtonType.normal,
                        size: ButtonSize.large,
                        loading: loginState is LoginLoading,
                        onPressed: () {
                          UserTypeEnum? type = userType(ref);
                          if (type != null) {
                            if (type == UserTypeEnum.guest) {
                              ref
                                  .read(loginProvider.notifier)
                                  .guestLogin();
                            } else {
                              context.push(ScreenPaths.register);
                            }
                          }
                        },
                      );
                    },
                  ),
                  PageCountDottedUI(
                    totalPage: 6,
                    currentPage: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
