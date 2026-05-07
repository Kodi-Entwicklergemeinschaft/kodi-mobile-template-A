import 'package:kodi/utils/enums/StateEnum.dart';
import '../../data/model/category_model.dart';
import '../../data/model/listing_model.dart';

class SearchListingsState {
  final StateEnum status;
  final List<ListingModel> listings;

  final bool hasReachedMax;
  final int page;
  final String? errorMessage;

  SearchListingsState({

    this.status = StateEnum.initial,
    this.listings = const <ListingModel>[],
    this.hasReachedMax = false,
    this.page = 1,
    this.errorMessage,
  });

  SearchListingsState copyWith({
    StateEnum? status,
    List<ListingModel>? listings,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
  }) {
    return SearchListingsState(
      status: status ?? this.status,
      listings: listings ?? this.listings,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
