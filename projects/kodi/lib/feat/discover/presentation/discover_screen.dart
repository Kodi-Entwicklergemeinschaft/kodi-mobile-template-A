import 'package:flutter/material.dart';
import 'package:common_components/common_components.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/feat/discover/presentation/widget/discover_item_card.dart';
import 'package:kodi/feat/home/controller/home_screen_controller.dart';
import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:kodi/utils/routing/routes.dart';
import 'package:locale/app_localization.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:scaling_dep/mobile_size_utils.dart';

import '../../../utils/common_methods.dart';
import '../../../utils/config/image.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(homeControllerProvider).category;

    return PopScope(
      canPop: false, // prevent system pop
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          // Switch to Home branch
          StatefulNavigationShell.of(context)
              .goBranch(0, initialLocation: false);
        }
      },
      child: BaseUI(
        body: SafeArea(
          child: Padding(
            padding:  EdgeInsets.all(5.iY),
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
                        onDone: (val){
                          if(val.isNotEmpty){
                            context.go("${ScreenPaths.discover}/${ScreenPaths.globalSearch}",extra: [val,UniqueKey()]);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 15.iX),
                    // InkWell(
                    //   onTap: (){
                    //     CommonMethods.showInfoDialog(context,"coming_soon".tr(context));
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
                if (categories == null)
                   Expanded(
                    child: Center(
                      child: Semantics(
                        label: 'loading_label'.tr(context),
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(10.iY),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 450.iX, // Max width per item
                        crossAxisSpacing: 10.iX,
                        mainAxisSpacing: 10.iY,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final item = categories[index];
                        return Semantics(
                          label: 'discover_item_label'.tr(context).replaceAll('{itemName}', item.name ?? ''),
                          child: DiscoverItemCard(
                            item: item,
                            onTap: () => CommonMethods.navigateCategories(
                              context,
                              item.slugString,
                              category: item,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
