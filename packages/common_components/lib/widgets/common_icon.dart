part of '../common_components.dart';

class CommonIcon extends StatelessWidget {
  const CommonIcon({
    super.key,
    this.onPressed,
    required this.icon,
    this.label,
    this.color,
    this.size,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String? label;
  final Color? color;
  final double? size;


  @override
  Widget build(BuildContext context) {
    return InkWell(

      onTap: onPressed,
      child: Icon(
        icon,
        color: color,
        size: size,
        semanticLabel: label??"Icon",
      ),
    );
  }
}
