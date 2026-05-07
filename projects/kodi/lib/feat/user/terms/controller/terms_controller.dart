import 'package:common_components/extensions/string_extension.dart';
import 'package:kodi/utils/app_pref_keys.dart';
import 'package:local_storage/local_storage.dart';
import 'package:local_storage/preference_manager.dart';
import 'package:locale/locale.dart';
import 'package:shared_dependencies/device_and_app_info.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../data/model/terms_request.dart';
import '../data/repo/terms_repo.dart';
import 'terms_state.dart';

final termsProvider = NotifierProvider<TermsController, TermsStatus>(() {
  return TermsController();
});

class TermsController extends Notifier<TermsStatus> {
  late final TermsRepository _termsRepository;
  late final PreferenceManager _preferenceManager;

  @override
  TermsStatus build() {
    _termsRepository = ref.read(termsRepositoryImplProvider);
    _preferenceManager = ref.read(preferenceManagerProvider);
    return TermsStatus.initial();
  }

  saveTermsStatus() async {
    state = state.copyWith(state: OnboardingStateEnum.loadingTermsAndCondition);
    _preferenceManager.saveBool(
      AppPrefsKeys.isTermsAndConditionAccepted,
      state.hasAcceptedConsent,
    );

    final response = await _termsRepository.postTermsStatus(
      TermsRequest(
        termsId: state.termsId,
        // ref.read(localeControllerProvider).languageCode,
      ),
    );
    response.fold(
      (l) {
        state = state.copyWith(errorMessage: l.toString());
      },
      (r) {
        state = state.copyWith(
          state: OnboardingStateEnum.successTermsAndCondition,
        );
      },
    );
  }

  getTermsStatus() async {
    DeviceAndAppInfo deviceAndAppInfo = await DeviceAndAppInfo.build();
    final response = await _termsRepository.getTermsStatus();
    response.fold(
      (l) {
        state = state.copyWith(errorMessage: l.toString());
        ref
            .read(preferenceManagerProvider)
            .saveBool(AppPrefsKeys.isTermsAndConditionAccepted, true);
      },
      (r) {
        ref
            .read(preferenceManagerProvider)
            .saveBool(
              AppPrefsKeys.isTermsAndConditionAccepted,
              r.data?.hasAccepted ?? false,
            );
      },
    );
  }

  //Check for latest terms and condition on every login.
  // getLatestTermsFromSplash() async {
  //   final response = await _termsRepository.getLatestTerms(
  //     TermsRequest(
  //       locale: 'en',
  //       // ref.read(localeControllerProvider).languageCode
  //     ),
  //   );
  //   response.fold(
  //     (l) {
  //       ref
  //           .read(preferenceManagerProvider)
  //           .saveBool(AppPrefsKeys.isTermsAndConditionAccepted, true);
  //       state = state.copyWith(errorMessage: l.toString());
  //       Future.delayed(const Duration(seconds: 1)).then((_) {
  //         state = state.copyWith(state: OnboardingStateEnum.successTermsAndCondition);
  //       });
  //     },
  //     (r) async {
  //       String? termsId = r.data?.id;
  //       if (termsId.isNotNullAndEmpty) {
  //         await getTermsStatus(termsId!);
  //       }
  //       else{
  //         ref
  //             .read(preferenceManagerProvider)
  //             .saveBool(AppPrefsKeys.isTermsAndConditionAccepted, true);
  //       }
  //       // else if (termsId.isNullOrEmpty || (r.data?.content).isNullOrEmpty) {
  //       //   //Not restricting the user to stay on splash screen.
  //       //   ref
  //       //       .read(preferenceManagerProvider)
  //       //       .saveBool(AppPrefsKeys.isTermsAndConditionAccepted, true);
  //       //   state = state.copyWith(stateEnum: StateEnum.success);
  //       // } else if (termsId.isNotNullAndEmpty &&
  //       //     (r.data?.content).isNotNullAndEmpty) {
  //       //   ref
  //       //       .read(preferenceManagerProvider)
  //       //       .saveBool(AppPrefsKeys.isTermsAndConditionAccepted, false);
  //       //   state = state.copyWith(
  //       //     termsContent: r.data!.content!,
  //       //     termsId: termsId!,
  //       //   );
  //       // }
  //     },
  //   );
  // }

  //After login first time terms and condition will be accepted.
  getLatestTerms() async {
    state = state.copyWith(state: OnboardingStateEnum.loadingContent);
    final response = await _termsRepository.getLatestTerms(
      TermsRequest(
        locale:
            // 'en'
            ref.read(localeControllerProvider).languageCode,
      ),
    );
    response.fold(
      (l) {
        ref
            .read(preferenceManagerProvider)
            .saveBool(AppPrefsKeys.isTermsAndConditionAccepted, false);
        state = state.copyWith(
          errorMessage: l.toString(),
          state: OnboardingStateEnum.errorTermAndCondition,
        );
      },
      (r) {
        if ((r.data?.content).isNotNullAndEmpty &&
            (r.data?.id).isNotNullAndEmpty) {
          state = state.copyWith(
            termsContent: r.data!.content!,
            termsId: r.data!.id!,
            state: OnboardingStateEnum.successContent,
          );
        }
      },
    );
  }

  resetTerms(){
    state = state.copyWith(
      hasAcceptedConsent: false,
    );
  }

  resetNotificationAndNewsLetter(){
    state = state.copyWith(
      hasAcceptedPushNotification: false,
      hasAcceptedNewsLetter: false,
    );
  }

  toggleTerms() {
    state = state.copyWith(hasAcceptedConsent: !state.hasAcceptedConsent);
  }

  void toggleNotificationConsent() {
    state = state.copyWith(
      hasAcceptedPushNotification: !state.hasAcceptedPushNotification,
    );
  }

  /// Sets notification consent to an explicit value without toggling.
  /// Used to sync the UI with device-level permission without triggering
  /// an API save.
  void setNotificationConsent(bool value) {
    state = state.copyWith(hasAcceptedPushNotification: value);
  }

  void toggleNewsLetterConsent() {
    // state = state.copyWith(hasAcceptedNewsLetter: !state.hasAcceptedNewsLetter);
    //The service can only be true cannot set to false.
    state = state.copyWith(hasAcceptedNewsLetter: true);
  }

  Future<void> saveNotificationStatus() async {
    state = state.copyWith(state: OnboardingStateEnum.loadingNotificationPref);
    _preferenceManager.saveBool(
      AppPrefsKeys.isPushNotificationsAccepted,
      state.hasAcceptedPushNotification,
    );
    _preferenceManager.saveBool(
      AppPrefsKeys.isNewsLetterAccepted,
      state.hasAcceptedNewsLetter,
    );

    final response = await _termsRepository.saveUserNotification(
      state.hasAcceptedPushNotification,
      state.hasAcceptedNewsLetter,
    );
    response.fold(
      (l) {
        // state = state.copyWith(errorMessage: l.toString());
        state = state.copyWith(
          state: OnboardingStateEnum.successNotificationPref,
        );
      },
      (r) {
        state = state.copyWith(
          state: OnboardingStateEnum.successNotificationPref,
        );
      },
    );
  }

  Future<void> saveSubscribeStatus() async {
    state = state.copyWith(state: OnboardingStateEnum.loadingNotificationPref);
    _preferenceManager.saveBool(
      AppPrefsKeys.isPushNotificationsAccepted,
      state.hasAcceptedPushNotification,
    );
    _preferenceManager.saveBool(
      AppPrefsKeys.isNewsLetterAccepted,
      state.hasAcceptedNewsLetter,
    );

    final response = await _termsRepository.saveUserNotification(
      state.hasAcceptedPushNotification,
      state.hasAcceptedNewsLetter,
    );
    response.fold(
          (l) {
        // state = state.copyWith(errorMessage: l.toString());
        state = state.copyWith(
          state: OnboardingStateEnum.successSubscribePref,
        );
      },
          (r) {
        state = state.copyWith(
          state: OnboardingStateEnum.successSubscribePref,
        );
      },
    );
  }

  Future<void> getNotificationStatus() async {
    state = state.copyWith(state: OnboardingStateEnum.loadingNotificationPref);
    // _preferenceManager.saveBool(
    //   AppPrefsKeys.isPushNotificationsAccepted,
    //   state.hasAcceptedPushNotification,
    // );
    // _preferenceManager.saveBool(
    //   AppPrefsKeys.isNewsLetterAccepted,
    //   state.hasAcceptedNewsLetter,
    // );

    final response = await _termsRepository.getUserNotification();
    response.fold(
      (l) {
        state = state.copyWith(
          errorMessage: l.toString(),
          state: OnboardingStateEnum.errorNotificationPref,
        );
      },
      (r) {
        state = state.copyWith(
          state: OnboardingStateEnum.successNotificationPref,
          hasAcceptedNewsLetter: (r.data?.newsletterSubscription != null)
              ? true
              : false,
          hasAcceptedPushNotification: r.data?.notificationsEnabled,
        );
      },
    );
  }

  goToNewsLetter() {
    state = state.copyWith(isNewsLetterScreen: true);
  }

  goToTerms() {
    state = state.copyWith(isNewsLetterScreen: false);
  }


  // Future<void> setNewsLetterNotification(bool value) async {
  //   state = state.copyWith(state: OnboardingStateEnum.loadingNotificationPref);
  //   final response = await _termsRepository.saveNewsLetterNotification(value);
  //   response.fold(
  //     (l) {
  //       state = state.copyWith(
  //         errorMessage: l.toString(),
  //         state: OnboardingStateEnum.errorNotificationPref,
  //       );
  //     },
  //     (r) {
  //       state = state.copyWith(
  //         state: OnboardingStateEnum.successNotificationPref,
  //         hasAcceptedNewsLetter: (r.data?.newsletterSubscription != null)
  //             ? true
  //             : false,
  //       );
  //     },
  //   );
  // }
  //
  // Future<void> setPushNotification(bool value) async {
  //   state = state.copyWith(state: OnboardingStateEnum.loadingNotificationPref);
  //   final response = await _termsRepository.savePushNotification(value);
  //   response.fold(
  //     (l) {
  //       state = state.copyWith(
  //         errorMessage: l.toString(),
  //         state: OnboardingStateEnum.errorNotificationPref,
  //       );
  //     },
  //     (r) {
  //       state = state.copyWith(
  //         state: OnboardingStateEnum.successNotificationPref,
  //         hasAcceptedPushNotification: r.data?.notificationsEnabled,
  //       );
  //     },
  //   );
  // }
}
