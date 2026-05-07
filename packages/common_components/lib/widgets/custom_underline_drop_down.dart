part of '../common_components.dart';


class CustomUnderlinedDropdown extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final bool isExpanded;
  final Widget? suffixIcon;

  const CustomUnderlinedDropdown({
    super.key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isExpanded = true,
    this.suffixIcon
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: isExpanded,
      dropdownColor: Theme.of(context).extension<AppContainerColors>()!.inverse,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).extension<AppContainerColors>()!.inverse,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 10,color: Theme.of(context).hintColor),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 2,color: Theme.of(context).extension<AppContainerColors>()!.normal,),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide( width: 2,color: Theme.of(context).extension<AppContainerColors>()!.normal,),
        ),
      ),
      icon: suffixIcon,
      style: TextStyle( fontSize: 16,color: Theme.of(context).extension<AppContainerColors>()!.normal),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: CommonText( titleText: item,textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).extension<AppTextColors>()!.normal,
          ),),
        );
      }).toList(),

      onChanged: onChanged,
    );
  }
}
