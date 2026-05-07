import 'package:network/network.dart';

class TermsStatusResponse extends BaseModel<TermsStatusResponse>{
  final bool? success;
  final TermsStatusData? data;
  final String? message;
  final DateTime? timestamp;
  final String? path;
  final int? statusCode;

  TermsStatusResponse({
    this.success,
    this.data,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });

  /// ✅ Safe deserialization
  @override
  TermsStatusResponse fromJson(Map<String, dynamic>? json) {
    if (json == null) return TermsStatusResponse();
    return TermsStatusResponse(
      success: json['success'] as bool?,
      data: json['data'] != null
          ? TermsStatusData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
      timestamp: _parseDateTime(json['timestamp'] as String?),
      path: json['path'] as String?,
      statusCode: json['statusCode'] is int
          ? json['statusCode'] as int
          : int.tryParse(json['statusCode']?.toString() ?? ''),
    );
  }

  /// ✅ Safe serialization
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

  static DateTime? _parseDateTime(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

}

class TermsStatusData {
  final bool? hasAccepted;
  final String? acceptedVersion;
  final String? latestVersion;
  final bool? needsAcceptance;
  final String? termsId;
  final DateTime? gracePeriodEndsAt;

  TermsStatusData({
    this.hasAccepted,
    this.acceptedVersion,
    this.latestVersion,
    this.needsAcceptance,
    this.termsId,
    this.gracePeriodEndsAt,
  });

  /// ✅ Safe deserialization
  factory TermsStatusData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TermsStatusData();
    return TermsStatusData(
      hasAccepted: json['hasAccepted'] as bool?,
      acceptedVersion: json['acceptedVersion'] as String?,
      latestVersion: json['latestVersion'] as String?,
      needsAcceptance: json['needsAcceptance'] as bool?,
      termsId: json['termsId'] as String?,
      gracePeriodEndsAt: _parseDateTime(json['gracePeriodEndsAt'] as String?),
    );
  }

  /// ✅ Safe serialization
  Map<String, dynamic> toJson() {
    return {
      'hasAccepted': hasAccepted,
      'acceptedVersion': acceptedVersion,
      'latestVersion': latestVersion,
      'needsAcceptance': needsAcceptance,
      'termsId': termsId,
      'gracePeriodEndsAt': gracePeriodEndsAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDateTime(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }
}