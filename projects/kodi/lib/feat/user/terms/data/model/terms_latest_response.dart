import 'package:network/network.dart'; // adjust based on your project

class TermsLatestResponse extends BaseModel<TermsLatestResponse> {
  final bool? success;
  final TermsData? data;
  final String? message;
  final DateTime? timestamp;
  final String? path;
  final int? statusCode;

  TermsLatestResponse({
    this.success,
    this.data,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });

  @override
  TermsLatestResponse fromJson(Map<String, dynamic>? json) {
    if (json == null) return TermsLatestResponse();
    return TermsLatestResponse(
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
  final String? version;
  final String? title;
  final String? content;
  final String? locale;
  final String? cityId;
  final bool? isActive;
  final bool? isLatest;
  final int? gracePeriodDays;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdBy;

  TermsData({
    this.id,
    this.version,
    this.title,
    this.content,
    this.locale,
    this.cityId,
    this.isActive,
    this.isLatest,
    this.gracePeriodDays,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  factory TermsData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TermsData();
    return TermsData(
      id: json['id'] as String?,
      version: json['version'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      locale: json['locale'] as String?,
      cityId: json['cityId'] as String?,
      isActive: json['isActive'] as bool?,
      isLatest: json['isLatest'] as bool?,
      gracePeriodDays: json['gracePeriodDays'] is int
          ? json['gracePeriodDays'] as int
          : int.tryParse(json['gracePeriodDays']?.toString() ?? ''),
      createdAt: _parseDateTime(json['createdAt'] as String?),
      updatedAt: _parseDateTime(json['updatedAt'] as String?),
      createdBy: json['createdBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'title': title,
      'content': content,
      'locale': locale,
      'cityId': cityId,
      'isActive': isActive,
      'isLatest': isLatest,
      'gracePeriodDays': gracePeriodDays,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  static DateTime? _parseDateTime(String? s) =>
      s != null ? DateTime.tryParse(s) : null;
}
