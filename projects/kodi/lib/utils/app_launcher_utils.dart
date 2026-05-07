import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_dependencies/custom_webview.dart';
import 'app_launcher_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';
export 'package:url_launcher/url_launcher.dart';

class AppLauncherUtils {
  /// Open map
  static Future<void> openMap(double latitude, double longitude) async {
    final googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final appleUrl = 'http://maps.apple.com/?q=$latitude,$longitude';

    final url = Platform.isIOS ? appleUrl : googleUrl;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Open phone dialer with number
  static Future<void> openDialer(String phoneNumber) async {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final telUrl = "tel:$cleaned";

    try {
      await launchUrlString(telUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw "Could not launch dialer for $cleaned";
    }
  }

  /// Open email app with mailto
  static Future<void> openEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    final url = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    ).toString();

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch email for $email';
    }
  }

  /// Open website (with fallback to in-app webview)
  static Future<void> openWebsite(
    BuildContext context, {
    required String url,
    required String title,
    bool inAppView = false,
  }) async {
    final uri = Uri.parse(url);
    if (inAppView) {
      CustomWebViewScreen.showAsBottomSheet(
        context: context,
        url: url,
        title: title,
      );
    } else if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      CustomWebViewScreen.showAsBottomSheet(
        context: context,
        url: url,
        title: title,
      );
    }
  }
}
