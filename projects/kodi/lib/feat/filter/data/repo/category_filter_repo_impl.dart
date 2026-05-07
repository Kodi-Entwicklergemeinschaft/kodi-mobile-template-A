import 'package:network/network.dart';

import '../model/category_filter_response_model.dart';
import 'category_filter_repo.dart';


class CategoryFilterRepositoryImpl implements CategoryFilterRepository {
  final ApiHelper apiHelper;

  static const String serverEndpoint = "/api/core";

  CategoryFilterRepositoryImpl(this.apiHelper);

  @override
  Future<Either<Exception, CategoryFilterResponseModel>>
  getCategoryFilters({
    required String categoryId,
    CancelToken? cancelToken,
  }) async {
    final response = await apiHelper.getRequest(
      path:
      "$serverEndpoint/categories/$categoryId/quick-filters",
      create: () => CategoryFilterResponseModel(),
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
