import 'package:network/network.dart';

class UnregisterDeviceResponseModel
    implements BaseModel<UnregisterDeviceResponseModel> {
  final bool? success;
  final bool? dataSuccess;
  final String? message;
  final String? timestamp;
  final String? path;
  final int? statusCode;

  UnregisterDeviceResponseModel({
    this.success,
    this.dataSuccess,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });

  @override
  UnregisterDeviceResponseModel fromJson(Map<String, dynamic> json) {
    return UnregisterDeviceResponseModel(
      success: json["success"],
      dataSuccess: json["data"]?["success"],
      message: json["message"],
      timestamp: json["timestamp"],
      path: json["path"],
      statusCode: json["statusCode"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": {"success": dataSuccess},
      "message": message,
      "timestamp": timestamp,
      "path": path,
      "statusCode": statusCode,
    };
  }
}
