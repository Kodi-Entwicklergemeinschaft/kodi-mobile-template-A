import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/auth/select_user_type/presentation/components/select_user_type_ref_logic.dart'
    show userType;
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/feat/user/terms/controller/terms_controller.dart';
import 'package:kodi/feat/user/terms/controller/terms_state.dart';
import 'package:kodi/utils/app_bar.dart';
import 'package:kodi/utils/config/image.dart';
import 'package:kodi/utils/enums/StateEnum.dart';
import 'package:kodi/utils/widgets/page_count_dotted_ui.dart';
import 'package:local_storage/local_storage.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';

import '../../../../../utils/routing/routes.dart';
import '../../../../common_widget.dart';
import '../../../../utils/app_pref_keys.dart';
import 'components/terms_conditions_ref_logic.dart';

class UserOnboardPrefs extends ConsumerStatefulWidget {
  const UserOnboardPrefs({super.key});

  @override
  ConsumerState<UserOnboardPrefs> createState() =>
      _UserOnboardPrefsUserOnboardPrefsState();
}

class _UserOnboardPrefsUserOnboardPrefsState
    extends ConsumerState<UserOnboardPrefs> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(termsProvider.notifier).resetNotificationAndNewsLetter();
      if (mounted) setState(() => _animate = true);
    });
  }

  @override
  Widget build(BuildContext context) {

    final state= ref.watch(termsProvider);

    ref.listen(termsProvider, (previous, next) {
      if (next.state == OnboardingStateEnum.successNotificationPref) {
        context.go(ScreenPaths.home);
      } else if (next.state == OnboardingStateEnum.errorNotificationPref) {
        AppSnackBar.showError(context, next.errorMessage);
      }
    });
    return BaseUI(
      backgroundColor: AppColors.dark,
      bodyPadding: EdgeInsets.zero,
      appBar: CommonAppBar(
          onBackPressed: (){
            ref.read(termsProvider.notifier).goToTerms();
          },
          showBackButton: state.isNewsLetterScreen,
          backButtonColor: AppColors.white,
          backgroundColor: AppColors.dark),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
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
              child: onboardingBuildings(
                animate: _animate,
                initialStart: 0.07,
                finalStart: 0.45,
              ),
            ),
            onboardingBottomInfo(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.iX),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10.iY,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.iY),
                      child: onboardingKodiLogo(),
                    ),
                    SizedBox(height: 20.iY),
                    if(!state.isNewsLetterScreen)
                    CommonText(
                      titleText: ('push_notifications_title').tr(context),
                      semanticsLabel: ('push_notifications_title').tr(context),

                      textStyle: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 24.iX,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: 10.iY),
                    if(!state.isNewsLetterScreen)
                    CommonText(
                      titleText: ('push_notifications_subtitle').tr(context),
                      semanticsLabel: ('push_notifications_subtitle').tr(context),
                      textStyle: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 24.iX,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                      ),
                    ),
                    if(state.isNewsLetterScreen)
                      CommonText(
                        titleText: ('newsletter_title').tr(context),
                        semanticsLabel: ('newsletter_title').tr(context),
                        textStyle: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 24.iX,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                        ),
                      ),
                    SizedBox(height: 20.iY),
                    //for push notification
                    if(!state.isNewsLetterScreen)
                      Consumer(
                      builder: (context, ref, _) {
                        bool isAccepted = hasUserAcceptedPushNotification(ref);
                        return CommonChecklistTile(
                          onTap: () {
                            ref
                                .read(termsProvider.notifier)
                                .toggleNotificationConsent();
                          },
                          text: ('accept_push_notifications').tr(context),
                          value: isAccepted,
                          backgroundColor: isAccepted
                              ? AppColors.primary
                              : AppColors.darkCard,
                        );
                      },
                    ),
                    //for newsletter
                    if(state.isNewsLetterScreen)
                      Consumer(
                      builder: (context, ref, _) {
                        bool isAccepted = hasUserAcceptedNewsLetter(ref);
                        return CommonChecklistTile(
                          onTap: () {
                            ref
                                .read(termsProvider.notifier)
                                .toggleNewsLetterConsent();
                          },
                          text: ('newsletter_permission').tr(context),
                          value: isAccepted,
                          backgroundColor: isAccepted
                              ? AppColors.primary
                              : AppColors.darkCard,
                        );
                      },
                    ),
                    SizedBox(height: 10.iY),
                    Consumer(
                      builder: (context, ref, _) {
                        return AppButton(
                          (state.isNewsLetterScreen?'finish_button':'next_button').tr(context),
                          type: ButtonType.normal,
                          size: ButtonSize.large,
                          loading: state.state==OnboardingStateEnum.loadingNotificationPref,
                          onPressed: () {
                            // String termsId = ref
                            //     .watch(preferenceManagerProvider)
                            //     .getStringOrEmpty(AppPrefsKeys.termsAndConditionId);
                            if(state.isNewsLetterScreen) {
                              ref
                                  .read(termsProvider.notifier)
                                  .saveNotificationStatus();
                            }
                            else{
                              ref.read(termsProvider.notifier).goToNewsLetter();
                            }
                          },
                        );
                      },
                    ),
                    PageCountDottedUI(totalPage: 6, currentPage: state.isNewsLetterScreen?5:4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
