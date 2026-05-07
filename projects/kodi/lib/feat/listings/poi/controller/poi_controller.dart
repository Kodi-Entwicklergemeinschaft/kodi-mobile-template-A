import 'dart:async';

import 'package:network/network.dart';
import 'package:shared_dependencies/geolocator.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../../utils/enums/StateEnum.dart';
import '../../../home/controller/home_screen_controller.dart';
import '../../data/model/category_model.dart';
import '../../data/model/listing_model.dart';
import '../../data/model/listing_request_model.dart';
import '../../data/repo/listings_repository.dart';
import '../../favourite/controller/favourite_controller.dart';
import 'poi_state.dart';

final poiControllerProvider =
    NotifierProvider.autoDispose<POIController, POIState>(
  () => POIController(),
);

class POIController extends Notifier<POIState> {
  late final ListingsRepository _listingRepository;
  late final FavouriteController _favouriteController;
  Timer? _debounce;
  String _lastQuery = '';
  CancelToken? _cancelToken;
  Position? _currentLoc;

  @override
  POIState build() {
    _listingRepository = ref.read(listingRepositoryImplProvider);
    _favouriteController = ref.read(favouriteControllerProvider.notifier);
    ref.onDispose(() {
      _cancelToken?.cancel();
      _debounce?.cancel();
    });
    return const POIState();
  }

  /// Initialises the screen with a category and immediately loads page 1.
  void setCategory(CategoryModel category) {
    if (!ref.mounted) return;
    state = state.copyWith(
      categoryModel: category,
      baseCategoryId: category.id,
    );
    loadListings();
  }

  Future<void> loadListings({String? searchTerm}) async {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    if (state.status == StateEnum.loading) return;
    state = state.copyWith(status: StateEnum.loading);

    if (state.categoryModel == null) {
      state = state.copyWith(
        status: StateEnum.error,
        errorMessage: 'No category configured.',
      );
      return;
    }

    _currentLoc =
        ref.read(homeControllerProvider.notifier).getCurrentLocation();

    final request = _buildRequest(
      page: 1,
      searchTerm: searchTerm ?? _lastQuery,
    );

    final response = await _listingRepository.getListings(
      listingsRequestModel: request,
      cancelToken: _cancelToken,
    );

    if (!ref.mounted) return;

    response.fold(
      (error) => state = state.copyWith(
        status: StateEnum.error,
        errorMessage: error.toString(),
      ),
      (result) {
        if (result.data?.items != null) {
          final listings = _withDistances(result.data!.items);
          state = state.copyWith(
            status: StateEnum.success,
            listings: listings,
            hasReachedMax: result.data!.items.isEmpty,
            page: 2,
          );
        } else {
          state = state.copyWith(
            status: StateEnum.error,
            errorMessage: 'Failed to load listings.',
          );
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (state.hasReachedMax || state.status == StateEnum.loadingMore) return;
    state = state.copyWith(status: StateEnum.loadingMore);

    final request = _buildRequest(page: state.page, searchTerm: _lastQuery);

    final response = await _listingRepository.getListings(
      listingsRequestModel: request,
      cancelToken: _cancelToken,
    );

    if (!ref.mounted) return;

    response.fold(
      (error) => state = state.copyWith(
        status: StateEnum.error,
        errorMessage: error.toString(),
      ),
      (result) {
        if (result.statusCode == 200 && result.data?.items != null) {
          final newItems = _withDistances(result.data!.items);
          state = state.copyWith(
            status: StateEnum.success,
            listings: List.of(state.listings)..addAll(newItems),
            hasReachedMax: result.data!.items.isEmpty,
            page: state.page + 1,
          );
        } else {
          state = state.copyWith(status: StateEnum.success);
        }
      },
    );
  }

  void searchListings(String text) {
    if (text == _lastQuery) return;
    _lastQuery = text;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      loadListings(searchTerm: text);
    });
  }

  /// Called on pull-to-refresh; resets search term and reloads.
  Future<void> refresh() {
    _lastQuery = '';
    return loadListings(searchTerm: '');
  }

  void toggleFavourite(String id, bool isFav, int index) {
    if (index >= 0 && index < state.listings.length) {
      final updated = List.of(state.listings);
      updated[index] = updated[index].copyWith(isFavourite: isFav);
      state = state.copyWith(listings: updated);
    }
    if (state.selectedMarker?.id == id) {
      state = state.withSelectedMarker(
        state.selectedMarker!.copyWith(isFavourite: isFav),
      );
    }
    _favouriteController.updateFavoriteStatus(id, isFav);
  }

  void selectMarker(ListingModel marker) {
    state = state.withSelectedMarker(marker);
  }

  void clearSelectedMarker() {
    state = state.withSelectedMarker(null);
  }

  ListingRequestModel _buildRequest({
    required int page,
    required String searchTerm,
  }) {
    return ListingRequestModel(
      page: page,
      search: searchTerm.isNotEmpty ? searchTerm : null,
      categoryIds: [state.baseCategoryId ?? state.categoryModel!.id],
      sortBy: 'createdAt',
      sortDirection: 'desc',
      eventSort: true,
      // quickFilter: 'nearby', //remove nearby filter from poi
      userLat: _currentLoc?.latitude,
      userLng: _currentLoc?.longitude,
    );
  }

  List<ListingModel> _withDistances(List<ListingModel> items) {
    return items.map((listing) {
      if (_currentLoc != null &&
          listing.geoLat != null &&
          listing.geoLng != null) {
        final dist = Geolocator.distanceBetween(
          _currentLoc!.latitude,
          _currentLoc!.longitude,
          listing.geoLat!,
          listing.geoLng!,
        );
        return listing.copyWith(distance: dist);
      }
      return listing;
    }).toList();
  }
}
