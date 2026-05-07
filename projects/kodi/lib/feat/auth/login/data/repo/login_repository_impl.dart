import 'dart:convert';
import 'package:common_components/extensions/string_extension.dart';
import 'package:kodi/utils/app_pref_keys.dart';
import 'package:local_storage/local_storage.dart';
import 'package:network/network.dart';
import 'package:shared_dependencies/device_and_app_info.dart';

import '../model/request/device_info_request.dart';
import '../model/request/login_request.dart';
import '../model/response/login_response.dart';
import 'login_repository.dart';
import 'package:shared_dependencies/riverpod.dart';

class LoginRepositoryImpl extends LoginRepository {
  final ApiHelper apiHelper;
  final Ref ref;
  static const String serverEndpoint = "/api/auth";

  LoginRepositoryImpl(this.apiHelper, this.ref);

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
  Future<Either<Exception, LoginResponse>> login(
    LoginRequest loginRequest,
  ) async {
    final response = await apiHelper.postRequest(
      path: "$serverEndpoint/login",
      body: loginRequest.toJson(),
      create: () => LoginResponse(),
    );
    return response.fold(
      (l) {
        return Left(Exception(_extractErrorMessage(l)));
      },
      (r) {
        if (r.statusCode == 200 && (r.data?.accessToken).isNotNullAndEmpty) {
          return right(r);
        }
        return Left(Exception(r.message));
      },
    );
  }

  @override
  Future<Either<Exception, LoginResponse>> guestLogin(
    DeviceInfoRequest deviceInfoRequest,
  ) async {
    final response = await apiHelper.postRequest(
      path: "$serverEndpoint/guest",
      body: deviceInfoRequest.toJson(),
      create: () => LoginResponse(),
    );
    return response.fold(
      (l) {
        return Left(Exception(_extractErrorMessage(l)));
      },
      (r) {
        if (r.statusCode == 200) {
          return right(r);
        }
        return Left(Exception(r.message));
      },
    );
  }

  @override
  Future<Either<Exception, LoginResponse>> refreshToken({required String deviceId}) async {
    final token = ref
        .watch(preferenceManagerProvider)
        .getStringOrEmpty(AppPrefsKeys.refreshToken);
    final response = await apiHelper.postRequest(
      path: "$serverEndpoint/refresh",
      body: {
        "refreshToken": token,
        "deviceId": deviceId,
      },
      create: () => LoginResponse(),
    );
    return response.fold(
      (l) {
        return Left(Exception(_extractErrorMessage(l)));
      },
      (r) {
        if (r.statusCode == 200 &&
            (r.data?.refreshToken).isNotNullAndEmpty &&
            (r.data?.accessToken).isNotNullAndEmpty) {
          return response;
        }
        return Left(Exception(r.message));
      },
    );
  }
}
