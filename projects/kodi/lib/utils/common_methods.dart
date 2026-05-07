import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kodi/utils/routing/routes.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/geolocator.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:theme/extension/app_container_colors.dart';
import 'package:theme/extension/app_text_colors.dart';

import '../feat/listings/data/model/category_model.dart';
import 'app_launcher_utils.dart';

class CommonMethods {

  static fieldFocusChange(
      BuildContext context,
      FocusNode current,
      FocusNode next,
      ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }
  static showInfoDialog(BuildContext context,String titleText,
      {Function()? onTap,Function()? onCancel,String? onTapText}) {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).extension<AppContainerColors>()!.inverse,
        content: Padding(
          padding: EdgeInsets.only(top: 30.iY),
          child: CommonText(titleText: titleText),
        ),
        actions: <Widget>[
          if(onCancel!=null)
            TextButton(
                child: CommonText(titleText: "cancel".tr(context)),
                onPressed: () => Navigator.of(dialogContext).pop()),
          TextButton(
              child: CommonText(titleText: onTapText??"ok".tr(context)),
              // Use the dialogContext to pop the dialog itself
              onPressed: () => onTap?.call()??Navigator.of(dialogContext).pop())
        ],
      ),
    );
  }

  static showDeleteAccountDialog(BuildContext context,
      {required Function() onDelete}) {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).extension<AppContainerColors>()!.inverse,
        title: CommonText(titleText: "delete_account_confirmation".tr(context)),
        content: CommonText(titleText: "delete_account_message".tr(context)),
        actions: <Widget>[
          TextButton(
              child: CommonText(titleText: "cancel".tr(context)),
              onPressed: () => Navigator.of(dialogContext).pop()),
          TextButton(
              child: CommonText(
                titleText: "delete".tr(context),
                textStyle: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onDelete();
              })
        ],
      ),
    );
  }

  static showRestartAppDialog(BuildContext context,
      {required Function() onRestart}) {
    return showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: Theme.of(context).extension<AppContainerColors>()!.inverse,
          title: CommonText(titleText: "restart_required".tr(context)),
          content: CommonText(titleText: "language_change_restart_message".tr(context)),
          actions: <Widget>[
            TextButton(
                child: CommonText(titleText: "cancel".tr(context)),
                onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
                child: CommonText(titleText: "restart".tr(context)),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  onRestart();
                })
          ],
        )
    );
  }

  static showLogOutDialog(BuildContext context,
      {required Function() onLogOut}) {
    return showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: Theme.of(context).extension<AppContainerColors>()!.inverse,
          title: CommonText(titleText: "dashboard_logout".tr(context)),
          content: CommonText(titleText: "logout_confirmation_message".tr(context)),
          actions: <Widget>[
            TextButton(
                child: CommonText(titleText: "cancel".tr(context)),
                onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
                onPressed: (){
                  Navigator.of(dialogContext).pop();
                  onLogOut();
                },
                child: CommonText(titleText: "dashboard_logout".tr(context)))
          ],
        )
    );
  }

  static hiddenKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("Location services are disabled");
      return null;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("Error: Location permissions are denied");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("Error: Location permissions are permanently denied, we cannot request permission");
      return null;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      debugPrint("Error fetching location: $e");
      return null;
    }
  }

  void copyToClipboard(BuildContext context, String message) {
    Clipboard.setData(ClipboardData(text: message));
    // It's safer to check if the widget is still mounted before showing a SnackBar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(('copied_to_clipboard').tr(context))),
      );
    }
  }

  // Minor fix: removed isExternal since launchUrl already has a mode parameter
  Future<void> launchURL(String url, {LaunchMode mode = LaunchMode.externalApplication}) async {
    final validUrl = url.startsWith('http') ? url : 'https://$url';
    final uri = Uri.parse(validUrl);

    if (!await launchUrl(
      uri,
      mode: mode,
    )) {
      throw 'Could not launch $uri';
    }
  }

  bool isImageUrl(String url) {
    final ext = url.toLowerCase();
    return ext.endsWith('.jpg') || ext.endsWith('.jpeg') || ext.endsWith('.png') || ext.endsWith('.gif');
  }

  bool isPdfUrl(String url) {
    return url.toLowerCase().endsWith('.pdf');
  }


  ///Singleton factory
  static final CommonMethods _instance = CommonMethods._internal();

  factory CommonMethods() {
    return _instance;
  }

  CommonMethods._internal();

  // Bug Fix: One of the lat2 was actually lon2
  Future<double> getDistance(double lat1, double lon1, double lat2, double lon2) async {
    double distanceInMeters = Geolocator.distanceBetween(
      lat1,
      lon1,
      lat2,
      lon2, // <-- This was lat2 before
    );
    return distanceInMeters;
  }

  static void navigateCategories(
    BuildContext context,
    String? slugString, {
    CategoryModel? category,
  }) {
    final type = CategorySlugExt.fromSlug(slugString ?? '');

    switch (type) {
      case CategorySlug.events:
        context.go(ScreenPaths.events);
        break;
      case CategorySlug.tours:
        CommonMethods.showInfoDialog(
          context,
          "blue_line_description".tr(context),
          onTap: () {
            GoRouter.of(context).go(
              '${ScreenPaths.discover}/${ScreenPaths.listings}',
              extra: [slugString, null, UniqueKey()],
            );
          },
        );
        break;
      case CategorySlug.kodiWeek:
        if (category != null) {
          GoRouter.of(context).go(
            '${ScreenPaths.discover}/${ScreenPaths.kodiWeekScreen}',
            extra: category,
          );
        }
        break;
      case CategorySlug.kodiWeekEvents:
        GoRouter.of(context).push(
          '${ScreenPaths.discover}/${ScreenPaths.listings}',
          extra: [slugString, category?.subServices[0].itemId, UniqueKey()],
        );
        break;
      default:
        GoRouter.of(context).go(
          '${ScreenPaths.discover}/${ScreenPaths.listings}',
          extra: [slugString, null, UniqueKey()],
        );
    }
  }
}
