import 'package:kodi/utils/enums/StateEnum.dart';
import 'package:shared_dependencies/equatable.dart';

// class TermsState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

enum OnboardingStateEnum {
  loadingContent,
  loadingTermsAndCondition,
  loadingNotificationPref,
  successContent,
  successTermsAndCondition,
  successNotificationPref,
  successSubscribePref,
  errorTermAndCondition,
  errorNotificationPref,
  initial,
}


class TermsStatus extends Equatable {
  final String? termsContent;
  final String? termsId;
  final bool hasAcceptedConsent;
  final bool hasAcceptedNewsLetter;
  final bool hasAcceptedPushNotification;
  final OnboardingStateEnum state;
  final String errorMessage;
  final bool isNewsLetterScreen;

  const TermsStatus({
    this.termsContent,
    this.termsId,
    required this.state,
    required this.errorMessage,
    required this.hasAcceptedConsent,
    required this.hasAcceptedNewsLetter,
    required this.hasAcceptedPushNotification,
    this.isNewsLetterScreen = false,
  });

  factory TermsStatus.initial() {
    return TermsStatus(
      termsContent: 'null',
      termsId: 'null',
      errorMessage: '',
      state: OnboardingStateEnum.initial,
      hasAcceptedConsent: false,
      hasAcceptedNewsLetter: false,
      hasAcceptedPushNotification: false,
      isNewsLetterScreen: false,
    );
  }

  @override
  List<Object?> get props => [
    hasAcceptedConsent,
    hasAcceptedNewsLetter,
    hasAcceptedPushNotification,
    termsContent,
    termsId,
    state,
    errorMessage,
    isNewsLetterScreen,
  ];

  TermsStatus copyWith({
    String? termsContent,
    String? termsId,
    String? errorMessage,
    OnboardingStateEnum? state,
    bool? hasAcceptedConsent,
    bool? hasAcceptedNewsLetter,
    bool? hasAcceptedPushNotification,
    bool? isNewsLetterScreen,
  }) {
    return TermsStatus(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      termsContent: termsContent ?? this.termsContent,
      termsId: termsId ?? this.termsId,
      hasAcceptedConsent: hasAcceptedConsent ?? this.hasAcceptedConsent,
      hasAcceptedNewsLetter:
          hasAcceptedNewsLetter ?? this.hasAcceptedNewsLetter,
      hasAcceptedPushNotification:
          hasAcceptedPushNotification ?? this.hasAcceptedPushNotification,
      isNewsLetterScreen: isNewsLetterScreen ?? this.isNewsLetterScreen,
    );
  }
}

// class TermsSuccess extends TermsState {}
// class TermsStatusSuccess extends TermsState {}
// class TermsFetchSuccess extends TermsState {}
//
// class TermsError extends TermsState {
//   final String error;
//
//   TermsError(this.error);
//
//   @override
//   List<Object?> get props => [error];
// }
