import 'package:kodi/feat/auth/reset_password/data/model/change_password_request.dart';
import 'package:kodi/feat/auth/reset_password/data/model/change_password_response.dart';
import 'package:kodi/utils/network.dart';
import 'package:shared_dependencies/dartz.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../model/reset_password_request.dart';
import '../model/reset_password_response.dart';
import 'reset_password_repository_impl.dart';



final resetPasswordRepositoryImplProvider = Provider<ResetPasswordRepository>((ref) {
  return ResetPasswordRepositoryImpl(ref.read(apiProvider), ref);
});

abstract class ResetPasswordRepository{
  Future<Either<String, ResetPasswordResponse>> resetPassword(ResetPasswordRequest resetPasswordRequest);

  Future<Either<String, ChangePasswordResponse>> confirmPassword(ChangePasswordRequest deviceInfoRequest);
}