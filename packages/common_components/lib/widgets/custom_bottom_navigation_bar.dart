part of '../common_components.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  final List<BottomNavItem> items;
  final Color? backgroundColor;
  final Color? selectedColor;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 10.iY),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final isSelected = index == currentIndex;
            final item = items[index];

            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null)
                      CommonIcon(
                        icon: item.icon!,
                        size: 26.iY,
                        color: isSelected
                            ? selectedColor ?? Colors.blue
                            : Colors.white,
                      ),
                    if (item.iconsString != null)
                      CommonImage(
                        label: "${item.label} Navigation",
                        imagePath: item.iconsString!,
                        width: 26.iY,
                        height: 26.iY,
                        color: isSelected
                            ? selectedColor ?? Colors.blue
                            : Colors.white,
                      ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(5.iY),
                        child: CommonText(
                          overflow: TextOverflow.ellipsis,
                          titleText: item.label,
                          textStyle: TextStyle(
                            color: isSelected
                                ? selectedColor ?? Colors.blue
                                : Colors.white,
                            fontSize: 14.iY,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class BottomNavItem {
  final IconData? icon;
  final String? iconsString;
  final String label;

  BottomNavItem({this.icon, this.iconsString, required this.label});
}
