import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:kodi/feat/listings/data/model/listing_model.dart';
import 'package:kodi/utils/enums/StateEnum.dart';

class FavouriteState{
  final StateEnum status;
  final List<ListingModel> listOfFav;
  final CategoryModel? eventCategory;
  final bool hasReachedMax;
  final int page;
  final String? errorMessage;


  FavouriteState({
    this.status=StateEnum.initial,
    this.listOfFav=const[],
    this.eventCategory,
    this.hasReachedMax = false,
    this.page = 1,
    this.errorMessage,
  });


  FavouriteState copyWith({
    StateEnum? status,
    List<ListingModel>? listOfFav,
    CategoryModel? eventCategory,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
  }){
    return FavouriteState(
      status: status ?? this.status,
      listOfFav: listOfFav ?? this.listOfFav,
      eventCategory: eventCategory ?? this.eventCategory,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: errorMessage,
    );
  }

}