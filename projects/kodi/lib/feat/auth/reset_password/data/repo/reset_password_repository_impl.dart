import 'dart:convert';
import 'package:common_components/extensions/string_extension.dart';
import 'package:network/network.dart';

import '../model/change_password_request.dart';
import '../model/change_password_response.dart';
import '../model/reset_password_request.dart';
import '../model/reset_password_response.dart';
import 'reset_password_repository.dart';
import 'package:shared_dependencies/riverpod.dart';

class ResetPasswordRepositoryImpl extends ResetPasswordRepository {
  final ApiHelper apiHelper;
  final Ref ref;
  static const String serverEndpoint = "/api/users";

  ResetPasswordRepositoryImpl(this.apiHelper, this.ref);

  String _extractErrorMessage(Exception l) {
    if (l is DioException && l.response?.data != null) {
      dynamic responseData = l.response!.data;
      Map<String, dynamic>? dataMap;

      if (responseData is Map<String, dynamic>) {
        dataMap = responseData;
      } else if (responseData is String) {
        try {
          dataMap = jsonDecode(responseData) as Map<String, dynamic>;
        } catch (e) {
          // Not a valid JSON, fall through
        }
      }

      if (dataMap != null) {
        final message = dataMap['message'] as String?;
        if (message.isNotNullAndEmpty) {
          return message!;
        }
      }
    }
    return l.toString();
  }

  @override
  Future<Either<String, ResetPasswordResponse>> resetPassword(
    ResetPasswordRequest resetPasswordRequest,
  ) async {
    final response = await apiHelper.postRequest(
      path: "$serverEndpoint/reset-password/request",
      body: resetPasswordRequest.toJson(),
      create: () => ResetPasswordResponse(),
    );
    return response.fold(
      (l) {
        return Left((_extractErrorMessage(l)));
      },
      (r) {
        if (r.success == true) {
          return right(r);
        }
        return Left((r.message ?? ''));
      },
    );
  }

  @override
  Future<Either<String, ChangePasswordResponse>> confirmPassword(
    ChangePasswordRequest changePasswordRequest,
  ) async {
    final response = await apiHelper.postRequest(
      path: "$serverEndpoint/guest",
      body: changePasswordRequest.toJson(),
      create: () => ChangePasswordResponse(),
    );
    return response.fold(
      (l) {
        return Left((_extractErrorMessage(l)));
      },
      (r) {
        if (r.statusCode == 200) {
          return right(r);
        }
        return Left((r.message ?? ''));
      },
    );
  }
}
