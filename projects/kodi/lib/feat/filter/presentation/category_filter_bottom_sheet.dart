import 'package:common_components/common_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:locale/locale.dart';

import '../../../utils/enums/StateEnum.dart';
import '../controller/category_filter_controller.dart';
import '../data/model/category_filter_response_model.dart';

Future<List<String>?> showCategoryFilterBottomSheet({

  required BuildContext context,
  required String categoryId,
}) {
  return showModalBottomSheet<List<String>?>(
    context: context,
    enableDrag: true,
    showDragHandle: true,
    useSafeArea: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.9,
    ),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: CategoryFilterSheet(
          categoryId: categoryId,
          // state: state,
          // stateNotifier: stateNotifier,
        ),
      );
    },
  );
}
class CategoryFilterSheet extends ConsumerStatefulWidget {
  final String categoryId;
  // final CategoryFilterState state;
  // final CategoryFilterController stateNotifier;


  const CategoryFilterSheet({
    super.key,
    required this.categoryId,
    // required this.state,
    // required this.stateNotifier
  });

  @override
  ConsumerState<CategoryFilterSheet> createState() =>
      _CategoryFilterSheetState();
}

class _CategoryFilterSheetState
    extends ConsumerState<CategoryFilterSheet> {
  final Set<String> _selectedIds = {};
  bool _isReset = false;


  @override
  void initState() {
    super.initState();

    final state = ref.read(categoryFilterControllerProvider);
    final stateNotifier = ref.read(categoryFilterControllerProvider.notifier);


    if (state.selectedFilterIds != null) {
      _selectedIds.addAll(state.selectedFilterIds!);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      stateNotifier.loadCategoryFilter(categoryId: widget.categoryId);
    });
  }


  // @override
  // void initState() {
  //   super.initState();
  //
  //   final state = ref.read(categoryFilterControllerProvider);
  //
  //   // if (state.filterGroups == null) {
  //   //   ref
  //   //       .read(categoryFilterControllerProvider.notifier)
  //   //       .loadCategoryFilter(categoryId: widget.categoryId);
  //   // }
  //
  //   Future.microtask((){
  //     ref
  //         .read(categoryFilterControllerProvider.notifier)
  //         .loadCategoryFilter(categoryId: widget.categoryId);
  //   });
  //
  //
  //   if (state.selectedFilterIds != null) {
  //     _selectedIds.addAll(state.selectedFilterIds!);
  //   }
  // }

  void _toggle(String id, bool? value) {
    setState(() {
      if (value == true) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    });
  }

  void _reset() {
    setState(() {
      _selectedIds.clear();
      _isReset = true;
    });
  }

  void _apply() {
    final ids = _selectedIds.toList();

    ref
        .read(categoryFilterControllerProvider.notifier).applyFilters(ids);

    // ref
    //     .read(categoryFilterControllerProvider.notifier)
    //     .state = ref
    //     .read(categoryFilterControllerProvider)
    //     .copyWith(selectedFilterIds: ids);

    Navigator.of(context).pop(ids);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryFilterControllerProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.iX, vertical: 16.iY),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Header
          Row(
            children: [
              Expanded(
                child: CommonText(
                  titleText: 'filter'.tr(context),
                  textAlign: TextAlign.start,
                  textStyle: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontSize: 24.iY,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: _reset,
                child: CommonText(
                  titleText: 'reset'.tr(context),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Content
          Expanded(
            child: Builder(
              builder: (_) {
                if (state.status == StateEnum.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.status == StateEnum.error) {
                  return Center(
                    child: CommonText(
                      titleText: state.errorMessage ?? 'Error',
                    ),
                  );
                }

                final groups = state.filterGroups ?? [];

                return ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, groupIndex) {
                    final group = groups[groupIndex];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (group.name != null)
                          Padding(
                            padding: EdgeInsets.only(
                                top: 12.iY, bottom: 4.iY),
                            child: CommonText(
                              titleText: group.name!,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                        ...(group.headings ?? [])
                            .map((heading) => _buildHeading(heading))
                            .toList(),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          /// Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final ids = _selectedIds.toList();

                    if(ids.isNotEmpty){
                      Navigator.pop(context);
                    } else {
                      // ref
                      //     .read(categoryFilterControllerProvider.notifier)
                      //     .state = ref
                      //     .read(categoryFilterControllerProvider)
                      //     .copyWith(selectedFilterIds: ids);

                      ref
                          .read(categoryFilterControllerProvider.notifier).applyFilters(ids);

                      Navigator.of(context).pop(ids);
                    }
                  },
                  child: CommonText(titleText: 'cancel'.tr(context)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  // onPressed: _selectedIds.isEmpty ? null : _apply,
                  onPressed: (_selectedIds.isEmpty && !_isReset) ? null : _apply,
                  child: CommonText(
                    titleText: 'apply'.tr(context),
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeading(Heading heading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading.name != null)
          Padding(
            padding: EdgeInsets.only(top: 8.iY, bottom: 4.iY),
            child: CommonText(
              titleText: heading.name!,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ...(heading.filters ?? []).map((item) {
          final id = item.id ?? '';
          final label =
              item.displayName ?? item.label ?? item.value ?? '';

          return CheckboxListTile(
            value: _selectedIds.contains(id),
            contentPadding: EdgeInsets.zero,
            title: CommonText(titleText: label, textAlign: TextAlign.start,textStyle: TextStyle(fontSize: 14),),
            onChanged: (value) => _toggle(id, value),
          );
        }),
        Divider()
      ],
    );
  }
}
