import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kodi/feat/filter/controller/category_filter_controller.dart';
import 'package:kodi/feat/filter/data/model/category_filter_response_model.dart';
import 'package:locale/locale.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/extension/app_container_colors.dart';
import 'package:theme/extension/app_text_colors.dart';
import 'package:theme/theme.dart';

import '../../../utils/enums/StateEnum.dart';
import 'filter_controller.dart';

/// Shows the date-range / category-filter bottom sheet.
///
/// When [categoryId] is provided the sheet also loads and displays the
/// category quick-filters for that category.
///
/// Set [showDateFilters] to `false` to hide the date/time picker sections
/// (e.g. for non-event categories that only support category quick-filters).
///
/// Returns a [Map] with `'start'` / `'end'` on apply, or `null` on dismiss.
Future<Map<String, DateTime?>?> showDateRangeFilterBottomSheet({
  required BuildContext context,
  required String id,
  String? categoryId,
  bool showDateFilters = true,
}) {
  return showModalBottomSheet<Map<String, DateTime?>?>(
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
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: DateRangeFilterSheet(
          id: id,
          categoryId: categoryId,
          showDateFilters: showDateFilters,
        ),
      );
    },
  );
}

/// The bottom-sheet content widget.
///
/// When [categoryId] is non-null the sheet renders an additional
/// category-filter section.
///
/// When [showDateFilters] is `false` the date/time picker rows and quick-range
/// chips are hidden, leaving only the category quick-filters.
class DateRangeFilterSheet extends ConsumerStatefulWidget {
  final String id;
  final String? categoryId;
  final bool showDateFilters;

  const DateRangeFilterSheet({
    super.key,
    required this.id,
    this.categoryId,
    this.showDateFilters = true,
  });

  @override
  ConsumerState<DateRangeFilterSheet> createState() =>
      _DateRangeFilterSheetState();
}

class _DateRangeFilterSheetState extends ConsumerState<DateRangeFilterSheet> {
  // ── Date state ───────────────────────────────────────────────────────────
  DateTime? _start;
  DateTime? _end;
  final DateFormat _fmt = DateFormat('yyyy-MM-dd');
  int? _choiceChipSelection;

  // ── Category-filter state (used only when categoryId is provided) ────────
  final Set<String> _selectedFilterIds = {};
  bool _isReset = false;

  bool get _hasCategoryFilter => widget.categoryId != null;

  @override
  void initState() {
    super.initState();

    // Restore previous date selections and chip selection.
    final filterState = ref.read(listingsFiltersControllerProvider);
    _start = filterState.startDate;
    _end = filterState.endDate;
    _choiceChipSelection = filterState.selectedChipIndex;

    if (_hasCategoryFilter) {
      // Restore previously applied category filter selections.
      final catState = ref.read(categoryFilterControllerProvider);
      if (catState.selectedFilterIds != null) {
        _selectedFilterIds.addAll(catState.selectedFilterIds!);
      }

      // Load the filter groups for the given category.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(categoryFilterControllerProvider.notifier)
            .loadCategoryFilter(categoryId: widget.categoryId!);
      });
    }
  }

  String _displayDate(DateTime? d) =>
      d == null ? 'not_set'.tr(context) : _fmt.format(d);

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      builder: (context, child) => child!,
      initialDate: _start ?? (_end ?? now),
      firstDate: now,
      lastDate: _end ?? DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() {
        _choiceChipSelection = null;
        _start = picked;
        if (_end != null && _start!.isAfter(_end!)) _end = null;
      });
    }
  }

  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      builder: (context, child) => child!,
      initialDate: _end ?? (_start ?? now),
      firstDate: _start ?? now,
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() {
        _choiceChipSelection = null;
        _end = _endOfDay(picked);
        if (_start != null && _end!.isBefore(_start!)) _start = null;
      });
    }
  }

  DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

  void _toggleFilter(String id, bool? value) {
    setState(() {
      value == true ? _selectedFilterIds.add(id) : _selectedFilterIds.remove(id);
    });
  }

  void _apply() {
    if (_start != null && _end != null && _start!.isAfter(_end!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CommonText(titleText: 'error_start_after_end'.tr(context)),
        ),
      );
      return;
    }

    // Commit date range and chip selection.
    ref
        .read(listingsFiltersControllerProvider.notifier)
        .updateDateRange(_start, _end, selectedChipIndex: _choiceChipSelection);

    // Commit category filters when applicable.
    if (_hasCategoryFilter) {
      ref
          .read(categoryFilterControllerProvider.notifier)
          .applyFilters(_selectedFilterIds.toList());
    }

    Navigator.of(context).pop({'start': _start, 'end': _end});
  }

  void _reset() {
    ref.read(listingsFiltersControllerProvider.notifier).resetDateRange();

    if (_hasCategoryFilter) {
      ref.read(categoryFilterControllerProvider.notifier).resetFilters();
    }

    setState(() {
      _choiceChipSelection = null;
      _start = null;
      _end = null;
      _selectedFilterIds.clear();
      _isReset = true;
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16.iX,
              right: 16.iX,
              top: 16.iY,
            ),
            child: Column(
              spacing: 10.iY,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: CommonText(
                        titleText: widget.showDateFilters
                            ? 'f_by_date'.tr(context)
                            : 'filter'.tr(context),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 24.iY,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .extension<AppTextColors>()
                                  ?.normal,
                            ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    TextButton(
                      onPressed: _reset,
                      child: CommonText(
                        titleText: 'reset'.tr(context),
                        overflow: TextOverflow.ellipsis,
                        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 18.iY,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),

                // ── Date & time pickers (events / Kodi Week only) ──────
                if (widget.showDateFilters) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CommonIcon(
                      icon: Icons.event,
                      label: 'common_icon_label'
                          .tr(context)
                          .replaceAll('{itemName}', "date".tr(context)),
                    ),
                    title: CommonText(
                      titleText: '${'start_date'.tr(context)},',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 20.iY),
                    ),
                    subtitle: CommonText(
                      overflow: TextOverflow.ellipsis,
                      titleText: _displayDate(_start),
                      textAlign: TextAlign.start,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 18.iY),
                    ),
                    trailing: TextButton(
                      onPressed: _pickStartDate,
                      child: CommonText(
                        overflow: TextOverflow.ellipsis,
                        titleText: 'select'.tr(context),
                        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 18.iY,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    onTap: _pickStartDate,
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CommonIcon(
                      icon: Icons.event_note,
                      label: 'common_icon_label'
                          .tr(context)
                          .replaceAll('{itemName}', "date".tr(context)),
                    ),
                    title: CommonText(
                      titleText: '${'end_date'.tr(context)},',
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 20.iY),
                    ),
                    subtitle: CommonText(
                      titleText: _displayDate(_end),
                      textAlign: TextAlign.start,
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 18.iY),
                    ),
                    trailing: TextButton(
                      onPressed: _pickEndDate,
                      child: CommonText(
                        titleText: 'select'.tr(context),
                        overflow: TextOverflow.ellipsis,
                        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 18.iY,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    onTap: _pickEndDate,
                  ),

                  CommonText(
                    titleText: '${'quick_ranges'.tr(context)}:',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18.iY,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Wrap(
                    spacing: 16.iX,
                    children: [
                      _quickChip(
                        label: 'l_7d'.tr(context),
                        index: 1,
                        onSelect: () {
                          _start = DateTime.now();
                          _end = DateTime.now().add(const Duration(days: 7));
                        },
                      ),
                      _quickChip(
                        label: 'l_30d'.tr(context),
                        index: 2,
                        onSelect: () {
                          _start = DateTime.now();
                          _end = DateTime.now().add(const Duration(days: 30));
                        },
                      ),
                      _quickChip(
                        label: 't_month'.tr(context),
                        index: 3,
                        onSelect: () {
                          final now = DateTime.now();
                          _start = DateTime(now.year, now.month, 1);
                          _end = DateTime(now.year, now.month + 1, 0);
                        },
                      ),
                    ],
                  ),
                ],

                // ── Category quick-filters ─────────────────────────────
                if (_hasCategoryFilter) ..._buildCategoryFiltersSection(),

                SizedBox(height: 10.iY),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(16.iX, 8.iY, 16.iX, 24.iY),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () {
                    ref
                        .read(listingsFiltersControllerProvider.notifier)
                        .resetDateRange();
                    Navigator.of(context).pop({'start': _start, 'end': _end});
                  },
                  child: CommonText(
                    titleText: 'cancel'.tr(context),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18.iY,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: (_start == null && _end == null && !_isReset &&
                          (_hasCategoryFilter
                              ? _selectedFilterIds.isEmpty
                              : true))
                      ? null
                      : _apply,
                  child: CommonText(
                    titleText: 'apply'.tr(context),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18.iY,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quickChip({
    required String label,
    required int index,
    required VoidCallback onSelect,
  }) {
    final selected = _choiceChipSelection == index;
    return ChoiceChip(
      backgroundColor:
          Theme.of(context).extension<AppContainerColors>()?.inverse,
      checkmarkColor: selected
          ? Theme.of(context).extension<AppTextColors>()?.inverse
          : Theme.of(context).extension<AppTextColors>()?.normal,
      label: CommonText(
        titleText: label,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 18.iY,
              color: selected
                  ? Theme.of(context).extension<AppTextColors>()?.inverse
                  : Theme.of(context).extension<AppTextColors>()?.normal,
            ),
      ),
      selected: selected,
      onSelected: (_) {
        setState(() {
          _choiceChipSelection = index;
          onSelect();
        });
      },
    );
  }

  List<Widget> _buildCategoryFiltersSection() {
    final catState = ref.watch(categoryFilterControllerProvider);
    final groups = catState.filterGroups ?? [];

    return [
      const Divider(),
      if (widget.showDateFilters)
        CommonText(
          titleText: 'filter'.tr(context),
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20.iY,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).extension<AppTextColors>()?.normal,
              ),
        ),
      if (catState.status == StateEnum.loading)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(child: CircularProgressIndicator()),
        )
      else if (groups.isEmpty)
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.iY),
          child: Center(
            child: CommonText(
              titleText: 'no_filters_available'.tr(context),
              textAlign: TextAlign.center,
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.iY,
                    color: Theme.of(context).extension<AppTextColors>()?.normal,
                  ),
            ),
          ),
        )
      else
        ...groups.map((group) => _buildFilterGroup(group)),
    ];
  }

  Widget _buildFilterGroup(FilterGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (group.name != null)
          Padding(
            padding: EdgeInsets.only(top: 12.iY, bottom: 4.iY),
            child: CommonText(
              titleText: group.name!,
              textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ...(group.headings ?? []).map((heading) => _buildHeading(heading)),
      ],
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
              textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
            ),
          ),
        ...(heading.filters ?? []).map((item) {
          final id = item.id ?? '';
          final label = item.displayName ?? item.label ?? item.value ?? '';
          return CheckboxListTile(
            value: _selectedFilterIds.contains(id),
            contentPadding: EdgeInsets.zero,
            title: CommonText(
              titleText: label,
              textAlign: TextAlign.start,
              textStyle: const TextStyle(fontSize: 14),
            ),
            onChanged: (value) => _toggleFilter(id, value),
          );
        }),
        const Divider(),
      ],
    );
  }
}
