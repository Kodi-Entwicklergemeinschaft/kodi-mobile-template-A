import 'package:shared_dependencies/equatable.dart';
import 'package:kodi/utils/enums/StateEnum.dart';

import '../data/model/parking_response_model.dart';

class ParkingState extends Equatable {
  const ParkingState({
    this.status = StateEnum.initial,
    this.parkingDataList,
    this.errorMessage,
  });

  final StateEnum status;
  final List<ParkingData>? parkingDataList;
  final String? errorMessage;

  ParkingState copyWith({
    StateEnum? status,
    List<ParkingData>? parkingDataList,
    String? errorMessage,
    bool? clearErrorMessage,
  }) {
    return ParkingState(
      status: status ?? this.status,
      parkingDataList: parkingDataList ?? this.parkingDataList,
      errorMessage: clearErrorMessage == true
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    parkingDataList,
    errorMessage,
  ];
}
