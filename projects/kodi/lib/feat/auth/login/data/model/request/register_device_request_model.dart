import 'package:network/network.dart';

class RegisterDeviceRequestModel
    implements BaseModel<RegisterDeviceRequestModel> {
  String? deviceId;
  String? fcmToken;
  String? platform;
  String? appVersion;
  String? osVersion;
  String? language;
  String? cityId;

  RegisterDeviceRequestModel({
    this.deviceId,
    this.fcmToken,
    this.platform,
    this.appVersion,
    this.osVersion,
    this.language,
    this.cityId,
  });

  @override
  RegisterDeviceRequestModel fromJson(Map<String, dynamic> json) {
    return RegisterDeviceRequestModel(
      deviceId: json['deviceId'],
      fcmToken: json['fcmToken'],
      platform: json['platform'],
      appVersion: json['appVersion'],
      osVersion: json['osVersion'],
      language: json['language'],
      cityId: json['cityId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "deviceId": deviceId,
      "fcmToken": fcmToken,
      "platform": platform,
      "appVersion": appVersion,
      "osVersion": osVersion,
      "language": language,
      "cityId": cityId,
    };
  }
}
