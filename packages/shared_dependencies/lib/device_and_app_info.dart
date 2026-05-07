import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:uuid/uuid.dart';

class DeviceAndAppInfo {
  final String _deviceId;
  final String _platform;
  final String _osVersion;
  final String _deviceModel;
  final String _appVersion;

  DeviceAndAppInfo._({
    required String deviceId,
    required String platform,
    required String osVersion,
    required String deviceModel,
    required String appVersion,
  })  : _deviceId = deviceId,
        _platform = platform,
        _osVersion = osVersion,
        _deviceModel = deviceModel,
        _appVersion = appVersion;

  /// ✅ Getters for all fields
  String get deviceId => _deviceId;

  String get platform => _platform;

  String get osVersion => _osVersion;

  String get deviceModel => _deviceModel;

  String get appVersion => _appVersion;

  static Future<DeviceAndAppInfo> build() async {
    final plugin = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    final platformValue = Platform.isIOS ? "IOS" : "ANDROID";
    String model = '';
    String version = '';

    if (Platform.isAndroid) {
      final android = await plugin.androidInfo;
      model = android.model;
      version = android.version.release;
    } else {
      final ios = await plugin.iosInfo;
      model = ios.utsname.machine;
      version = ios.systemVersion;
    }

    String identifier;

    if (Platform.isAndroid) {
      final android = await plugin.androidInfo;
      identifier = android.id; // ANDROID_ID
    } else {
      final ios = await plugin.iosInfo;
      identifier = ios.identifierForVendor ?? const Uuid().v4();
    }

    return DeviceAndAppInfo._(
      deviceId: identifier,
      platform: platformValue,
      osVersion: version,
      deviceModel: model,
      appVersion: packageInfo.version,
    );
  }
}
