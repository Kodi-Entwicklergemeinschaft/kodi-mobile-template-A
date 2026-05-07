import 'package:kodi/feat/listings/data/model/listing_request_model.dart';
import 'package:kodi/feat/listings/data/model/listing_response_model.dart';
import 'package:network/network.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../../../utils/network.dart';
import '../model/fav_listing_response_model.dart';
import '../model/favourite_request.dart';
import '../model/favourite_response.dart';
import 'favourite_repo_impl.dart';

final favouriteRepositoryProvider = Provider<FavouriteRepository>((ref) {

  return FavouriteRepositoryImpl(ref.read(apiProvider));
});

abstract class FavouriteRepository {
  Future<Either<Exception, ListingResponseModel>> getFavoriteList(ListingRequestModel request);
  Future<Either<Exception, FavouriteResponse>> updateFavoriteStatus(FavouriteRequest request);

}
