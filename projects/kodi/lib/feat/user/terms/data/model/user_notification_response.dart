import 'package:network/network.dart'; // adjust if BaseModel lives elsewhere

class UserNotificationResponse extends BaseModel<UserNotificationResponse> {
  final bool? success;
  final NotificationData? data;
  final String? message;
  final DateTime? timestamp;
  final String? path;
  final int? statusCode;

  UserNotificationResponse({
    this.success,
    this.data,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });

  @override
  UserNotificationResponse fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserNotificationResponse();
    return UserNotificationResponse(
      success: json['success'] as bool?,
      data: json['data'] is Map<String, dynamic>
          ? NotificationData.fromJson(json['data'] as Map<String, dynamic>)
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

class NotificationData {
  final String? userId;
  final String? preferredLanguage;
  final NewsletterSubscription? newsletterSubscription;
  final bool? notificationsEnabled;
  final DateTime? updatedAt;

  NotificationData({
    this.userId,
    this.preferredLanguage,
    this.newsletterSubscription,
    this.notificationsEnabled,
    this.updatedAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return NotificationData();
    return NotificationData(
      userId: json['userId'] as String?,
      preferredLanguage: json['preferredLanguage'] as String?,
      newsletterSubscription: json['newsletterSubscription'] is Map<String, dynamic>
          ? NewsletterSubscription.fromJson(
        json['newsletterSubscription'] as Map<String, dynamic>,
      )
          : null,
      notificationsEnabled: json['notificationsEnabled'] as bool?,
      updatedAt: _parseDateTime(json['updatedAt'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'preferredLanguage': preferredLanguage,
      'newsletterSubscription': newsletterSubscription?.toJson(),
      'notificationsEnabled': notificationsEnabled,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDateTime(String? s) =>
      s != null ? DateTime.tryParse(s) : null;
}

class NewsletterSubscription {
  final String? id;
  final String? userId;
  final String? email;
  final String? emsContactId;
  final String? status;
  final bool? emsEventTriggered;
  final DateTime? subscribedAt;
  final DateTime? confirmedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NewsletterSubscription({
    this.id,
    this.userId,
    this.email,
    this.emsContactId,
    this.status,
    this.emsEventTriggered,
    this.subscribedAt,
    this.confirmedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory NewsletterSubscription.fromJson(Map<String, dynamic>? json) {
    if (json == null) return NewsletterSubscription();
    return NewsletterSubscription(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      emsContactId: json['emsContactId'] as String?,
      status: json['status'] as String?,
      emsEventTriggered: json['emsEventTriggered'] as bool?,
      subscribedAt: _parseDateTime(json['subscribedAt'] as String?),
      confirmedAt: _parseDateTime(json['confirmedAt'] as String?),
      createdAt: _parseDateTime(json['createdAt'] as String?),
      updatedAt: _parseDateTime(json['updatedAt'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'email': email,
      'emsContactId': emsContactId,
      'status': status,
      'emsEventTriggered': emsEventTriggered,
      'subscribedAt': subscribedAt?.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDateTime(String? s) =>
      s != null ? DateTime.tryParse(s) : null;
}
