import 'package:flutter/cupertino.dart';
import 'package:kodi/feat/listings/categories/categories_controller.dart';
import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:kodi/utils/app_pref_keys.dart';
import 'package:local_storage/local_storage.dart';
import 'package:local_storage/preference_manager.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'account_state.dart';
import '../data/model/favorite_item_model.dart';
import '../data/model/service_item_model.dart';

final accountControllerProvider = NotifierProvider<AccountController, AccountState>(() {
  return AccountController();
});

class AccountController extends Notifier<AccountState> {
  late final PreferenceManager preferenceManager;
  late final CategoriesController categoriesController;

  @override
  AccountState build() {
    preferenceManager = ref.read(preferenceManagerProvider);
    categoriesController = ref.read(categoriesControllerProvider.notifier);
    return const AccountState();
  }

  Future<void> loadUserData() async {
    // Load dummy favorites data
    await categoriesController.loadCategory();
    final allCategory= categoriesController.getCategories();
    List<CategoryModel> favorites = [];
    allCategory.forEach((element) {
      if(element.isFavourite){
        favorites.add(element);
      }
    });

    // Load dummy services data
    final dummyServices = [
      const ServiceItem(
        id: '1',
        title: 'FEEDBACK',
        imageUrl: 'lib/feat/user/account/presentation/assets/feedback.png',
        color: '0xFFB0CB52',
      ),
      const ServiceItem(
        id: '2',
        title: 'ÖPNV',
        imageUrl: 'lib/feat/user/account/presentation/assets/transport.png',
        color: '0xFF455A6A',
      ),
    ];

    state = state.copyWith(favorites: favorites, services: dummyServices);
  }

  bool isLoggedIn() {
    bool? isLoggedIn = preferenceManager.getBool(AppPrefsKeys.isLoggedIn);
    return isLoggedIn;
  }
}
