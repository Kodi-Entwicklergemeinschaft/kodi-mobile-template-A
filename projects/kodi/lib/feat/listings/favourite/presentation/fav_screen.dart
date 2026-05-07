import 'package:common_components/common_components.dart';
import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/filter/controller/category_filter_controller.dart';
import 'package:kodi/feat/home/controller/home_screen_controller.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';

import '../../../../utils/config/image.dart';
import '../../../../utils/enums/StateEnum.dart';
import '../../../../utils/routing/routes.dart';
import '../../../base_UI/presentation/base_ui_screen.dart';
import '../../../listings/common_methods.dart';
import '../../data/model/category_model.dart';
import '../../data/model/listing_model.dart';
import '../../filter/filter_controller.dart';
import '../../filter/listing_filter_bottom_sheet.dart';
import '../controller/favourite_controller.dart';
import '../controller/favourite_state.dart';

class FavScreen extends ConsumerStatefulWidget {
  final String? categoryId;

  const FavScreen({super.key, this.categoryId});

  @override
  ConsumerState<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends ConsumerState<FavScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(listingsFiltersControllerProvider.notifier).resetDateRange();
      ref.read(categoryFilterControllerProvider.notifier).resetFilters();
      ref.read(favouriteControllerProvider.notifier).loadFavoritesList(categoryId: widget.categoryId);
    });
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      ref.read(favouriteControllerProvider.notifier).loadMore();
    }
  }

  /// Returns the Kodi Week Events category ID (itemId) when [widget.categoryId]
  /// matches the events sub-service, otherwise returns null.
  ///
  /// When navigating to KodiWeekEvents, `subServices[0].itemId` is used as the
  /// selectedSubCategoryId / baseCategoryId (see common_methods.dart). That same
  /// value is stored in [widget.categoryId] for the fav screen, so we match on
  /// `itemId` here — not `id`.
  String? _getKodiWeekEventsBaseCategoryId() {
    if (widget.categoryId == null) return null;
    final categories = ref.read(homeControllerProvider).category;
    for (final cat in categories ?? []) {
      if (cat.slug == CategorySlug.kodiWeek) {
        for (final sub in cat.subServices) {
          // Match either by itemId directly or by any child category ID
          if (sub.itemId == widget.categoryId ||
              (sub.children?.any((c) => c.id == widget.categoryId) ?? false)) {
            return sub.itemId ?? sub.id;
          }
        }
      }
    }
    return null;
  }

  /// Returns true when the current category supports date/time filtering.
  /// Only Events and Kodi Week categories show date filters.
  bool _shouldShowDateFilters() {
    final slug = ref.read(favouriteControllerProvider).eventCategory?.slug;
    return slug == CategorySlug.events ||
        slug == CategorySlug.kodiWeek ||
        slug == CategorySlug.kodiWeekEvents;
  }

  /// Returns true when category quick-filters should be loaded and shown in
  /// the filter sheet. Plain Events listings have no quick-filters; only
  /// Kodi Week Events and other categories with server-side filter groups do.
  bool _shouldShowCategoryFilters() {
    final slug = ref.read(favouriteControllerProvider).eventCategory?.slug;
    return slug != CategorySlug.events;
  }

  void _onSearchChanged() {
    ref
        .read(favouriteControllerProvider.notifier)
        .searchEvents(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(favouriteControllerProvider);
    final filterState = ref.watch(listingsFiltersControllerProvider);
    final categoryFilterState = ref.watch(categoryFilterControllerProvider);
    return BaseUI(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.iY),
          child: Column(
            spacing: 10.iY,
            children: [
              Row(
                children: [
                  if (context.canPop())
                    InkWell(
                      onTap: () => context.pop(),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.iX),
                        child: CommonIcon(
                          icon: Icons.arrow_back_ios,
                          label: 'common_icon_label'
                              .tr(context)
                              .replaceAll(
                                '{itemName}',
                                "back_button_label".tr(context),
                              ),
                          size: 30.iX,
                        ),
                      ),
                    ),
                  SizedBox(width: 10.iX),
                  Expanded(
                    child: SearchBarWidget(
                      controller: _searchController,
                      label: 'search'.tr(context),
                    ),
                  ),
                  SizedBox(width: 10.iX),
                  if (state.eventCategory?.slug != CategorySlug.administration)
                  InkWell(
                    onTap: () async {
                      final kodiWeekBaseCategoryId =
                          _getKodiWeekEventsBaseCategoryId();
                      // For Kodi Week use the resolved base category id;
                      // for all other categories pass widget.categoryId so
                      // their quick-filters are also loaded in the sheet.
                      // For plain Events, pass null so no category filters
                      // are loaded or shown.
                      final effectiveCategoryId =
                          kodiWeekBaseCategoryId ?? widget.categoryId;
                      final sheetCategoryId = _shouldShowCategoryFilters()
                          ? effectiveCategoryId
                          : null;
                      final result = await showDateRangeFilterBottomSheet(
                        context: context,
                        id: ref.read(favouriteControllerProvider.notifier).id,
                        categoryId: sheetCategoryId,
                        showDateFilters: _shouldShowDateFilters(),
                      );
                      if (kDebugMode) {
                        print(result);
                      }
                      if (result != null) {
                        final latestFilterIds = sheetCategoryId != null
                            ? ref
                                .read(categoryFilterControllerProvider)
                                .selectedFilterIds
                            : null;
                        ref
                            .read(favouriteControllerProvider.notifier)
                            .loadFavoritesList(
                              searchTerm: _searchController.text,
                              groupFilterIds:
                                  latestFilterIds?.isNotEmpty == true
                                      ? latestFilterIds
                                      : null,
                            );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.iY),
                      decoration: BoxDecoration(
                        color: (filterState.startDate != null ||
                                filterState.endDate != null ||
                                (categoryFilterState.selectedFilterIds
                                        ?.isNotEmpty ??
                                    false))
                            ? state.eventCategory?.headerBackgroundColor
                                    ?.hexToColor ??
                                AppColors.pink
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(40.iY),
                      ),
                      child: CommonImage(
                        imagePath: Images.filterIcon,
                        label: "Filter Icon Tap",
                        width: 50.iX,
                        height: 50.iY,
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(child: _buildBody(state)),
            ],
          ),
        ),
      ),
    );
  }

  bool _isAdminListing(ListingModel listing) {
    return listing.categories
            ?.any((c) => c.slug == CategorySlug.administration.slug) ??
        false;
  }

  Widget _buildBody(FavouriteState state) {
    if (state.status == StateEnum.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.listOfFav.isEmpty) {
      return Center(child: CommonText(titleText: 'no_fav_listing'.tr(context)));
    }

    return RefreshIndicator(
      onRefresh: () {
        _searchController.clear();
        ref.read(listingsFiltersControllerProvider.notifier).resetDateRange();
        ref.read(categoryFilterControllerProvider.notifier).resetFilters();
        return ref
            .read(favouriteControllerProvider.notifier)
            .loadFavoritesList(searchTerm: "");
      },
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        controller: _scrollController,
        slivers: [
          SliverList.builder(
            itemCount: state.hasReachedMax
                ? state.listOfFav.length
                : state.listOfFav.length + 1,
            itemBuilder: (_, index) {
              if (index >= state.listOfFav.length) {
                return state.status == StateEnum.loadingMore
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              }
              final listing = state.listOfFav[index];
              final isAdmin = _isAdminListing(listing);
              final isKodiWeek = state.eventCategory?.slug == CategorySlug.kodiWeek ||
                  state.eventCategory?.slug == CategorySlug.kodiWeekEvents;
              return ListingCard(
                searchedString: _searchController.text,
                imageLabel: "listing_image_label".tr(context),
                headerColor: state.eventCategory?.headerBackgroundColor?.hexToColor,
                imageUrl: listing.heroImageUrl,
                address: listing.address,
                isKodiWeekCard: isKodiWeek,
                hours: listing.eventStart,
                todayOpeningStatus: isKodiWeek
                    ? listing.eventStart.isNotNullAndEmpty
                        ? ListingsMethods.getDateRangeUI(
                            listing.eventStart,
                            listing.eventEnd,
                          )
                        : null
                    : listing.timeIntervals!.isNotEmpty
                        ? ListingsMethods.getTodayOpeningHours(
                            context,
                            listing.timeIntervals!,
                          )
                        : null,
                name: listing.title,
                hideImage: isAdmin,
                nameMaxLine: isAdmin ? 2 : null,
                onTap: () {
                  context.go(
                    '${ScreenPaths.account}/${ScreenPaths.favouriteScreen}/${ScreenPaths.listingDetails}',
                    extra: [
                      listing,
                      state.eventCategory?.headerBackgroundColor.hexToColor,
                      false,
                      _searchController.text,
                      isKodiWeek, // isKodiWeekListing
                      isAdmin, // hideImage
                    ],
                  );
                },
                isFavourite: listing.isFavorite,
                distance: listing.distance != null
                      ? "${listing.distance!.floor()/1000} km"
                      : null,
                onTapFavourite: () {
                  ref
                      .read(favouriteControllerProvider.notifier)
                      .toggleFavourite(
                        listing.id!,
                        !(listing.isFavorite ?? false),
                        index,
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
