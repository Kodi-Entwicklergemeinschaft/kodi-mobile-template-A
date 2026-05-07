import 'package:kodi/utils/network.dart';
import 'package:shared_dependencies/dartz.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../model/request/device_info_request.dart';
import '../model/request/login_request.dart';
import '../model/response/login_response.dart';
import 'login_repository_impl.dart';



final loginRepositoryImplProvider = Provider<LoginRepository>((ref) {
  return LoginRepositoryImpl(ref.read(apiProvider), ref);
});

abstract class LoginRepository{
  Future<Either<Exception, LoginResponse>> login(LoginRequest loginRequest);

  Future<Either<Exception, LoginResponse>> guestLogin(DeviceInfoRequest deviceInfoRequest);

  Future<Either<Exception, LoginResponse>> refreshToken({required String deviceId});
}