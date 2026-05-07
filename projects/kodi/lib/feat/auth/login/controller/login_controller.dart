import 'package:common_components/extensions/string_extension.dart';
import 'package:kodi/feat/auth/register_device/controller/register_device_conroller.dart';
import 'package:kodi/my_app.dart';
import 'package:local_storage/preference_manager.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:shared_dependencies/device_and_app_info.dart';
import '../data/model/request/device_info_request.dart';
import '../data/model/request/login_request.dart';
import '../data/model/response/login_response.dart';
import '../data/repo/login_repository.dart';
import 'login_state.dart';
import 'package:kodi/utils/app_pref_keys.dart';
import 'package:local_storage/local_storage.dart';

final loginProvider = NotifierProvider<LoginController, LoginState>(() {
  return LoginController();
});

class LoginController extends Notifier<LoginState> {
  late final LoginRepository loginRepository;
  late final PreferenceManager preferenceManager;
  late final RegisterDeviceController registerDeviceController;

  @override
  LoginState build() {
    loginRepository = ref.read(loginRepositoryImplProvider);
    preferenceManager = ref.read(preferenceManagerProvider);
    registerDeviceController = ref.read(
      registerDeviceControllerProvider.notifier,
    );
    return LoginState();
  }

  Future<void> login({required String email, required String password}) async {
    state = LoginLoading();
    final deviceInfo = await DeviceAndAppInfo.build();
    final response = await loginRepository.login(
      LoginRequest(email: email, password: password, deviceId: deviceInfo.deviceId),
    );
    response.fold(
      (l) {
        state = LoginError(l.toString());
      },
      (LoginResponse r) async {
        if (r.statusCode == 200) {
          if ((r.data!.accessToken).isNotNullAndEmpty &&
              (r.data!.refreshToken).isNotNullAndEmpty) {
            preferenceManager.saveString(
              AppPrefsKeys.token,
              r.data!.accessToken!,
            );
            preferenceManager.saveString(
              AppPrefsKeys.refreshToken,
              r.data!.refreshToken!,
            );
            preferenceManager.saveBool(
              AppPrefsKeys.isTermsAndConditionAccepted,
              !(r.data?.requiresTermsAcceptance ?? true),
            );
            if (r.data?.requiresTermsAcceptance == true) {
              preferenceManager.saveString(
                AppPrefsKeys.termsAndConditionId,
                r.data?.termsId ?? '',
              );
            }
            preferenceManager.saveBool(AppPrefsKeys.isLoggedIn, true);
            preferenceManager.saveBool(AppPrefsKeys.isGuestUser, false);
            preferenceManager.saveString(AppPrefsKeys.email, email);
            await registerDeviceController.registerDevice();
          } else {
            state = LoginError('');
          }
        }
        state = LoginSuccess();
      },
    );
  }

  Future<void> guestLogin() async {
    state = LoginLoading();
    DeviceAndAppInfo deviceAndAppInfo = await DeviceAndAppInfo.build();
    final response = await loginRepository.guestLogin(
      DeviceInfoRequest(
        deviceId: deviceAndAppInfo.deviceId,
        devicePlatform: deviceAndAppInfo.platform,
        deviceMetadata: DeviceMetadata(
          osVersion: deviceAndAppInfo.osVersion,
          appVersion: deviceAndAppInfo.appVersion,
          deviceModel: deviceAndAppInfo.deviceModel,
        ),
      ),
    );
    response.fold(
      (l) {
        state = GuestLoginError(l.toString());
      },
      (LoginResponse r) async {
        if (r.statusCode == 200) {
          if ((r.data!.accessToken).isNotNullAndEmpty &&
              (r.data!.refreshToken).isNotNullAndEmpty){
            preferenceManager.saveString(
              AppPrefsKeys.token,
              r.data!.accessToken!,
            );
            preferenceManager.saveString(
              AppPrefsKeys.refreshToken,
              r.data!.refreshToken!,
            );
            preferenceManager.saveBool(
              AppPrefsKeys.isTermsAndConditionAccepted,
              !(r.data?.requiresTermsAcceptance ?? true),
            );
            if (r.data?.requiresTermsAcceptance == true) {
              preferenceManager.saveString(
                AppPrefsKeys.termsAndConditionId,
                r.data?.termsId ?? '',
              );
            }
            preferenceManager.saveBool(AppPrefsKeys.isGuestUser, true);
            await registerDeviceController.registerDevice();
            state = GuestLoginSuccess();
          }
        }
        state = LoginError('');
      },
    );
  }

  Future<void> logout() async {
    await registerDeviceController.unregisterDevice();
    ref.read(messagingServiceProvider).firebaseDeleteToken();
    await preferenceManager.removePreference(AppPrefsKeys.token);
    await preferenceManager.removePreference(AppPrefsKeys.refreshToken);
    await preferenceManager.removePreference(
      AppPrefsKeys.isTermsAndConditionAccepted,
    );
    await preferenceManager.removePreference(AppPrefsKeys.termsAndConditionId);
    await preferenceManager.removePreference(AppPrefsKeys.isGuestUser);
    await preferenceManager.removePreference(AppPrefsKeys.isLoggedIn);

    state = Logout();
  }

  void resetState() {
    state = LoginState();
  }

  refreshToken() async {
    final deviceInfo = await DeviceAndAppInfo.build();

    final response = await loginRepository.refreshToken(deviceId: deviceInfo.deviceId);

    response.fold((ifLeft){
      return logout();
    }, (r){
      ref
          .read(preferenceManagerProvider)
          .saveString(AppPrefsKeys.refreshToken, r.data!.refreshToken!);
      ref
          .read(preferenceManagerProvider)
          .saveString(AppPrefsKeys.token, r.data!.accessToken!);
      return;
    });

  }
}
