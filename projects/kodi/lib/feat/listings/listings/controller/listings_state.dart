import 'package:kodi/utils/enums/StateEnum.dart';
import '../../data/model/category_model.dart';
import '../../data/model/listing_model.dart';

class ListingsState {
  final StateEnum status;
  final List<ListingModel> listings;
  final String? selectedSubCategoryId;
  final CategoryModel? selectedSubCategory;
  final CategoryModel? categoryModel;
  final bool hasReachedMax;
  final int page;
  final String? errorMessage;
  /// The original category/item ID passed on screen open (e.g. kodiWeekEvents
  /// itemId). Preserved so that deselecting a sub-category chip restores the
  /// correct base filter rather than falling back to categoryModel.id.
  final String? baseCategoryId;
  /// Whether the current listings are for Kodi Week events. When true,
  /// eventSort=true is sent with every API request.
  final bool isKodiWeekEvents;

  ListingsState({
    this.status = StateEnum.initial,
    this.listings = const <ListingModel>[],
    this.selectedSubCategory,
    this.selectedSubCategoryId,
    this.categoryModel,
    this.hasReachedMax = false,
    this.page = 1,
    this.errorMessage,
    this.baseCategoryId,
    this.isKodiWeekEvents = false,
  });

  ListingsState copyWith({
    StateEnum? status,
    List<ListingModel>? listings,
    String? selectedSubCategoryId,
    CategoryModel? selectedSubCategory,
    CategoryModel? categoryModel,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
    String? baseCategoryId,
    bool? isKodiWeekEvents,
  }) {
    return ListingsState(
      status: status ?? this.status,
      listings: listings ?? this.listings,
      selectedSubCategoryId:
          selectedSubCategoryId ?? this.selectedSubCategoryId,
      selectedSubCategory:
          selectedSubCategory ?? this.selectedSubCategory,
      categoryModel: categoryModel ?? this.categoryModel,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
      baseCategoryId: baseCategoryId ?? this.baseCategoryId,
      isKodiWeekEvents: isKodiWeekEvents ?? this.isKodiWeekEvents,
    );
  }
}
