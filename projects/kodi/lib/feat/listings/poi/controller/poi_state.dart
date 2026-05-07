import 'package:kodi/utils/enums/StateEnum.dart';
import '../../data/model/category_model.dart';
import '../../data/model/listing_model.dart';

class POIState {
  final StateEnum status;
  final List<ListingModel> listings;
  final ListingModel? selectedMarker;
  final CategoryModel? categoryModel;
  final bool hasReachedMax;
  final int page;
  final String? errorMessage;
  final String? baseCategoryId;

  const POIState({
    this.status = StateEnum.initial,
    this.listings = const <ListingModel>[],
    this.selectedMarker,
    this.categoryModel,
    this.hasReachedMax = false,
    this.page = 1,
    this.errorMessage,
    this.baseCategoryId,
  });

  POIState copyWith({
    StateEnum? status,
    List<ListingModel>? listings,
    CategoryModel? categoryModel,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
    String? baseCategoryId,
  }) {
    return POIState(
      status: status ?? this.status,
      listings: listings ?? this.listings,
      selectedMarker: selectedMarker,
      categoryModel: categoryModel ?? this.categoryModel,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
      baseCategoryId: baseCategoryId ?? this.baseCategoryId,
    );
  }

  /// Returns a copy with selectedMarker explicitly set (or cleared to null).
  POIState withSelectedMarker(ListingModel? marker) {
    return POIState(
      status: status,
      listings: listings,
      selectedMarker: marker,
      categoryModel: categoryModel,
      hasReachedMax: hasReachedMax,
      page: page,
      errorMessage: errorMessage,
      baseCategoryId: baseCategoryId,
    );
  }
}
