import 'package:kodi/feat/user/terms/controller/terms_controller.dart';
import 'package:kodi/feat/user/terms/controller/terms_state.dart';
import 'package:shared_dependencies/riverpod.dart';

bool hasUserAcceptedTerms(WidgetRef ref) {
  return ref.watch(
    termsProvider.select((state) {
      if(state is TermsStatus){
        return state.hasAcceptedConsent;
      }
      return false;
    }),
  );
}

bool hasUserAcceptedPushNotification(WidgetRef ref) {
  return ref.watch(
    termsProvider.select((state) {
      if(state is TermsStatus) {
        return state.hasAcceptedPushNotification;
      }
      return false;
    }),
  );
}

bool hasUserAcceptedNewsLetter(WidgetRef ref) {
  return ref.watch(
    termsProvider.select((state) {
      if(state is TermsStatus) {
        return state.hasAcceptedNewsLetter;
      }
      return false;
    }),
  );
}
