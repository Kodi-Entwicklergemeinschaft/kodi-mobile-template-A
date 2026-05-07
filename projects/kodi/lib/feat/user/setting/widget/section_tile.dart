import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:theme/extension/app_container_colors.dart';
import 'package:theme/extension/app_text_colors.dart';
import 'package:theme/theme.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onTap;
  final String? iconImage;
  final String? label;


  const SectionTitle(this.text, {super.key, this.icon, this.onTap,this.iconImage,required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.iX),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          children: [
            if(iconImage!=null)
              CommonImage(imagePath: iconImage!,
                // height: 40.iY,
                color: Theme.of(context).extension<AppTextColors>()!.inverse,
                width: 35.iX,
              ),
            if (icon != null && iconImage==null) ...[
              CommonIcon(
                icon: icon!,
                label: label,
                size: 35.iX,
                color: Theme.of(context).extension<AppTextColors>()!.inverse,
              ),

            ],
            const SizedBox(width: 8),
            Flexible(
              child: CommonText(
                titleText: text,
                overflow: TextOverflow.ellipsis,
                textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16.iX,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).extension<AppTextColors>()!.inverse,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
