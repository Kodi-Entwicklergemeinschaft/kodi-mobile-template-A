import 'package:shared_dependencies/equatable.dart';
import 'package:kodi/utils/enums/StateEnum.dart';

import '../data/model/category_filter_response_model.dart';

class CategoryFilterState extends Equatable {
  const CategoryFilterState({
    this.status = StateEnum.initial,
    this.filterGroups,
    this.selectedFilterIds,
    this.errorMessage,
  });

  final StateEnum status;
  final List<FilterGroup>? filterGroups;
  final List<String>? selectedFilterIds;
  final String? errorMessage;

  CategoryFilterState copyWith({
    StateEnum? status,
    List<FilterGroup>? filterGroups,
    List<String>? selectedFilterIds,
    String? errorMessage,
    bool? clearErrorMessage,
  }) {
    return CategoryFilterState(
      status: status ?? this.status,
      filterGroups: filterGroups ?? this.filterGroups,
      selectedFilterIds: selectedFilterIds ?? this.selectedFilterIds,
      errorMessage: clearErrorMessage == true
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    filterGroups,
    selectedFilterIds,
    errorMessage,
  ];
}
