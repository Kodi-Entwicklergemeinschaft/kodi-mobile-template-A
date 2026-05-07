import 'package:network/network.dart';

class ChangePasswordResponse extends BaseModel<ChangePasswordResponse> {
  final String? errorCode;
  final String? message;
  final DateTime? timestamp;
  final String? path;
  final String? method;
  final String? requestId;
  final int? statusCode;

  ChangePasswordResponse({
    this.errorCode,
    this.message,
    this.timestamp,
    this.path,
    this.method,
    this.requestId,
    this.statusCode,
  });

  @override
  ChangePasswordResponse fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      errorCode: json['errorCode']?.toString(),
      message: json['message']?.toString(),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString())
          : null,
      path: json['path']?.toString(),
      method: json['method']?.toString(),
      requestId: json['requestId']?.toString(),
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? ''),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'errorCode': errorCode,
      'message': message,
      'timestamp': timestamp?.toIso8601String(),
      'path': path,
      'method': method,
      'requestId': requestId,
      'statusCode': statusCode,
    };
  }
}
