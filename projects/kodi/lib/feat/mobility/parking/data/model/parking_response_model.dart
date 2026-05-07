import 'package:network/network.dart';

class ParkingResponseModel
    implements BaseModel<ParkingResponseModel> {
  bool? success;
  List<ParkingData>? data;
  String? message;
  String? timestamp;
  String? path;
  int? statusCode;

  ParkingResponseModel({
    this.success,
    this.data,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });

  @override
  ParkingResponseModel fromJson(Map<String, dynamic> json) {
    return ParkingResponseModel(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List)
          .map((e) => ParkingData.fromJson(e))
          .toList()
          : null,
      message: json['message'],
      timestamp: json['timestamp'],
      path: json['path'],
      statusCode: json['statusCode'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data?.map((e) => e.toJson()).toList(),
      "message": message,
      "timestamp": timestamp,
      "path": path,
      "statusCode": statusCode,
    };
  }
}

class ParkingData {
  String? id;
  String? parkingSiteId;
  String? name;
  String? description;
  ParkingLocation? location;
  ParkingCapacity? capacity;
  VehicleSlots? vehicleSlots;
  String? status;
  String? lastUpdate;
  dynamic pricing;

  ParkingData({
    this.id,
    this.parkingSiteId,
    this.name,
    this.description,
    this.location,
    this.capacity,
    this.vehicleSlots,
    this.status,
    this.lastUpdate,
    this.pricing,
  });

  factory ParkingData.fromJson(Map<String, dynamic> json) {
    return ParkingData(
      id: json['id'],
      parkingSiteId: json['parkingSiteId'],
      name: json['name'],
      description: json['description'],
      location: json['location'] != null
          ? ParkingLocation.fromJson(json['location'])
          : null,
      capacity: json['capacity'] != null
          ? ParkingCapacity.fromJson(json['capacity'])
          : null,
      vehicleSlots: json['vehicleSlots'] != null
          ? VehicleSlots.fromJson(json['vehicleSlots'])
          : null,
      status: json['status'],
      lastUpdate: json['lastUpdate'],
      pricing: json['pricing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "parkingSiteId": parkingSiteId,
      "name": name,
      "description": description,
      "location": location?.toJson(),
      "capacity": capacity?.toJson(),
      "vehicleSlots": vehicleSlots?.toJson(),
      "status": status,
      "lastUpdate": lastUpdate,
      "pricing": pricing,
    };
  }
}

class ParkingLocation {
  double? latitude;
  double? longitude;
  String? address;

  ParkingLocation({
    this.latitude,
    this.longitude,
    this.address,
  });

  factory ParkingLocation.fromJson(Map<String, dynamic> json) {
    return ParkingLocation(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "address": address,
    };
  }
}

class ParkingCapacity {
  int? total;
  int? available;
  int? occupied;
  double? occupancy;

  ParkingCapacity({
    this.total,
    this.available,
    this.occupied,
    this.occupancy,
  });

  factory ParkingCapacity.fromJson(Map<String, dynamic> json) {
    return ParkingCapacity(
      total: json['total'],
      available: json['available'],
      occupied: json['occupied'],
      occupancy: (json['occupancy'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total": total,
      "available": available,
      "occupied": occupied,
      "occupancy": occupancy,
    };
  }
}

class VehicleSlots {
  dynamic fourWheeler;
  dynamic twoWheeler;
  dynamic unclassified;

  VehicleSlots({
    this.fourWheeler,
    this.twoWheeler,
    this.unclassified,
  });

  factory VehicleSlots.fromJson(Map<String, dynamic> json) {
    return VehicleSlots(
      fourWheeler: json['fourWheeler'],
      twoWheeler: json['twoWheeler'],
      unclassified: json['unclassified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fourWheeler": fourWheeler,
      "twoWheeler": twoWheeler,
      "unclassified": unclassified,
    };
  }
}
