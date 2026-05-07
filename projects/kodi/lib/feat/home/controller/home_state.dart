import 'package:kodi/feat/home/data/model/city_model.dart';
import 'package:kodi/feat/home/data/model/service_model.dart';
import 'package:kodi/feat/home/data/model/tile_response_model.dart';
import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:shared_dependencies/geolocator.dart';

import '../../listings/data/model/listing_model.dart';

class HomeState {
  final bool? isLoading;
  final String? headerImage;
  final List<CityModel>? cityList;
  final List<ListingModel>? eventList;
  final List<ServiceModel>? importantServicesList;
  final CategoryModel? shoppingList;
  final List<TileModel>? giftVoucherList;
  final CategoryModel? foodAndDrinkServices;
  final List<CategoryModel>? administrationServices;
  final List<CategoryModel>? category;
  final Position? currentLocation;


  HomeState({
    this.isLoading,
    this.headerImage,
    this.cityList,
    this.eventList,
    this.importantServicesList,
    this.shoppingList,
    this.giftVoucherList,
    this.foodAndDrinkServices,
    this.administrationServices,
    this.category,
    this.currentLocation,
  });

  HomeState copyWith({
    bool? isLoading,
    String? headerImage,
    List<CityModel>? cityList,
    List<ListingModel>? eventList,
    List<ServiceModel>? importantServicesList,
    CategoryModel? shoppingList,
    List<TileModel>? giftVoucherList,
    CategoryModel? foodAndDrinkServices,
    List<CategoryModel>? administrationServices,
    List<CategoryModel>? category,
    Position? currentLocation,
  }) {
    return HomeState(
      isLoading: isLoading,
      headerImage: headerImage ?? this.headerImage,
      cityList: cityList ?? this.cityList,
      eventList: eventList ?? this.eventList,
      importantServicesList:
          importantServicesList ?? this.importantServicesList,
      shoppingList: shoppingList ?? this.shoppingList,
      giftVoucherList: giftVoucherList ?? this.giftVoucherList,
      foodAndDrinkServices:
          foodAndDrinkServices ?? this.foodAndDrinkServices,
      category: category ?? this.category,
      currentLocation: currentLocation ?? this.currentLocation,
      administrationServices: administrationServices ?? this.administrationServices,
    );
  }
}
