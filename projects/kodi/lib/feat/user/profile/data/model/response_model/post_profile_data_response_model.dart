import 'package:network/network.dart';

class PostProfileDataResponseModel
    implements BaseModel<PostProfileDataResponseModel> {
  bool? success;
  ProfileUpdatedData? data;
  String? message;
  String? timestamp;
  String? path;
  int? statusCode;

  PostProfileDataResponseModel({
    this.success,
    this.data,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });

  @override
  PostProfileDataResponseModel fromJson(Map<String, dynamic> json) {
    return PostProfileDataResponseModel(
      success: json['success'],
      data: json['data'] != null
          ? ProfileUpdatedData.fromJson(json['data'])
          : null,
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

class ProfileUpdatedData {
  String? id;
  String? email;
  String? username;
  String? role;
  String? firstName;
  String? lastName;
  String? salutationCode;
  bool? hasVehicle;
  String? profilePhotoUrl;
  String? preferredLanguage;
  String? updatedAt;

  ProfileUpdatedData({
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
    this.updatedAt,
  });

  factory ProfileUpdatedData.fromJson(Map<String, dynamic> json) {
    return ProfileUpdatedData(
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
      updatedAt: json['updatedAt'],
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
      'updatedAt': updatedAt,
    };
  }
}
