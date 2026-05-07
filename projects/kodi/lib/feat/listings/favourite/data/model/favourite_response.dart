import 'package:network/network.dart';

class FavouriteResponse extends BaseModel<FavouriteResponse>{
  final bool? success;
  final FavouriteData? data;
  final String? message;

  FavouriteResponse({this.success, this.data, this.message});

  factory FavouriteResponse.fromJson(Map<String, dynamic> json) {
    return FavouriteResponse(
      success: json['success'],
      data: json['data'] != null ? FavouriteData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  @override
  FavouriteResponse fromJson(Map<String, dynamic> json) {
    return FavouriteResponse.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['data'] = this.data?.toJson();
    data['message'] = message;
    return data;
  }
}

class FavouriteData {
  final String? id;
  final String? listingId;
  final ListingInFavourite? listing;

  FavouriteData({this.id, this.listingId, this.listing});

  factory FavouriteData.fromJson(Map<String, dynamic> json) {
    return FavouriteData(
      id: json['id'],
      listingId: json['listingId'],
      listing: json['listing'] != null
          ? ListingInFavourite.fromJson(json['listing'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['listingId'] = listingId;
    data['listing'] = listing?.toJson();
    return data;
  }
}

class ListingInFavourite {
  final String? id;
  final bool? isFavorite;

  ListingInFavourite({this.id, this.isFavorite});

  factory ListingInFavourite.fromJson(Map<String, dynamic> json) {
    return ListingInFavourite(
      id: json['id'],
      isFavorite: json['isFavorite'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isFavorite'] = isFavorite;
    return data;
  }
}
