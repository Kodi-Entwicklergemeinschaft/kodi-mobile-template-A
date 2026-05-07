part of '../common_components.dart';

class InfoTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconBackground;
  final Color iconColor;
  final Color textColor;

  const InfoTile({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor = const Color(0xFF2C4158),
    this.iconBackground = Colors.white,
    this.iconColor = Colors.black,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CommonIcon( icon:
              Icons.info,
              size: 25,
              color: AppColors.secondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
