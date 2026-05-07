import 'dart:async';

import 'package:common_components/extensions/string_extension.dart';
import 'package:kodi/feat/home/controller/home_screen_controller.dart';
import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:shared_dependencies/geolocator.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../../utils/enums/StateEnum.dart';
import '../../categories/categories_controller.dart';
import '../../data/model/listing_request_model.dart';
import '../../data/repo/listings_repository.dart';
import '../../favourite/controller/favourite_controller.dart';
import '../../filter/filter_controller.dart';
import 'event_state.dart';


final eventControllerProvider = 
    NotifierProvider<EventController, EventState>(() {
      return EventController();
    });

class EventController extends Notifier<EventState> {
  final String id = 'event';
  late final ListingsRepository listingRepository;
  late final FavouriteController favouriteController;
  late final ListingFiltersController listingFiltersController;
  late final CategoriesController categoriesController;


  Position? currentLoc;
  Timer? _debounce;
  String _lastQuery = "";

  @override
  EventState build() {
    listingRepository = ref.read(listingRepositoryImplProvider);
    favouriteController = ref.read(favouriteControllerProvider.notifier);
    listingFiltersController= ref.read(listingsFiltersControllerProvider.notifier);
    categoriesController= ref.read(categoriesControllerProvider.notifier);

    ref.onDispose(() {
      _debounce?.cancel();
    });

    return const EventState();
  }

  Future<void> loadEvents({ String? searchTerm,}) async {
    if (state.status == StateEnum.loading) return; // Prevent concurrent loads

    updateCategory();
    state = state.copyWith(status: StateEnum.loading);
    if (state.categoryModel == null) {
      state = state.copyWith(
        status: StateEnum.error,
        errorMessage: "Category not loaded.",
      );
      return;
    }
    currentLoc=ref.read(homeControllerProvider.notifier).getCurrentLocation();
    if (!ref.mounted) return;

    final request = ListingRequestModel(page: 1,
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
          : state.categoryModel!.id.isNotNullAndEmpty
          ? [state.categoryModel!.id]
          : null),
      eventSort:true,
      upcomingAfter: listingFiltersController.state.startDate?.toIso8601String(),
      upcomingBefore: listingFiltersController.state.endDate?.toIso8601String(),
    );
    final response = await listingRepository.getListings(listingsRequestModel: request);
    if (!ref.mounted) return;

    response.fold(
      (error) {
        state = state.copyWith(status: StateEnum.error, errorMessage: error.toString());
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
          state = state.copyWith(
            status: StateEnum.success,
            events: listings,
            hasReachedMax: result.data!.items.isEmpty,
            page: 2, // Next page to fetch
          );
        } else {
          state = state.copyWith(status: StateEnum.error, errorMessage: "Failed to load events.");
        }
      },
    );
  }

  Future<void> loadRecentEvents(String categoryId) async {
    if (state.status == StateEnum.loading) return; // Prevent concurrent loads
    state = state.copyWith(status: StateEnum.loading);

    final request = ListingRequestModel(page: 1,
      pageSize: 4,
      categoryIds: [categoryId],
      eventSort:true,
    );
    final response = await listingRepository.getListings(listingsRequestModel: request);
    if (!ref.mounted) return;

    response.fold(
      (error) {
        state = state.copyWith(status: StateEnum.error, errorMessage: error.toString());
      },
      (result) {
        if (result.data?.items != null) {
          state = state.copyWith(
            status: StateEnum.success,
            recentEvents: result.data!.items,
          );
        } else {
          state = state.copyWith(status: StateEnum.error, errorMessage: "Failed to load events.");
        }
      },
    );
  }

  void toggleFavouriteForResentEvents(String s, bool isFav, int index) {
    if (state.recentEvents!=null && index >= 0 && index < state.recentEvents!.length) {
      final updatedEvents = List.of(state.recentEvents!);
      final eventToUpdate = updatedEvents[index];
      // Assuming EventModel has a copyWith method or is mutable
      updatedEvents[index] = eventToUpdate.copyWith(isFavourite: isFav);
      state = state.copyWith(recentEvents: updatedEvents);
      favouriteController.updateFavoriteStatus(s, isFav);
    }
  }

  Future<void> loadMoreEvents() async {
    if (state.hasReachedMax || state.status == StateEnum.loadingMore) return;

    state = state.copyWith(status: StateEnum.loadingMore);

    final request = ListingRequestModel(
      page: state.page,
      search: _lastQuery,
      categoryIds: (state.selectedSubCategoryId.isNotNullAndEmpty&&state.selectedSubCategory!=null && state.selectedSubCategory!.isQuickFilter)
          ?[state.selectedSubCategory!.parentId!]
          :((state.selectedSubCategoryId.isNotNullAndEmpty&&state.selectedSubCategory!=null)
          ? [state.selectedSubCategory!.id]
          : state.categoryModel!.id.isNotNullAndEmpty
          ? [state.categoryModel!.id]
          : null),
      eventSort:true,
      quickFilter: (state.selectedSubCategoryId.isNotNullAndEmpty&&state.selectedSubCategory!=null && state.selectedSubCategory!.isQuickFilter)
          ?state.selectedSubCategory!.quickFilter:null,
      radiusMeters: (state.selectedSubCategoryId.isNotNullAndEmpty&&state.selectedSubCategory!=null && state.selectedSubCategory!.isQuickFilter)
          ?state.selectedSubCategory!.radiusMeters:null,
      userLat: state.selectedSubCategoryId.isNotNullAndEmpty?currentLoc?.latitude:null,
      userLng: state.selectedSubCategoryId.isNotNullAndEmpty?currentLoc?.longitude:null,
      upcomingAfter: listingFiltersController.state.startDate?.toIso8601String(),
      upcomingBefore: listingFiltersController.state.endDate?.toIso8601String(),
    );
    final response = await listingRepository.getListings(listingsRequestModel: request);
    if (!ref.mounted) return;

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
            events: List.of(state.events)..addAll(newItems),
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

  void toggleFavourite(String s, bool isFav, int index) {
    if (index >= 0 && index < state.events.length) {
      final updatedEvents = List.of(state.events);
      final eventToUpdate = updatedEvents[index];
      // Assuming EventModel has a copyWith method or is mutable
      updatedEvents[index] = eventToUpdate.copyWith(isFavourite: isFav);
      state = state.copyWith(events: updatedEvents);

      favouriteController.updateFavoriteStatus(s, isFav);

    }
  }

  void searchEvents(String text) {
    // avoid redundant calls
    if (text == _lastQuery) return;
    _lastQuery = text;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      loadEvents(searchTerm: text);
    });
  }


   updateCategory()  {
    final eventCategory= categoriesController.getCategorySlugByEnum(CategorySlug.events);
    if (eventCategory == null) return;
    state = state.copyWith(categoryModel: eventCategory);
  }

  void updateSubCategoryId({CategoryModel? subCategory}) {
    if (state.status == StateEnum.loading) return;
    String? subCategoryID = subCategory?.id;
    // Prevent concurrent loads
    if (state.selectedSubCategoryId == subCategory?.id || subCategory==null) {
      subCategory=null;
      subCategoryID = "";
    }
    state = state.copyWith(selectedSubCategory: subCategory,selectedSubCategoryId: subCategoryID);
    loadEvents();

  }
}
