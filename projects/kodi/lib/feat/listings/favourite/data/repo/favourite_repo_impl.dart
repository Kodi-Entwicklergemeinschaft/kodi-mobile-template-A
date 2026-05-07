
import 'package:kodi/feat/listings/data/model/listing_request_model.dart';
import 'package:kodi/feat/listings/data/model/listing_response_model.dart';
import 'package:network/network.dart';

import '../../../../../utils/enums/status_enum.dart';
import '../model/fav_listing_response_model.dart';
import '../model/favourite_request.dart';
import '../model/favourite_response.dart';
import 'favourite_repo.dart';

class FavouriteRepositoryImpl extends FavouriteRepository {
  final ApiHelper apiHelper;

  static const String serverEndpoint = "/api/core";

  FavouriteRepositoryImpl(this.apiHelper);


  @override
  Future<Either<Exception, FavouriteResponse>> updateFavoriteStatus(
      FavouriteRequest request) async {
    final response = await apiHelper.postRequest(
      path: "$serverEndpoint/favorites",
      body: request.toJson(),
      create: () =>FavouriteResponse() ,
    );

    return response.fold(
      (l) => Left(Exception(l)),
      (r) {
        if (r.success==true) {
          return right(r);
        }
        return Left(Exception(r.message ??
            'Favorite update failed'));
      },
    );
  }

  @override
  Future<Either<Exception, ListingResponseModel>> getFavoriteList(ListingRequestModel request) async {

    final response = await apiHelper.getRequest(
      path: "$serverEndpoint/favorites",
      params: request.toQueryParameters(),
      create: () => ListingResponseModel(),
    );
    return response.fold((l) => Left(l), (r) {
      if (r.statusCode == 200 ){
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }


}
