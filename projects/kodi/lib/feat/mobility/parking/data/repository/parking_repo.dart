import 'package:network/network.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../../../utils/network.dart';
import '../model/parking_response_model.dart';
import 'parking_repo_impl.dart';


final parkingRepositoryImplProvider = Provider<ParkingRepository>((ref) {
  return ParkingRepositoryImpl(ref.read(apiProvider));
});

abstract class ParkingRepository {
  Future<Either<Exception, ParkingResponseModel>> getParkingData({
    required String cityId,
    CancelToken? cancelToken,
  });
}