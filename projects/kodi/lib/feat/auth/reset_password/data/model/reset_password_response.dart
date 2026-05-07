import 'package:network/network.dart';

class ResetPasswordResponse extends BaseModel<ResetPasswordResponse> {
  final bool? success;
  final ResetData? data;
  final String? message;
  final DateTime? timestamp;
  final String? path;
  final int? statusCode;

  ResetPasswordResponse({
    this.success,
    this.data,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });

  @override
  ResetPasswordResponse fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      success: json['success'] is bool
          ? json['success']
          : (json['success']?.toString().toLowerCase() == 'true'),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? ResetData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message']?.toString(),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString())
          : null,
      path: json['path']?.toString(),
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
      'message': message,
      'timestamp': timestamp?.toIso8601String(),
      'path': path,
      'statusCode': statusCode,
    };
  }
}

class ResetData {
  final String? message;

  ResetData({this.message});

  factory ResetData.fromJson(Map<String, dynamic> json) {
    return ResetData(
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
