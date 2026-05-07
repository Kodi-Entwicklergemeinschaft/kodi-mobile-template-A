import 'package:shared_dependencies/equatable.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {}

class GuestLoginSuccess extends LoginState {}

class LoginLoading extends LoginState {}
class Logout extends LoginState {}

class LoginError extends LoginState {
  final String error;

  LoginError(this.error);

  @override
  List<Object?> get props => [];
}

class GuestLoginError extends LoginError {
  GuestLoginError(super.error);
}
