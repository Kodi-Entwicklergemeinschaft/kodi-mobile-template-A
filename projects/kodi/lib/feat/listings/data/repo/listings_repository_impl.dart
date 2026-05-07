

import 'package:kodi/feat/listings/data/model/category_response_model.dart';
import 'package:kodi/utils/enums/status_enum.dart';
import 'package:network/network.dart';
import '../model/listing_request_model.dart';
import '../model/listing_response_model.dart';
import 'listings_repository.dart';

class ListingRepositoryImpl implements ListingsRepository{
  final ApiHelper apiHelper;
  static const String serverEndpoint = "/api/core";

  ListingRepositoryImpl(this.apiHelper,);

  @override
  Future<Either<Exception, ListingResponseModel>> getListings(
      {required ListingRequestModel listingsRequestModel, CancelToken? cancelToken,}) async {

    final requestModel=listingsRequestModel.copyWith(status: StatusEnum.APPROVED.toString());

    final response = await apiHelper.getRequest(
      path: "$serverEndpoint/listings",
      params: requestModel.toQueryParameters(),
      create: () => ListingResponseModel(success: null),
      cancelToken: cancelToken,
    );
    return response.fold((l) => Left(l), (r) {
      if (r.statusCode == 200 ){
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }

  @override
  Future<Either<Exception, CategoryResponse>> getCategories({required String cityId}) async {
    final response= await apiHelper.getRequest(
        path: "$serverEndpoint/categories/cities/$cityId/with-filters",
        params: {},
        create: ()=>CategoryResponse());
    return response.fold((l) => Left(l), (r) {
      if (r.success == true ){
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }

}