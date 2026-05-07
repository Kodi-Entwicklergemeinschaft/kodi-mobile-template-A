
import 'package:common_components/common_components.dart';
import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:theme/theme.dart';

import '../../../../utils/config/image.dart';
import '../../data/model/discover_item.dart';
import 'package:shared_dependencies/flutter_html.dart';

class DiscoverItemCard extends StatelessWidget {
  const DiscoverItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final CategoryModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;
    return GestureDetector(
      onTap: onTap,
      child: Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.iX),
      ),
      elevation: 4,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Network image with shimmer loading
          CommonImage(
            imagePath: item.imageUrl??"",
            fit: BoxFit.cover,
            height: 20.iY,
            label: "discover_item_label".tr(context).replaceAll("{itemName}", item.name??""),
            // cacheHeight: 400.iX.toInt(),
            // cacheWidth: 400.iY.toInt(),
          ),
          // Gradient overlay for text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.5, 1.0],
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 12.iY),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.iY,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.iX, vertical: 4.iY),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      minWidth: 0.iX,
                    ),
                    decoration: BoxDecoration(
                      color: item.headerBackgroundColor?.hexToColor ?? Colors.teal,
                      borderRadius: BorderRadius.circular(6.iX),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CommonImage(
                          imagePath: item.iconUrl??Images.mapIcon,
                          height: 22.iY,
                          fit: BoxFit.cover,
                          label: "common_icon_label".tr(context).replaceAll("{itemName}", item.name??""),
                          cacheHeight: 80.iY.toInt(),
                        ),
                        SizedBox(width: 5.iX),
                        Flexible(
                          child: CommonText(
                            titleText: item.name??"",
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
                  if(item.subtitle!=null && item.subtitle!.isNotEmpty)
                    Container(
                    padding: EdgeInsets.all(5.iY),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                      minWidth: 0.iX,
                    ),
                    decoration: BoxDecoration(
                      color: item.headerBackgroundColor?.hexToColor ?? Colors.teal,
                      borderRadius:isRTL?
                      BorderRadius.only(
                        topLeft: Radius.circular(8.iY),
                        bottomLeft: Radius.circular(8.iY),
                      ):BorderRadius.only(
                        topRight: Radius.circular(8.iY),
                        bottomRight: Radius.circular(8.iY),
                      ),
                    ),
                    child: CommonText(
                      titleText: item.subtitle ?? "",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textStyle: TextStyle(
                        fontSize: 18.iY,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.iY),
                  if(item.description!=null && item.description!.isNotEmpty)
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 200.iY,
                      minHeight: 0,
                      maxWidth: 320.iX,
                      minWidth: 0,
                    ),
                      padding: EdgeInsets.all(3.iX),
                      decoration: BoxDecoration(
                        color: AppColors.dark,
                        borderRadius: isRTL?
                        BorderRadius.only(
                          topLeft: Radius.circular(8.iY),
                          bottomLeft: Radius.circular(8.iY),
                        ):BorderRadius.only(
                          topRight: Radius.circular(8.iY),
                          bottomRight: Radius.circular(8.iY),
                        ),
                      ),
                      child: Html(
                        data: item.description??"",
                        style: {
                          "body": Style(
                            color: Colors.white,
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(13.iX),
                            maxLines: 3,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        },
                      ),
                    ),
                ],
              ),
          ),
        ],
      ),
    ),
    );
  }
}
