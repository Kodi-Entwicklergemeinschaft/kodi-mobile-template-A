import 'package:kodi/feat/user/terms/data/model/terms_latest_response.dart';
import 'package:kodi/feat/user/terms/data/repo/terms_repo.dart';
import 'package:network/network.dart';

import '../model/terms_request.dart';
import '../model/terms_response.dart';
import '../model/terms_status_response.dart';
import '../model/user_notification_response.dart';

class TermsRepositoryImpl extends TermsRepository {
  ApiHelper apiHelper;
  static const String serverEndpoint = "/api/users";

  TermsRepositoryImpl(this.apiHelper);

  @override
  Future<Either<Exception, TermsResponse>> postTermsStatus(
    TermsRequest termsRequest,
  ) async {
    final response = await apiHelper.postRequest(
      path: "$serverEndpoint/terms/accept",
      body: termsRequest.toJson(),
      create: () => TermsResponse(),
    );

    return response.fold((l) => Left(l), (r) {
      if (r.statusCode == 201 || r.statusCode == 200) {
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }

  @override
  Future<Either<Exception, TermsStatusResponse>> getTermsStatus() async {
    final response = await apiHelper.getRequest(
      path: "$serverEndpoint/terms/status",
      create: () => TermsStatusResponse(),
    );

    return response.fold((l) => Left(l), (r) {
      if (r.success == true) {
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }

  @override
  Future<Either<Exception, TermsLatestResponse>> getLatestTerms(
    TermsRequest termsRequest,
  ) async {
    final response = await apiHelper.getRequest(
      path: "$serverEndpoint/terms/latest",
      create: () => TermsLatestResponse(),
      params: termsRequest.toJson(),
    );

    return response.fold((l) => Left(l), (r) {
      if (r.success == true) {
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }

  @override
  Future<Either<Exception, UserNotificationResponse>> saveUserNotification(
    bool pushNotification,
    bool newsLetter,
  ) async {
    final response = await apiHelper.patchRequest(
      path: "$serverEndpoint/me/preferences",
      body: {
        "newsletterSubscribed": newsLetter,
        "notificationsEnabled": pushNotification,
      },
      create: () => UserNotificationResponse(),
    );

    return response.fold((l) => Left(l), (r) {
      if (r.statusCode == 201 || r.statusCode == 200) {
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }

  // @override
  // Future<Either<Exception, UserNotificationResponse>>
  // saveNewsLetterNotification(bool newsLetter) async {
  //   final response = await apiHelper.patchRequest(
  //     path: "$serverEndpoint/me/preferences",
  //     body: {"newsletterSubscribed": newsLetter},
  //     create: () => UserNotificationResponse(),
  //   );
  //
  //   return response.fold((l) => Left(l), (r) {
  //     if (r.statusCode == 201 || r.statusCode == 200) {
  //       return right(r);
  //     }
  //     return Left(Exception(r.message));
  //   });
  // }

  // @override
  // Future<Either<Exception, UserNotificationResponse>> savePushNotification(
  //   bool pushNotification,
  // ) async {
  //   final response = await apiHelper.patchRequest(
  //     path: "$serverEndpoint/me/preferences",
  //     body: {
  //       "newsletterSubscribed": newsLetter,
  //       "notificationsEnabled": pushNotification,
  //     },
  //     create: () => UserNotificationResponse(),
  //   );
  //
  //   return response.fold((l) => Left(l), (r) {
  //     if (r.statusCode == 201 || r.statusCode == 200) {
  //       return right(r);
  //     }
  //     return Left(Exception(r.message));
  //   });
  // }

  @override
  Future<Either<Exception, UserNotificationResponse>>
  getUserNotification() async {
    final response = await apiHelper.getRequest(
      path: "$serverEndpoint/me/preferences",
      create: () => UserNotificationResponse(),
    );

    return response.fold((l) => Left(l), (r) {
      if (r.statusCode == 201 || r.statusCode == 200) {
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }
}
