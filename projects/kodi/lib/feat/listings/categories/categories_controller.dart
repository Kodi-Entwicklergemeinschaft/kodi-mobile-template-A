import 'package:kodi/feat/city/controller/city_controller.dart';
import 'package:kodi/utils/app_pref_keys.dart';
import 'package:local_storage/preference_manager.dart';
import 'package:local_storage/preference_manager_impl.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../../auth/select_user_type/controller/select_user_type_controller.dart';
import '../../auth/select_user_type/controller/select_user_type_state.dart';
import '../data/model/category_model.dart';
import '../data/repo/listings_repository.dart';
import 'categories_state.dart';

final categoriesControllerProvider =
    NotifierProvider<CategoriesController, CategoriesState>(
      () => CategoriesController(),
    );

class CategoriesController extends Notifier<CategoriesState> {
  late final ListingsRepository listingRepository;
  late final PreferenceManager preferenceManager;
  late final CityController cityController;
  late final UserTypeEnum? _userTypeEnum;

  @override
  CategoriesState build() {
    cityController = ref.read(cityControllerProvider.notifier);
    listingRepository = ref.read(listingRepositoryImplProvider);
    preferenceManager = ref.read(preferenceManagerProvider);
    return CategoriesState();
  }

  Future<void> loadCategory() async {
    final cityId = cityController.getCityId();

    final response = await listingRepository.getCategories(cityId: cityId);
    response.fold((ifLeft) {}, (ifRight) {
      if (ifRight.data != null) {
        ifRight.data!.sort((a, b) {
          final aOrder = a.cityCategoryDisplayOrder;
          final bOrder = b.cityCategoryDisplayOrder;
          if (aOrder == null && bOrder == null) return 0;
          if (aOrder == null) return 1; // a comes after b
          if (bOrder == null) return -1; // b comes after a
          return aOrder.compareTo(bOrder);
        });
        state = state.copyWith(listOfCategory: ifRight.data);
      }
    });
  }

  getCategories() {
    return state.listOfCategory;
  }

  getFilteredCategories() {
    List<CategoryModel> filteredCategories = [];

    for (final category in state.listOfCategory) {
      if (category.slug != CategorySlug.events) {
        filteredCategories.add(category);
      }
    }
    return filteredCategories;
  }

  CategoryModel? getCategorySlugByEnum(CategorySlug type) {
    for (final category in state.listOfCategory) {
      if (category.slug == type) {
        return category;
      }
    }
    return null;
  }

  List<CategoryModel> getAdministrationServices() {
    List<CategoryModel> administrationServices = [];
    administrationServices.addAll([
      CategoryModel(
        id: 'sdf-sdf94-1',
        name: "id_registration_matters",
        slugString: 'administration',
        slug: CategorySlug.administration,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        children: [],
        cityCategoryDisplayOrder: 1,
        imageUrl: 'assets/images/verwaltung/ausweise.webp',
        onTapUrl: "https://terminvergabe.kodi.de/tevis-ema/",
      ),
      CategoryModel(
        id: 'sdf-sdf94-2',
        name: 'immigration',
        slugString: 'administration',
        slug: CategorySlug.administration,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        children: [],
        cityCategoryDisplayOrder: 2,
        imageUrl: 'assets/images/verwaltung/zuwanderung.webp',
        onTapUrl: "https://terminvergabe.kodi.de/tevis-zuwanderung/",
      ),
      CategoryModel(
        id: 'sdf-sdf94-3',
        name: "vehicle_registrations_driving_licenses",
        slugString: 'administration',
        slug: CategorySlug.administration,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        children: [],
        cityCategoryDisplayOrder: 3,
        imageUrl: 'assets/images/verwaltung/fahrzeug.webp',
        onTapUrl: "https://terminvergabe-ema-zulassung.kodi.de/tevisema/",
      ),
      CategoryModel(
        id: 'sdf-sdf94-4',
        name: 'registry_office',
        slugString: 'administration',
        slug: CategorySlug.administration,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        children: [],
        cityCategoryDisplayOrder: 4,
        imageUrl: 'assets/images/verwaltung/standesamt.webp',
        onTapUrl: "https://terminvergabe.kodi.de/tevis-standesamt/",
      ),
      CategoryModel(
        id: 'sdf-sdf94-5',
        name: 'housing_benefit',
        slugString: 'administration',
        slug: CategorySlug.administration,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        children: [],
        cityCategoryDisplayOrder: 5,
        imageUrl: 'assets/images/verwaltung/wohngeld.webp',
        onTapUrl: "https://terminvergabe.kodi.de/tevis55/",
      ),
      CategoryModel(
        id: 'sdf-sdf94-6',
        name: 'youth_welfare_office',
        slugString: 'administration',
        slug: CategorySlug.administration,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        children: [],
        cityCategoryDisplayOrder: 6,
        imageUrl: 'assets/images/verwaltung/jugendamt.webp',
        onTapUrl: "https://terminvergabe.kodi.de/tevis-jugendamt/",
      ),
      CategoryModel(
        id: 'sdf-sdf94-7',
        name: 'building_records_archive',
        slugString: 'administration',
        slug: CategorySlug.administration,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        children: [],
        cityCategoryDisplayOrder: 7,
        imageUrl: 'assets/images/verwaltung/bauakten.webp',
        onTapUrl: "https://terminvergabe.kodi.de/tevis-va/",
      ),
      CategoryModel(
        id: 'sdf-sdf94-8',
        name: 'environmental_office',
        slugString: 'administration',
        slug: CategorySlug.administration,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        children: [],
        cityCategoryDisplayOrder: 8,
        imageUrl: 'assets/images/verwaltung/umweltamt.webp',
        onTapUrl: "https://terminvergabe.kodi.de/tevis-umweltamt/",
      ),
      CategoryModel(
        id: 'sdf-sdf94-8',
        name: 'pension_consulting',
        slugString: 'administration',
        slug: CategorySlug.administration,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        children: [],
        cityCategoryDisplayOrder: 8,
        imageUrl: 'assets/images/verwaltung/rentenberartung.webp',
        onTapUrl: "https://terminvergabe.kodi.de/tevis-rb/",
      ),
    ]);
    return administrationServices;
  }
}
