import 'package:flutter/material.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:theme/theme.dart';
import 'package:locale/app_localization.dart';


class PageCountDottedUI extends StatelessWidget {
  final int totalPage;
  final int currentPage;

  const PageCountDottedUI({
    super.key,
    required this.totalPage,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.iY),
      child: Align(
        alignment: Alignment.center,
        child: Semantics(
          label: "page_count_label".tr(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6.iX, // spacing between dots
            children: List.generate(totalPage, (index) {
              final bool isActive = index == currentPage;
              return Container(
                height: 12.iX,
                width: 12.iX,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? AppColors
                            .white // ACTIVE dot
                      : AppColors.white.withAlpha(60), // INACTIVE dot
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
