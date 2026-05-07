import 'dart:async';
import 'dart:developer' as UtilLogger;

import 'package:kodi/feat/base_UI/controller/base_ui_controller.dart';
import 'package:kodi/feat/city/controller/city_controller.dart';
import 'package:kodi/feat/splash/controller/splash_state.dart';
import 'package:kodi/feat/user/terms/controller/terms_controller.dart';
import 'package:kodi/utils/common_methods.dart';
import 'package:local_storage/local_storage.dart';
import 'package:local_storage/preference_manager.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../utils/app_pref_keys.dart';
import '../../../utils/enums/StateEnum.dart';


final splashProvider = NotifierProvider<SplashNotifier, SplashState>(() {
  return SplashNotifier();
});

class SplashNotifier extends Notifier<SplashState> {
  late final PreferenceManager preferenceManager;
  late final CityController cityController;
  late final TermsController termsController;


  @override
  SplashState build() {
    termsController= ref.read(termsProvider.notifier);
    preferenceManager= ref.read(preferenceManagerProvider);
    cityController = ref.read(cityControllerProvider.notifier);
    return const SplashState();
  }

  Future<void> initializeApp() async {
    try {
      state = SplashLoading();
      final isGuestUser =preferenceManager.getBool(AppPrefsKeys.isGuestUser);
      final token = preferenceManager.getStringOrEmpty(AppPrefsKeys.token);
      if(token.isNotEmpty) {
        await termsController.getTermsStatus();
      }
      await cityController.loadCityData();

      state = SplashSuccess();
    } catch (e) {
      UtilLogger.log("ERROR", error: e);
      state = SplashError(e.toString());
    } finally{
      if (state is! SplashError) {
        state = SplashSuccess();
      }
    }
  }


  void resetState() {
    state = const SplashState();
  }
}
