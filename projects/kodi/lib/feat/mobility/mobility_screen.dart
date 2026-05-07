import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../utils/config/image.dart';
import '../../utils/routing/routes.dart';
import '../base_UI/presentation/base_ui_screen.dart';
import 'package:locale/app_localization.dart';

class MobilityScreen extends ConsumerStatefulWidget {
  const MobilityScreen({super.key});

  @override
  ConsumerState<MobilityScreen> createState() => _MobilityScreenState();
}

class _MobilityScreenState extends ConsumerState<MobilityScreen> {
  @override
  Widget build(BuildContext context) {
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
                  ],
                ),
                SizedBox(height: 20.iY),
                Expanded(
                  child: GridView(
                    padding: EdgeInsets.all(10.iY),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 450.iX, // Max width per item
                      crossAxisSpacing: 10.iX,
                      mainAxisSpacing: 10.iY,
                      childAspectRatio: 1.5,
                    ),
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.go(
                            '${ScreenPaths.home}/${ScreenPaths.mobilityScreen}/${ScreenPaths.parkingScreen}',
                            extra: [],
                          );
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.iX),
                          ),
                          elevation: 4,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CommonImage(
                                imagePath: Images.parkingImage,
                                fit: BoxFit.cover,
                                height: 20.iY,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: const [0.5, 1.0],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.iY),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10.iY),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.iX,
                                        vertical: 4.iY,
                                      ),
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                            0.9,
                                        minWidth: 0.iX,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius: BorderRadius.circular(
                                          6.iX,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 5.iX),
                                          Flexible(
                                            child: CommonText(
                                              titleText: "parking".tr(context),
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.iY,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push(
                            ScreenPaths.webView,
                            extra: [
                              "https://www.netzplan-kodi.de/maps/tlnp-kodi/place-marker",
                              "ÖPNV"
                            ],
                          );
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.iX),
                          ),
                          elevation: 4,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CommonImage(
                                imagePath: Images.opnvImage,
                                fit: BoxFit.cover,
                                height: 20.iY,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: const [0.5, 1.0],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.iY),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10.iY),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.iX,
                                        vertical: 4.iY,
                                      ),
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                            0.9,
                                        minWidth: 0.iX,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius: BorderRadius.circular(
                                          6.iX,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: CommonText(
                                              titleText: "opnv".tr(context),
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.iY,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
