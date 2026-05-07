import 'package:kodi/feat/auth/login/data/model/response/login_response.dart' show LoginResponse;
import 'package:kodi/feat/auth/register/data/repo/user_registration_repo_impl.dart';
import 'package:kodi/utils/network.dart';
import 'package:shared_dependencies/dartz.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../model/registration_request.dart';
import '../model/registration_response.dart';





final userRegistrationRepositoryImplProvider = Provider<UserRegistrationRepo>((ref) {
  return UserRegistrationRepositoryImpl(ref.read(apiProvider));
});

abstract class UserRegistrationRepo{
  Future<Either<Exception, RegistrationResponse>> registerUser(
      RegistrationRequest user
      );
}