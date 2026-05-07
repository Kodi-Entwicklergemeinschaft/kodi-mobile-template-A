

import 'package:kodi/feat/city/data/model/city_response_model.dart';
import 'package:kodi/feat/city/data/repo/city_repo.dart';
import 'package:network/network.dart';

class CityRepositoryImpl extends CityRepository{
  final ApiHelper api;
  static const String serverEndpoint = "/api/city";

  CityRepositoryImpl(this.api);

  @override
  Future<Either<Exception, CityResponseModel>> getCityDetails({required String cityName}) async {
    final response = await api.getRequest(
      path: "$serverEndpoint/",
      // params: {"key":cityName},
      create: () => CityResponseModel(),
    );
    return response.fold(
          (l) => Left(Exception(l)),
          (r) {
        if (r.success==true) {
          return right(r);
        }
        return Left(Exception(r.message));
      },
    );
  }


}