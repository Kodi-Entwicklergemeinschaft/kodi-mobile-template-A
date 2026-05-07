import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/feat/discover/presentation/widget/discover_item_card.dart';
import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:kodi/feat/listings/kodi_week/controller/kodi_week_controller.dart';
import 'package:kodi/utils/common_methods.dart';
import 'package:kodi/utils/config/image.dart';
import 'package:kodi/utils/routing/routes.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';

class KodiWeekScreen extends ConsumerStatefulWidget {
  const KodiWeekScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  ConsumerState<KodiWeekScreen> createState() => _KodiWeekScreenState();
}

class _KodiWeekScreenState extends ConsumerState<KodiWeekScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(kodiWeekControllerProvider.notifier)
          .setCategory(widget.category);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTapSubService(SubServiceModel item, CategoryModel? category) {
    if (item.itemType == 'TILE' &&
        item.websiteUrl != null &&
        item.websiteUrl!.isNotEmpty) {
      context.push(ScreenPaths.webView, extra: [item.websiteUrl, item.name]);
    } else if (item.itemType == 'MAP') {
      final poiCategory = CategoryModel(
        id: item.itemId ?? item.id,
        name: item.name,
        slugString: item.slug ?? '',
        slug: CategorySlugExt.fromSlug(item.slug ?? ''),
        description: item.description,
        subtitle: item.subtitle,
        iconUrl: item.iconUrl,
        imageUrl: item.imageUrl,
        headerBackgroundColor: item.headerBackgroundColor,
        contentBackgroundColor: item.contentBackgroundColor,
        isActive: item.isActive,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
        children: [],
      );
      final matchedLocation = GoRouterState.of(context).matchedLocation;
      context.push(
        '$matchedLocation/${ScreenPaths.kodiPoiScreen}',
        extra: poiCategory,
      );
    } else {
      CommonMethods.navigateCategories(context, item.slug, category: category);
    }
  }

  /// Maps a SubServiceModel to a CategoryModel for display via DiscoverItemCard.
  CategoryModel _toDisplayModel(SubServiceModel service) {
    return CategoryModel(
      id: service.id,
      name: service.name,
      slugString: service.slug ?? '',
      slug: CategorySlugExt.fromSlug(service.slug ?? ''),
      description: service.description,
      subtitle: service.subtitle,
      iconUrl: service.iconUrl,
      imageUrl: service.imageUrl,
      headerBackgroundColor: service.headerBackgroundColor,
      contentBackgroundColor: service.contentBackgroundColor,
      isActive: service.isActive,
      createdAt: service.createdAt,
      updatedAt: service.updatedAt,
      children: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kodiWeekControllerProvider);
    final subServices = state.category?.subServices ?? [];

    return BaseUI(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(5.iY),
          child: Column(
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
                          size: 30.iX,
                          label: 'back_button_label'.tr(context),
                        ),
                      ),
                    ),
                  SizedBox(width: 10.iX),
                  Expanded(
                    child: SearchBarWidget(
                      controller: _searchController,
                      label: 'search'.tr(context),
                      onDone: (val) {
                        if (val.isNotEmpty) {
                          context.go(
                            '${ScreenPaths.discover}/${ScreenPaths.globalSearch}',
                            extra: [val, UniqueKey()],
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 15.iX),
                  // InkWell(
                  //   onTap: () {
                  //     CommonMethods.showInfoDialog(
                  //       context,
                  //       'coming_soon'.tr(context),
                  //     );
                  //   },
                  //   child: Padding(
                  //     padding: EdgeInsets.all(2.iY),
                  //     child: CommonImage(
                  //       imagePath: Images.filterIcon,
                  //       label: 'filter_icon_label'.tr(context),
                  //       width: 50.iX,
                  //       height: 50.iY,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: 20.iY),
              if (subServices.isEmpty)
                Expanded(
                  child: Center(
                    child: CommonText(
                      titleText: 'no_services_found'.tr(context),
                    ),
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(10.iY),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 450.iX,
                      crossAxisSpacing: 10.iX,
                      mainAxisSpacing: 10.iY,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: subServices.length,
                    itemBuilder: (context, index) {
                      final item = subServices[index];
                      return DiscoverItemCard(
                        item: _toDisplayModel(item),
                        onTap: () => _onTapSubService(item, state.category),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}