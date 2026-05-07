import 'package:shared_dependencies/riverpod.dart';

import '../data/model/registration_request.dart';
import '../data/repo/user_registration_repo.dart';
import 'register_state.dart';


final registerProvider =
NotifierProvider<RegisterController, RegisterState>(() {
  return RegisterController();
});


class RegisterController extends Notifier<RegisterState>{

  late final UserRegistrationRepo _registrationRepo;
  @override
  RegisterState build() {
    _registrationRepo=ref.read(userRegistrationRepositoryImplProvider);
    return RegisterState();
  }


  register({
    required String email,
    required String password,
    // required String firstName,
    // required String lastName,
    // required String username,
  }) async {
    state = RegisterLoading();
    final response = await _registrationRepo.registerUser(
      RegistrationRequest(
        email: email,
        password: password,
        // firstName: firstName,
        // lastName: lastName,
        // username: username,
      ),
    );
    response.fold(
          (l) {
        state = RegisterError(l.toString());
      },
          (r) {
        state = RegisterSuccess(r.message??"Registration Success");
      },
    );
  }

}