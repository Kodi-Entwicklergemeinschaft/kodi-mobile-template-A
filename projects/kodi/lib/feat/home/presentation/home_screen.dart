import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/city/controller/city_controller.dart';
import 'package:kodi/feat/home/controller/home_screen_controller.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/extension/app_text_colors.dart';
import 'package:theme/theme.dart';
import '../../../utils/common_methods.dart';
import '../../../utils/config/image.dart';
import '../../../utils/routing/routes.dart';
import 'home_content_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider.notifier).loadData();
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cityState = ref.watch(cityControllerProvider).cityData;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          searchController.clear();
          return ref.read(homeControllerProvider.notifier).loadData();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true, // This is essential for the title to stay visible
              floating: false,
              expandedHeight: 250.iY,
              backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
              // Color when collapsed

              // This is the key part of the solution
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                // The title is what remains visible when the app bar collapses.
                // We wrap the SearchBar in a container to manage its padding and alignment.
                title: Container(
                  // Use this height to match the default toolbar height, ensuring no overflow
                  height: kToolbarHeight,
                  alignment: Alignment.center,
                  child: SearchBarWidget(
                    controller: searchController,
                    label: "find_next_experience".tr(context),
                    onDone: (val) {
                      if (val.isNotEmpty) {
                        context.go(
                            "${ScreenPaths.discover}/${ScreenPaths.globalSearch}",
                            extra: [val,UniqueKey()]);
                      }
                    },
                  ),
                ),
                // This padding is automatically managed by Flutter to avoid the back button etc.
                // Setting to zero gives us full control, but be careful on iOS.
                // For now, let's remove it to place the SearchBar correctly.
                titlePadding: EdgeInsets.symmetric(horizontal: 16.iX),
                centerTitle: true, // This ensures the title (our SearchBar) is centered

                // The background is what disappears during the scroll.
                background: Padding(
                  padding:  EdgeInsets.only(bottom: 20.iY),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(120.iX, 20.iY),
                      bottomRight: Radius.elliptical(120.iX, 20.iY),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Your background image
                        CommonImage(
                          label: ('illustration_related_to_content_label').tr(context),
                          imagePath: cityState?.items?[0].headerImageUrl ?? "",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        // Your gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).extension<AppTextColors>()!.inverse,
                                Theme.of(context).extension<AppTextColors>()!.inverse.withOpacity(0.0),
                              ],
                              stops: const [0.0, 0.4],
                            ),
                          ),
                        ),
                        // Your logo
                        Positioned(
                          top: 50.iY,
                          left: 16.iX,
                          child: CommonImage(
                            height: 80.iY,
                            imagePath: Images.kodiLogo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // The rest of your content
            SliverToBoxAdapter(child: HomeContentSection()),
          ],
        ),
      ),
    );
  }
}
