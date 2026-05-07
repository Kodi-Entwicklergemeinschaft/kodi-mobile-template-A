import 'package:kodi/feat/user/terms/data/repo/terms_repo_impl.dart';
import 'package:kodi/utils/network.dart';
import 'package:shared_dependencies/dartz.dart';
import 'package:shared_dependencies/riverpod.dart';

import '../model/terms_latest_response.dart';
import '../model/terms_request.dart';
import '../model/terms_response.dart';
import '../model/terms_status_response.dart';
import '../model/user_notification_response.dart';

final termsRepositoryImplProvider = Provider<TermsRepository>((ref) {
  return TermsRepositoryImpl(ref.read(apiProvider));
});

abstract class TermsRepository {
  Future<Either<Exception, TermsResponse>> postTermsStatus(
    TermsRequest termsRequest,
  );

  Future<Either<Exception, TermsStatusResponse>> getTermsStatus();

  Future<Either<Exception, TermsLatestResponse>> getLatestTerms(
    TermsRequest termsRequest,
  );

  Future<Either<Exception, UserNotificationResponse>> saveUserNotification(
    bool pushNotification,
    bool newsLetter,
  );

  Future<Either<Exception, UserNotificationResponse>> getUserNotification();

  // Future<Either<Exception, UserNotificationResponse>>
  // saveNewsLetterNotification(bool value, bool pushNotification);
  //
  // Future<Either<Exception, UserNotificationResponse>> savePushNotification(
  //   bool value,
  // );
}
