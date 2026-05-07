import 'package:common_components/common_components.dart';
import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:locale/app_localization.dart';

import '../../../../utils/common_methods.dart';
import '../../../../utils/routing/routes.dart';
import '../../../listings/data/model/category_model.dart';
import '../../controller/home_screen_controller.dart';
import 'activity_card_widget.dart';

class CategoryActivityCarousel extends ConsumerStatefulWidget {
  const CategoryActivityCarousel({super.key});

  @override
  ConsumerState<CategoryActivityCarousel> createState() =>
      _CityActivityCarouselState();
}

class _CityActivityCarouselState
    extends ConsumerState<CategoryActivityCarousel> {
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
            itemCount: state.category?.length ?? 0,
            itemBuilder: (context, index) {
              final item = state.category?[index];
              return ActivityCard(
                titleBgColor: item?.headerBackgroundColor.hexToColor,
                tagTextBgColor: item?.headerBackgroundColor.hexToColor,
                imageUrl: item?.imageUrl ?? "",
                tagText: item?.name,
                tagIconPath: item?.iconUrl,
                title: item?.subtitle,
                subtitle: item?.description,
                onTap: () {
                  CommonMethods.navigateCategories(
                    context,
                    state.category?[index].slugString,
                    category: state.category?[index],
                  );
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
            children: List.generate(state.category?.length ?? 0, (index) {
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
