import 'package:network/network.dart';

class RegistrationRequest extends BaseModel<RegistrationRequest> {
  final String? email;
  final String? username;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? cityId;

  RegistrationRequest({
    this.email,
    this.username,
    this.password,
    this.firstName,
    this.lastName,
    this.address,
    this.cityId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      if (email?.isNotEmpty ?? false) 'email': email,
      if (username?.isNotEmpty ?? false) 'username': username,
      if (password?.isNotEmpty ?? false) 'password': password,
      if (firstName?.isNotEmpty ?? false) 'firstName': firstName,
      if (lastName?.isNotEmpty ?? false) 'lastName': lastName,
      if (address?.isNotEmpty ?? false) 'address': address,
      if (cityId?.isNotEmpty ?? false) 'cityId': cityId,
    };
  }

  @override
  RegistrationRequest fromJson(Map<String, dynamic> json) {
    return RegistrationRequest(
      email: json['email']?.toString(),
      username: json['username']?.toString(),
      password: json['password']?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      address: json['address']?.toString(),
      cityId: json['cityId']?.toString(),
    );
  }
}