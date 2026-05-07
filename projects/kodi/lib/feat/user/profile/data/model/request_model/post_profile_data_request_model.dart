import 'package:network/network.dart';

class PostProfileDataRequestModel
    implements BaseModel<PostProfileDataRequestModel> {
  String? firstName;
  String? lastName;
  String? salutationCode;
  String? profilePhotoUrl;
  String? preferredLanguage;
  bool? hasVehicle;

  PostProfileDataRequestModel({
    this.firstName,
    this.lastName,
    this.salutationCode,
    this.profilePhotoUrl,
    this.preferredLanguage,
    this.hasVehicle,
  });

  @override
  PostProfileDataRequestModel fromJson(Map<String, dynamic> json) {
    return PostProfileDataRequestModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      salutationCode: json['salutationCode'],
      profilePhotoUrl: json['profilePhotoUrl'],
      preferredLanguage: json['preferredLanguage'],
      hasVehicle: json['hasVehicle'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'salutationCode': salutationCode,
      'profilePhotoUrl': profilePhotoUrl,
      'preferredLanguage': preferredLanguage,
      'hasVehicle': hasVehicle,
    };
  }
}
