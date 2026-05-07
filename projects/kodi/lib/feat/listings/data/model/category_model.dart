
// Category Model (supports nested children)
class CategoryModel {
  final String id;
  final String name;
  final String slugString;
  final CategorySlug slug;
  final String? description;
  final String? subtitle;
  final String? iconUrl;
  final String? imageUrl;
  final String? headerBackgroundColor;
  final String? contentBackgroundColor;
  final String? type;
  final String? parentId;
  final bool isQuickFilter;
  final String? quickFilter;
  final int? cityCategoryDisplayOrder;
  final int? radiusMeters;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CategoryModel> children;
  final bool isFavourite;
  final String? onTapUrl;
  final String? languageCode;
  final String? viewType;
  final bool hasCityOverride;
  final String? cityId;
  final List<SubServiceModel> subServices;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slugString,
    required this.slug,
    this.description,
    this.subtitle,
    this.iconUrl,
    this.imageUrl,
    this.headerBackgroundColor,
    this.contentBackgroundColor,
    this.type,
    this.parentId,
    this.isQuickFilter = false,
    this.quickFilter,
    this.cityCategoryDisplayOrder,
    this.radiusMeters,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.children,
    this.isFavourite = false,
    this.onTapUrl,
    this.languageCode,
    this.viewType,
    this.hasCityOverride = false,
    this.cityId,
    this.subServices = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      slugString: json['slug'],
      slug: CategorySlugExt.fromSlug(json["slug"] ?? ""),
      description: json['description'],
      subtitle: json['subtitle'],
      iconUrl: json['iconUrl'],
      imageUrl: json['imageUrl'],
      onTapUrl: json['onTapUrl'],
      headerBackgroundColor: json['headerBackgroundColor'],
      contentBackgroundColor: json['contentBackgroundColor'],
      type: json['type'],
      parentId: json['parentId'],
      isQuickFilter: json['isQuickFilter'] ?? false,
      quickFilter: json['quickFilter'],
      cityCategoryDisplayOrder: json['cityCategoryDisplayOrder'],
      radiusMeters: json['radiusMeters'],
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      children: (json['children'] as List<dynamic>? ?? [])
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
      isFavourite: json['isFavorite'] ?? false,
      languageCode: json['languageCode'],
      viewType: json['viewType'],
      hasCityOverride: json['hasCityOverride'] ?? false,
      cityId: json['cityId'],
      subServices: (json['subServices'] as List<dynamic>? ?? [])
          .map((e) => SubServiceModel.fromJson(e))
          .toList(),
    );
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? slugString,
    CategorySlug? slug,
    String? description,
    String? subtitle,
    String? iconUrl,
    String? imageUrl,
    String? headerBackgroundColor,
    String? contentBackgroundColor,
    String? type,
    String? parentId,
    bool? isQuickFilter,
    String? quickFilter,
    int? cityCategoryDisplayOrder,
    int? radiusMeters,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CategoryModel>? children,
    bool? isFavourite,
    String? onTapUrl,
    String? languageCode,
    String? viewType,
    bool? hasCityOverride,
    String? cityId,
    List<SubServiceModel>? subServices,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slugString: slugString ?? this.slugString,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      subtitle: subtitle ?? this.subtitle,
      iconUrl: iconUrl ?? this.iconUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor,
      contentBackgroundColor: contentBackgroundColor ?? this.contentBackgroundColor,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
      isQuickFilter: isQuickFilter ?? this.isQuickFilter,
      quickFilter: quickFilter ?? this.quickFilter,
      cityCategoryDisplayOrder: cityCategoryDisplayOrder ?? this.cityCategoryDisplayOrder,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      children: children ?? this.children,
      isFavourite: isFavourite ?? this.isFavourite,
      onTapUrl: onTapUrl ?? this.onTapUrl,
      languageCode: languageCode ?? this.languageCode,
      viewType: viewType ?? this.viewType,
      hasCityOverride: hasCityOverride ?? this.hasCityOverride,
      cityId: cityId ?? this.cityId,
      subServices: subServices ?? this.subServices,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slugString,
      'description': description,
      'subtitle': subtitle,
      'iconUrl': iconUrl,
      'imageUrl': imageUrl,
      'onTapUrl': onTapUrl,
      'headerBackgroundColor': headerBackgroundColor,
      'contentBackgroundColor': contentBackgroundColor,
      'type': type,
      'parentId': parentId,
      'isQuickFilter': isQuickFilter,
      'quickFilter': quickFilter,
      'cityCategoryDisplayOrder': cityCategoryDisplayOrder,
      'radiusMeters': radiusMeters,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'children': children.map((e) => e.toJson()).toList(),
      'isFavorite': isFavourite,
      'languageCode': languageCode,
      'viewType': viewType,
      'hasCityOverride': hasCityOverride,
      'cityId': cityId,
      'subServices': subServices.map((e) => e.toJson()).toList(),
    };
  }
}


class SubServiceModel {
  final String id;
  final String? itemType;
  final int? displayOrder;
  final String? itemId;
  final String? slug;
  final String name;
  final String? subtitle;
  final String? description;
  final String? imageUrl;
  final String? iconUrl;
  final String? headerBackgroundColor;
  final String? contentBackgroundColor;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? websiteUrl;
  final bool? openInExternalBrowser;
  final DateTime? publishAt;
  final DateTime? expireAt;
  final String? createdByUserId;
  final String? lastEditedByUserId;
  final List<SubServiceCityModel>? cities;
  final String? type;
  final String? parentId;
  final String? viewType;
  final List<CategoryModel>? children;
  final bool? isFavorite;

  SubServiceModel({
    required this.id,
    this.itemType,
    this.displayOrder,
    this.itemId,
    this.slug,
    required this.name,
    this.subtitle,
    this.description,
    this.imageUrl,
    this.iconUrl,
    this.headerBackgroundColor,
    this.contentBackgroundColor,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.websiteUrl,
    this.openInExternalBrowser,
    this.publishAt,
    this.expireAt,
    this.createdByUserId,
    this.lastEditedByUserId,
    this.cities,
    this.type,
    this.parentId,
    this.viewType,
    this.children,
    this.isFavorite,
  });

  factory SubServiceModel.fromJson(Map<String, dynamic> json) {
    return SubServiceModel(
      id: json['id'] ?? "",
      itemType: json['itemType'],
      displayOrder: json['displayOrder'],
      itemId: json['itemId'],
      slug: json['slug'],
      name: json['name'] ?? "",
      subtitle: json['subtitle'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      iconUrl: json['iconUrl'],
      headerBackgroundColor: json['headerBackgroundColor'],
      contentBackgroundColor: json['contentBackgroundColor'],
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      websiteUrl: json['websiteUrl'],
      openInExternalBrowser: json['openInExternalBrowser'],
      publishAt: json['publishAt'] != null ? DateTime.parse(json['publishAt']) : null,
      expireAt: json['expireAt'] != null ? DateTime.parse(json['expireAt']) : null,
      createdByUserId: json['createdByUserId'],
      lastEditedByUserId: json['lastEditedByUserId'],
      cities: (json['cities'] as List<dynamic>?)
          ?.map((e) => SubServiceCityModel.fromJson(e))
          .toList(),
      type: json['type'],
      parentId: json['parentId'],
      viewType: json['viewType'],
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e))
          .toList(),
      isFavorite: json['isFavorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemType': itemType,
      'displayOrder': displayOrder,
      'itemId': itemId,
      'slug': slug,
      'name': name,
      'subtitle': subtitle,
      'description': description,
      'imageUrl': imageUrl,
      'iconUrl': iconUrl,
      'headerBackgroundColor': headerBackgroundColor,
      'contentBackgroundColor': contentBackgroundColor,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'websiteUrl': websiteUrl,
      'openInExternalBrowser': openInExternalBrowser,
      'publishAt': publishAt?.toIso8601String(),
      'expireAt': expireAt?.toIso8601String(),
      'createdByUserId': createdByUserId,
      'lastEditedByUserId': lastEditedByUserId,
      'cities': cities?.map((e) => e.toJson()).toList(),
      'type': type,
      'parentId': parentId,
      'viewType': viewType,
      'children': children?.map((e) => e.toJson()).toList(),
      'isFavorite': isFavorite,
    };
  }
}


class SubServiceCityModel {
  final String id;
  final String cityId;
  final bool isPrimary;
  final int displayOrder;

  SubServiceCityModel({
    required this.id,
    required this.cityId,
    required this.isPrimary,
    required this.displayOrder,
  });

  factory SubServiceCityModel.fromJson(Map<String, dynamic> json) {
    return SubServiceCityModel(
      id: json['id'] ?? "",
      cityId: json['cityId'] ?? "",
      isPrimary: json['isPrimary'] ?? false,
      displayOrder: json['displayOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cityId': cityId,
      'isPrimary': isPrimary,
      'displayOrder': displayOrder,
    };
  }
}


enum CategorySlug {
  shopping,
  restaurants,
  poi,
  culture,
  hotelsAndStays,
  tours,
  events,
  foodAndDrink,
  articlesAndStories,
  nearMe,
  showMeMore,
  kategorieName,
  administration,
  kodiWeek,
  kodiWeekEvents
}

extension CategorySlugExt on CategorySlug {
  String get slug {
    switch (this) {
      case CategorySlug.events:
        return "events";
      case CategorySlug.tours:
        return "tours";
      case CategorySlug.poi:
        return "points-of-interest";
      case CategorySlug.shopping:
        return "shopping";
      case CategorySlug.restaurants:
        return "restaurants";
      case CategorySlug.culture:
        return "culture";
      case CategorySlug.hotelsAndStays:
        return "hotels-and-stays";
      case CategorySlug.foodAndDrink:
        return "food-and-drink";
      case CategorySlug.articlesAndStories:
        return "articles-and-stories";
      case CategorySlug.showMeMore:
        return "show-me-more";
      case CategorySlug.nearMe:
        return "near-me";
      case CategorySlug.kategorieName:
        return "kategoriename";
      case CategorySlug.administration:
        return "kodier-verwaltung";
      case CategorySlug.kodiWeek:
        return "kodier-woche";
      case CategorySlug.kodiWeekEvents:
        return "kodier-woche-events";
    }
  }

  static CategorySlug fromSlug(String value) {
    return CategorySlug.values.firstWhere(
          (e) => e.slug == value,
      orElse: () => CategorySlug.poi,
    );
  }

  String get name => toString().split('.').last;

}