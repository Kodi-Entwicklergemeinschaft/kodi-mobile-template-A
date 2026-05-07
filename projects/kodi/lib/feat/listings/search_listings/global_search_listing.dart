import 'package:common_components/common_components.dart';
import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/feat/listings/search_listings/controller/search_listing_state.dart';
import 'package:kodi/utils/enums/StateEnum.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:locale/app_localization.dart';

import '../../../utils/app_bar.dart';
import '../../../utils/routing/routes.dart';
import '../common_methods.dart';
import 'controller/search_listing_controller.dart';

class GlobalSearchListing extends ConsumerStatefulWidget {
  final String searchTerm;
  const GlobalSearchListing({super.key, required this.searchTerm});

  @override
  ConsumerState<GlobalSearchListing> createState() =>
      _GlobalSearchListingState();
}

class _GlobalSearchListingState extends ConsumerState<GlobalSearchListing> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(searchListingControllerProvider.notifier)
          .loadListings(widget.searchTerm);
    });
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      ref
          .read(searchListingControllerProvider.notifier)
          .loadMore(widget.searchTerm);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchListingControllerProvider);
    return BaseUI(
      appBar:  CommonAppBar(
        showBackButton: true,
        showTitleLogo: false,
        title:  CommonText(titleText: 'search'.tr(context),),
        toolbarHeight: 70.iY,
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(SearchListingsState state) {
    if (state.status == StateEnum.loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (state.listings.isEmpty) {
      return Center(child: CommonText(titleText: 'no_listings'.tr(context)));
    }

    return RefreshIndicator(
      onRefresh: () {
        return ref.read(searchListingControllerProvider.notifier).loadListings(widget.searchTerm);
      },
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        controller: _scrollController,
        slivers: [
          SliverList.builder(
            itemCount: state.hasReachedMax
                ? state.listings.length
                : state.listings.length + 1,
            itemBuilder: (_, index) {
              if (index >= state.listings.length) {
                return state.status == StateEnum.loadingMore
                    ? Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }
              final listing = state.listings[index];
              return ListingCard(
                searchedString: widget.searchTerm,
                imageLabel: "listing_image_label".tr(context),
                headerColor: listing.headerBackgroundColor?.hexToColor,
                imageUrl: listing.heroImageUrl,
                address: listing.address,
                hours: listing.eventStart,
                distance: listing.distance != null
                    ? "${listing.distance!.floor()/1000} km"
                    : null,
                todayOpeningStatus: listing.timeIntervals!.isNotEmpty
                    ? ListingsMethods.getTodayOpeningHours(
                        context,
                        listing.timeIntervals!,
                      )
                    : null,
                name: listing.title,
                onTap: () {
                  context.push(
                    '${ScreenPaths.discover}/${ScreenPaths.listingDetails}',
                    extra: [
                      listing,
                      listing.headerBackgroundColor?.hexToColor,
                      false,
                      widget.searchTerm,
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
