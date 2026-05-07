import 'package:dartz/dartz.dart';
import 'package:kodi/feat/user/profile/data/model/request_model/post_profile_data_request_model.dart';
import 'package:kodi/feat/user/profile/data/model/response_model/get_profile_data_response_model.dart';
import 'package:kodi/feat/user/profile/data/model/response_model/get_salutation_response_model.dart';
import 'package:kodi/feat/user/profile/data/model/response_model/post_profile_data_response_model.dart';
import 'package:kodi/feat/user/profile/data/repo/profile_repo_impl.dart';
import 'package:kodi/utils/network.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../model/response_model/language_response_model.dart';

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepoImpl(apiHelper: ref.read(apiProvider)),
);

abstract class ProfileRepository {
  Future<Either<Exception, GetProfileDataResponseModel>> getProfileData();

  Future<Either<Exception, PostProfileDataResponseModel>> postProfileData(
    PostProfileDataRequestModel postProfileDataRequestModel,
  );

  Future<Either<Exception, GetSalutationResponseModel>> getSalutation();
  Future<Either<Exception, LanguageResponseModel>> updateLanguage(String language);
  Future<Either<Exception, LanguageResponseModel>> deleteAccount();
}
