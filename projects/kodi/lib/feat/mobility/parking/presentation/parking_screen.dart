import 'dart:async';
import 'dart:io';

import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/app_launcher_utils.dart';
import '../../../../utils/enums/StateEnum.dart';
import '../../../base_UI/presentation/base_ui_screen.dart';
import '../controller/parking_controller.dart';
import '../controller/parking_state.dart';
import '../data/model/parking_response_model.dart';

class ParkingScreen extends ConsumerStatefulWidget {
  const ParkingScreen({super.key});

  @override
  ConsumerState<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends ConsumerState<ParkingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Initial API call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(parkingControllerProvider.notifier).loadParking();
    });

    // Auto refresh every 1 minute
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      ref
          .read(parkingControllerProvider.notifier)
          .refreshParking(isLoading: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(parkingControllerProvider);

    return PopScope(
      canPop: true,
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
                          label: 'parking'.tr(context),
                        ),
                      ),
                    ),
                  SizedBox(height: 15.iY),
                ],
              ),
              SizedBox(height: 10.iY),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref
                      .read(parkingControllerProvider.notifier)
                      .refreshParking(),
                  child: _buildBody(state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ParkingState state) {
    if (state.status == StateEnum.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.parkingDataList == null || state.parkingDataList!.isEmpty) {
      return Center(
        child: CommonText(
          titleText: 'no_parking_data_text'.tr(context),
          textStyle: TextStyle(fontSize: 14),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Title text
        Padding(
          padding: EdgeInsets.fromLTRB(15.iX, 15.iY, 15.iX, 5.iY),
          child: CommonText(
            titleText: 'parking'.tr(context),
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              fontSize: 22.iY,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        /// List
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 15.iX),
            itemCount: state.parkingDataList!.length,
            separatorBuilder: (_, __) =>
                Divider(color: AppColors.primary, height: 4.iY),
            itemBuilder: (_, index) {
              final parking = state.parkingDataList![index];
              return _parkingCard(parking);
            },
          ),
        ),
      ],
    );
  }

  Widget _parkingCard(ParkingData parking) {
    final total = parking.capacity?.total ?? 0;
    final free = parking.capacity?.available ?? 0;
    final occupied = parking.capacity?.occupied ?? (total - free);

    final lat = parking.location?.latitude;
    final lng = parking.location?.longitude;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.iX, vertical: 25.iY),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Name
          Align(
            alignment: Alignment.center,
            child: CommonText(
              titleText: parking.name ?? "",
              textAlign: TextAlign.center,
              textStyle: TextStyle(
                fontSize: 28.iY,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          SizedBox(height: 12.iY),

          /// Total + Free
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    titleText: 'free'.tr(context),
                    textStyle: TextStyle(fontSize: 22),
                  ),
                  CommonText(
                    titleText: "$free",
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    titleText: 'total'.tr(context),
                    textStyle: TextStyle(fontSize: 22),
                  ),
                  CommonText(
                    titleText: "$total",
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 10.iY),

          /// Progress bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.iY),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 14,
                child: Row(
                  children: [
                    Expanded(
                      flex: occupied > 0 ? occupied : 0,
                      child: Container(color: Colors.red),
                    ),
                    Expanded(
                      flex: free > 0 ? free : 0,
                      child: Container(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 15.iY),

          /// Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: (lat != null && lng != null)
                      ? () => AppLauncherUtils.openMap(lat, lng)
                  : null,
                  child: CommonText(
                    titleText: "open_maps".tr(context),
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 10.iX),
              // Expanded(
              //   child: OutlinedButton(
              //     onPressed: (lat != null && lng != null)
              //         ? () => _openMap(lat, lng)
              //         : null,
              //     child: const CommonText(
              //       titleText: "Apple Maps",
              //       textStyle: TextStyle(fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
