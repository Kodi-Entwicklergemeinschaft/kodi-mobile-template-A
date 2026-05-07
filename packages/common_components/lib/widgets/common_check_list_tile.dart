part of '../common_components.dart';

class CommonChecklistTile extends StatelessWidget {
  final bool value;
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final Color checkColor;
  final Color borderColor;

  const CommonChecklistTile({
    super.key,
    required this.value,
    required this.text,
    required this.onTap,
    this.backgroundColor = const Color(0xFF2C4158),
    this.textColor = Colors.white,
    this.checkColor = Colors.white,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            _checkbox(),
            const SizedBox(width: 12),
            Expanded(
              child: CommonText(
                semanticsLabel: text,
                textAlign: TextAlign.start,
                textStyle: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ), titleText: text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkbox() {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        color: value ? checkColor : Colors.transparent,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: value
          ? const CommonIcon(
              icon:Icons.check,
              size: 16, color: Colors.black)
          : null,
    );
  }
}
