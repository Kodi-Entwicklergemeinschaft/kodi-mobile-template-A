import 'package:network/network.dart';

import 'listing_model.dart';

class ListingResponseModel extends BaseModel<ListingResponseModel> {
  final bool? success;
  final EventListData? data;
  final String? message;
  final String? timestamp;
  final String? path;
  final int? statusCode;

  ListingResponseModel({
    this.success,
    this.data,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });

  @override
  ListingResponseModel fromJson(Map<String, dynamic> json) {
    return ListingResponseModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? EventListData().fromJson(json['data']) : null,
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

class EventListData extends BaseModel<EventListData> {
  final List<ListingModel> items;
  final MetaModel? meta;

  EventListData({
    this.items = const [],
    this.meta,
  });

  @override
  EventListData fromJson(Map<String, dynamic> json) {
    return EventListData(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ListingModel().fromJson(e))
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


class MetaModel {
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

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "pageSize": pageSize,
      "total": total,
      "totalPages": totalPages,
    };
  }

  MetaModel fromJson(Map<String, dynamic> json) {
    return MetaModel(
      page: json["page"],
      pageSize: json["pageSize"],
      total: json["total"],
      totalPages: json["totalPages"],
    );
  }
}
