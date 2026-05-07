

import 'package:shared_dependencies/equatable.dart';

class SplashState extends Equatable{
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashSuccess extends SplashState{}
class SplashLoading extends SplashState{}

class SplashError extends SplashState{
  final String error;
  const SplashError(this.error);

  @override
  List<Object?> get props => [error];
}
