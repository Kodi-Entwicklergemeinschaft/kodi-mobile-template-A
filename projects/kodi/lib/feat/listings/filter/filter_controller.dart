import 'package:shared_dependencies/riverpod.dart';

final listingsFiltersControllerProvider =
NotifierProvider<ListingFiltersController, FilterListingsState>(
      () {
    return ListingFiltersController();
  },
);

class ListingFiltersController extends Notifier<FilterListingsState> {

  @override
  FilterListingsState build() {
    return FilterListingsState.initial();
  }

  void updateDateRange(DateTime? startDate, DateTime? endDate, {int? selectedChipIndex}) {
    state = state.copyWith(startDate: startDate, endDate: endDate, selectedChipIndex: selectedChipIndex);
  }

  void resetDateRange() {
    state = FilterListingsState.initial();
  }
}



class FilterListingsState {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? selectedChipIndex;

  FilterListingsState({this.startDate, this.endDate, this.selectedChipIndex});

  factory FilterListingsState.initial() {
    return FilterListingsState(
      startDate: null,
      endDate: null,
      selectedChipIndex: null,
    );
  }

  FilterListingsState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    Object? selectedChipIndex = _sentinel,
  }) {
    return FilterListingsState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedChipIndex: identical(selectedChipIndex, _sentinel)
          ? this.selectedChipIndex
          : selectedChipIndex as int?,
    );
  }
}

const Object _sentinel = Object();
