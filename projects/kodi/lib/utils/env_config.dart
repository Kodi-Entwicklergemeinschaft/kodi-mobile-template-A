import 'package:firebase_core/firebase_core.dart';
import 'package:kodi/firebase_options/stage/firebase_options.dart' as stage;
import 'package:kodi/firebase_options/prod/firebase_options.dart' as prod;

enum AppEnvironment { stage, prod }

class EnvironmentConfig {
  static late AppEnvironment _environment;

  /// Set the environment once during app bootstrap
  static void setEnvironment(AppEnvironment env) {
    _environment = env;
  }

  /// ✅ Safe getter (cannot modify externally)
  static AppEnvironment get environment => _environment;

  static String get baseUrl {
    switch (_environment) {
      case AppEnvironment.stage:
        return "your_base_url_stage";
      case AppEnvironment.prod:
        return "your_base_url_prod";
    }
  }

  /// Firebase Options (stage / prod)
  static FirebaseOptions get firebaseOptions {
    switch (_environment) {
      case AppEnvironment.stage:
        return stage.DefaultFirebaseOptions.currentPlatform;
      case AppEnvironment.prod:
        return prod.DefaultFirebaseOptions.currentPlatform;
    }
  }

  static bool get isProd {
    return _environment == AppEnvironment.prod;
  }

  static String get kodiCityKey{
    return 'kodi';
  }

}