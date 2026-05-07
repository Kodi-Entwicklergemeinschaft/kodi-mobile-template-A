import 'package:flutter/material.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../../../utils/config/image.dart';
import '../../../../utils/routing/routes.dart';
import 'activity_card_widget.dart';

class MobilityCarousel extends ConsumerStatefulWidget {
  const MobilityCarousel({super.key});

  @override
  ConsumerState<MobilityCarousel> createState() =>
      _MobilityCarouselState();
}

class _MobilityCarouselState extends ConsumerState<MobilityCarousel> {
  final PageController _controller = PageController(viewportFraction: 1);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 400.iY,
          child: PageView(
            controller: _controller,
            children: [
              ActivityCard(
                tagIconPath: Images.carIcon,
                imageUrl: Images.kodiMap,
                tagText: "KODI MOBIL",
                title: "KODI MOBIL",
                tagTextBgColor: Colors.blue,
                onTap: () {
                  context.go(
                    '${ScreenPaths.home}/${ScreenPaths.mobilityScreen}',
                    extra: [],
                  );
                },
              ),
              ActivityCard(
                tagIconPath: Images.carIcon,
                imageUrl: Images.kodiMap,
                tagText: "Nahverkehr",
                title: "Nahverkehr",
                tagTextBgColor: Colors.green,
                onTap: () {
                  context.push(
                    ScreenPaths.webView,
                    extra: ["https://mobil.kodiregion.de/", "Nahverkehr"],
                  );
                  },
              ),
            ],
          ),
        ),
        Positioned(
          top: 10.iY,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (
                index,
                ) {
              final isActive = _currentPage == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
