import 'package:kodi/feat/auth/register/data/model/user_model.dart';
import 'package:network/network.dart';

class RegistrationResponse extends BaseModel<RegistrationResponse> {
  final bool? success;
  final UserModel? data;
  final DateTime? timestamp;
  final String? path;
  final String? message;
  final int? statusCode;

  RegistrationResponse({
    this.success,
    this.data,
    this.timestamp,
    this.path,
    this.message,
    this.statusCode,
  });

  @override
  RegistrationResponse fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      success: json['success'] is bool
          ? json['success']
          : json['success']?.toString().toLowerCase() == 'true',
      data: json['data'] != null
          ? UserModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString())
          : null,
      path: json['path']?.toString(),
      message: json['message']?.toString(),
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? ''),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'timestamp': timestamp?.toIso8601String(),
      'path': path,
      'message': message,
      'statusCode': statusCode,
    };
  }
}