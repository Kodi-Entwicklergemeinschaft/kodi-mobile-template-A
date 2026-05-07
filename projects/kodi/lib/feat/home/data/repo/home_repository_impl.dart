
import 'package:kodi/feat/home/data/model/tile_response_model.dart';
import 'package:network/network.dart';

import 'home_repository.dart';

class HomeRepositoryImpl implements HomeRepository{
  final ApiHelper apiHelper;
  static const String serverEndpoint = "/api/core";

  HomeRepositoryImpl(this.apiHelper);

  @override
  Future<Either<Exception, TileResponseModel>> getTiles() async {
    final response = await apiHelper.getRequest(
      path: "$serverEndpoint/tiles",
      params: {"isActive": true},
      create: () => TileResponseModel(success: false),
    );
    return response.fold((l) => Left(l), (r) {
      if (r.statusCode == 200 ){
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }

}