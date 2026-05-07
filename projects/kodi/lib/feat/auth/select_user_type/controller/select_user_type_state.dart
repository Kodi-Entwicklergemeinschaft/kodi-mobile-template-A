import 'package:shared_dependencies/equatable.dart';

enum UserTypeEnum { guest, resident }

extension UserTypeEnumX on UserTypeEnum {
  /// Convert enum → int
  int get toInt {
    switch (this) {
      case UserTypeEnum.guest:
        return 0;
      case UserTypeEnum.resident:
        return 1;
    }
  }

  /// Convert int → enum
  static UserTypeEnum fromInt(int value) {
    switch (value) {
      case 0:
        return UserTypeEnum.guest;
      case 1:
        return UserTypeEnum.resident;
      default:
        throw ArgumentError('Invalid UserTypeEnum value: $value');
    }
  }
}

class SelectUserTypeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectUserTypeSuccess extends SelectUserTypeState {
  final UserTypeEnum type;

  SelectUserTypeSuccess(this.type);

  @override
  List<Object?> get props => [type];
}

class SelectUserTypeLoading extends SelectUserTypeState {}

class SelectUserTypeError extends SelectUserTypeState {
  final String error;

  SelectUserTypeError(this.error);

  @override
  List<Object?> get props => [];
}
