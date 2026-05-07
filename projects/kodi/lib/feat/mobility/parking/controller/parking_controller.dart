import 'package:kodi/feat/city/controller/city_controller.dart';
import 'package:shared_dependencies/riverpod.dart';
import '../../../../utils/enums/StateEnum.dart';
import '../data/repository/parking_repo.dart';
import 'parking_state.dart';

final parkingControllerProvider =
NotifierProvider<ParkingController, ParkingState>(() {
  return ParkingController();
});

class ParkingController extends Notifier<ParkingState> {
  late final ParkingRepository parkingRepository;
  late final CityController cityController;

  @override
  ParkingState build() {
    parkingRepository = ref.read(parkingRepositoryImplProvider);
    cityController = ref.read(cityControllerProvider.notifier);
    return const ParkingState();
  }

  Future<void> loadParking({bool isRefresh = false}) async {
    final cityId = cityController.getCityId();

    if (state.status == StateEnum.loading) return;

    if(!isRefresh){
      state = state.copyWith(
        status: StateEnum.loading,
        clearErrorMessage: true,
      );
    }


    final response =
    await parkingRepository.getParkingData(cityId: cityId);

    if (!ref.mounted) return;

    response.fold(
          (error) {
        state = state.copyWith(
          status: StateEnum.error,
          errorMessage: error.toString(),
        );
      },
          (result) {
            if(!isRefresh){
              state = state.copyWith(
                status: StateEnum.success,
                parkingDataList: result.data ?? [],
              );
            } else {
              state = state.copyWith(
                parkingDataList: result.data ?? [],
              );
            }

      },
    );
  }

  /// Optional: refresh parking data
  Future<void> refreshParking({bool isLoading = false}) async {
    await loadParking(isRefresh:  isLoading);
  }
}
