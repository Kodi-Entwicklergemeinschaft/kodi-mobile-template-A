import 'package:network/network.dart';

class RegisterDeviceResponseModel
    implements BaseModel<RegisterDeviceResponseModel> {
  bool? success;
  DeviceModel? device;
  String? message;
  String? timestamp;
  String? path;
  int? statusCode;

  RegisterDeviceResponseModel({
    this.success,
    this.device,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });

  @override
  RegisterDeviceResponseModel fromJson(Map<String, dynamic> json) {
    return RegisterDeviceResponseModel(
      success: json['success'],
      device: json['data'] != null && json['data']['device'] != null
          ? DeviceModel().fromJson(json['data']['device'])
          : null,
      message: json['message'],
      timestamp: json['timestamp'],
      path: json['path'],
      statusCode: json['statusCode'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": {
        "device": device?.toJson(),
      },
      "message": message,
      "timestamp": timestamp,
      "path": path,
      "statusCode": statusCode,
    };
  }
}

class DeviceModel {
  String? id;
  String? deviceId;
  String? platform;
  String? appVersion;
  String? osVersion;
  String? language;
  String? cityId;
  String? lastSeenAt;
  String? createdAt;

  DeviceModel({
    this.id,
    this.deviceId,
    this.platform,
    this.appVersion,
    this.osVersion,
    this.language,
    this.cityId,
    this.lastSeenAt,
    this.createdAt,
  });

  DeviceModel fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      deviceId: json['deviceId'],
      platform: json['platform'],
      appVersion: json['appVersion'],
      osVersion: json['osVersion'],
      language: json['language'],
      cityId: json['cityId'],
      lastSeenAt: json['lastSeenAt'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "deviceId": deviceId,
      "platform": platform,
      "appVersion": appVersion,
      "osVersion": osVersion,
      "language": language,
      "cityId": cityId,
      "lastSeenAt": lastSeenAt,
      "createdAt": createdAt,
    };
  }
}
