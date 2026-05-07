import 'package:kodi/feat/dashboard/controller/dashboard_state.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../home/controller/home_screen_controller.dart';


final dashboardControllerProvider=NotifierProvider.autoDispose<DashboardController,DashboardState>(() {
  return DashboardController();
});


class DashboardController extends Notifier<DashboardState>{
  late final HomeController homeController;
  @override
  DashboardState build() {
    homeController=ref.read(homeControllerProvider.notifier);
    return DashboardState();
  }

  updateIndex({required int index}){
    state= state.copyWith(index: index);
  }


}
