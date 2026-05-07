part of '../common_components.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    super.key,
    required this.label,
    this.fillColor,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.obscureText = false,
    this.validator,
    this.onSubmitted,
    this.autovalidateMode,
    this.onEditingComplete,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.hintTextColor,
    this.labelTextColor,
    this.readOnly=false,
    this.focusColor,
  });

  final String label;
  final Color? fillColor;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;
  final AutovalidateMode? autovalidateMode;
  final VoidCallback? onEditingComplete;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Color? hintTextColor;
  final Color? labelTextColor;
  final bool readOnly;
  final Color? focusColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      textField: true,
      label: label,
      child: TextFormField(
        readOnly: readOnly,
        enabled: !readOnly,
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validator,
        onFieldSubmitted: onSubmitted,
        autovalidateMode: autovalidateMode,
        onEditingComplete: onEditingComplete,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          // labelText: label,                                // ✅ A11y label
          hintText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,

          filled: true,
          fillColor: fillColor ?? AppColors.darkCard,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),

          // ✅ Focused border (shows when field is active)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color:  focusColor??Theme.of(context).colorScheme.onPrimary, // 👈 your focus color here
            ),
          ),
          errorStyle: theme.textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.error,
            backgroundColor: Colors.transparent,
          ),

          // ✅ Clear contrast + support for color-blindness
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            fontSize: theme.textTheme.bodyMedium?.fontSize ?? 16.iY,
            overflow: TextOverflow.ellipsis,
            color: hintTextColor??Theme.of(context).colorScheme.onPrimary,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),

        // ✅ Dynamic font scaling for accessibility
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: theme.textTheme.bodyMedium?.fontSize ?? 16.iY,
          overflow: TextOverflow.ellipsis,
          color: labelTextColor??Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
