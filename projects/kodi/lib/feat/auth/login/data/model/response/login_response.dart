import 'package:network/network.dart';

class LoginResponse extends BaseModel<LoginResponse> {
  final bool? success;
  final LoginData? data;
  final DateTime? timestamp;
  final String? path;
  final String? message;
  final int? statusCode;

  LoginResponse({
    this.success,
    this.data,
    this.timestamp,
    this.path,
    this.message,
    this.statusCode,
  });

  @override
  LoginResponse fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] is bool
          ? json['success']
          : (json['success']?.toString().toLowerCase() == 'true'),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
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

class LoginData {
  final User? user;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final bool? requiresTermsAcceptance;
  final String? termsId;
  final String? latestVersion;
  final String? gracePeriodEndsAt;

  LoginData({
    this.user,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.requiresTermsAcceptance,
    this.termsId,
    this.latestVersion,
    this.gracePeriodEndsAt,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: json['user'] != null && json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      accessToken: json['accessToken']?.toString(),
      refreshToken: json['refreshToken']?.toString(),
      expiresIn: json['expiresIn'] is int
          ? json['expiresIn']
          : int.tryParse(json['expiresIn']?.toString() ?? ''),
      requiresTermsAcceptance: json['requiresTermsAcceptance'] is bool
          ? json['requiresTermsAcceptance']
          : (json['requiresTermsAcceptance']?.toString().toLowerCase() == 'true'),
      termsId: json['termsId']?.toString(),
      latestVersion: json['latestVersion']?.toString(),
      gracePeriodEndsAt: json['gracePeriodEndsAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'requiresTermsAcceptance': requiresTermsAcceptance,
      'termsId': termsId,
      'latestVersion': latestVersion,
      'gracePeriodEndsAt': gracePeriodEndsAt,
    };
  }
}

class User {
  final String? id;
  final String? email;
  final String? username;
  final int? role;
  final String? userType;
  final String? firstName;
  final String? lastName;

  User({
    this.id,
    this.email,
    this.username,
    this.role,
    this.userType,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      email: json['email']?.toString(),
      username: json['username']?.toString(),
      role: json['role'] is int
          ? json['role']
          : int.tryParse(json['role']?.toString() ?? ''),
      userType: json['userType']?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'role': role,
      'userType': userType,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
