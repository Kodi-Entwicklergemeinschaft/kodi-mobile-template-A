import 'package:kodi/feat/auth/select_user_type/controller/select_user_type_controller.dart';
import 'package:kodi/feat/auth/select_user_type/controller/select_user_type_state.dart';
import 'package:shared_dependencies/riverpod.dart';


UserTypeEnum? userType(WidgetRef ref) {
  return ref.watch(
    selectUserTypeProvider.select((state) {
      if (state is SelectUserTypeSuccess) {
        return state.type;
      }
      return null;
    }),
  );
}