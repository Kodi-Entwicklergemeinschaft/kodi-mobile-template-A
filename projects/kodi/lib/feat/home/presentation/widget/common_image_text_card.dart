import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:locale/locale.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:theme/theme.dart';

class CommonImageTextCard extends StatelessWidget {
  const CommonImageTextCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.titleColour,
    this.fontSize,
    this.isSelected=false,
  });

  final String imageUrl;
  final String title;
  final Color titleColour;
  final double? fontSize;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final double width=160;
    final double height=160;
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: width.iX,
      height: height.iY,
      margin:  EdgeInsets.only(right: 12.iX),
      decoration: BoxDecoration(
        color: titleColour,
        borderRadius: BorderRadius.all(Radius.circular(8.iX)),
        // color: AppColors.primary,
        border:  isSelected?Border.all(color: titleColour, width: 4.iX):null,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8.iX)),
            child: CommonImage(
              imagePath: imageUrl,
              height: double.infinity,
              width: double.infinity,
              // fit: BoxFit.cover,

            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 12.iY),
            child: Column(
              children: [
                Spacer(),
                Container(
                  constraints: BoxConstraints(maxWidth: width * 0.88.iX),
                  decoration: BoxDecoration(
                    color: titleColour,
                    borderRadius: isRTL?
                    BorderRadius.only(
                      topLeft: Radius.circular(8.iY),
                      bottomLeft: Radius.circular(8.iY),
                    ):BorderRadius.only(
                      topRight: Radius.circular(8.iY),
                      bottomRight: Radius.circular(8.iY),
                    ),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.only(top: 10.iX,left: 10.iY, right: 10.iY, bottom: 10.iX),
                    child: CommonText(
                      titleText: title,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textStyle: TextStyle(
                        fontSize: fontSize??14.iY,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
