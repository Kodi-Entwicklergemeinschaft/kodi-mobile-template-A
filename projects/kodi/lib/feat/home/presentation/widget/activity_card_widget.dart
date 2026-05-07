import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/flutter_html.dart';
import 'package:theme/theme.dart';

import '../../../../utils/app_launcher_utils.dart';
import '../../../../utils/config/image.dart';

class ActivityCard extends StatelessWidget {
  final String imageUrl;
  final String? tagText;
  final Color? tagTextBgColor;
  final String? title;
  final String? titleSubText;
  final Color? titleBgColor;
  final Color? titleColor;
  final String? subtitle;
  final VoidCallback? onTap;
  final String? tagIconPath;

  const ActivityCard({
    super.key,
    required this.imageUrl,
    this.tagText,
    this.tagTextBgColor,
    this.title,
    this.titleBgColor,
    this.titleColor,
    this.titleSubText,
    this.subtitle,
    this.onTap,
    this.tagIconPath,
  });

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              CommonImage(
                imagePath: imageUrl,
                width: 480.iX,
                height: 480.iY,
                fit: BoxFit.cover,
                label: "discover_item_label"
                    .tr(context)
                    .replaceAll("{itemName}", tagText ?? ""),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 25.iY),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag (Top-left)
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.9,
                        minWidth: 0.iX,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.iX,
                        vertical: 4.iY,
                      ),
                      decoration: BoxDecoration(
                        color: tagTextBgColor ?? Colors.teal,
                        borderRadius: BorderRadius.circular(6.iX),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonImage(
                            imagePath: tagIconPath ?? Images.mapIcon,
                            height: 22.iY,
                            fit: BoxFit.cover,
                            label: ('map_icon_logo').tr(context),
                            cacheHeight: 80.iY.toInt(),
                            cacheWidth: 100.iX.toInt(),
                          ),
                          SizedBox(width: 8.iX),
                          if (tagText != null)
                            Flexible(
                              child: CommonText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                titleText: tagText!,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.iY,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Spacer(),
                    // Title + subtitle (Bottom-left)
                    if (title != null)
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.9,
                          minWidth: 0.iX,
                        ),
                        padding: EdgeInsets.all(8.iY),
                        decoration: BoxDecoration(
                          color: titleBgColor ?? Colors.teal,

                          borderRadius: isRTL?
                          BorderRadius.only(
                            topLeft: Radius.circular(8.iY),
                            bottomLeft: Radius.circular(8.iY),
                          ):BorderRadius.only(
                            topRight: Radius.circular(8.iY),
                            bottomRight: Radius.circular(8.iY),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title != null)
                              CommonText(
                                titleText: title!,
                                // maxLines: 2,
                                textAlign: TextAlign.start,
                                textStyle: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 18.iY,
                                  fontWeight: FontWeight.bold,
                                  color: titleColor ?? Colors.white,
                                ),
                              ),
                            if (titleSubText != null)
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: 200.iY,
                                  minHeight: 0,
                                  maxWidth: 320.iX,
                                  minWidth: 0,
                                ),
                                child: Html(
                                  onLinkTap: (url, _, __) {
                                    if (url != null) {
                                      AppLauncherUtils.openWebsite(
                                        context,
                                        url: url,
                                        title: url,
                                      );
                                    }
                                  },
                                  data: titleSubText!,
                                  style: {
                                    "body": Style(
                                      color: titleColor ?? Colors.white,
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                      fontSize: FontSize(13.iX),
                                      maxLines: 6,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 4),
                    if (subtitle != null)
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.9,
                          minWidth: 0.iX,
                        ),
                        padding: EdgeInsets.all(8.iY),
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
                        child: CommonText(
                          titleText: subtitle!,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          textStyle: TextStyle(
                            fontSize: 13.iY,
                            color: Colors.white70,
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
