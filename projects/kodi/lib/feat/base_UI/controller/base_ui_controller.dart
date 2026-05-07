import 'package:local_storage/preference_manager.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:shared_dependencies/device_and_app_info.dart';
import 'base_ui_state.dart';
import 'package:kodi/utils/app_pref_keys.dart';
import 'package:local_storage/local_storage.dart';

final baseUIProvider = NotifierProvider<BaseUIController, BaseUIState>(() {
  return BaseUIController();
});

class BaseUIController extends Notifier<BaseUIState> {
  late final PreferenceManager preferenceManager;

  @override
  BaseUIState build() {
    preferenceManager = ref.read(preferenceManagerProvider);
    return BaseUIState();
  }

  startLoading(){
    state = BaseUILoading();
  }

  startStackLoading(){
    state = BaseUIStackLoading();
  }

  success(){
    state = BaseUISuccess();
  }

  error(){
    state = BaseUIError();
  }
}
