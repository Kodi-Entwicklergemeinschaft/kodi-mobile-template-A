import 'package:dartz/dartz.dart';
import 'package:kodi/feat/user/profile/data/model/request_model/post_profile_data_request_model.dart';
import 'package:kodi/feat/user/profile/data/model/response_model/get_profile_data_response_model.dart';
import 'package:kodi/feat/user/profile/data/model/response_model/post_profile_data_response_model.dart';
import 'package:kodi/feat/user/profile/data/repo/profile_repository.dart';
import 'package:network/network.dart';

import '../model/response_model/get_salutation_response_model.dart';
import '../model/response_model/language_response_model.dart';

class ProfileRepoImpl implements ProfileRepository{

ApiHelper apiHelper;
static const String userEndPoint="api/users/me";
static const String serverEndpoint = "api/users/profile/me";
static const String salutationEndPoint = "api/users/salutations";

ProfileRepoImpl({required this.apiHelper});
  @override
  Future<Either<Exception, GetProfileDataResponseModel>> getProfileData() async{
    final response = await apiHelper.getRequest(
      path: serverEndpoint,
      create: () => GetProfileDataResponseModel(),
    );
    return response.fold((l) => Left(l), (r) {
      if (r.statusCode!=null && r.statusCode == 200 ){
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }

  @override
  Future<Either<Exception, PostProfileDataResponseModel>> postProfileData(
      PostProfileDataRequestModel postProfileDataRequestModel) async {
    final response = await apiHelper.patchRequest(
      path: serverEndpoint,
      body: postProfileDataRequestModel.toJson(),
      create: () => PostProfileDataResponseModel(),
    );
    return response.fold((l) => Left(l), (r) {
      if (r.statusCode!=null && r.statusCode == 200 ){
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }

  @override
  Future<Either<Exception, GetSalutationResponseModel>> getSalutation() async {
    final response = await apiHelper.getRequest(
      path: salutationEndPoint,
      create: () => GetSalutationResponseModel(),
    );
    return response.fold((l) => Left(l), (r) {
      if (r.statusCode!=null && r.statusCode == 200 ){
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }

  @override
  Future<Either<Exception, LanguageResponseModel>> updateLanguage(String language) async {
    final response = await apiHelper.patchRequest(
      path: "$userEndPoint/preferences",
      body: {
        'preferredLanguage': language
      },
      create: () => LanguageResponseModel(),
    );
    return response.fold((l) => Left(l), (r) {
      if (r.statusCode!=null && r.statusCode == 200 ){
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }

  @override
  Future<Either<Exception, LanguageResponseModel>> deleteAccount() async {
    final response = await apiHelper.deleteRequest(
      path: serverEndpoint,
      create: () => LanguageResponseModel(),
    );
    return response.fold((l) => Left(l), (r) {
      if (r.success==true){
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }
}