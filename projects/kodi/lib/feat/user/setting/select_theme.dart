import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/utils/app_bar.dart';
import 'package:locale/locale.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/extension/app_text_colors.dart';
import 'package:theme/theme.dart';

class ThemeSelectionScreen extends ConsumerStatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  ConsumerState<ThemeSelectionScreen> createState() =>
      _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends ConsumerState<ThemeSelectionScreen> {
  ThemeMode? themeMode;

  @override
  void initState() {
    themeMode = ref.read(themeServiceProvider).mode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseUI(
      appBar: CommonAppBar(
        showBackButton: true,
        showTitleLogo: false,
        toolbarHeight: 70.iY,
        // title: Expanded(
        //   child: CommonText(
        //     titleText: "app_theme".tr(context),
        //     textAlign: TextAlign.start,
        //     textStyle: Theme.of(context).textTheme.headlineSmall,
        //     overflow: TextOverflow.ellipsis,
        //   ),
        // ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.iY),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10.iY,
          children: [
            CommonText(
              titleText: "app_theme".tr(context).toUpperCase(),
              textStyle: TextStyle(
                fontSize: 20.iY,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.iY),
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(10.iX),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CommonText(
                        titleText: 'bright'.tr(context),
                        textStyle: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(
                              fontSize: 18.iX,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(
                                context,
                              ).extension<AppTextColors>()!.inverse,
                            ),
                      ),
                      Switch(
                        value: (themeMode == ThemeMode.dark),
                        onChanged: (value) {
                          setState(() {
                            themeMode = value ? ThemeMode.dark : ThemeMode.light;
                            ref
                                .read(themeServiceProvider.notifier)
                                .toggleTheme(value);
                          });
                        },
                      ),
                      CommonText(
                        titleText: 'dark'.tr(context),
                        textStyle: Theme.of(context).textTheme.bodyLarge
                            ?.copyWith(
                              fontSize: 18.iX,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(
                                context,
                              ).extension<AppTextColors>()!.inverse,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    themeMode = null;
    super.dispose();
  }
}
