import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:kodi/feat/listings/kodi_week/controller/kodi_week_state.dart';
import 'package:kodi/utils/enums/StateEnum.dart';
import 'package:shared_dependencies/riverpod.dart';

final kodiWeekControllerProvider =
    NotifierProvider.autoDispose<KodiWeekController, KodiWeekState>(
      () => KodiWeekController(),
    );

class KodiWeekController extends Notifier<KodiWeekState> {
  @override
  KodiWeekState build() => KodiWeekState();

  void setCategory(CategoryModel category) {
    state = state.copyWith(
      category: category,
      status: StateEnum.success,
    );
  }
}