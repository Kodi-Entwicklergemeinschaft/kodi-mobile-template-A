import 'package:flutter/cupertino.dart';
import 'package:kodi/feat/auth/login/data/model/request/register_device_request_model.dart';
import 'package:kodi/feat/auth/register_device/controller/register_device_state.dart';
import 'package:kodi/feat/auth/register_device/data/model/request/unregister_device_request_model.dart';
import 'package:kodi/feat/auth/register_device/data/model/response/unregister_device_response_model.dart';
import 'package:kodi/feat/city/controller/city_controller.dart';
import 'package:kodi/my_app.dart';
import 'package:local_storage/preference_manager.dart';
import 'package:local_storage/preference_manager_impl.dart';
import 'package:locale/locale.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_dependencies/device_and_app_info.dart';
import 'package:shared_dependencies/riverpod.dart';
import '../../../../utils/app_pref_keys.dart';
import '../../../../utils/enums/StateEnum.dart';
import '../../login/data/model/response/register_device_response_model.dart';
import '../data/repo/register_device_repository.dart';

final registerDeviceControllerProvider =
    NotifierProvider<RegisterDeviceController, RegisterDeviceState>(
      () {
        return RegisterDeviceController();
      },
    );

class RegisterDeviceController extends Notifier<RegisterDeviceState> {
  late final RegisterDeviceRepository registerDeviceRepository;
  late final PreferenceManager preferenceManager;
  late final LocaleController localeController;
  late final MessagingService messagingService;
  late final CityController cityController;

  @override
  RegisterDeviceState build() {
    registerDeviceRepository = ref.read(registerDeviceRepositoryImplProvider);
    preferenceManager = ref.read(preferenceManagerProvider);
    localeController = ref.watch(localeControllerProvider.notifier);
    messagingService = ref.read(messagingServiceProvider);
    cityController = ref.read(cityControllerProvider.notifier);
    return RegisterDeviceState();
  }

  Future<void> registerDevice() async {
    state = state.copyWith(status: StateEnum.loading);

    final deviceInfo = await DeviceAndAppInfo.build();
    String appVersion = await getAppVersion();
    String? cityId = cityController.getCityId();
    String languageCode = localeController.getCurrentLanguageCode();
    final fcmToken = await ref.read(messagingServiceProvider).getToken();
    RegisterDeviceRequestModel registerDeviceRequestModel =
        RegisterDeviceRequestModel(
          deviceId: deviceInfo.deviceId,
          platform: deviceInfo.platform,
          fcmToken: fcmToken,
          osVersion: deviceInfo.osVersion,
          language: languageCode,
          appVersion: appVersion,
          cityId: cityId ?? "",
        );

    RegisterDeviceResponseModel registerDeviceResponseModel =
        RegisterDeviceResponseModel();

    final response = await registerDeviceRepository.registerDevice(
      registerDeviceRequestModel,
    );

    response.fold(
      (error) {
        state = state.copyWith(
          status: StateEnum.error,
          errorMessage: error.toString(),
        );
      },
      (result) {
        if (result.statusCode == 200) {
          registerDeviceResponseModel = result;
          state = state.copyWith(status: StateEnum.success);
        } else {
          state = state.copyWith(
            status: StateEnum.error,
            errorMessage: "Failed to register device.",
          );
        }
      },
    );
  }

  Future<void> unregisterDevice() async {
    state = state.copyWith(status: StateEnum.loading);

    final deviceInfo = await DeviceAndAppInfo.build();
    UnregisterDeviceRequestModel unregisterDeviceRequestModel =
    UnregisterDeviceRequestModel(
      deviceId: deviceInfo.deviceId,
    );

    UnregisterDeviceResponseModel unregisterDeviceResponseModel =
    UnregisterDeviceResponseModel();

    final response = await registerDeviceRepository.unregisterDevice(
        unregisterDeviceRequestModel
    );

    response.fold(
          (error) {
        state = state.copyWith(
          status: StateEnum.error,
          errorMessage: error.toString(),
        );
      },
          (result) {
        if (result.statusCode == 200) {
          unregisterDeviceResponseModel = result;
          state = state.copyWith(status: StateEnum.success);
        } else {
          state = state.copyWith(
            status: StateEnum.error,
            errorMessage: "Failed to unregister device.",
          );
        }
      },
    );
  }

  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    debugPrint(info.version);
    debugPrint(info.buildNumber);
    return info.version;
  }
}
