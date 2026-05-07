import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kodi/utils/env_config.dart' show EnvironmentConfig, AppEnvironment;
import 'package:flutter/material.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //// ✅ Set your environment here BEFORE Firebase & runApp
  EnvironmentConfig.setEnvironment(AppEnvironment.prod);

  // Register handler BEFORE initialization
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await initializeRunApp();
}
