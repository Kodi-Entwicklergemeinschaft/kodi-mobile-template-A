import 'package:network/network.dart';

class CategoryFilterResponseModel
    extends BaseModel<CategoryFilterResponseModel> {
  bool? success;
  int? statusCode;
  String? message;
  List<FilterGroup>? groups;

  CategoryFilterResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.groups,
  });

  @override
  CategoryFilterResponseModel fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return CategoryFilterResponseModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      groups: (data?['groups'] as List?)
          ?.map((e) => FilterGroup().fromJson(e))
          .toList(),
    );
  }


  @override
  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "statusCode": statusCode,
      "message": message,
      "groups": groups?.map((e) => e.toJson()).toList(),
    };
  }
}

class FilterGroup extends BaseModel<FilterGroup> {
  String? name;
  List<Heading>? headings;

  FilterGroup({this.name, this.headings});

  @override
  FilterGroup fromJson(Map<String, dynamic> json) {
    return FilterGroup(
      name: json['name'],
      headings: (json['headings'] as List?)
          ?.map((e) => Heading().fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "headings": headings?.map((e) => e.toJson()).toList(),
    };
  }
}

class Heading extends BaseModel<Heading> {
  String? name;
  List<FilterItem>? filters;

  Heading({this.name, this.filters});

  @override
  Heading fromJson(Map<String, dynamic> json) {
    return Heading(
      name: json['name'],
      filters: (json['filters'] as List?)
          ?.map((e) => FilterItem().fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "filters": filters?.map((e) => e.toJson()).toList(),
    };
  }
}

class FilterItem extends BaseModel<FilterItem> {
  String? id;
  String? value;
  String? label;
  String? displayName;
  int? displayOrder;

  FilterItem({
    this.id,
    this.value,
    this.label,
    this.displayName,
    this.displayOrder,
  });

  @override
  FilterItem fromJson(Map<String, dynamic> json) {
    return FilterItem(
      id: json['id'],
      value: json['value'],
      label: json['label'],
      displayName: json['displayName'],
      displayOrder: json['displayOrder'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "value": value,
      "label": label,
      "displayName": displayName,
      "displayOrder": displayOrder,
    };
  }
}