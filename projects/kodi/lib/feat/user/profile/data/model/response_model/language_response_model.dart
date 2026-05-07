import 'dart:convert';

import 'package:network/network.dart';



String languageResponseModelToJson(LanguageResponseModel data) =>
    json.encode(data.toJson());

class LanguageResponseModel implements BaseModel<LanguageResponseModel>{
  final bool? success;
  final LanguageData? data;
  final String? message;
  final DateTime? timestamp;
  final String? path;
  final int? statusCode;

  LanguageResponseModel({
    this.success,
    this.data,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });

  @override
  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
        "timestamp": timestamp?.toIso8601String(),
        "path": path,
        "statusCode": statusCode,
      };

  @override
  LanguageResponseModel fromJson(Map<String, dynamic> json) =>
      LanguageResponseModel(
        success: json["success"] as bool?,
        data: json["data"] == null
            ? null
            : LanguageData.fromJson(json["data"],),
        message: json["message"] as String?,
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.tryParse(json["timestamp"] as String),
        path: json["path"] as String?,
        statusCode: json["statusCode"] as int?,
      );
}

class LanguageData {
  final String? id;
  final String? preferredLanguage;
  final DateTime? updatedAt;

  LanguageData({
    this.id,
    this.preferredLanguage,
    this.updatedAt,
  });

  factory LanguageData.fromJson(Map<String, dynamic> json) => LanguageData(
        id: json["id"] as String?,
        preferredLanguage: json["preferredLanguage"] as String?,
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"] as String),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "preferredLanguage": preferredLanguage,
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
