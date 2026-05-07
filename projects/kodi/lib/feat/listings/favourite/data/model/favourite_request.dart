import 'package:network/network.dart';

class FavouriteRequest extends BaseModel<FavouriteRequest>{
  final String listingId;
  final bool isFavorite;

  FavouriteRequest({required this.listingId, required this.isFavorite});

  @override
  Map<String, dynamic> toJson() {
    return {
      'listingId': listingId,
      'isFavorite': isFavorite,
    };
  }

  @override
  FavouriteRequest fromJson(Map<String, dynamic> json) {
    return FavouriteRequest(
      listingId: json['listingId'],
      isFavorite: json['isFavorite'],
    );
  }
}
