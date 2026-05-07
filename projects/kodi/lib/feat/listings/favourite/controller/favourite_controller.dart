import 'dart:async';

import 'package:kodi/feat/home/controller/home_screen_controller.dart';
import 'package:kodi/feat/listings/categories/categories_controller.dart';
import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:kodi/feat/listings/data/model/listing_request_model.dart';
import 'package:shared_dependencies/geolocator.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../../utils/enums/StateEnum.dart';
import '../../filter/filter_controller.dart';
import '../data/model/favourite_request.dart';
import '../data/repo/favourite_repo.dart';
import 'favourite_state.dart';



final favouriteControllerProvider = NotifierProvider<FavouriteController, FavouriteState>(() {
  return FavouriteController();
});

class FavouriteController extends Notifier<FavouriteState> {
  final String id = 'favourite';
  late final FavouriteRepository _favouriteRepository;
  late final CategoriesController _categoriesController;
  late final ListingFiltersController listingFiltersController;
  Position? currentLoc;
  Timer? _debounce;
  String _lastQuery = "";
  String? _categoryId;
  List<String>? _groupFilterIds;

  @override
  FavouriteState build() {
    _favouriteRepository = ref.read(favouriteRepositoryProvider);
    _categoriesController = ref.read(categoriesControllerProvider.notifier);
    listingFiltersController = ref.read(listingsFiltersControllerProvider.notifier);
    ref.onDispose(() {
      _debounce?.cancel();
    });

    return FavouriteState();
  }

  Future<void> loadFavoritesList({
    String? searchTerm,
    String? categoryId,
    List<String>? groupFilterIds,
  }) async {
    state = state.copyWith(status: StateEnum.loading);
    _categoryId = categoryId ?? _categoryId;
    _groupFilterIds = groupFilterIds;
    setEventCategory();
    if (state.eventCategory == null) {
      return;
    }
    final request = ListingRequestModel(
      page: 1,
      search: searchTerm ?? _lastQuery,
      categoryIds: _categoryId != null ? [_categoryId!] : [],
      upcomingAfter: listingFiltersController.state.startDate?.toIso8601String(),
      upcomingBefore: listingFiltersController.state.endDate?.toIso8601String(),
      filterIds: _groupFilterIds?.isNotEmpty == true ? _groupFilterIds : null,
    );

    currentLoc = ref.read(homeControllerProvider.notifier).getCurrentLocation();

    final response = await _favouriteRepository.getFavoriteList(request);
    response.fold(
      (error) {
        state = state.copyWith(status: StateEnum.error, errorMessage: error.toString());
      },
      (result) {
        if (result.data?.items != null) {
          final items = result.data!.items.map((listing) {
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
          state = state.copyWith(
            status: StateEnum.success,
            listOfFav: items,
            hasReachedMax: result.data!.items.isEmpty,
            page: 2, // Next page to fetch
          );
        } else {
          state = state.copyWith(status: StateEnum.error, errorMessage: "Failed to load fav.");
        }
      },
    );
  }

  setEventCategory() {
    if (_categoryId == null) {
      state = state.copyWith(
        eventCategory: _categoriesController.getCategorySlugByEnum(CategorySlug.events),
      );
      return;
    }

    final List<CategoryModel> categories = _categoriesController.getCategories();
    CategoryModel? matched;

    for (final cat in categories) {
      // Direct match by category id
      if (cat.id == _categoryId) {
        matched = cat;
        break;
      }
      // Match by sub-service itemId (e.g. Kodi Week Events)
      for (final sub in cat.subServices) {
        if (sub.itemId == _categoryId) {
          matched = cat;
          break;
        }
      }
      if (matched != null) break;
    }

    state = state.copyWith(
      eventCategory: matched ?? _categoriesController.getCategorySlugByEnum(CategorySlug.events),
    );
  }

  void toggleFavourite(String s, bool isFav, int index) {
    if (index >= 0 && index < state.listOfFav.length) {
      final updatedEvents = List.of(state.listOfFav);
      final eventToUpdate = updatedEvents[index];
      // Assuming EventModel has a copyWith method or is mutable
      updatedEvents[index] = eventToUpdate.copyWith(isFavourite: isFav);
      state = state.copyWith(listOfFav: updatedEvents);
      updateFavoriteStatus(s, isFav);

    }
  }

  Future<void> updateFavoriteStatus(String listingId, bool isFavorite) async {
    // state = state.copyWith(status: StateEnum.loading);
    final request = FavouriteRequest(listingId: listingId, isFavorite: isFavorite);
    final result = await _favouriteRepository.updateFavoriteStatus(request);

    result.fold(
          (error) => state = state.copyWith(status: StateEnum.error),
          (response) => state = state.copyWith(status: StateEnum.success),
    );
  }

  Future<void> loadMore() async {
    if (state.hasReachedMax || state.status == StateEnum.loadingMore) return;

    state = state.copyWith(status: StateEnum.loadingMore);

    final request = ListingRequestModel(
      search: _lastQuery,
      page: state.page,
      categoryIds: _categoryId != null ? [_categoryId!] : [],
      upcomingAfter: listingFiltersController.state.startDate?.toIso8601String(),
      upcomingBefore: listingFiltersController.state.endDate?.toIso8601String(),
      filterIds: _groupFilterIds?.isNotEmpty == true ? _groupFilterIds : null,
    );
    final response = await _favouriteRepository.getFavoriteList(request);

    response.fold(
      (error) {
        // Revert status on error, so user can try again
        state = state.copyWith(status: StateEnum.error, errorMessage: error.toString());
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
          state = state.copyWith(
            status: StateEnum.success,
            listOfFav: List.of(state.listOfFav)..addAll(newItems),
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

  void searchEvents(String text) {
    // avoid redundant calls
    if (text == _lastQuery) return;
    _lastQuery = text;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      loadFavoritesList(searchTerm: text,categoryId: _categoryId);
    });
  }


}

