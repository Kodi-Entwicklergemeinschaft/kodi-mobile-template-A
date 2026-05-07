import 'package:equatable/equatable.dart';
import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:kodi/utils/enums/StateEnum.dart';

import '../../data/model/listing_model.dart';




class EventState extends Equatable {
  const EventState({
    this.status = StateEnum.initial,
    this.events = const <ListingModel>[],
    this.recentEvents,
    this.categoryModel,
    this.hasReachedMax = false,
    this.page = 1,
    this.errorMessage,
    this.selectedSubCategoryId,
    this.selectedSubCategory,

  });

  final StateEnum status;
  final List<ListingModel> events;
  final List<ListingModel>? recentEvents;
  final CategoryModel? categoryModel;
  final CategoryModel? selectedSubCategory;
  final String? selectedSubCategoryId;
  final bool hasReachedMax;
  final int page;
  final String? errorMessage;

  EventState copyWith({
    StateEnum? status,
    List<ListingModel>? events,
    List<ListingModel>? recentEvents,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
    bool? clearErrorMessage,
    CategoryModel? categoryModel,
    String? selectedSubCategoryId,
    CategoryModel? selectedSubCategory,
  }) {
    return EventState(
      status: status ?? this.status,
      events: events ?? this.events,
      recentEvents: recentEvents ?? this.recentEvents,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: clearErrorMessage == true ? null : errorMessage ?? this.errorMessage,
      categoryModel: categoryModel ?? this.categoryModel,
      selectedSubCategoryId: selectedSubCategoryId ?? this.selectedSubCategoryId,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory ,
    );
  }

  @override
  List<Object?> get props => [status, events, recentEvents, hasReachedMax, page, errorMessage, categoryModel, selectedSubCategoryId, selectedSubCategory];
}
