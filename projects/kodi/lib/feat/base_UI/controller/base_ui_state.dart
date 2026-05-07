
import 'package:shared_dependencies/equatable.dart';

class BaseUIState extends Equatable{
  @override
  List<Object?> get props => [];
}

class BaseUISuccess extends BaseUIState{}
class BaseUILoading extends BaseUIState{}
class BaseUIStackLoading extends BaseUIState{}

class BaseUIError extends BaseUIState{
  final String? error;

  BaseUIError({this.error});

  @override
  List<Object?> get props => [error];
}