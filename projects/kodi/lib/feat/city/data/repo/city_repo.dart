

import 'package:kodi/feat/city/data/model/city_response_model.dart';
import 'package:network/network.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../../utils/network.dart';
import 'city_repo_impl.dart';

final cityRepositoryProvider = Provider<CityRepository>((ref) {

  return CityRepositoryImpl(ref.read(apiProvider));
});

abstract class CityRepository {
  Future<Either<Exception, CityResponseModel>> getCityDetails({required String cityName});
}
