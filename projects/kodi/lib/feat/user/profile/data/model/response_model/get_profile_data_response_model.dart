import 'package:network/network.dart';

class GetProfileDataResponseModel
    implements BaseModel<GetProfileDataResponseModel> {
  bool? success;
  ProfileData? data;
  String? message;
  String? timestamp;
  String? path;
  int? statusCode;

  GetProfileDataResponseModel({
    this.success,
    this.data,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });

  @override
  GetProfileDataResponseModel fromJson(Map<String, dynamic> json) {
    return GetProfileDataResponseModel(
      success: json['success'],
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
      message: json['message'],
      timestamp: json['timestamp'],
      path: json['path'],
      statusCode: json['statusCode'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'message': message,
      'timestamp': timestamp,
      'path': path,
      'statusCode': statusCode,
    };
  }
}

class ProfileData {
  String? id;
  String? email;
  String? username;
  int? role;
  String? firstName;
  String? lastName;
  String? salutationCode;
  bool? hasVehicle;
  String? profilePhotoUrl;
  String? preferredLanguage;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? cityAssignments;

  ProfileData({
    this.id,
    this.email,
    this.username,
    this.role,
    this.firstName,
    this.lastName,
    this.salutationCode,
    this.hasVehicle,
    this.profilePhotoUrl,
    this.preferredLanguage,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.cityAssignments,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      role: json['role'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      salutationCode: json['salutationCode'],
      hasVehicle: json['hasVehicle'],
      profilePhotoUrl: json['profilePhotoUrl'],
      preferredLanguage: json['preferredLanguage'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      cityAssignments: json['cityAssignments'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'salutationCode': salutationCode,
      'hasVehicle': hasVehicle,
      'profilePhotoUrl': profilePhotoUrl,
      'preferredLanguage': preferredLanguage,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'cityAssignments': cityAssignments,
    };
  }
}
