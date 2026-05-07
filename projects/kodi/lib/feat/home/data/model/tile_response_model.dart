import 'package:network/network.dart';

class TileResponseModel extends BaseModel<TileResponseModel> {
  final bool success;
  final TileDataModel? data;
  final String? message;
  final String? timestamp;
  final String? path;
  final int? statusCode;

  TileResponseModel({
    required this.success,
    this.data,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });

  @override
  TileResponseModel fromJson(Map<String, dynamic> json) {
    return TileResponseModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? TileDataModel().fromJson(json['data']) : null,
      message: json['message'],
      timestamp: json['timestamp'],
      path: json['path'],
      statusCode: json['statusCode'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data?.toJson(),
    'message': message,
    'timestamp': timestamp,
    'path': path,
    'statusCode': statusCode,
  };
}

class TileDataModel extends BaseModel<TileDataModel> {
  final List<TileModel> items;
  final MetaModel? meta;

  TileDataModel({
    this.items = const [],
    this.meta,
  });

  @override
  TileDataModel fromJson(Map<String, dynamic> json) {
    return TileDataModel(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => TileModel().fromJson(e))
          .toList() ??
          [],
      meta: json['meta'] != null ? MetaModel().fromJson(json['meta']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'meta': meta?.toJson(),
  };
}

class TileModel extends BaseModel<TileModel> {
  final String? id;
  final String? slug;
  final String? backgroundImageUrl;
  final String? iconImageUrl;
  final String? headerBackgroundColor;
  final String? header;
  final String? subheader;
  final String? description;
  final String? contentBackgroundColor;
  final String? websiteUrl;
  final bool? openInExternalBrowser;
  final int? displayOrder;
  final bool? isActive;
  final String? publishAt;
  final String? expireAt;
  final String? createdByUserId;
  final String? lastEditedByUserId;
  final String? createdAt;
  final String? updatedAt;
  final List<TileCityModel> cities;

  TileModel({
    this.id,
    this.slug,
    this.backgroundImageUrl,
    this.iconImageUrl,
    this.headerBackgroundColor,
    this.header,
    this.subheader,
    this.description,
    this.contentBackgroundColor,
    this.websiteUrl,
    this.openInExternalBrowser,
    this.displayOrder,
    this.isActive,
    this.publishAt,
    this.expireAt,
    this.createdByUserId,
    this.lastEditedByUserId,
    this.createdAt,
    this.updatedAt,
    this.cities = const [],
  });

  @override
  TileModel fromJson(Map<String, dynamic> json) {
    return TileModel(
      id: json['id'],
      slug: json['slug'],
      backgroundImageUrl: json['backgroundImageUrl'],
      iconImageUrl: json['iconImageUrl'],
      headerBackgroundColor: json['headerBackgroundColor'],
      header: json['header'],
      subheader: json['subheader'],
      description: json['description'],
      contentBackgroundColor: json['contentBackgroundColor'],
      websiteUrl: json['websiteUrl'],
      openInExternalBrowser: json['openInExternalBrowser'],
      displayOrder: json['displayOrder'],
      isActive: json['isActive'],
      publishAt: json['publishAt'],
      expireAt: json['expireAt'],
      createdByUserId: json['createdByUserId'],
      lastEditedByUserId: json['lastEditedByUserId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      cities: (json['cities'] as List<dynamic>?)
          ?.map((e) => TileCityModel().fromJson(e))
          .toList() ??
          [],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'backgroundImageUrl': backgroundImageUrl,
    'iconImageUrl': iconImageUrl,
    'headerBackgroundColor': headerBackgroundColor,
    'header': header,
    'subheader': subheader,
    'description': description,
    'contentBackgroundColor': contentBackgroundColor,
    'websiteUrl': websiteUrl,
    'openInExternalBrowser': openInExternalBrowser,
    'displayOrder': displayOrder,
    'isActive': isActive,
    'publishAt': publishAt,
    'expireAt': expireAt,
    'createdByUserId': createdByUserId,
    'lastEditedByUserId': lastEditedByUserId,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'cities': cities.map((e) => e.toJson()).toList(),
  };
}

class TileCityModel extends BaseModel<TileCityModel> {
  final String? id;
  final String? cityId;
  final bool? isPrimary;
  final int? displayOrder;

  TileCityModel({
    this.id,
    this.cityId,
    this.isPrimary,
    this.displayOrder,
  });

  @override
  TileCityModel fromJson(Map<String, dynamic> json) {
    return TileCityModel(
      id: json['id'],
      cityId: json['cityId'],
      isPrimary: json['isPrimary'],
      displayOrder: json['displayOrder'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'cityId': cityId,
    'isPrimary': isPrimary,
    'displayOrder': displayOrder,
  };
}

class MetaModel extends BaseModel<MetaModel> {
  final int? page;
  final int? pageSize;
  final int? total;
  final int? totalPages;

  MetaModel({
    this.page,
    this.pageSize,
    this.total,
    this.totalPages,
  });

  @override
  MetaModel fromJson(Map<String, dynamic> json) {
    return MetaModel(
      page: json['page'],
      pageSize: json['pageSize'],
      total: json['total'],
      totalPages: json['totalPages'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'page': page,
    'pageSize': pageSize,
    'total': total,
    'totalPages': totalPages,
  };
}
