import 'package:kodi/feat/auth/register/data/repo/user_registration_repo.dart';
import 'package:network/network.dart';

import '../model/registration_request.dart';
import '../model/registration_response.dart';

class UserRegistrationRepositoryImpl extends UserRegistrationRepo{
  ApiHelper apiHelper;

  UserRegistrationRepositoryImpl(this.apiHelper);

  @override
  Future<Either<Exception, RegistrationResponse>> registerUser(
      RegistrationRequest user
      ) async {
    final response = await apiHelper.postRequest(
      path: "/api/users/register",
      body: user.toJson(),
      create: () => RegistrationResponse(),
    );

    return response.fold((l) => Left(l),
            (r) {
      if (r.statusCode == 201) {
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }
}
