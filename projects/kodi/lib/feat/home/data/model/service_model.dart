import 'package:network/network.dart';

class ServiceModel  extends BaseModel<ServiceModel>{
  final String? imageUrl;
  final String? title;
  final String? description;
  final String? tagText;
  final String? tagIconUrl;


  ServiceModel({
    this.imageUrl,
    this.title,
    this.description,
    this.tagText,
    this.tagIconUrl,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    imageUrl: json['imageUrl'],
    title: json['title'],
    description: json['description'],
    tagText: json['tagText'],
    tagIconUrl: json['tagIconUrl'],
  );

  @override
  ServiceModel fromJson(Map<String, dynamic> json)=> ServiceModel(
    imageUrl: json['imageUrl'],
    title: json['title'],
    description: json['description'],
    tagText: json['tagText'],
    tagIconUrl: json['tagIconUrl'],
  );

  @override
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'tagText': tagText,
      'tagIconUrl': tagIconUrl,
    };
  }
}
