import 'dart:async';

import 'package:common_components/extensions/string_extension.dart';
import 'package:kodi/utils/common_methods.dart';
import 'package:network/network.dart';
import 'package:shared_dependencies/geolocator.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../../utils/enums/StateEnum.dart';
import '../../../home/controller/home_screen_controller.dart';
import '../../data/model/category_model.dart';
import '../../data/model/listing_request_model.dart';
import '../../data/repo/listings_repository.dart';
import '../../favourite/controller/favourite_controller.dart';
import '../../filter/filter_controller.dart';
import 'listings_state.dart';

final listingsControllerProvider =
    NotifierProvider.autoDispose<ListingsController, ListingsState>(() {
      return ListingsController();
    });

class ListingsController extends Notifier<ListingsState> {
  final String id = 'listings';
  late final ListingsRepository listingRepository;
  late final FavouriteController favouriteController;
  late final ListingFiltersController listingFiltersController;
  Position? currentLoc;
  Timer? _debounce;
  String _lastQuery = "";
  CancelToken? _cancelToken;

  @override
  ListingsState build() {
    listingRepository = ref.read(listingRepositoryImplProvider);
    favouriteController = ref.read(favouriteControllerProvider.notifier);
    listingFiltersController= ref.read(listingsFiltersControllerProvider.notifier);


    ref.onDispose(() {
      _cancelToken?.cancel();
      _debounce?.cancel();
    });
    return ListingsState();
  }

  void updateCategory(CategoryModel? category, String? selectedSubCategoryId, {bool isKodiWeekEvents = false}) {

    if (category == null) return;

    CategoryModel? selectedSubCategory ;
    int? index = category.children.indexWhere((e) => e.id == selectedSubCategoryId);
    if (index != -1) {
      selectedSubCategory= category.children[index];
    }

    if (!ref.mounted) return;
    state = state.copyWith(
      categoryModel: category,
      selectedSubCategoryId: selectedSubCategoryId,
      selectedSubCategory: selectedSubCategory,
      baseCategoryId: selectedSubCategoryId,
      isKodiWeekEvents: isKodiWeekEvents,
    );

    loadListings();
  }

  Future<void> loadListings({String? searchTerm, List<String>? groupFilterIds}) async {
    // If a request is already in progress, cancel it before starting a new one.
    _cancelToken?.cancel();
    // Create a new token for the new request.
    _cancelToken = CancelToken();

    if (state.status == StateEnum.loading) return; // Prevent concurrent loads
    state = state.copyWith(status: StateEnum.loading);
    if ((state.categoryModel == null ||
            state.categoryModel!.id.isNullOrEmpty) &&
        state.selectedSubCategoryId.isNullOrEmpty) {
      state = state.copyWith(
        status: StateEnum.error,
        errorMessage: "Failed to load categories.",
      );
      return;
    }
    currentLoc=ref.read(homeControllerProvider.notifier).getCurrentLocation();

    if (!ref.mounted) return;
    final request = ListingRequestModel(
      page: 1,
      search: searchTerm??_lastQuery,
      quickFilter: (state.selectedSubCategoryId.isNotNullAndEmpty&&state.selectedSubCategory!=null && state.selectedSubCategory!.isQuickFilter)
          ?state.selectedSubCategory!.quickFilter:null,
      radiusMeters: (state.selectedSubCategoryId.isNotNullAndEmpty&&state.selectedSubCategory!=null && state.selectedSubCategory!.isQuickFilter)
          ?state.selectedSubCategory!.radiusMeters:null,
      userLat: state.selectedSubCategoryId.isNotNullAndEmpty?currentLoc?.latitude:null,
      userLng: state.selectedSubCategoryId.isNotNullAndEmpty?currentLoc?.longitude:null,
      categoryIds: (state.selectedSubCategoryId.isNotNullAndEmpty&&state.selectedSubCategory!=null && state.selectedSubCategory!.isQuickFilter)
          ?[state.selectedSubCategory!.parentId!]
          :((state.selectedSubCategoryId.isNotNullAndEmpty&&state.selectedSubCategory!=null)
          ? [state.selectedSubCategory!.id]
          : state.selectedSubCategoryId.isNotNullAndEmpty
          ? [state.selectedSubCategoryId!]
          : state.baseCategoryId.isNotNullAndEmpty
          ? [state.baseCategoryId!]
          : state.categoryModel!.id.isNotNullAndEmpty
          ? [state.categoryModel!.id]
          : null),
      sortBy: "createdAt",
      sortDirection: "desc",
      eventSort: state.isKodiWeekEvents ? true : null,
      upcomingAfter: listingFiltersController.state.startDate?.toIso8601String(),
      upcomingBefore: listingFiltersController.state.endDate?.toIso8601String(),
      filterIds: groupFilterIds
    );

    final response = await listingRepository.getListings(listingsRequestModel: request,cancelToken: _cancelToken);
    if (!ref.mounted) return;

    response.fold(
      (error) {
        state = state.copyWith(
          status: StateEnum.error,
          errorMessage: error.toString(),
        );
      },
      (result) {
        if (result.data?.items != null) {
          final listings = result.data!.items.map((listing) {
            if (currentLoc != null &&
                listing.geoLat != null &&
                listing.geoLng != null) {
              final distanceInMeters = Geolocator.distanceBetween(
                currentLoc!.latitude,
                currentLoc!.longitude,
                listing.geoLat!,
                listing.geoLng!,
              );
              return listing.copyWith(distance: distanceInMeters);
            }
            return listing;
          }).toList();
          if (!ref.mounted) return;
          state = state.copyWith(
            status: StateEnum.success,
            listings: listings,
            hasReachedMax: result.data!.items.isEmpty,
            page: 2, // Next page to fetch
          );
        } else {
          state = state.copyWith(
            status: StateEnum.error,
            errorMessage: "Failed to load events.",
          );
        }
      },
    );
  }

  Future<void> loadMore(List<String>? groupFilterIds) async {
    if (state.hasReachedMax || state.status == StateEnum.loadingMore) return;

    state = state.copyWith(status: StateEnum.loadingMore);

    final request = ListingRequestModel(
      page: state.page,
      search: _lastQuery,
      quickFilter: (state.selectedSubCategoryId.isNotNullAndEmpty&&state.selectedSubCategory!=null && state.selectedSubCategory!.isQuickFilter)
          ?state.selectedSubCategory!.quickFilter:null,
      radiusMeters: (state.selectedSubCategoryId.isNotNullAndEmpty&&state.selectedSubCategory!=null && state.selectedSubCategory!.isQuickFilter)
          ?state.selectedSubCategory!.radiusMeters:null,
      userLat: state.selectedSubCategoryId.isNotNullAndEmpty?currentLoc?.latitude:null,
      userLng: state.selectedSubCategoryId.isNotNullAndEmpty?currentLoc?.longitude:null,
      categoryIds: (state.selectedSubCategoryId.isNotNullAndEmpty&&state.selectedSubCategory!=null && state.selectedSubCategory!.isQuickFilter)
          ?[state.selectedSubCategory!.parentId!]
          :((state.selectedSubCategoryId.isNotNullAndEmpty&&state.selectedSubCategory!=null)
          ? [state.selectedSubCategory!.id]
          : state.selectedSubCategoryId.isNotNullAndEmpty
          ? [state.selectedSubCategoryId!]
          : state.baseCategoryId.isNotNullAndEmpty
          ? [state.baseCategoryId!]
          : state.categoryModel!.id.isNotNullAndEmpty
          ? [state.categoryModel!.id]
          : null),
      sortBy: "createdAt",
      sortDirection: "desc",
      eventSort: state.isKodiWeekEvents ? true : null,
      upcomingAfter: listingFiltersController.state.startDate?.toIso8601String(),
      upcomingBefore: listingFiltersController.state.endDate?.toIso8601String(),
      filterIds: groupFilterIds
    );
    final response = await listingRepository.getListings(listingsRequestModel: request,cancelToken: _cancelToken);
    if (!ref.mounted) return;

    response.fold(
      (error) {
        // Revert status on error, so user can try again
        state = state.copyWith(
          status: StateEnum.error,
          errorMessage: error.toString(),
        );
      },
      (result) {
        if (result.statusCode == 200 && result.data?.items != null) {
          final newItems = result.data!.items.map((listing) {
            if (currentLoc != null &&
                listing.geoLat != null &&
                listing.geoLng != null) {
              final distanceInMeters = Geolocator.distanceBetween(
                currentLoc!.latitude,
                currentLoc!.longitude,
                listing.geoLat!,
                listing.geoLng!,
              );
              return listing.copyWith(distance: distanceInMeters);
            }
            return listing;
          }).toList();
          if (!ref.mounted) return;
          state = state.copyWith(
            status: StateEnum.success,
            listings: List.of(state.listings)..addAll(newItems),
            hasReachedMax: result.data!.items.isEmpty,
            page: state.page + 1,
          );
        } else {
          // If fetching more fails, just revert to the success state
          state = state.copyWith(status: StateEnum.success);
        }
      },
    );
  }

  void updateSubCategoryId({CategoryModel? subCategory, List<String>? groupFilterIds}) {
    if (state.status == StateEnum.loading) return;
    String? subCategoryID = subCategory?.id;
    // Prevent concurrent loads
    if (state.selectedSubCategoryId == subCategory?.id) {
      subCategory=null;
      subCategoryID = "";
    }
    state = state.copyWith(selectedSubCategory: subCategory,selectedSubCategoryId: subCategoryID);
    loadListings(groupFilterIds: groupFilterIds);
  }

  void toggleFavourite(String s, bool isFav, int index) {
    if (index >= 0 && index < state.listings.length) {
      final updatedEvents = List.of(state.listings);
      final eventToUpdate = updatedEvents[index];
      // Assuming EventModel has a copyWith method or is mutable
      updatedEvents[index] = eventToUpdate.copyWith(isFavourite: isFav);
      state = state.copyWith(listings: updatedEvents);

      favouriteController.updateFavoriteStatus(s, isFav);
    }
  }

  void searchListings(String text, List<String>? groupFilterIds) {
    // avoid redundant calls
    if (text == _lastQuery) return;
    _lastQuery = text;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      loadListings(searchTerm: text, groupFilterIds: groupFilterIds);
    });
  }
}
