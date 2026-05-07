import 'package:network/network.dart';

class UnregisterDeviceRequestModel
    implements BaseModel<UnregisterDeviceRequestModel> {
  String? deviceId;

  UnregisterDeviceRequestModel({this.deviceId});

  @override
  UnregisterDeviceRequestModel fromJson(Map<String, dynamic> json) {
    return UnregisterDeviceRequestModel(deviceId: json['deviceId']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {"deviceId": deviceId};
  }
}
