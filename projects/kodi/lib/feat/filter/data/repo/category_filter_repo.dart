import 'package:kodi/feat/filter/data/model/category_filter_response_model.dart';
import 'package:network/network.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../../../utils/network.dart';
import 'category_filter_repo_impl.dart';


final categoryFilterRepositoryImplProvider = Provider<CategoryFilterRepository>((ref) {
  return CategoryFilterRepositoryImpl(ref.read(apiProvider));
});

abstract class CategoryFilterRepository {
  Future<Either<Exception, CategoryFilterResponseModel>> getCategoryFilters({
    required String categoryId,
    CancelToken? cancelToken,
  });
}