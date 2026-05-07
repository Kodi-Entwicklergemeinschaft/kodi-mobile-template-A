import 'package:kodi/feat/mobility/parking/data/repository/parking_repo.dart';
import 'package:network/network.dart';

import '../model/parking_response_model.dart';

class ParkingRepositoryImpl implements ParkingRepository {
  final ApiHelper apiHelper;

  static const String serverEndpoint = "/api/core";

  ParkingRepositoryImpl(this.apiHelper);

  @override
  Future<Either<Exception, ParkingResponseModel>> getParkingData({
    required String cityId,
    CancelToken? cancelToken,
  }) async {
    final response = await apiHelper.getRequest(
      path: "$serverEndpoint/parking/spaces",
      params: {
        "cityId": cityId,
      },
      create: () => ParkingResponseModel(),
      cancelToken: cancelToken,
    );

    return response.fold((l) => Left(l), (r) {
      if (r.statusCode == 200 && r.success == true) {
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }
}
