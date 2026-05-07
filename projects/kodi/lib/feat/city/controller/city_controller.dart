import 'package:kodi/feat/city/data/repo/city_repo.dart';
import 'package:local_storage/preference_manager.dart';
import 'package:local_storage/preference_manager_impl.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../utils/app_pref_keys.dart';
import '../../../utils/enums/StateEnum.dart';
import '../../../utils/env_config.dart';
import 'city_state.dart';

final cityControllerProvider = NotifierProvider<CityController, CityState>(
  () => CityController(),
);

class CityController extends Notifier<CityState> {
  late final CityRepository cityRepository;
  late final PreferenceManager preferenceManager;

  @override
  CityState build() {
    cityRepository = ref.read(cityRepositoryProvider);
    preferenceManager = ref.read(preferenceManagerProvider);
    return CityState();
  }

  loadCityData() async {
    state = state.copyWith(state: StateEnum.loading);

    final result = await cityRepository.getCityDetails(cityName: EnvironmentConfig.kodiCityKey);

    result.fold((error) => state = state.copyWith(state: StateEnum.error), (
      response,
    ) {
      if(response.success==true) {
        final cityData= response.data?.items?[0];
        if(cityData?.id !=null) {
          preferenceManager.saveString(
              AppPrefsKeys.cityId, cityData?.id??"");
        }
        state =
            state.copyWith(cityData: response.data, state: StateEnum.success);
      }
    });
  }

  getCityData() {
    return state.cityData;
  }

  getCityId() {
    return state.cityData?.items?[0].id;
  }
}
