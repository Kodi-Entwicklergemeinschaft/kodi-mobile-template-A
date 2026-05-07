
part of '../common_components.dart';

enum ButtonType { normal, outline, text }

enum ButtonSize { large, small }

class AppButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final TextAlign? textAlign;
  final Color? textColor;
  final bool loading;
  final bool disabled;
  final ButtonType type;
  final Widget? icon;
  final MainAxisSize mainAxisSize;
  final ButtonSize size;
  final Color? backgroundColor;

  const AppButton(
    this.text, {
    super.key,
    this.textAlign,
    this.onPressed,
    this.icon,
    this.textColor,
    this.loading = false,
    this.disabled = false,
    this.type = ButtonType.normal,
    this.mainAxisSize = MainAxisSize.min,
    this.size = ButtonSize.large,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    final VoidCallback? pressCallback =
        disabled || loading || onPressed == null ? null : () => onPressed!();
    Size buttonSize =  Size(64.iX, 48.iY);
    if (size == ButtonSize.small) {
      buttonSize =  Size(64.iX, 36.iY);
    }
    Widget buttonContent = Flexible(
      child: CommonText(
        semanticsLabel: "$text button",
        titleText: text,
        textAlign: textAlign ?? TextAlign.center,
        overflow: TextOverflow.clip,
        textScaler: MediaQuery.textScalerOf(context), // system font scaling
        textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: textColor ?? ((type == ButtonType.normal)
              ? Colors.white
              : Theme.of(context).primaryColor),
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (loading) {
      buttonContent = SizedBox(
        height: 24.iY, width: 24.iX, // Adjust size as needed
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: type == ButtonType.normal
              ? Colors.white
              : Theme.of(context).primaryColor,
        ),
      );
    }
    switch (type) {
      case ButtonType.outline:
        if (icon != null) {
          return OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor : backgroundColor,
              minimumSize: buttonSize,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.iX),
              ),
            ),
            onPressed: pressCallback,
            icon: icon!,
            label: Row(
              mainAxisSize: mainAxisSize,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[buttonContent],
            ),
          );
        }
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor : backgroundColor,
            minimumSize: buttonSize,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.iX),
            ),
          ),
          onPressed: pressCallback,
          child: Row(
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[buttonContent],
          ),
        );

      case ButtonType.text:
        if (icon != null) {
          return TextButton.icon(
            onPressed: pressCallback,
            icon: icon!,
            label: Row(
              mainAxisSize: mainAxisSize,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[buttonContent],
            ),
          );
        }
        return TextButton(
          onPressed: pressCallback,
          child: Row(
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[buttonContent],
          ),
        );
      default:
        if (icon != null) {
          return ElevatedButton.icon(
            onPressed: pressCallback,
            style: ElevatedButton.styleFrom(
              minimumSize: buttonSize,
              backgroundColor : backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.iX),
              ),
              disabledBackgroundColor: AppColors.darkCard,
            ),
            icon: loading ? const SizedBox.shrink() : icon!,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[buttonContent],
            ),
          );
        }
        return ElevatedButton(
          onPressed: pressCallback,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
            minimumSize: buttonSize,
            disabledBackgroundColor: AppColors.darkCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[buttonContent],
          ),
        );
    }
  }
}