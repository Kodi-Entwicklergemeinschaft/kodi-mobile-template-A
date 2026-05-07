import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodi/feat/auth/login/controller/login_controller.dart';
import 'package:kodi/feat/user/profile/controller/profile_state.dart';
import 'package:kodi/feat/user/profile/data/model/request_model/post_profile_data_request_model.dart';
import 'package:kodi/feat/user/profile/data/model/response_model/get_profile_data_response_model.dart';
import 'package:kodi/feat/user/profile/data/model/response_model/get_salutation_response_model.dart';
import 'package:kodi/feat/user/profile/data/model/response_model/post_profile_data_response_model.dart';
import 'package:kodi/feat/user/profile/data/repo/profile_repository.dart';

import '../../../../utils/enums/StateEnum.dart';

final profileProvider =
    NotifierProvider.autoDispose<ProfileController, ProfileState>(() {
      return ProfileController();
    });

class ProfileController extends Notifier<ProfileState> {
  late ProfileRepository profileRepository;
  late LoginController loginController;

  @override
  ProfileState build() {
    profileRepository = ref.read(profileRepositoryProvider);
    loginController=ref.read(loginProvider.notifier);
    return ProfileState();
  }

  getProfileData() async {
    state = state.copyWith(status: StateEnum.loading);
    try {
      // await getSalutations();
      final response = await profileRepository.getProfileData();

      response.fold(
        (l) {
          state = state.copyWith(
            status: StateEnum.error,
            errorMessage: l.toString(),
          );
        },
        (result) {
          if (result.statusCode == 200) {
            GetProfileDataResponseModel getProfileDataResponseModel = result;
            String salutationLabel = getSalutationLabel(
              getProfileDataResponseModel.data?.salutationCode,
            );
            state = state.copyWith(
              firstName: getProfileDataResponseModel.data?.firstName ?? '',
              lastName: getProfileDataResponseModel.data?.lastName ?? '',
              salutation: salutationLabel,
              isIOwnVehicle: getProfileDataResponseModel.data?.hasVehicle,
              status: StateEnum.success,
            );
          } else {
            state = state.copyWith(
              status: StateEnum.error,
              errorMessage: "Failed to get profile.",
            );
          }
        },
      );
    } catch (error) {
      debugPrint('exception while fetching profile data : $error');
    }
  }

  getSalutations() async {
    state = state.copyWith(status: StateEnum.loading);
    try {
      final response = await profileRepository.getSalutation();
      response.fold(
        (l) {
          state = state.copyWith(
            status: StateEnum.error,
            errorMessage: l.toString(),
          );
        },
        (result) {
          if (result.statusCode == 200) {
            List<String>? salutationsLabel = getLabels(result.data);
            GetSalutationResponseModel getSalutationResponseModel = result;
            state = state.copyWith(
              salutationsList: result.data,
              salutationLabels: salutationsLabel,
              status: StateEnum.success,
            );
          } else {
            state = state.copyWith(
              status: StateEnum.error,
              errorMessage: "Failed to get Salutation list.",
            );
          }
        },
      );
    } catch (error) {
      state = state.copyWith(
        status: StateEnum.error,
        errorMessage: "Failed to get Salutation list.",
      );
      debugPrint('exception while fetching Salutation list : $error');
    }
  }

  List<String> getLabels(List<SalutationItem>? salutations) {
    if (salutations != null) {
      return salutations
          .map((item) => item.label ?? "") // Handle null labels
          .where((label) => label.isNotEmpty) // Filter out empty strings
          .toSet() // Convert to Set to remove duplicates
          .toList(); // Convert back to List
    }
    return []; // Return empty list if data is null
  }

  updateProfileData() async {
    state= state.copyWith(status: StateEnum.loadingDialog);
    String? firstName = state.firstName;
    String? lastName = state.lastName;
    String? salutationLabel = state.salutation;
    bool? isVehicleOwned = state.isIOwnVehicle;

    String salutationCode = getSalutationCode(salutationLabel);
    try {
      PostProfileDataRequestModel profileDataRequestModel =
          PostProfileDataRequestModel(
            firstName: firstName,
            lastName: lastName,
            salutationCode: salutationCode,
            hasVehicle: isVehicleOwned,
          );
      final response = await profileRepository.postProfileData(
        profileDataRequestModel,
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
            state = state.copyWith(status: StateEnum.successSnackBar);
          } else {
            state = state.copyWith(
              status: StateEnum.error,
              errorMessage: "Failed to updating profile.",
            );
          }
        },
      );
    } catch (error) {
      state = state.copyWith(
        status: StateEnum.error,
        errorMessage: "Failed to updating profile.",
      );
      debugPrint('exception while updating profile data : $error');
    }
  }

  String getSalutationCode(String? label) {
    List<SalutationItem> salutationsItemList;
    salutationsItemList = state.salutationsList;
    if (salutationsItemList.isNotEmpty) {
      for (var item in salutationsItemList) {
        if (item.label == label) {
          return item.code ?? '';
        }
      }
    }
    return '';
  }

  updateIsIOwnVehicleValue(bool value) {
    state = state.copyWith(isIOwnVehicle: value);
  }

  updateFirstName(String name) {
    state = state.copyWith(firstName: name);
  }

  updateLastName(String name) {
    state = state.copyWith(lastName: name);
  }

  void updateSalutation(String salutation) {
    state = state.copyWith(salutation: salutation);
  }

  String getSalutationLabel(String? salutationCode) {
    List<SalutationItem> salutationsItemList;
    salutationsItemList = state.salutationsList;
    if (salutationsItemList.isNotEmpty) {
      for (var item in salutationsItemList) {
        if (item.code == salutationCode) {
          return item.label ?? '';
        }
      }
    }
    return '';
  }

  Future<void> updateLanguage(String language) async {
    state = state.copyWith(status: StateEnum.loading);
    final response= await profileRepository.updateLanguage(language);
    response.fold((ifLeft){
      state = state.copyWith(status: StateEnum.error);
    }, (ifRight){
      state = state.copyWith(status: StateEnum.success);
    });

  }

  Future<bool> deleteAccount() async {
    state = state.copyWith(status: StateEnum.loadingDialog);
    final response = await profileRepository.deleteAccount();
    response.fold((l) {
      state = state.copyWith(
        status: StateEnum.error,
        errorMessage: l.toString(),
      );
      return false;
    }, (r) async {
      if (r.success == true) {
        await loginController.logout();
        state = state.copyWith(status: StateEnum.success,successMessage: r.message);
        return true;
      } else {
        state = state.copyWith(status: StateEnum.error, errorMessage: r.message);
        return false;
      }
    });
    return false;
  }


}
