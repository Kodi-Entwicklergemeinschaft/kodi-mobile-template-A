
import 'package:network/network.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../../utils/network.dart';
import '../model/category_response_model.dart';
import '../model/listing_request_model.dart';
import '../model/listing_response_model.dart';
import 'listings_repository_impl.dart';

final listingRepositoryImplProvider = Provider<ListingsRepository>((ref) {
  return ListingRepositoryImpl(ref.read(apiProvider));
});

abstract class ListingsRepository{

  Future<Either<Exception, ListingResponseModel>> getListings(
      {required ListingRequestModel listingsRequestModel, CancelToken? cancelToken,});
  Future<Either<Exception, CategoryResponse>> getCategories({required String cityId});
}