import 'package:kodi/feat/listings/data/model/category_model.dart';

class CategoriesState {
  final List<CategoryModel> listOfCategory;

  CategoriesState({this.listOfCategory = const <CategoryModel>[]});

  CategoriesState copyWith({List<CategoryModel>? listOfCategory}) {
    return CategoriesState(
      listOfCategory: listOfCategory ?? this.listOfCategory,
    );
  }
}
