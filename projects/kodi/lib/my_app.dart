import 'dart:async';

import 'package:common_components/common_components.dart';
import 'package:common_components/extensions/string_extension.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:kodi/feat/city/controller/city_controller.dart';
import 'package:kodi/feat/home/controller/home_screen_controller.dart';
import 'package:kodi/utils/routing/routes.dart';
import 'package:local_storage/preference_manager_impl.dart';
import 'package:locale/locale.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/extension/app_container_colors.dart';
import 'package:theme/theme.dart';
import 'package:shared_dependencies/connectivity_plus.dart';
import 'utils/env_config.dart';
import 'lang/app_translation_provider.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: EnvironmentConfig.firebaseOptions);
  debugPrint("💤 Background Message: ${message.notification?.title}");
}

initializeRunApp() async {
  await Firebase.initializeApp();

  // Initialize shared preferences
  await initPreferences();
  // Restrict to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  initSizeUtils();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    // Initialize services once the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final languageCode = ref.read(localeControllerProvider).languageCode;
      ref.read(messagingServiceProvider).init(globalNavKey, languageCode);
      _initConnectivity();
      appRouter.routerDelegate.addListener(_handleRouteChange);
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    appRouter.routerDelegate.removeListener(_handleRouteChange);
    super.dispose();
  }

  void _initConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _handleConnectivityChange,
    );
    // Also check the initial state
    Connectivity().checkConnectivity().then(_handleConnectivityChange);
  }

  void _handleRouteChange() {
    // After a route change, the dialog might have been dismissed. Re-check.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Connectivity().checkConnectivity().then(_handleConnectivityChange);
      }
    });
  }

  void _handleConnectivityChange(List<ConnectivityResult> result) {
    if (!mounted) return;

    final hasConnection =
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet);

    final context = globalNavKey.currentContext;
    if (context == null) return;

    if (!hasConnection && !_isDialogShowing) {
      setState(() {
        _isDialogShowing = true;
      });
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: Theme.of(
              context,
            ).extension<AppContainerColors>()!.inverse,
            title: Text('no_internet'.tr(dialogContext)),
            content: Text('check_connection'.tr(dialogContext)),
          );
        },
      ).then((_) {
        // This is called when the dialog is popped, for any reason.
        if (mounted) {
          setState(() {
            _isDialogShowing = false;
          });
        }
      });
    } else if (hasConnection && _isDialogShowing) {
      Navigator.of(context).pop();
      checkAndReloadCityAndHomePage();
    }
  }

  checkAndReloadCityAndHomePage() async {
    if (ref.read(cityControllerProvider.notifier).getCityId() == null) {
      await ref.read(cityControllerProvider.notifier).loadCityData();
      await ref.read(homeControllerProvider.notifier).loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceLocale = View.of(context).platformDispatcher.locale;
    final theme = ref.watch(themeServiceProvider);
    final translations = ref.read(appTranslationProvider);
    final locale = ref.watch(localeControllerProvider);
    ref.watch(cityControllerProvider);

    // Switch FCM warning topic whenever the user changes their language.
    // Works for both authenticated and guest users — the service checks the
    // OS-level notification permission before subscribing/unsubscribing.
    ref.listen<Locale>(localeControllerProvider, (previous, next) {
      if (previous != null && previous.languageCode != next.languageCode) {
        ref.read(messagingServiceProvider).switchLanguageTopic(
          previous.languageCode,
          next.languageCode,
        );
      }
    });
    ThemeData dataDark = getTheme(brightness: Brightness.dark);
    ThemeData dataLight = getTheme(brightness: Brightness.light);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      themeMode: theme.mode,
      theme: dataLight,
      darkTheme: dataDark,
      locale: locale,
      supportedLocales: translations.supportedLocales,
      localizationsDelegates: AppLocalizationsDelegate.delegates(translations),
      // localeResolutionCallback: (device, supported) {
      //   if (device == null) return supported.first;
      //   Locale? match;
      //   for (final l in supported) {
      //     if (l.languageCode.toString().contains(
      //       device.languageCode.toString(),
      //     )) {
      //       match = l;
      //       break;
      //     }
      //   }
      //   return match ?? supported.first;
      // },
      builder: (context, child) {
        //To set scaling factors if it rebuilds with diff dimension ex - orientation.
        initSizeUtils();
        return SafeArea(bottom: true, top: false, child: child!);
      },
    );
  }
}

final messagingServiceProvider = Provider<MessagingService>((ref) {
  return MessagingService();
});

class MessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static String _topicForLanguage(String languageCode) =>
      'warnings_$languageCode';

  Future<void> subscribeToLanguageTopic(String languageCode) async {
    try {
      await _messaging
          .subscribeToTopic(_topicForLanguage(languageCode))
          .timeout(const Duration(seconds: 10));
      debugPrint('✅ Subscribed to topic: ${_topicForLanguage(languageCode)}');
    } catch (e) {
      debugPrint('⚠️ Warning topic subscription failed: $e');
    }
  }

  Future<void> unsubscribeFromLanguageTopic(String languageCode) async {
    try {
      await _messaging
          .unsubscribeFromTopic(_topicForLanguage(languageCode))
          .timeout(const Duration(seconds: 10));
      debugPrint(
          '✅ Unsubscribed from topic: ${_topicForLanguage(languageCode)}');
    } catch (e) {
      debugPrint('⚠️ Warning topic unsubscription failed: $e');
    }
  }

  /// Unsubscribes from the old language topic and subscribes to the new one,
  /// but only when the OS has granted notification permission. This makes it
  /// safe to call for both authenticated users and guests — the service itself
  /// is the single source of truth for the permission check.
  Future<void> switchLanguageTopic(
      String oldLanguageCode, String newLanguageCode) async {
    if (oldLanguageCode == newLanguageCode) return;
    final settings = await _messaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;
    await unsubscribeFromLanguageTopic(oldLanguageCode);
    await subscribeToLanguageTopic(newLanguageCode);
  }

  Future<void> init(
      GlobalKey<NavigatorState> navigatorKey, String languageCode) async {
    // Request permission for iOS
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await subscribeToLanguageTopic(languageCode);
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      await unsubscribeFromLanguageTopic(languageCode);
    }

    // Get the FCM token
    final token = await _messaging.getToken();
    debugPrint('🔔 FCM Token (${EnvironmentConfig.environment.name}): $token');

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
        '📩 Message received in foreground: ${message.notification?.title}',
      );

      // final context = navigatorKey.currentContext;
      // if (context != null && context.mounted) {
      //   AppSnackBar.show(
      //     context,
      //     "${message.notification?.title}\n${message.notification?.body}",
      //   );
      // }
    });

    /// ----- When notification tapped & app opened from background -----
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("📬 onMessageOpenedApp: ${message.notification?.title}");
      _handleNavigationFromMessage(navigatorKey, message);
    });

    /// ----- When app opened from terminated (cold start) -----
    RemoteMessage? initialMsg =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMsg != null) {
      debugPrint("🚀 App opened from terminated by notification");
      _handleNavigationFromMessage(navigatorKey, initialMsg);
    }
  }

  void _handleNavigationFromMessage(
    GlobalKey<NavigatorState> navigatorKey,
    RemoteMessage message,
  ) {
    // TODO: Need to implement
  }

  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      return null;
    }
  }

  Future<void> firebaseDeleteToken() async {
    return await _messaging.deleteToken();
  }
}
