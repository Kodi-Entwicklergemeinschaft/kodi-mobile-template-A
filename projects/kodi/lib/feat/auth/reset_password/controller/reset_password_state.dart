import 'package:shared_dependencies/equatable.dart';

class ResetPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ResetPasswordSuccess extends ResetPasswordState {
  final String? message;

  ResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ChangePasswordSuccess extends ResetPasswordSuccess {
  ChangePasswordSuccess(super.message);
}

class ResetPasswordLoading extends ResetPasswordState {}

class ChangePasswordLoading extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String error;

  ResetPasswordError(this.error);

  @override
  List<Object?> get props => [error];
}

class ChangePasswordError extends ResetPasswordError {
  ChangePasswordError(super.error);
}
