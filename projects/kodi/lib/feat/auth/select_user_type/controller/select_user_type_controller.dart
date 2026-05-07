import 'package:local_storage/preference_manager.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:shared_dependencies/device_and_app_info.dart';
import 'select_user_type_state.dart';
import 'package:kodi/utils/app_pref_keys.dart';
import 'package:local_storage/local_storage.dart';

final selectUserTypeProvider =
    NotifierProvider<SelectUserTypeController, SelectUserTypeState>(() {
      return SelectUserTypeController();
    });

class SelectUserTypeController extends Notifier<SelectUserTypeState> {
  late final PreferenceManager preferenceManager;

  @override
  SelectUserTypeState build() {
    preferenceManager = ref.read(preferenceManagerProvider);
    return SelectUserTypeState();
  }

  void selectUserType(int value) async {
    state = SelectUserTypeSuccess(UserTypeEnumX.fromInt(value));
  }

  void resetState() {
    state = SelectUserTypeState();
  }

  UserTypeEnum? getUserType() {
    if(state is SelectUserTypeSuccess){
      return (state as SelectUserTypeSuccess).type;
    }
    return null;
  }
}
