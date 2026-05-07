import 'package:common_components/common_components.dart';
import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/auth/login/controller/login_controller.dart';
import 'package:kodi/feat/listings/common_methods.dart';
import 'package:kodi/feat/listings/data/model/listing_model.dart';
import 'package:kodi/feat/listings/poi/controller/poi_controller.dart';
import 'package:kodi/feat/listings/poi/controller/poi_state.dart';
import 'package:kodi/utils/app_pref_keys.dart';
import 'package:kodi/utils/common_methods.dart';
import 'package:kodi/utils/enums/StateEnum.dart';
import 'package:kodi/utils/routing/routes.dart';
import 'package:locale/app_localization.dart';
import 'package:local_storage/preference_manager_impl.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';

class POIBottomSheet extends ConsumerStatefulWidget {
  const POIBottomSheet({
    super.key,
    required this.scrollController,
    required this.sheetController,
    this.themeColor,
  });

  final ScrollController scrollController;
  final DraggableScrollableController sheetController;
  final Color? themeColor;

  @override
  ConsumerState<POIBottomSheet> createState() => _POIBottomSheetState();
}

class _POIBottomSheetState extends ConsumerState<POIBottomSheet> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onSearchChanged() {
    ref
        .read(poiControllerProvider.notifier)
        .searchListings(_searchController.text);
  }

  static const List<double> _snapSizes = [0.40, 0.85];
  static const double _minSize = 0.40;
  static const double _maxSize = 0.85;

  void _onHeaderDragUpdate(DragUpdateDetails details) {
    if (!widget.sheetController.isAttached) return;
    final screenHeight = MediaQuery.of(context).size.height;
    // Dragging up (negative primaryDelta) should expand the sheet.
    final newSize = (widget.sheetController.size -
            details.primaryDelta! / screenHeight)
        .clamp(_minSize, _maxSize);
    widget.sheetController.jumpTo(newSize);
  }

  void _onHeaderDragEnd(DragEndDetails details) {
    if (!widget.sheetController.isAttached) return;
    final velocity = details.primaryVelocity ?? 0;
    final current = widget.sheetController.size;

    double target;
    if (velocity < -500) {
      // Fast upward fling → nearest larger snap.
      target = _snapSizes.lastWhere((s) => s > current,
          orElse: () => _snapSizes.last);
    } else if (velocity > 500) {
      // Fast downward fling → nearest smaller snap.
      target = _snapSizes.firstWhere((s) => s < current,
          orElse: () => _snapSizes.first);
    } else {
      // Slow drag → snap to closest.
      target = _snapSizes.reduce((a, b) =>
          (a - current).abs() < (b - current).abs() ? a : b);
    }

    widget.sheetController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onScroll() {
    if (widget.scrollController.hasClients &&
        widget.scrollController.position.atEdge &&
        widget.scrollController.position.pixels != 0) {
      ref.read(poiControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(poiControllerProvider);
    final isMarkerSelected = state.selectedMarker != null;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: _onHeaderDragUpdate,
            onVerticalDragEnd: _onHeaderDragEnd,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DragHandle(),
                if (isMarkerSelected)
                  _SingleMarkerHeader(
                    onBack: () {
                      ref
                          .read(poiControllerProvider.notifier)
                          .clearSelectedMarker();
                    },
                  )
                else
                  _AllListingsHeader(
                    searchController: _searchController,
                    themeColor: widget.themeColor,
                  ),
              ],
            ),
          ),
          Expanded(
            child: isMarkerSelected
                ? _buildSingleMarker(context, state)
                : _buildListingList(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleMarker(BuildContext context, POIState state) {
    final listing = state.selectedMarker!;
    final isGuestUser = ref
        .watch(preferenceManagerProvider)
        .getBool(AppPrefsKeys.isGuestUser);
    final index = state.listings.indexWhere((l) => l.id == listing.id);
    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.iX, vertical: 8.iY),
      child: ListingCard(
        imageLabel: 'listing_image_label'.tr(context),
        headerColor: widget.themeColor,
        imageUrl: listing.heroImageUrl,
        address: listing.address,
        hours: listing.eventStart,
        distance: listing.distance != null
            ? '${(listing.distance! / 1000).toStringAsFixed(1)} km'
            : null,
        todayOpeningStatus: listing.eventStart.isNotNullAndEmpty
            ? ListingsMethods.getDateRangeUI(
          listing.eventStart,
          listing.eventEnd,
        )
            : null,
        name: listing.title,
        isFavourite: listing.isFavorite ?? false,
        onTap: () => _navigateToDetails(context, state, listing),
        onTapFavourite: !isGuestUser
            ? () {
                ref.read(poiControllerProvider.notifier).toggleFavourite(
                  listing.id!,
                  !(listing.isFavorite ?? false),
                  index,
                );
              }
            : () {
                CommonMethods.showInfoDialog(
                  context,
                  'login_to_enable_feature'.tr(context),
                  onTapText: 'register'.tr(context),
                  onTap: () {
                    ref.read(loginProvider.notifier).logout();
                  },
                  onCancel: () {},
                );
              },
        isKodiWeekCard: true,
      ),
    );
  }

  Widget _buildListingList(BuildContext context, POIState state) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isGuestUser = ref
        .watch(preferenceManagerProvider)
        .getBool(AppPrefsKeys.isGuestUser);

    if (state.status == StateEnum.loading) {
      return Center(
        child: CircularProgressIndicator(
            color: isDarkMode ? null : widget.themeColor
        ),
      );
    }

    if (state.listings.isEmpty) {
      return Center(
        child: CommonText(titleText: 'no_listings'.tr(context)),
      );
    }

    return RefreshIndicator(
      color: widget.themeColor,
      onRefresh: () {
        _searchController.clear();
        return ref.read(poiControllerProvider.notifier).refresh();
      },
      child: CustomScrollView(
        controller: widget.scrollController,
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.iX),
            sliver: SliverList.builder(
              itemCount: state.hasReachedMax
                  ? state.listings.length
                  : state.listings.length + 1,
              itemBuilder: (_, index) {
                if (index >= state.listings.length) {
                  return state.status == StateEnum.loadingMore
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(12.iY),
                            child: CircularProgressIndicator(
                                color: widget.themeColor),
                          ),
                        )
                      : const SizedBox.shrink();
                }
                final listing = state.listings[index];
                return ListingCard(
                  imageLabel: 'listing_image_label'.tr(context),
                  headerColor: widget.themeColor,
                  imageUrl: listing.heroImageUrl,
                  address: listing.address,
                  hours: listing.eventStart,
                  distance: listing.distance != null
                      ? '${(listing.distance! / 1000).toStringAsFixed(1)} km'
                      : null,
                  todayOpeningStatus: listing.eventStart.isNotNullAndEmpty
                      ? ListingsMethods.getDateRangeUI(
                    listing.eventStart,
                    listing.eventEnd,
                  ) : null,
                  name: listing.title,
                  isFavourite: listing.isFavorite ?? false,
                  onTap: () => _navigateToDetails(context, state, listing),
                  onTapFavourite: !isGuestUser
                      ? () {
                          ref
                              .read(poiControllerProvider.notifier)
                              .toggleFavourite(
                            listing.id!,
                            !(listing.isFavorite ?? false),
                            index,
                          );
                        }
                      : () {
                          CommonMethods.showInfoDialog(
                            context,
                            'login_to_enable_feature'.tr(context),
                            onTapText: 'register'.tr(context),
                            onTap: () {
                              ref.read(loginProvider.notifier).logout();
                            },
                            onCancel: () {},
                          );
                        },
                  isKodiWeekCard: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(
      BuildContext context, POIState state, ListingModel listing) {
    // Absolute path required inside a StatefulShellRoute — relative segments
    // cause the navigator-key assertion to fail in GoRouter v16.
    final matchedLocation = GoRouterState.of(context).matchedLocation;
    context.push(
      '$matchedLocation/${ScreenPaths.listingDetails}',
      extra: [
        listing,
        widget.themeColor,
        false,
        _searchController.text,
        true,
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.iY),
      child: Center(
        child: Container(
          width: 40.iX,
          height: 4.iY,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _AllListingsHeader extends StatelessWidget {
  const _AllListingsHeader({
    required this.searchController,
    this.themeColor,
  });

  final TextEditingController searchController;
  final Color? themeColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.iX),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10.iY,),
          CommonText(
            titleText: 'poi_find_near_you'.tr(context),
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              fontSize: 18.iY,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20.iY),
          SearchBarWidget(
            controller: searchController,
            label: 'search'.tr(context),
          ),
          SizedBox(height: 12.iY),
        ],
      ),
    );
  }
}

class _SingleMarkerHeader extends StatelessWidget {
  const _SingleMarkerHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.iX, vertical: 8.iY),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: EdgeInsets.all(4.iY),
              child: CommonIcon(
                icon: Icons.arrow_back_ios,
                size: 24.iX,
                label: 'back_button_label'.tr(context),
              ),
            ),
          ),
          SizedBox(width: 8.iX),
          CommonText(
            titleText: 'poi_selected_location'.tr(context),
            textStyle: TextStyle(
              fontSize: 16.iY,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
