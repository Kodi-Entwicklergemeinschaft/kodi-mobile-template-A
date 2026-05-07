import 'package:flutter/foundation.dart';
import 'package:kodi/feat/auth/login/controller/login_controller.dart';
import 'package:kodi/utils/app_pref_keys.dart';
import 'package:kodi/utils/env_config.dart';
import 'package:local_storage/local_storage.dart';
import 'package:locale/locale_controller.dart';
import 'package:network/network.dart';
import 'package:shared_dependencies/riverpod.dart';

final apiProvider = Provider<ApiHelper>((ref) {
  String baseUrl = EnvironmentConfig.baseUrl;

  final apiHelper = ApiHelper(
    dioHelper: DioHelper(
      baseUrl: baseUrl,
      showLogs: kDebugMode ? true : false,
      timeoutDuration: const Duration(seconds: 45),
      errorModel: () => ErrorModel(),
      dioInterceptors: [
        HeaderInterceptor(
          () => ref
              .read(preferenceManagerProvider)
              .getStringOrEmpty(AppPrefsKeys.token),
          () => ref.read(localeControllerProvider).languageCode,
          () => ref.read(loginProvider.notifier).refreshToken(),
        ),
      ],
    ),
    errorModel: () => ErrorModel(),
    fallbackErrorMessage: "Something went wrong!",
  );

  return apiHelper;
});
