import 'package:network/network.dart';

class CityModel extends BaseModel<CityModel> {
  final String? imageUrl;
  final String? tagText;
  final String? title;
  final String? subtitle;

  CityModel({
    this.imageUrl,
    this.tagText,
    this.title,
    this.subtitle,
  });


  @override
  Map<String, dynamic> toJson() {
    return {
      "imageUrl": imageUrl,
      "tagText": tagText,
      "title": title,
      "subtitle": subtitle,
    };
  }

  @override
  CityModel fromJson(Map<String, dynamic> json) {
    return CityModel(
      imageUrl: json["imageUrl"] as String?,
      tagText: json["tagText"] as String?,
      title: json["title"] as String?,
      subtitle: json["subtitle"] as String?,
    );
  }
}
