import 'package:app_settings/app_settings.dart';
import 'package:common_components/common_components.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/feat/user/terms/controller/terms_controller.dart';
import 'package:kodi/feat/user/terms/controller/terms_state.dart';
import 'package:kodi/my_app.dart';
import 'package:kodi/utils/app_bar.dart';
import 'package:locale/locale.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/extension/app_text_colors.dart';

class NotificationPrefs extends ConsumerStatefulWidget {
  const NotificationPrefs({super.key});

  @override
  ConsumerState<NotificationPrefs> createState() => _NotificationPrefsState();
}

class _NotificationPrefsState extends ConsumerState<NotificationPrefs>
    with WidgetsBindingObserver {
  /// Set to true right before redirecting the user to OS settings so that
  /// when they return we can re-check permission and auto-enable the toggle.
  bool _awaitingPermissionFromSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(termsProvider.notifier).getNotificationStatus();
      _syncDevicePermission();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ── Lifecycle observer ────────────────────────────────────────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.resumed &&
        _awaitingPermissionFromSettings) {
      _awaitingPermissionFromSettings = false;
      _syncDevicePermission(autoEnableIfGranted: true);
    }
  }

  // ── Permission helpers ────────────────────────────────────────────────────

  /// Reconciles the in-app toggle with the device-level notification permission.
  ///
  /// * If the device permission is **denied** but the toggle is ON → silently
  ///   turns the toggle OFF (no API call — device has overridden the preference).
  /// * If [autoEnableIfGranted] is `true` and the device permission is now
  ///   **authorized** while the toggle is OFF → enables the toggle, saves the
  ///   preference, and subscribes to the FCM topic. This covers the case where
  ///   the user just granted permission from the OS settings page.
  Future<void> _syncDevicePermission({bool autoEnableIfGranted = false}) async {
    final settings =
        await FirebaseMessaging.instance.getNotificationSettings();
    final isDeviceGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (!mounted) return;

    final notifEnabled =
        ref.read(termsProvider).hasAcceptedPushNotification;

    if (!isDeviceGranted && notifEnabled) {
      // Device permission was revoked — reflect that in the UI silently.
      ref.read(termsProvider.notifier).setNotificationConsent(false);
    } else if (isDeviceGranted && !notifEnabled && autoEnableIfGranted) {
      // User just granted permission from OS settings — enable the toggle.
      _applyNotificationEnabled(true);
    }
  }

  /// Handles the Switch toggle change for push notifications.
  ///
  /// Turning **ON**: checks the device permission first.
  /// * `notDetermined` → requests permission from the OS.
  /// * `authorized` / `provisional` → enables immediately.
  /// * `denied` → redirects to OS notification settings.
  ///
  /// Turning **OFF**: disables immediately and unsubscribes from the FCM topic.
  Future<void> _handleNotificationToggle(bool value) async {
    if (value) {
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();

      switch (settings.authorizationStatus) {
        case AuthorizationStatus.notDetermined:
          // First time asking — show the OS permission dialog.
          final result =
              await FirebaseMessaging.instance.requestPermission();
          if (result.authorizationStatus == AuthorizationStatus.authorized ||
              result.authorizationStatus == AuthorizationStatus.provisional) {
            _applyNotificationEnabled(true);
          }

        case AuthorizationStatus.authorized:
        case AuthorizationStatus.provisional:
          _applyNotificationEnabled(true);

        case AuthorizationStatus.denied:
          // Permission was previously denied — send user to OS settings.
          _awaitingPermissionFromSettings = true;
          AppSettings.openAppSettings(type: AppSettingsType.notification);
      }
    } else {
      _applyNotificationEnabled(false);
    }
  }

  /// Commits the notification enabled state: updates the controller, saves
  /// the preference, and subscribes / unsubscribes from the FCM topic.
  void _applyNotificationEnabled(bool enabled) {
    ref.read(termsProvider.notifier).setNotificationConsent(enabled);
    ref.read(termsProvider.notifier).saveNotificationStatus();

    final languageCode = ref.read(localeControllerProvider).languageCode;
    if (enabled) {
      ref.read(messagingServiceProvider).subscribeToLanguageTopic(languageCode);
    } else {
      ref
          .read(messagingServiceProvider)
          .unsubscribeFromLanguageTopic(languageCode);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(termsProvider);
    ref.listen(termsProvider, (previous, next) {
      if (previous?.state != OnboardingStateEnum.successSubscribePref &&
          next.state == OnboardingStateEnum.successSubscribePref) {
        AppSnackBar.showSuccess(context, 'subscribe_request_sent'.tr(context));
      }

      if (previous?.state != OnboardingStateEnum.errorNotificationPref &&
          next.state == OnboardingStateEnum.errorNotificationPref) {
        AppSnackBar.showError(context, next.errorMessage);
      }
    });
    return BaseUI(
      isStackLoading:
          state.state == OnboardingStateEnum.loadingNotificationPref,
      appBar: CommonAppBar(
        showBackButton: true,
        showTitleLogo: false,
        toolbarHeight: 70.iY,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.iY),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonText(
              titleText: "notification".tr(context).toUpperCase(),
              textStyle: TextStyle(
                fontSize: 20.iY,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 90.iY,
              child: Padding(
                padding: EdgeInsets.only(top: 5.iY),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(10.iX),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.iX),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CommonText(
                              titleText: 'push_notification'.tr(context),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 18.iX,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context)
                                        .extension<AppTextColors>()!
                                        .inverse,
                                  ),
                            ),
                          ),
                          Switch(
                            value: state.hasAcceptedPushNotification,
                            onChanged: _handleNotificationToggle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 90.iY,
              child: Padding(
                padding: EdgeInsets.only(top: 10.iY),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(10.iX),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.iX),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CommonText(
                              titleText: 'newsletter'.tr(context),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 18.iX,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context)
                                        .extension<AppTextColors>()!
                                        .inverse,
                                  ),
                            ),
                          ),
                          SizedBox(
                            height: 50.iY,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                ref
                                    .read(termsProvider.notifier)
                                    .toggleNewsLetterConsent();
                                ref
                                    .read(termsProvider.notifier)
                                    .saveSubscribeStatus();
                              },
                              child: CommonText(
                                titleText: "subscribe".tr(context),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 14.iX,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
