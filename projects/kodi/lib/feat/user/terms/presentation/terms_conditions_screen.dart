import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/feat/user/terms/controller/terms_controller.dart';
import 'package:kodi/feat/user/terms/controller/terms_state.dart';
import 'package:kodi/utils/app_bar.dart';
import 'package:kodi/utils/config/image.dart';
import 'package:kodi/utils/widgets/page_count_dotted_ui.dart';
import 'package:local_storage/local_storage.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/flutter_html.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/extension/app_text_colors.dart';
import 'package:theme/theme.dart';

import '../../../../../utils/routing/routes.dart';
import '../../../../common_widget.dart';
import '../../../../utils/app_pref_keys.dart';
import '../../../../utils/enums/StateEnum.dart';
import 'components/terms_conditions_ref_logic.dart';

class TermsConditions extends ConsumerStatefulWidget {
  const TermsConditions({super.key});

  @override
  ConsumerState<TermsConditions> createState() =>
      _TermsConditionsTermsConditionsState();
}

class _TermsConditionsTermsConditionsState
    extends ConsumerState<TermsConditions> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(termsProvider.notifier).resetTerms();
      if (mounted) setState(() => _animate = true);
      ref.read(termsProvider.notifier).getLatestTerms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(termsProvider);
    final isGuestUser = ref
        .watch(preferenceManagerProvider)
        .getBool(AppPrefsKeys.isGuestUser);

    ref.listen(termsProvider, (previous, next) {
      if (next.state == OnboardingStateEnum.successTermsAndCondition) {
        if (isGuestUser) {
          context.go(ScreenPaths.home);
        } else {
          context.go(ScreenPaths.userOnboardPref);
        }
      } else if (next.state == OnboardingStateEnum.errorTermAndCondition) {
        AppSnackBar.showError(context, next.errorMessage);
      }
    });
    return BaseUI(
      bodyPadding: EdgeInsets.zero,
      backgroundColor: AppColors.dark,
      appBar: CommonAppBar(backgroundColor: AppColors.dark),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            buildWave(animate: _animate, imagePath: Images.wave5Svg),
            buildWave(
              animate: _animate,
              imagePath: Images.wave6Svg,
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
                slideForward: false,
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
                    CommonText(
                      titleText: ('terms_and_conditions_title').tr(context),
                      semanticsLabel: ('terms_and_conditions_title').tr(
                        context,
                      ),
                      textStyle: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 24.iX,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 5.iY),
                    CommonText(
                      titleText: ('terms_and_conditions_subtitle').tr(context),
                      semanticsLabel: ('terms_and_conditions_subtitle').tr(
                        context,
                      ),
                      textStyle: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 24.iX,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 20.iY),
                    InfoTile(
                      text: ('view_terms_and_conditions').tr(context),
                      onTap: () {
                        context.push(
                          ScreenPaths.webView,
                          extra: [
                            "https://www.kodi.de/de/kodi_zukunft/_mein_kodi/mein_kodi_nutzungsbedingungen.php",
                            "terms_of_use".tr(context),
                          ],
                        );
                        // showDialog(
                        //   context: context,
                        //   builder: (_) {
                        //     return AlertDialog(
                        //       content: Scrollbar(
                        //         child: SingleChildScrollView(
                        //           child: (state.state == OnboardingStateEnum.loadingContent)
                        //               ?Center(child: CircularProgressIndicator()):
                        //           Padding(
                        //             padding:  EdgeInsets.symmetric(horizontal: 20.iX),
                        //             child: Html(
                        //               data: state.termsContent,
                        //               style: {
                        //                 "body": Style(
                        //                   color: Theme.of(
                        //                     context,
                        //                   ).extension<AppTextColors>()!.inverse,
                        //                   margin: Margins.zero,
                        //                   padding: HtmlPaddings.zero,
                        //                   fontSize: FontSize(13.iX),
                        //                 ),
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       actions: <Widget>[
                        //         TextButton(
                        //           child: CommonText(titleText: "ok".tr(context)),
                        //           onPressed: () => Navigator.of(context).pop(),
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // );
                      },
                    ),
                    InfoTile(
                      text: ('view_privacy_policy').tr(context),
                      onTap: () {
                        context.push(
                          ScreenPaths.webView,
                          extra: [
                            "https://www.kodi.de/de/kodi_zukunft/_mein_kodi/mein_kodi_datenschutzhinweise.php",
                            "privacy_policy".tr(context),
                          ],
                        );
                        // showDialog(
                        //   context: context,
                        //   builder: (_) {
                        //     return AlertDialog(
                        //       content: Scrollbar(
                        //         child: SingleChildScrollView(
                        //           child: (state.state == OnboardingStateEnum.loadingContent)
                        //               ?Center(child: CircularProgressIndicator()):
                        //           Padding(
                        //             padding:  EdgeInsets.symmetric(horizontal: 20.iX),
                        //             child: Html(
                        //               data: state.termsContent,
                        //               style: {
                        //                 "body": Style(
                        //                   color: Theme.of(
                        //                     context,
                        //                   ).extension<AppTextColors>()!.inverse,
                        //                   margin: Margins.zero,
                        //                   padding: HtmlPaddings.zero,
                        //                   fontSize: FontSize(13.iX),
                        //                 ),
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       actions: <Widget>[
                        //         TextButton(
                        //           child: CommonText(titleText: "ok".tr(context)),
                        //           onPressed: () => Navigator.of(context).pop(),
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // );
                      },
                    ),
                    SizedBox(height: 10.iY),
                    Consumer(
                      builder: (context, ref, _) {
                        bool isAccepted = hasUserAcceptedTerms(ref);
                        return CommonChecklistTile(
                          onTap: () {
                            ref.read(termsProvider.notifier).toggleTerms();
                          },
                          text: ('accept_terms_and_conditions').tr(context),
                          value: isAccepted,
                          backgroundColor: isAccepted
                              ? AppColors.primary
                              : AppColors.darkCard,
                        );
                      },
                    ),
                    SizedBox(height: 30.iY),
                    AppButton(
                      (isGuestUser ? 'finish_button' : 'next_button').tr(
                        context,
                      ),
                      disabled: hasUserAcceptedTerms(ref) ? false : true,
                      loading:
                          state.state ==
                          OnboardingStateEnum.loadingTermsAndCondition,
                      type: ButtonType.normal,
                      size: ButtonSize.large,
                      onPressed: () {
                        ref.read(termsProvider.notifier).saveTermsStatus();
                      },
                    ),
                    PageCountDottedUI(totalPage: 6, currentPage: 3),
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
