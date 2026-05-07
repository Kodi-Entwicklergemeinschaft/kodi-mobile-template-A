import 'package:shared_dependencies/riverpod.dart';
import '../../../../utils/enums/StateEnum.dart';
import '../data/repo/category_filter_repo.dart';
import 'category_filter_state.dart';

final categoryFilterControllerProvider =
NotifierProvider.autoDispose<CategoryFilterController, CategoryFilterState>(() {
  return CategoryFilterController();
});

class CategoryFilterController extends Notifier<CategoryFilterState> {
  late final CategoryFilterRepository categoryFilterRepository;

  @override
  CategoryFilterState build() {
    categoryFilterRepository =
        ref.read(categoryFilterRepositoryImplProvider);
    return const CategoryFilterState();
  }

  Future<void> loadCategoryFilter({
    required String categoryId,
  }) async {
    state = state.copyWith(
      status: StateEnum.loading,
      clearErrorMessage: true,
    );

    final response = await categoryFilterRepository.getCategoryFilters(
      categoryId: categoryId,
    );

    if (!ref.mounted) return;

    response.fold(
          (error) {
        state = state.copyWith(
          status: StateEnum.error,
          errorMessage: error.toString(),
        );
      },
          (result) {
        state = state.copyWith(
          status: StateEnum.success,
          filterGroups: result.groups ?? [],
        );
      },
    );
  }

  void applyFilters(List<String> ids) {
    state = state.copyWith(selectedFilterIds: ids);
  }

  void resetFilters() {
    state = state.copyWith(selectedFilterIds: null);
  }
}
