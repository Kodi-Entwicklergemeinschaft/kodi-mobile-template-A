import 'package:kodi/utils/enums/StateEnum.dart';

class RegisterDeviceState {
  final StateEnum status;
  final String errorMessage;

  RegisterDeviceState({
    this.status = StateEnum.initial,
    this.errorMessage = "",
  });

  RegisterDeviceState copyWith({StateEnum? status, String? errorMessage}) {
    return RegisterDeviceState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
