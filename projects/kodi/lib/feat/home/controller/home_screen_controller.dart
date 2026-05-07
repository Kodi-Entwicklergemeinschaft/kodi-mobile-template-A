
import 'package:kodi/feat/city/controller/city_controller.dart';
import 'package:kodi/feat/home/controller/home_state.dart';
import 'package:kodi/feat/home/data/model/city_model.dart';
import 'package:kodi/feat/home/data/model/service_model.dart';
import 'package:kodi/feat/listings/categories/categories_controller.dart';
import 'package:shared_dependencies/riverpod.dart';
import '../../../utils/common_methods.dart';
import '../../listings/data/model/category_model.dart';
import '../../listings/data/repo/listings_repository.dart';
import '../../listings/events/controller/event_controller.dart';
import '../data/repo/home_repository.dart';


final homeControllerProvider= NotifierProvider.autoDispose<HomeController, HomeState>(() => HomeController());


class HomeController extends Notifier<HomeState>{
  late final ListingsRepository listingRepository;
  late final CategoriesController categoriesController;
  late final EventController eventController;
  late final HomeRepository homeRepository;
  late final CityController cityController;


  @override
  HomeState build() {
    cityController = ref.read(cityControllerProvider.notifier);
    listingRepository = ref.read(listingRepositoryImplProvider);
    eventController = ref.read(eventControllerProvider.notifier);
    homeRepository = ref.read(homeRepositoryImplProvider);
    categoriesController = ref.read(categoriesControllerProvider.notifier);
    return HomeState();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    CommonMethods().getCurrentLocation().then((location){
      state = state.copyWith(currentLocation: location);
    });
    await getCategories();
    getCategoryOfActivities();
    loadRecentEvents();
    loadTilesList();

    return Future.delayed(const Duration(seconds: 2)).then((value) {
      state = state.copyWith(
          isLoading: false,
          headerImage: "https://kodi.nbg1.your-objectstorage.com/cities/424f0ad6-2916-4f07-87d0-cea34a883456/header.webp",
          );
    });
  }

  getCurrentLocation(){
    return state.currentLocation;
  }

  getCategories() async {
    await categoriesController.loadCategory();
    state = state.copyWith(category: categoriesController.getFilteredCategories());
  }

  loadRecentEvents(){
    if(state.category!=null) {
      final eventCategory= categoriesController.getCategorySlugByEnum(CategorySlug.events);
      if(eventCategory!=null) {
        eventController.loadRecentEvents(eventCategory.id);
      }
      ref.read(eventControllerProvider.notifier).updateCategory();

    }
  }

  getCategoryOfActivities() {
    if(state.category!=null) {
      if(state.category!=null) {
        for (final category in state.category!) {
          if(category.slug==CategorySlug.shopping) {
            state= state.copyWith(shoppingList: category);
          }
          if(category.slug==CategorySlug.foodAndDrink) {
            state= state.copyWith(foodAndDrinkServices: category);
          }
          // if(category.slug==CategorySlug.administration) {
          //   state = state.copyWith(administrationServices: category);
          // }
        }
        state = state.copyWith(administrationServices: categoriesController
            .getAdministrationServices());
      }
    }
  }



  loadTilesList() async {
    final response= await homeRepository.getTiles();
    response.fold((l){
      state = state.copyWith(isLoading: false);
    },(r){
      if(r.success==true) {
        final tileList = r.data?.items;
        state = state.copyWith(giftVoucherList: tileList);
      }
      else{
        state = state.copyWith(isLoading: false);
      }
    });
  }

}