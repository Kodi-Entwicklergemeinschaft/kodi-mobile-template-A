import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:kodi/utils/enums/StateEnum.dart';

class KodiWeekState {
  final CategoryModel? category;
  final StateEnum status;

  KodiWeekState({
    this.category,
    this.status = StateEnum.initial,
  });

  KodiWeekState copyWith({
    CategoryModel? category,
    StateEnum? status,
  }) {
    return KodiWeekState(
      category: category ?? this.category,
      status: status ?? this.status,
    );
  }
}