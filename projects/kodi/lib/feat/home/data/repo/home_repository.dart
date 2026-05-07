

import 'package:kodi/feat/home/data/model/tile_response_model.dart';
import 'package:network/network.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../../utils/network.dart';
import 'home_repository_impl.dart';


final homeRepositoryImplProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(ref.read(apiProvider));
});

abstract class HomeRepository {
  Future<Either<Exception, TileResponseModel>> getTiles();

}