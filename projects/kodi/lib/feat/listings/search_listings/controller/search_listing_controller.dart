import 'package:kodi/feat/listings/search_listings/controller/search_listing_state.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../../utils/enums/StateEnum.dart';
import '../../data/model/listing_request_model.dart';
import '../../data/repo/listings_repository.dart';

final searchListingControllerProvider =
    NotifierProvider.autoDispose<SearchListingController, SearchListingsState>(
      () => SearchListingController(),
    );

class SearchListingController extends Notifier<SearchListingsState> {
  late final ListingsRepository listingRepository;

  @override
  SearchListingsState build() {
    listingRepository = ref.read(listingRepositoryImplProvider);
    return SearchListingsState();
  }

  Future<void> loadListings(String searchTerm) async {
    if (state.status == StateEnum.loading) return; // Prevent concurrent loads
    state = state.copyWith(status: StateEnum.loading);

    final request = ListingRequestModel(page: 1, search: searchTerm);

    final response = await listingRepository.getListings(listingsRequestModel: request);
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
            return listing;
          }).toList();
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

  Future<void> loadMore(String searchTerm) async {
    if (state.hasReachedMax || state.status == StateEnum.loadingMore) return;

    state = state.copyWith(status: StateEnum.loadingMore);

    final request = ListingRequestModel(page: state.page, search: searchTerm);
    final response = await listingRepository.getListings(listingsRequestModel: request);
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
            return listing;
          }).toList();
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
}
