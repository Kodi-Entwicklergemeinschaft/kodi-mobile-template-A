import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:locale/app_localization.dart';
import 'package:theme/theme.dart';

import 'config/image.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  final bool? automaticallyImplyLeading;
  final double? toolbarHeight;
  final bool showBackButton;
  final Color? backButtonColor;
  final bool showTitleLogo;
  final VoidCallback? onBackPressed;
  final Widget? title;

  const CommonAppBar({
    super.key,
    this.backgroundColor,
    this.surfaceTintColor,
    this.automaticallyImplyLeading,
    this.toolbarHeight,
    this.onBackPressed,
    this.showBackButton = false,
    this.showTitleLogo = true,
    this.backButtonColor,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      automaticallyImplyLeading: automaticallyImplyLeading ?? false,
      // <-- removes back arrow
      toolbarHeight: toolbarHeight ?? 140.iY,
      title: Row(
        spacing: 10.iY,
        children: [
          if (showBackButton)
            CommonIcon(
              icon:Icons.arrow_back_ios_new,
              label: 'back_button_label'.tr(context),
              color: backButtonColor,
              onPressed: () {
                if (onBackPressed != null) {
                  onBackPressed!();
                }
                else {
                  context.pop();
                }
              },
            ),
          if (showTitleLogo)
            CommonImage(
              imagePath: Images.kodiLogo,
              height: 100.iY,
              width: 100.iX,
              fit: BoxFit.fitHeight,
            ),
          title ?? Container(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? 140.iY);
}
