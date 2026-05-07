import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/custom_webview.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';
import '../../../../utils/routing/routes.dart';
import '../../controller/home_screen_controller.dart';
import 'activity_card_widget.dart';

class GiftVoucherCarousel extends ConsumerStatefulWidget {
  const GiftVoucherCarousel({super.key});

  @override
  ConsumerState<GiftVoucherCarousel> createState() =>
      _GiftVoucherCarouselState();
}

class _GiftVoucherCarouselState extends ConsumerState<GiftVoucherCarousel> {
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
    final state = ref.watch(homeControllerProvider);

    return Stack(
      children: [
        SizedBox(
          height: 400.iY,
          child: PageView.builder(
            controller: _controller,
            itemCount: state.giftVoucherList?.length ?? 0,
            itemBuilder: (context, index) {
              final item = state.giftVoucherList?[index];
              return ActivityCard(
                tagIconPath: item?.iconImageUrl,
                imageUrl: item?.backgroundImageUrl ?? "",
                tagText: item?.header ?? "",
                title: item?.subheader ?? "",
                titleSubText: item?.description ?? '',
                tagTextBgColor: item?.headerBackgroundColor.hexToColor,
                titleBgColor: item?.contentBackgroundColor.hexToColor,
                onTap: () {
                  if ((item?.websiteUrl).isNotNullAndEmpty) {
                    context.push(
                      ScreenPaths.webView,
                      extra: [item!.websiteUrl!, item.header],
                    );
                    // CustomWebViewScreen.showAsBottomSheet(
                    //   context: context,
                    //   url: item!.websiteUrl!,
                    //   title: item.header,
                    // );
                  }
                },
              );
            },
          ),
        ),
        Positioned(
          top: 10.iY,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(state.giftVoucherList?.length ?? 0, (
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
