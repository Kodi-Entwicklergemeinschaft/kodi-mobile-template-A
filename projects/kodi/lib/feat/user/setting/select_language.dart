import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/feat/home/controller/home_screen_controller.dart';
import 'package:kodi/feat/listings/events/controller/event_controller.dart';
import 'package:kodi/feat/user/profile/controller/profile_controller.dart';
import 'package:kodi/lang/app_translation_provider.dart';
import 'package:kodi/utils/app_bar.dart';
import 'package:kodi/utils/common_methods.dart';
import 'package:kodi/utils/routing/routes.dart';
import 'package:locale/locale.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/extension/app_container_colors.dart';
import 'package:theme/extension/app_text_colors.dart';
import 'package:theme/theme.dart';

import '../../../utils/enums/StateEnum.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  String? selectedLanguage;

  @override
  void initState() {
    selectedLanguage = ref
        .read(appTranslationProvider)
        .languageDisplayName(ref.read(localeControllerProvider));
    super.initState();
  }

  restartApp(){
    CommonMethods.showRestartAppDialog(
        context,
        onRestart: ()=> context.go(ScreenPaths.splash),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> languageDisplayNames = ref
        .read(appTranslationProvider)
        .localeNames
        .values
        .toList();
    final profileState= ref.watch(profileProvider);
    return BaseUI(
      isStackLoading: profileState.status==StateEnum.loading,
      appBar: CommonAppBar(
        showBackButton: true,
        showTitleLogo: false,
        toolbarHeight: 70.iY,
        // title: CommonText(titleText: "language".tr(context),textStyle: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.iY),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10.iY,
          children: [
            CommonText(
              titleText: "language".tr(context).toUpperCase(),
              textStyle: TextStyle(
                fontSize: 20.iY,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: ref.read(appTranslationProvider).supportedLocales.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10.iY),
                    child: Container(
                      color:Colors.red,
                      child: InkWell(
                        onTap: () async {
                          if(selectedLanguage==languageDisplayNames[index]) return;
                          setState((){
                            selectedLanguage = languageDisplayNames[index];
                          });
                          final languageCode=ref
                              .read(appTranslationProvider)
                              .localeFromName(languageDisplayNames[index]);
                          ref
                              .read(localeControllerProvider.notifier)
                              .setLocale(
                              languageCode
                          );
                          await ref.read(profileProvider.notifier).updateLanguage(languageCode.languageCode??'de').then((onValue){
                            // restartApp();
                            ref.read(homeControllerProvider.notifier).loadData();
                          });

                        },
                        child: Container(
                          padding: EdgeInsets.all(10.iX),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Theme.of(context).extension<AppContainerColors>()!.normal,
                          ),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: languageDisplayNames[index],
                                groupValue: selectedLanguage,
                              ),
                              CommonText(
                                titleText: languageDisplayNames[index],
                                textStyle: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                  fontSize: 18.iX,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).extension<AppTextColors>()!.inverse,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    selectedLanguage = null;
    super.dispose();
  }
}
