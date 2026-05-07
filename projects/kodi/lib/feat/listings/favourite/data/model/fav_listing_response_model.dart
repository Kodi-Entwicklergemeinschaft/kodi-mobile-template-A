import 'package:network/network.dart';

import '../../../data/model/listing_model.dart';

class FavouriteListingResponse extends BaseModel<FavouriteListingResponse> {
  final bool? success;
  final List<FavouriteListing>? data;
  final String? message;
  final DateTime? timestamp;
  final String? path;
  final int? statusCode;

  FavouriteListingResponse({
    this.success,
    this.data,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });


  @override
  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.map((e) => e.toJson()).toList(),
    "message": message,
    "timestamp": timestamp?.toIso8601String(),
    "path": path,
    "statusCode": statusCode,
  };

  @override
  FavouriteListingResponse fromJson(Map<String, dynamic> json) {
    return FavouriteListingResponse(
      success: json['success'] as bool?,
      data: (json['data'] as List?)
          ?.map((e) => FavouriteListing.fromJson(e))
          .toList(),
      message: json['message'] as String?,
      timestamp: DateTime.tryParse(json['timestamp'] ?? ""),
      path: json['path'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }
}

class FavouriteListing {
  final String? id;
  final String? listingId;
  final ListingModel? listing;
  final DateTime? createdAt;

  FavouriteListing({
    this.id,
    this.listingId,
    this.listing,
    this.createdAt,
  });

  factory FavouriteListing.fromJson(Map<String, dynamic>? json) {
    if (json == null) return FavouriteListing();
    return FavouriteListing(
      id: json["id"],
      listingId: json["listingId"],
      listing: ListingModel().fromJson(json["listing"]),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "listingId": listingId,
    "listing": listing?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
  };
}
