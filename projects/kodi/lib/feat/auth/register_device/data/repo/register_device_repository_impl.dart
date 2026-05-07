import 'dart:convert';
import 'package:common_components/extensions/string_extension.dart';
import 'package:kodi/feat/auth/login/data/model/request/register_device_request_model.dart';
import 'package:kodi/feat/auth/login/data/model/response/register_device_response_model.dart';
import 'package:kodi/feat/auth/register_device/data/model/request/unregister_device_request_model.dart';
import 'package:kodi/feat/auth/register_device/data/model/response/unregister_device_response_model.dart';
import 'package:kodi/feat/auth/register_device/data/repo/register_device_repository.dart';
import 'package:network/network.dart';
import 'package:shared_dependencies/riverpod.dart';

class RegisterDeviceRepositoryImpl extends RegisterDeviceRepository{
  final ApiHelper apiHelper;
  final Ref ref;
  static const String registerDeviceEndPoint = "/api/users/me/devices";


  RegisterDeviceRepositoryImpl(this.apiHelper, this.ref);
  
  @override
  Future<Either<Exception, RegisterDeviceResponseModel>> registerDevice(RegisterDeviceRequestModel registerDeviceRequest) async {
    final response = await apiHelper.postRequest(
      path: registerDeviceEndPoint,
      body: registerDeviceRequest.toJson(),
      create: () => RegisterDeviceResponseModel(),
    );
    return response.fold((l) {
      return Left(Exception(_extractErrorMessage(l)));
    }, (r) {
      if (r.statusCode == 200) {
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }

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
  Future<Either<Exception, UnregisterDeviceResponseModel>> unregisterDevice(UnregisterDeviceRequestModel unregisterDeviceRequest) async {
    final response = await apiHelper.deleteRequest(
      path: "$registerDeviceEndPoint/${unregisterDeviceRequest.deviceId}",
      create: () => UnregisterDeviceResponseModel(),
    );
    return response.fold((l) {
      return Left(Exception(_extractErrorMessage(l)));
    }, (r) {
      if (r.statusCode == 200) {
        return right(r);
      }
      return Left(Exception(r.message));
    });
  }
}
