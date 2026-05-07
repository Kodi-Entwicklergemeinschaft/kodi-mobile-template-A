import 'package:common_components/common_components.dart';
import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/auth/login/controller/login_state.dart';
import 'package:kodi/feat/home/controller/home_screen_controller.dart';
import 'package:kodi/feat/home/controller/home_state.dart';
import 'package:kodi/feat/home/presentation/widget/category_activity_crousel.dart';
import 'package:kodi/feat/home/presentation/widget/common_image_text_card.dart';
import 'package:kodi/feat/home/presentation/widget/event_card.dart';
import 'package:kodi/feat/home/presentation/widget/gift_voucher_crousel.dart';
import 'package:kodi/feat/home/presentation/widget/mobility_carousel.dart';
import 'package:kodi/feat/listings/common_methods.dart';
import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:kodi/feat/listings/data/model/listing_model.dart';
import 'package:kodi/utils/common_methods.dart';
import 'package:local_storage/local_storage.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/extension/app_text_colors.dart';
import 'package:theme/theme.dart';

import '../../../utils/app_pref_keys.dart';
import '../../../utils/config/image.dart';
import '../../../utils/enums/StateEnum.dart';
import '../../../utils/routing/routes.dart';
import '../../auth/login/controller/login_controller.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../listings/events/controller/event_controller.dart';
import '../../listings/events/controller/event_state.dart';

class HomeContentSection extends ConsumerStatefulWidget {
  const HomeContentSection({super.key});

  @override
  ConsumerState<HomeContentSection> createState() => _HomeContentSectionState();
}

class _HomeContentSectionState extends ConsumerState<HomeContentSection> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      ref.read(eventControllerProvider.notifier).loadMoreEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    if (state.isLoading ?? false) {
      return const _LoadingState();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30.iY,
        children: [
          const CategoryActivityCarousel(),
          ongoingEvents(),
          // importantServices(state),
          if (!ref
              .read(preferenceManagerProvider)
              .getBool(AppPrefsKeys.isGuestUser))
          administrationServices(state),
          shoppingServices(state),
          foodAndDrinkServices(state),
          buildMapView(context),
          // const MobilityCarousel(),
          const GiftVoucherCarousel()
        ],
      ),
    );
  }

  Column buildMapView(BuildContext context) {
    return Column(
      spacing: 15.iY,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.iX, vertical: 4.iY),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(6.iX),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonImage(
                imagePath: Images.carIcon,
                height: 20.iY,
                width: 20.iY,
                fit: BoxFit.cover,
                label: ('map_icon_logo').tr(context),
              ),
              SizedBox(width: 4.iX),
              CommonText(
                titleText: "kodi_mobil".tr(context),
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18.iY,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: (){
            context.go(
              '${ScreenPaths.home}/${ScreenPaths.mobilityScreen}',
              extra: [],
            );
          },
          child: CommonImage(
            imagePath: Images.kodiMap,
            width: double.infinity,
            height: 400.iY,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget ongoingEvents() {
    final isGuestUser = ref
        .watch(preferenceManagerProvider)
        .getBool(AppPrefsKeys.isGuestUser);
    final state = ref.watch(eventControllerProvider);
    final events =
        state.recentEvents; // Use a local variable for clarity and safety

    return CommonShimmer(
      enabled: events == null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align title to the left
        spacing: 10.iY,
        children: [
          // This is the title row, it stays the same
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: CommonText(
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  titleText: ("home_events_title").tr(context),
                  textStyle: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          // This is the empty state, it stays the same
          if (events != null &&
              events.isEmpty &&
              state.status != StateEnum.loading &&
              state.status != StateEnum.initial)
            SizedBox(
              height: 160.iY, // Give the empty state a predictable size
              child: Center(
                child: CommonText(titleText: "no_ongoing_events".tr(context)),
              ),
            )
          // ===== KEY CHANGE STARTS HERE =====
          else if (events != null) // Only build if events are not null
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align cards to the top
                children: [
                  // Use a standard for-loop to build the list of cards
                  for (
                    int index = 0;
                    index < events.length && index < 4;
                    index++
                  )
                    EventCard(
                      title: events[index].title ?? "",
                      dateRange: events[index].eventStart.isNotNullAndEmpty
                          ? ListingsMethods.getDateRangeUI(
                              events[index].eventStart,
                              events[index].eventEnd,
                            )
                          : null,
                      // dateRange: "${ListingsMethods.formatDateMonthOnly(events[index].eventStart)} - ${ListingsMethods.formatDate(events[index].eventEnd)}",
                      location: events[index].address ?? "",
                      imageUrl: events[index].heroImageUrl ?? "",
                      isFavourite: events[index].isFavorite ?? false,
                      onTap: () {
                        context.go(
                          '${ScreenPaths.home}/${ScreenPaths.listingDetails}',
                          extra: [
                            events[index],
                            state
                                .categoryModel
                                ?.headerBackgroundColor
                                ?.hexToColor,
                          ],
                        );
                      },
                      onTapOnFavourite: isGuestUser
                          ? () {
                              CommonMethods.showInfoDialog(
                                context,
                                "login_to_enable_feature".tr(context),
                                onTapText: "register".tr(context),
                                onTap: () {
                                  ref.read(loginProvider.notifier).logout();
                                },
                                onCancel: () {},
                              );
                            }
                          : () {
                              ref
                                  .read(eventControllerProvider.notifier)
                                  .toggleFavouriteForResentEvents(
                                    events[index].id!,
                                    !(events[index].isFavorite ?? false),
                                    index,
                                  );
                            },
                    ),
                  _buildShowMoreButton(context),
                ],
              ),
            ),
          // ===== KEY CHANGE ENDS HERE =====
        ],
      ),
    );
  }

  // Helper widget for the "Show More" button to keep the build method clean
  Widget _buildShowMoreButton(BuildContext context) {
    return InkWell(
      onTap: () {
        ref.read(eventControllerProvider.notifier).updateSubCategoryId();
        context.go(ScreenPaths.events);
      },
      child: Container(
        // The EventCard has a right margin, so we add a left margin to center this button
        margin: EdgeInsets.symmetric(horizontal: 16.iX),
        // We need to give this button a height to align correctly with the cards
        height: 190.iY,
        // Start with the old height and adjust as needed
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.iY),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.eventCategoryBackground,
              ),
              child: CommonIcon(
                icon: Icons.arrow_forward_ios,
                size: 22.iY,
                color: AppColors.white,
                label: 'show_more_events'.tr(context),
              ),
            ),
            SizedBox(height: 8.iY), // Add some space
            CommonText(
              titleText: 'show_more_events'.tr(context),
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget importantServices(HomeState state) {
    final serviceList = state.importantServicesList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          titleText: ("important_service_title").tr(context),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 160.iY,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: serviceList?.length ?? 0,
            itemBuilder: (_, index) {
              return CommonImageTextCard(
                title: serviceList?[index].title ?? "",
                imageUrl: serviceList?[index].imageUrl ?? "",
                titleColour: AppColors.serviceTitleBackground,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget shoppingServices(HomeState state) {
    final serviceList = state.shoppingList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.iY,
      children: [
        CommonText(
          titleText: ("shopping_service_title").tr(context),
          textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 150.iY,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: serviceList?.children.length ?? 0,
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () {
                  GoRouter.of(context).go(
                    '${ScreenPaths.discover}/${ScreenPaths.listings}',
                    extra: [
                      CategorySlug.shopping.slug,
                      serviceList?.children[index].id,
                      UniqueKey(),
                    ],
                  );
                },
                child: CommonImageTextCard(
                  title: serviceList?.children[index].name ?? "",
                  imageUrl:
                      serviceList?.children[index].imageUrl ??
                      serviceList?.imageUrl ??
                      "",
                  titleColour:
                      serviceList?.headerBackgroundColor.hexToColor ??
                      AppColors.shoppingTitleBackground,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget administrationServices(HomeState state) {
    final serviceList = state.administrationServices;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.iY,
      children: [
        CommonText(
          titleText: ("appointment_booking").tr(context),
          textAlign: TextAlign.start,
          textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 150.iY,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: serviceList?.length ?? 0,
            itemBuilder: (_, index) {
              String administrationServiceName = serviceList?[index].name ?? "";
              return InkWell(
                onTap: () {
                  if (serviceList != null &&
                      (serviceList[index].onTapUrl)
                          .isNotNullAndEmpty) {
                    context.push(
                      ScreenPaths.webView,
                      extra: [
                        serviceList[index].onTapUrl,
                        administrationServiceName.tr(context),
                      ],
                    );
                    // CustomWebViewScreen.showAsBottomSheet(
                    //   context: context,
                    //   url: item!.websiteUrl!,
                    //   title: item.header,
                    // );
                  }
                  // GoRouter.of(context).go(
                  //   '${ScreenPaths.discover}/${ScreenPaths.listings}',
                  //   extra: [
                  //     CategorySlug.foodAndDrink.slug,
                  //     serviceList?.children[index].id,
                  //     UniqueKey(),
                  //   ],
                  // );
                },
                child: CommonImageTextCard(
                  title: administrationServiceName.tr(context),
                  imageUrl:
                      serviceList?[index].imageUrl ?? "",
                  titleColour:
                      AppColors.adminstrationTitleBackground,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget foodAndDrinkServices(HomeState state) {
    final serviceList = state.foodAndDrinkServices;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.iY,
      children: [
        CommonText(
          titleText: ("eat_and_drinking_title").tr(context),
          textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 150.iY,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: serviceList?.children.length ?? 0,
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () {
                  GoRouter.of(context).go(
                    '${ScreenPaths.discover}/${ScreenPaths.listings}',
                    extra: [
                      CategorySlug.foodAndDrink.slug,
                      serviceList?.children[index].id,
                      UniqueKey(),
                    ],
                  );
                },
                child: CommonImageTextCard(
                  title: serviceList?.children[index].name ?? "",
                  imageUrl:
                      serviceList?.children[index].imageUrl ??
                      serviceList?.imageUrl ??
                      "",
                  titleColour:
                      serviceList?.headerBackgroundColor.hexToColor ??
                      AppColors.shoppingTitleBackground,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return CommonShimmer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 30.iY,
          children: [
            // Placeholder for CityActivityCarousel
            Container(
              height: 180.iY,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.iX),
              ),
            ),

            // Placeholder for lists
            _buildPlaceholderList(context),
            _buildPlaceholderList(context),
            _buildPlaceholderList(context),

            const SizedBox(height: 130),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 24,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(height: 16.iY),
        SizedBox(
          height: 230.iY,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (_, index) {
              return Container(
                width: 180.iX,
                margin: EdgeInsets.only(right: 16.iX),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
