import 'package:common_components/common_components.dart';
import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/feat/listings/filter/listing_filter_bottom_sheet.dart';
import 'package:kodi/utils/routing/routes.dart';
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
import '../../../auth/login/controller/login_controller.dart';
import '../../../home/presentation/widget/common_image_text_card.dart';
import '../../common_methods.dart';
import '../../filter/filter_controller.dart';
import '../controller/event_controller.dart';
import '../controller/event_state.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventControllerProvider.notifier).loadEvents();
    });
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
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
      ref.read(eventControllerProvider.notifier).loadMoreEvents();
    }
  }

  void _onSearchChanged() {
    ref
        .read(eventControllerProvider.notifier)
        .searchEvents(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventControllerProvider);
    final filterState = ref.watch(
      listingsFiltersControllerProvider
    );

    return PopScope(
      canPop: false, // prevent system pop
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          // Switch to Home branch
          StatefulNavigationShell.of(
            context,
          ).goBranch(0, initialLocation: false);
        }
      },
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
                      InkWell(
                        onTap: () async {
                          final result = await showDateRangeFilterBottomSheet(
                            context: context,
                            id: ref.read(eventControllerProvider.notifier).id,
                          );

                          if (result != null) {
                            ref
                                .read(eventControllerProvider.notifier)
                                .loadEvents(searchTerm: _searchController.text);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(2.iY),
                          decoration: BoxDecoration(
                            color:
                            filterState.startDate != null ||
                                filterState.endDate != null
                                ? state
                                .categoryModel
                                ?.headerBackgroundColor
                                ?.hexToColor ??
                                AppColors.pink
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(40.iY),
                          ),
                          child: CommonImage(
                            imagePath: Images.filterIcon,
                            label: 'common_icon_label'
                                .tr(context)
                                .replaceAll(
                                  '{itemName}',
                                  "filter_icon_label".tr(context),
                                ),
                            width: 50.iX,
                            height: 50.iY,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (state.categoryModel != null) subCategories(state),
                  Flexible(child: _buildBody(state)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(EventState state) {
    final isGuestUser = ref
        .watch(preferenceManagerProvider)
        .getBool(AppPrefsKeys.isGuestUser);

    if (state.status == StateEnum.loading) {
      return Center(
        child: CircularProgressIndicator(
          color: state.categoryModel?.headerBackgroundColor.hexToColor,
        ),
      );
    }

    if (state.events.isEmpty) {
      return Center(
        child: CommonText(titleText: 'no_ongoing_events'.tr(context)),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        _searchController.clear();
        ref
            .read(
              listingsFiltersControllerProvider.notifier,
            )
            .resetDateRange();
        return ref
            .read(eventControllerProvider.notifier)
            .loadEvents(searchTerm: "");
      },
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        controller: _scrollController,
        slivers: [
          SliverList.builder(
            itemCount: state.hasReachedMax
                ? state.events.length
                : state.events.length + 1,
            itemBuilder: (_, index) {
              if (index >= state.events.length) {
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
              final listing = state.events[index];
              return ListingCard(
                searchedString: _searchController.text,
                imageLabel: "listing_image_label".tr(context),
                headerColor:
                    state.categoryModel?.headerBackgroundColor.hexToColor,
                imageUrl: listing.heroImageUrl,
                address: listing.address,
                distance: listing.distance != null
                    ? "${(listing.distance!/1000).toStringAsFixed(2)} km"
                    : null,
                // hours: listing.eventStart,
                todayOpeningStatus: listing.eventStart.isNotNullAndEmpty
                    ? ListingsMethods.getDateRangeUI(
                        listing.eventStart,
                        listing.eventEnd,
                      )
                    : null,
                name: listing.title,
                onTap: () {
                  context.go(
                    '${ScreenPaths.events}/${ScreenPaths.listingDetails}',
                    extra: [
                      listing,
                      state.categoryModel?.headerBackgroundColor.hexToColor,
                      false,
                      _searchController.text,
                    ],
                  );
                },
                isFavourite: listing.isFavorite ?? false ,
                onTapFavourite: !isGuestUser
                    ? () {
                        ref
                            .read(eventControllerProvider.notifier)
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
              );
            },
          ),
        ],
      ),
    );
  }

  Widget subCategories(EventState state) {
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
                  .read(eventControllerProvider.notifier)
                  .updateSubCategoryId(subCategory: serviceList?[index]);
            },
            child: CommonImageTextCard(
              title: serviceList?[index].name ?? "",
              imageUrl:
                  serviceList?[index].imageUrl ??
                  state.categoryModel?.imageUrl ??
                  "",
              titleColour:
                  state.categoryModel?.headerBackgroundColor?.hexToColor ??
                  AppColors.shoppingTitleBackground,
              isSelected: state.selectedSubCategoryId == serviceList?[index].id,
            ),
          );
        },
      ),
    );
  }
}
