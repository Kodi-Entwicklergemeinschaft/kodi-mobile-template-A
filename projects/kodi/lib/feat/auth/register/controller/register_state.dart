import 'package:equatable/equatable.dart';

class RegisterState extends Equatable{
  @override
  List<Object?> get props => [];
}

class RegisterSuccess extends RegisterState{
  final String message;

  RegisterSuccess(this.message);

  @override
  List<Object?> get props => [];
}

class RegisterLoading extends RegisterState{}

class RegisterError extends RegisterState{
  final String error;

  RegisterError(this.error);

  @override
  List<Object?> get props => [];
}