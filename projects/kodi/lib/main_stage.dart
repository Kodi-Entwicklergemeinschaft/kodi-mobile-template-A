import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kodi/utils/env_config.dart' show EnvironmentConfig, AppEnvironment;
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvironmentConfig.setEnvironment(AppEnvironment.stage);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await initializeRunApp();
}
