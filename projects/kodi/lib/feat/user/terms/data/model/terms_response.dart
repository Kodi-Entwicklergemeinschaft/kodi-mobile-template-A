import 'package:network/network.dart'; // adjust import if BaseModel is elsewhere

class TermsResponse extends BaseModel<TermsResponse> {
  final bool? success;
  final TermsData? data;
  final String? message;
  final DateTime? timestamp;
  final String? path;
  final int? statusCode;

  TermsResponse({
    this.success,
    this.data,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });

  @override
  TermsResponse fromJson(Map<String, dynamic>? json) {
    if (json == null) return TermsResponse();
    return TermsResponse(
      success: json['success'] as bool?,
      data: json['data'] is Map<String, dynamic>
          ? TermsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
      timestamp: _parseDateTime(json['timestamp'] as String?),
      path: json['path'] as String?,
      statusCode: json['statusCode'] is int
          ? json['statusCode'] as int
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

  static DateTime? _parseDateTime(String? s) =>
      s != null ? DateTime.tryParse(s) : null;
}

class TermsData {
  final String? id;
  final String? userId;
  final String? termsId;
  final String? version;
  final String? locale;
  final String? ipAddress;
  final String? userAgent;
  final DateTime? acceptedAt;
  final TermsDetails? terms;

  TermsData({
    this.id,
    this.userId,
    this.termsId,
    this.version,
    this.locale,
    this.ipAddress,
    this.userAgent,
    this.acceptedAt,
    this.terms,
  });

  factory TermsData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TermsData();
    return TermsData(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      termsId: json['termsId'] as String?,
      version: json['version'] as String?,
      locale: json['locale'] as String?,
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
      acceptedAt: _parseDateTime(json['acceptedAt'] as String?),
      terms: json['terms'] is Map<String, dynamic>
          ? TermsDetails.fromJson(json['terms'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'termsId': termsId,
      'version': version,
      'locale': locale,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'acceptedAt': acceptedAt?.toIso8601String(),
      'terms': terms?.toJson(),
    };
  }

  static DateTime? _parseDateTime(String? s) =>
      s != null ? DateTime.tryParse(s) : null;
}

class TermsDetails {
  final String? id;
  final String? version;
  final String? title;
  final String? locale;

  TermsDetails({
    this.id,
    this.version,
    this.title,
    this.locale,
  });

  factory TermsDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TermsDetails();
    return TermsDetails(
      id: json['id'] as String?,
      version: json['version'] as String?,
      title: json['title'] as String?,
      locale: json['locale'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'title': title,
      'locale': locale,
    };
  }
}
