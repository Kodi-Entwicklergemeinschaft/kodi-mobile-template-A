import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locale/locale.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';

import '../../../utils/config/image.dart';
import '../../../utils/routing/routes.dart';
import '../../auth/login/controller/login_controller.dart';
import '../../auth/login/controller/login_state.dart';
import '../../listings/events/controller/event_controller.dart';
import '../../listings/filter/filter_controller.dart';
import '../../user/account/controller/account_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen(loginProvider, (pre, nxt) {
      if (pre != nxt) {
        if (nxt is Logout) {
          context.go(ScreenPaths.welcome,extra: true);
        }
      }
    });

    void onBottomNavTap(int index) {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
      //for Event screen
      if(index==2){
        ref.read(listingsFiltersControllerProvider.notifier).resetDateRange();
        ref.read(eventControllerProvider.notifier).updateSubCategoryId();
      }

      //for profile
      if(index==3){
        ref.read(accountControllerProvider.notifier).loadUserData();
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: onBottomNavTap,
          backgroundColor: AppColors.dark,
          items: [
            BottomNavItem(
              iconsString: Images.homeIcon,
              label: ('dashboard_home').tr(context),
            ),
            BottomNavItem(
              iconsString: Images.searchIcon,
              label: ('dashboard_service').tr(context),
            ),
            BottomNavItem(
              iconsString: Images.calenderIcon,
              label: ('dashboard_calendar').tr(context),
            ),
            BottomNavItem(
              iconsString: Images.accountIcon,
              label: ('dashboard_account').tr(context),
            ),
          ],
        ),
      ),
    );
  }
}
