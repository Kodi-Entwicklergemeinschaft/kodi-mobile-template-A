import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/auth/login/controller/login_controller.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/utils/common_methods.dart';
import 'package:kodi/utils/config/image.dart';
import 'package:kodi/utils/routing/routes.dart';
import 'package:local_storage/preference_manager_impl.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:common_components/common_components.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:theme/extension/app_text_colors.dart';
import 'package:kodi/feat/home/presentation/widget/common_image_text_card.dart';
import 'package:locale/locale.dart';
import '../../../../utils/app_pref_keys.dart';
import '../../../listings/categories/categories_controller.dart';
import '../../../listings/data/model/category_model.dart';
import '../controller/account_controller.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(accountControllerProvider.notifier).loadUserData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountController = ref.watch(accountControllerProvider.notifier);

    final isGuestUser = ref
        .read(preferenceManagerProvider)
        .getBool(AppPrefsKeys.isGuestUser);

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
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.iX, vertical: 16.iY),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  // SearchBarWidget(
                  //   label: 'search'.tr(context),
                  //   controller: _searchController,
                  // ),
                  SizedBox(height: 24.iY),

                  // Account Section
                  CommonText(
                    titleText: 'account_header'.tr(context),
                    textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 24.iX,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 12.iY),
                  _buildAccountMenuItems(context),
                  SizedBox(height: 24.iY),

                  // Favorites Section
                  if (accountController.isLoggedIn())
                    _buildFavoritesSection(context),

                  // Services Section
                  // CommonText(
                  //   titleText: 'account_services_title'.tr(context),
                  //   textStyle: TextStyle(
                  //     fontSize: 18.iY,
                  //     fontWeight: FontWeight.w700,
                  //     color: AppColors.dark,
                  //   ),
                  //   textAlign: TextAlign.start,
                  // ),
                  // SizedBox(height: 12.iY),
                  // _buildServicesSection(context, accountState),
                  // SizedBox(height: 24.iY),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountMenuItems(BuildContext context) {
    final accountController = ref.watch(accountControllerProvider.notifier);
    return Column(
      spacing: 12.iY,
      children: [
        if (accountController.isLoggedIn())
          _buildMenuItem(
            imagePath: Images.accountIcon,
            title: 'account_my_profile'.tr(context),
            onTap: () {
              context.go('${ScreenPaths.account}/${ScreenPaths.profileScreen}');
            },
          ),
        // _buildMenuItem(
        //   imagePath: Images.idIcon,
        //   title: 'account_meinkodi_id'.tr(context),
        //   onTap: () => {},
        // ),
        // _buildMenuItem(
        //   imagePath: Images.myApplication,
        //   title: 'account_my_applications'.tr(context),
        //   onTap: () => {},
        // ),
        _buildMenuItem(
          icon: Icons.settings,
          title: 'account_settings_contact'.tr(context),
          onTap: () => {
            context.go('${ScreenPaths.account}/${ScreenPaths.setting}'),
          },
        ),
        if (accountController.isLoggedIn())
          _buildMenuItem(
            icon: Icons.logout,
            title: 'dashboard_logout'.tr(context),
            onTap: () {
              CommonMethods.showLogOutDialog(
                context,
                onLogOut: () {
                  ref.read(loginProvider.notifier).logout().then((onValue) {
                    if (context.mounted) {
                      context.go(ScreenPaths.welcome);
                    }
                  });
                },
              );
            },
          ),
        if (!accountController.isLoggedIn())
          _buildMenuItem(
            icon: Icons.login,
            title: 'register_login'.tr(context),
            onTap: () {
              ref.read(loginProvider.notifier).logout();
            },
          ),
      ],
    );
  }

  Widget _buildMenuItem({
    IconData? icon,
    String? imagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      enableFeedback: true,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5.iY),
        child: Row(
          children: [
            if (imagePath != null)
              CommonImage(
                imagePath: imagePath,
                height: 26.iY,
                width: 26.iX,
                fit: BoxFit.contain,
                color: Theme.of(context).iconTheme.color,
                label: 'common_icon_label'
                    .tr(context)
                    .replaceAll('{itemName}', title),
              )
            else if (icon != null)
              CommonIcon(
                icon: icon,
                label: 'common_icon_label'
                    .tr(context)
                    .replaceAll('{itemName}', title),
                size: 26.iY,
                color: Theme.of(context).iconTheme.color,
              ),
            SizedBox(width: 12.iX),
            Expanded(
              child: CommonText(
                titleText: title,
                textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18.iX,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            CommonImage(
              imagePath: Images.arrowAccountIcon,
              color: Theme.of(context).extension<AppTextColors>()!.normal,
              width: 12.iY,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesSection(BuildContext context) {
    final accountState = ref.watch(accountControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          titleText: 'account_favorites_title'.tr(context),
          textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 24.iX,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 12.iY),
        if(accountState.favorites.isEmpty)
          SizedBox(
            height: 100.iY,
            child: Center(child: CommonText(titleText: 'no_fav_listing'.tr(context))),
          ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: accountState.favorites.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 230 / 230, // adjust if needed
          ),
          itemBuilder: (context, index) {
            final favorite = accountState.favorites[index];
            return GestureDetector(
              onTap: () {
                final categoryId =
                    (favorite.slug == CategorySlug.kodiWeek &&
                            favorite.subServices.isNotEmpty)
                        ? favorite.subServices[0].itemId ?? favorite.id
                        : favorite.id;
                context.go(
                  '${ScreenPaths.account}/${ScreenPaths.favouriteScreen}',
                  extra: categoryId,
                );
              },
              child: SizedBox(
                child: CommonImageTextCard(
                  imageUrl: favorite.imageUrl ?? "",
                  title: favorite.name.toString().tr(context),
                  fontSize: 18.iY,
                  titleColour: favorite.headerBackgroundColor.hexToColor,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 24.iY),
      ],
    );
  }

  Widget _buildServicesSection(BuildContext context, accountState) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: accountState.services
            .map<Widget>(
              (service) => GestureDetector(
                onTap: () => {},
                child: SizedBox.square(
                  dimension: 230.iX,
                  child: CommonImageTextCard(
                    imageUrl: service.imageUrl,
                    title: service.title,
                    fontSize: 22.iY,
                    titleColour: Color(
                      int.parse(service.color.replaceFirst('0x', '0x')),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
