import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/feat/user/profile/controller/profile_controller.dart';
import 'package:kodi/feat/user/setting/widget/section_tile.dart';
import 'package:kodi/utils/app_bar.dart';
import 'package:kodi/utils/app_launcher_utils.dart';
import 'package:kodi/utils/common_methods.dart';
import 'package:kodi/utils/enums/StateEnum.dart';
import 'package:kodi/utils/routing/routes.dart';
import 'package:local_storage/preference_manager_impl.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/custom_webview.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';

import '../../../utils/app_pref_keys.dart';
import '../../../utils/config/image.dart';
import '../account/controller/account_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuestUser = ref.watch(preferenceManagerProvider).getBool(AppPrefsKeys.isGuestUser);
    final profileState= ref.watch(profileProvider);
    final accountController = ref.watch(accountControllerProvider.notifier);

    ref.listen(profileProvider, (previous, next) {
      if(previous!=next){
        if(next.errorMessage.isNotEmpty){
          AppSnackBar.showError(context, next.errorMessage);
        }
        if(next.successMessage.isNotEmpty){

          AppSnackBar.showSuccess(context, next.successMessage);
        }
      }
    });

    return BaseUI(
      showBottomNavigationBar: true,
      isStackLoading: profileState.status==StateEnum.loadingDialog,
      appBar: CommonAppBar(
        showBackButton: true,
        showTitleLogo: false,
        toolbarHeight: 70.iY,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.iY),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10.iY,
            children: [
              CommonText(
                titleText: "setting".tr(context).toUpperCase(),
                textStyle: TextStyle(
                  fontSize: 20.iY,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SectionTitle(
                "language".tr(context),
                label: 'common_icon_label'
                    .tr(context)
                    .replaceAll('{itemName}', "language".tr(context)),
                iconImage: Images.languageIcon,
                onTap: () {
                  context.go(
                    '${ScreenPaths.account}/${ScreenPaths.setting}/${ScreenPaths.languageSelection}',
                  );
                },
              ),

              SectionTitle(
                "accessibility".tr(context),
                icon: Icons.accessibility_new,
                onTap: () {
                  context.push(
                    ScreenPaths.webView,
                    extra: [
                      "https://www.kodi.de/de/_info/barrierefreiheit.php",
                      "accessibility".tr(context),
                    ],
                  );
                },
                label: 'common_icon_label'
                    .tr(context)
                    .replaceAll('{itemName}', "accessibility".tr(context)),
              ),

              if(!isGuestUser)
              SectionTitle(
                "notifications".tr(context),
                icon: Icons.notifications,
                onTap: () {
                  context.go(
                    '${ScreenPaths.account}/${ScreenPaths.setting}/${ScreenPaths.notificationPrefs}',
                  );
                },
                label: 'common_icon_label'
                    .tr(context)
                    .replaceAll('{itemName}', "notifications".tr(context)),
              ),

              SectionTitle(
                "privacy_policy".tr(context),
                label: 'common_icon_label'
                    .tr(context)
                    .replaceAll('{itemName}', "privacy_policy".tr(context)),
                iconImage: Images.privacyIcon,
                onTap: () {
                  context.push(
                    ScreenPaths.webView,
                    extra: [
                      "https://www.kodi.de/de/kodi_zukunft/_mein_kodi/mein_kodi_datenschutzhinweise.php",
                      "privacy_policy".tr(context),
                    ],
                  );
                },
              ),

              SectionTitle(
                "imprint".tr(context),
                label: 'common_icon_label'
                    .tr(context)
                    .replaceAll('{itemName}', "imprint".tr(context)),
                iconImage: Images.imprintIcon,
                onTap: () {
                  context.push(
                    ScreenPaths.webView,
                    extra: [
                      "https://www.kodi.de/de/kodi_zukunft/_mein_kodi/mein_kodi_impressum.php",
                      "imprint".tr(context),
                    ],
                  );
                },
              ),

              SectionTitle(
                "app_theme".tr(context),
                label: 'common_icon_label'
                    .tr(context)
                    .replaceAll('{itemName}', "app_theme".tr(context)),
                iconImage: Images.servicesIcon,
                onTap: () {
                  context.go(
                    '${ScreenPaths.account}/${ScreenPaths.setting}/${ScreenPaths.themeSelection}',
                  );
                },
              ),
              if(accountController.isLoggedIn())
                SectionTitle(
                  "reset_password".tr(context),
                  label: 'common_icon_label'
                      .tr(context)
                      .replaceAll('{itemName}', "reset_password".tr(context)),
                  icon: Icons.password,
                  onTap: () {
                    context.go(
                      '${ScreenPaths.account}/${ScreenPaths.setting}/${ScreenPaths.resetPasswordProfileScreen}',
                    );
                  },
                ),
              if(accountController.isLoggedIn())
                SectionTitle(
                "delete_account".tr(context),
                label: 'common_icon_label'
                    .tr(context)
                    .replaceAll('{itemName}', "delete_account".tr(context)),
                icon: Icons.delete,
                onTap: () {
                  CommonMethods.showDeleteAccountDialog(context,onDelete: (){

                    ref.read(profileProvider.notifier).deleteAccount().then((isDeleted)  {
                      if(isDeleted) {
                        if(context.mounted) {
                          context.go(ScreenPaths.welcome);
                        }
                      }
                    });
                  });
                },
              ),

              // SectionTitle(
              //   "service_offers_configuration".tr(context),
              //   icon: Icons.build,
              // ),
              //
              // SectionTitle(
              //   "connections_interfaces".tr(context),
              //   icon: Icons.share,
              // ),
              // SizedBox(height: 10.iY),
              // CommonText(
              //   titleText: "contact".tr(context).toUpperCase(),
              //   textStyle: TextStyle(
              //     fontSize: 20.iY,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SectionTitle("chat".tr(context), icon: Icons.chat),
              //
              // SectionTitle("opening_hours".tr(context), icon: Icons.access_time),
              //
              // SectionTitle("contact".tr(context), icon: Icons.contact_mail),
            ],
          ),
        ),
      ),
    );
  }
}
