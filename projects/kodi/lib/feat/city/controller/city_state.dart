import 'package:kodi/feat/city/data/model/city_response_model.dart';
import 'package:kodi/utils/enums/StateEnum.dart';

class CityState {
  final CityData? cityData;
  final StateEnum state;

  CityState({this.cityData, this.state = StateEnum.initial});

  CityState copyWith({CityData? cityData, StateEnum? state}) {
    return CityState(
      cityData: cityData ?? this.cityData,
      state: state ?? this.state,
    );
  }
}
