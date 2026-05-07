import 'package:network/network.dart';

class ErrorModel extends BaseModel<ErrorModel>{
  final int? statusCode;
  final String? errorCode;
  final List<String>? message;
  final DateTime? timestamp;
  final String? path;
  final String? method;
  final String? requestId;
  final Map<String, dynamic>? details;

  ErrorModel({
    this.statusCode,
    this.errorCode,
    this.message,
    this.timestamp,
    this.path,
    this.method,
    this.requestId,
    this.details,
  });

  // ---------------------- fromJson ----------------------
  @override
  ErrorModel fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? ''),
      errorCode: json['errorCode'],
      // message can be string OR list → normalize to List<String>
      message: json['message'] is List
          ? List<String>.from(json['message'])
          : json['message'] != null
          ? [json['message'].toString()]
          : null,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
      path: json['path'],
      method: json['method'],
      requestId: json['requestId'],
      details: json['details'] is Map
          ? Map<String, dynamic>.from(json['details'])
          : null,
    );
  }

  // ---------------------- toJson ----------------------
  @override
  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'errorCode': errorCode,
      'message': message,
      'timestamp': timestamp?.toIso8601String(),
      'path': path,
      'method': method,
      'requestId': requestId,
      'details': details,
    };
  }
}
