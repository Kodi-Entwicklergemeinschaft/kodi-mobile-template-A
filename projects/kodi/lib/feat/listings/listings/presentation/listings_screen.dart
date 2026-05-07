import 'package:common_components/common_components.dart';
import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/feat/filter/controller/category_filter_controller.dart';
import 'package:kodi/feat/listings/categories/categories_controller.dart';
import 'package:kodi/feat/listings/filter/filter_controller.dart';
import 'package:local_storage/preference_manager_impl.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';

import '../../../../utils/app_pref_keys.dart';
import '../../../../utils/common_methods.dart';
import '../../../../utils/config/image.dart';
import '../../../../utils/enums/StateEnum.dart';
import '../../../../utils/routing/routes.dart';
import '../../../auth/login/controller/login_controller.dart';
import '../../../filter/controller/category_filter_state.dart';
import '../../../filter/presentation/category_filter_bottom_sheet.dart';
import '../../../home/controller/home_screen_controller.dart';
import '../../../home/presentation/widget/common_image_text_card.dart';
import '../../common_methods.dart';
import '../../data/model/category_model.dart';
import '../controller/listings_controller.dart';
import '../controller/listings_state.dart';
import '../../filter/listing_filter_bottom_sheet.dart';

class ListingsScreen extends ConsumerStatefulWidget {
  final String categorySlug;
  final String? selectedSubCategoryId;

  const ListingsScreen({
    super.key,
    required this.categorySlug,
    this.selectedSubCategoryId,
  });

  @override
  ConsumerState<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends ConsumerState<ListingsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(listingsFiltersControllerProvider.notifier).resetDateRange();
      ref.read(categoryFilterControllerProvider.notifier).resetFilters();
      setCategories();
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

  void setCategories() {
    final categoryList = ref.read(homeControllerProvider).category;

    // kodier-woche-events is not a top-level category; it lives as a
    // subService of kodier-woche, so look up the parent slug instead.
    final slugToSearch = widget.categorySlug == CategorySlug.kodiWeekEvents.slug
        ? CategorySlug.kodiWeek.slug
        : widget.categorySlug;

    int? index = categoryList?.indexWhere(
      (e) => e.slugString == slugToSearch,
    );
    if (index != null && index != -1) {
      CategoryModel? category = categoryList?[index];

      // For kodiWeekEvents the parent has no children of its own; the
      // sub-categories that should appear as filter chips live in
      // subServices[0].children — inject them so the chip row renders.
      if (widget.categorySlug == CategorySlug.kodiWeekEvents.slug &&
          category != null &&
          category.subServices.isNotEmpty) {
        category = category.copyWith(
          children: category.subServices[0].children ?? [],
        );
      }

      ref
          .read(listingsControllerProvider.notifier)
          .updateCategory(category, widget.selectedSubCategoryId,
              isKodiWeekEvents: widget.categorySlug == CategorySlug.kodiWeekEvents.slug);
    }
  }

  void _onScroll() {
    final categoryFilterState  = ref.read(categoryFilterControllerProvider);
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      ref.read(listingsControllerProvider.notifier).loadMore(
          categoryFilterState.selectedFilterIds != null &&
              categoryFilterState.selectedFilterIds!.isNotEmpty
              ? categoryFilterState.selectedFilterIds
              : null);
    }
  }

  void _onSearchChanged() {
    final categoryFilterState  = ref.read(categoryFilterControllerProvider);
    ref
        .read(listingsControllerProvider.notifier)
        .searchListings(
        _searchController.text, categoryFilterState.selectedFilterIds != null &&
        categoryFilterState.selectedFilterIds!.isNotEmpty
        ? categoryFilterState.selectedFilterIds
        : null);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(listingsControllerProvider);
    final categoryFilterState  = ref.watch(categoryFilterControllerProvider);

    final filterState = ref.watch(
      listingsFiltersControllerProvider
    );
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.pop();
        }
      },
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BaseUI(
          body: SafeArea(
            child: AbsorbPointer(
              absorbing: state.status == StateEnum.loading,
              child: Padding(
                padding: EdgeInsets.all(5.iY),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20.iY,
                  children: [
                    Row(
                      spacing: 10.iX,
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
                        Expanded(
                          child: SearchBarWidget(
                            controller: _searchController,
                            label: "search".tr(context),
                          ),
                        ),
                        if(widget.categorySlug!=CategorySlug.administration.slug)
                          InkWell(
                          onTap: () async {
                            if (state.isKodiWeekEvents) {
                              // Combined date + category filter sheet for
                              // KodiWeekEvents. baseCategoryId is the actual
                              // events sub-service ID used to fetch filters.
                              final result = await showDateRangeFilterBottomSheet(
                                context: context,
                                id: widget.categorySlug,
                                categoryId: state.baseCategoryId,
                              );
                              if (result != null) {
                                // Read fresh state — the captured
                                // categoryFilterState is stale at this point
                                // because applyFilters/resetFilters ran inside
                                // the sheet before popping.
                                final latestFilterIds = ref
                                    .read(categoryFilterControllerProvider)
                                    .selectedFilterIds;
                                ref
                                    .read(listingsControllerProvider.notifier)
                                    .loadListings(
                                  searchTerm: _searchController.text,
                                  groupFilterIds: latestFilterIds?.isNotEmpty == true
                                      ? latestFilterIds
                                      : null,
                                );
                              }
                            } else if (state.categoryModel != null) {
                              // Standard category filter for all other screens.
                              final String? filterId = ref
                                  .read(categoriesControllerProvider.notifier)
                                  .getCategorySlugByEnum(state.categoryModel!.slug)
                                  ?.id;

                              if (filterId == null) return;

                              final result = await showCategoryFilterBottomSheet(
                                context: context,
                                categoryId: filterId,
                              );

                              debugPrint("$result");
                              if (result != null) {
                                ref
                                    .read(listingsControllerProvider.notifier)
                                    .loadListings(groupFilterIds: result);
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(2.iY),
                            decoration: BoxDecoration(
                              color: state.isKodiWeekEvents
                                  // Active when date OR category filters are set.
                                  ? (filterState.startDate != null ||
                                          filterState.endDate != null ||
                                          (categoryFilterState.selectedFilterIds?.isNotEmpty ?? false))
                                      ? state.categoryModel?.headerBackgroundColor?.hexToColor ?? AppColors.pink
                                      : Colors.transparent
                                  : (categoryFilterState.selectedFilterIds != null &&
                                          categoryFilterState.selectedFilterIds!.isNotEmpty)
                                      ? state.categoryModel?.headerBackgroundColor?.hexToColor ?? AppColors.pink
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

                    if (state.categoryModel?.children != null &&
                        state.categoryModel!.children.isNotEmpty)
                      subCategories(state, categoryFilterState),
                    Flexible(child: _buildBody(state)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ListingsState state) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isGuestUser = ref
        .watch(preferenceManagerProvider)
        .getBool(AppPrefsKeys.isGuestUser);
    if (state.status == StateEnum.loading) {
      return Center(
        child: CircularProgressIndicator(
          color: (isDarkMode && state.isKodiWeekEvents) ? null : state.categoryModel
              ?.headerBackgroundColor.hexToColor,
        ),
      );
    }

    if (state.listings.isEmpty) {
      return Center(child: CommonText(titleText: 'no_listings'.tr(context)));
    }

    return RefreshIndicator(
      onRefresh: () {
        _searchController.clear();
        ref
            .read(
              listingsFiltersControllerProvider.notifier,
            )
            .resetDateRange();
        final categoryFilterState  = ref.read(categoryFilterControllerProvider);
        return ref
            .read(listingsControllerProvider.notifier)
            .loadListings(searchTerm: "",
            groupFilterIds: categoryFilterState.selectedFilterIds != null &&
                categoryFilterState.selectedFilterIds!.isNotEmpty
                ? categoryFilterState.selectedFilterIds
                : null);
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
                    ? Center(
                        child: CircularProgressIndicator(
                          color: state
                              .categoryModel
                              ?.headerBackgroundColor
                              .hexToColor,
                        ),
                      )
                    : const SizedBox.shrink();
              }
              final listing = state.listings[index];
              return ListingCard(
                searchedString: _searchController.text,
                imageLabel: "listing_image_label".tr(context),
                headerColor:
                    state.categoryModel?.headerBackgroundColor?.hexToColor,
                imageUrl: listing.heroImageUrl,
                address: listing.address,
                hours: listing.eventStart,
                distance: listing.distance != null
                    ? "${listing.distance!.floor()/1000} km"
                    : null,
                todayOpeningStatus: widget.categorySlug ==
                    CategorySlug.kodiWeekEvents.slug ? listing.eventStart
                    .isNotNullAndEmpty
                    ? ListingsMethods.getDateRangeUI(
                  listing.eventStart,
                  listing.eventEnd,
                )
                    : null : listing.timeIntervals!.isNotEmpty
                    ? ListingsMethods.getTodayOpeningHours(
                  context,
                  listing.timeIntervals!,
                )
                    : null,
                name: listing.title,
                hideImage: widget.categorySlug == CategorySlug.administration.slug,
                onTap: () {
                  if(widget.categorySlug == CategorySlug.kodiWeekEvents.slug) {
                    context.push(
                      '${ScreenPaths.discover}/${ScreenPaths.kodiWeekScreen}/${ScreenPaths.listingDetails}',
                      extra: [
                        listing,
                        state.categoryModel?.headerBackgroundColor?.hexToColor,
                        state.categoryModel?.slug == CategorySlug.shopping,
                        _searchController.text,
                        true,
                        false,
                      ],
                    );
                  } else {
                    context.push(
                      '${ScreenPaths.discover}/${ScreenPaths.listingDetails}',
                      extra: [
                        listing,
                        state.categoryModel?.headerBackgroundColor?.hexToColor,
                        state.categoryModel?.slug == CategorySlug.shopping,
                        _searchController.text,
                        widget.categorySlug == CategorySlug.kodiWeekEvents.slug,
                        widget.categorySlug == CategorySlug.administration.slug,
                      ],
                    );
                  }
                },
                isFavourite: listing.isFavorite??false,
                nameMaxLine: (widget.categorySlug ==
                    CategorySlug.administration.slug) ? 2 : null,
                onTapFavourite: !isGuestUser
                    ? () {
                        ref
                            .read(listingsControllerProvider.notifier)
                            .toggleFavourite(
                              listing.id!,
                              !(listing.isFavorite ?? false),
                              index,
                            );
                      }
                    : (){
                  CommonMethods.showInfoDialog(
                      context,
                      "login_to_enable_feature".tr(context),
                      onTapText: "register".tr(context),
                      onTap: (){
                        ref.read(loginProvider.notifier).logout();
                      },
                      onCancel: (){}
                  );
                } ,
                isKodiWeekCard: state.isKodiWeekEvents,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget subCategories(ListingsState state, CategoryFilterState categoryFilterState) {
    final serviceList = state.categoryModel?.children;
    return SizedBox(
      height: 160.iY,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: serviceList?.length ?? 0,
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () {
              ref
                  .read(listingsControllerProvider.notifier)
                  .updateSubCategoryId(subCategory: serviceList?[index], groupFilterIds: categoryFilterState.selectedFilterIds != null &&
                  categoryFilterState.selectedFilterIds!.isNotEmpty
                  ? categoryFilterState.selectedFilterIds
                  : null);
            },
            child: CommonImageTextCard(
              title: serviceList?[index].name ?? "",
              imageUrl: serviceList?[index].imageUrl ??
                  (state.isKodiWeekEvents
                      ? (state.categoryModel?.subServices ?? []).length > 1
                          ? state.categoryModel!.subServices[0].imageUrl
                          : null
                      : state.categoryModel?.imageUrl) ??
                  "",
              titleColour:
                  state.categoryModel?.headerBackgroundColor?.hexToColor ??
                  AppColors.pink,
              isSelected: state.selectedSubCategoryId == serviceList?[index].id,
            ),
          );
        },
      ),
    );
  }
}
