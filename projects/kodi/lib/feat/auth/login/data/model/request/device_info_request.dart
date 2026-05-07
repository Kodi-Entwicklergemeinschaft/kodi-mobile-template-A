class DeviceInfoRequest {
  final String deviceId;
  final String? devicePlatform;
  final DeviceMetadata? deviceMetadata;

  DeviceInfoRequest({
    required this.deviceId,
    this.devicePlatform,
    this.deviceMetadata,
  });

  factory DeviceInfoRequest.fromJson(Map<String, dynamic> json) {
    return DeviceInfoRequest(
      deviceId: json['deviceId'] as String,
      devicePlatform: json['devicePlatform'] as String,
      deviceMetadata: DeviceMetadata.fromJson(json['deviceMetadata']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'devicePlatform': devicePlatform,
      'deviceMetadata': deviceMetadata?.toJson(),
    };
  }
}

class DeviceMetadata {
  final String osVersion;
  final String appVersion;
  final String deviceModel;

  DeviceMetadata({
    required this.osVersion,
    required this.appVersion,
    required this.deviceModel,
  });

  factory DeviceMetadata.fromJson(Map<String, dynamic> json) {
    return DeviceMetadata(
      osVersion: json['osVersion'] as String,
      appVersion: json['appVersion'] as String,
      deviceModel: json['deviceModel'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'osVersion': osVersion,
      'appVersion': appVersion,
      'deviceModel': deviceModel,
    };
  }
}

