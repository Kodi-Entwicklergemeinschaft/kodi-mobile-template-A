part of '../common_components.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    required this.label,
    required this.controller,
    this.onClear,
    this.onDone,
    super.key,
  });
  final String label;
  final TextEditingController controller;
  final VoidCallback? onClear;
  final ValueChanged<String>? onDone;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  void initState() {
    super.initState();
    // Add a listener to rebuild the widget when text changes.
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed.
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    // This will trigger a rebuild of the widget to show/hide the clear button.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      prefixIcon: CommonIcon(
        icon: Icons.search,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      suffixIcon: widget.controller.text.isNotEmpty
          ? CommonIcon(
              icon: Icons.clear,
              onPressed: () {
                widget.controller.clear();
                FocusScope.of(context).unfocus();
                if (widget.onClear != null) {
                  widget.onClear!();
                }
              },
              color: Theme.of(context).colorScheme.onPrimary,
            )
          : null,
      label: widget.label,
      fillColor: Theme.of(context).colorScheme.surface,
      controller: widget.controller,
      onSubmitted: (value) {
        widget.onDone?.call(value);
      },
    );
  }
}
