import 'package:kodi/feat/auth/reset_password/data/model/change_password_request.dart';
import 'package:kodi/feat/auth/reset_password/data/model/change_password_response.dart';
import 'package:local_storage/preference_manager.dart';
import 'package:shared_dependencies/riverpod.dart';
import '../data/model/reset_password_request.dart';
import '../data/model/reset_password_response.dart';
import '../data/repo/reset_password_repository.dart';
import 'reset_password_state.dart';
import 'package:local_storage/local_storage.dart';

final resetPasswordProvider = NotifierProvider<ResetPasswordController, ResetPasswordState>(() {
  return ResetPasswordController();
});

class ResetPasswordController extends Notifier<ResetPasswordState> {
  late final ResetPasswordRepository resetPasswordRepository;
  late final PreferenceManager preferenceManager;

  @override
  ResetPasswordState build() {
    resetPasswordRepository = ref.read(resetPasswordRepositoryImplProvider);
    preferenceManager = ref.read(preferenceManagerProvider);
    return ResetPasswordState();
  }

  Future<void> resetPassword(String email) async {
    state = ResetPasswordLoading();
    final response = await resetPasswordRepository.resetPassword(
      ResetPasswordRequest(email: email),
    );
    response.fold(
      (l) {
        state = ResetPasswordError(l.toString());
      },
      (ResetPasswordResponse r) {
        state = ResetPasswordSuccess(r.data?.message??r.message);
      },
    );
  }

  /// Not using change password for mobile devices.
  Future<void> confirmPassword(String newPassword) async {
    state = ChangePasswordLoading();
    final response = await resetPasswordRepository.confirmPassword(
      ChangePasswordRequest(
        token: '',
        newPassword: newPassword,
      ),
    );
    response.fold(
      (l) {
        state = ChangePasswordError(l.toString());
      },
      (ChangePasswordResponse r) {
        state = ChangePasswordSuccess(r.message);
      },
    );
  }
}
