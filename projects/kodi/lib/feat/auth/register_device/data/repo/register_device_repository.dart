import 'package:kodi/feat/auth/login/data/model/request/register_device_request_model.dart';
import 'package:kodi/feat/auth/register_device/data/model/request/unregister_device_request_model.dart';
import 'package:kodi/feat/auth/register_device/data/model/response/unregister_device_response_model.dart';
import 'package:kodi/feat/auth/register_device/data/repo/register_device_repository_impl.dart';
import 'package:kodi/utils/network.dart';
import 'package:shared_dependencies/dartz.dart';
import 'package:shared_dependencies/riverpod.dart';
import '../../../login/data/model/response/register_device_response_model.dart';

final registerDeviceRepositoryImplProvider = Provider<RegisterDeviceRepository>(
  (ref) {
    return RegisterDeviceRepositoryImpl(ref.read(apiProvider), ref);
  },
);

abstract class RegisterDeviceRepository {
  Future<Either<Exception, RegisterDeviceResponseModel>> registerDevice(
    RegisterDeviceRequestModel registerDeviceRequestModel,
  );

  Future<Either<Exception, UnregisterDeviceResponseModel>> unregisterDevice(
    UnregisterDeviceRequestModel unregisterDeviceRequestModel,
  );
}
