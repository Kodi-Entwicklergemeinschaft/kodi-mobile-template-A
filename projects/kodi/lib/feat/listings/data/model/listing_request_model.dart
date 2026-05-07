import 'package:network/network.dart';

class ListingRequestModel extends BaseModel<ListingRequestModel> {
  final String? search;
  final List<String>? cityIds;
  final List<String>? categoryIds;
  final String? status;
  final String? moderationStatus;
  final String? visibility;
  final String? sourceType;
  final bool? isFeatured;
  final List<String>? languageCodes;
  final String? publishAfter;
  final String? publishBefore;
  final String? upcomingAfter;
  final String? upcomingBefore;
  final String? sortBy;
  final String? sortDirection;
  final bool? eventSort;
  final int? page;
  final int? pageSize;
  final String? quickFilter;
  final int? radiusMeters;
  final double? userLat;
  final double? userLng;
  final String? parentId;
  List<String>? filterIds;

  ListingRequestModel({
    this.search,
    this.cityIds,
    this.categoryIds,
    this.status,
    this.moderationStatus,
    this.visibility,
    this.sourceType,
    this.isFeatured,
    this.languageCodes,
    this.publishAfter,
    this.publishBefore,
    this.upcomingAfter,
    this.upcomingBefore,
    this.sortBy,
    this.sortDirection,
    this.eventSort,
    this.page,
    this.pageSize,
    this.quickFilter,
    this.radiusMeters,
    this.userLat,
    this.userLng,
    this.parentId,
    this.filterIds,
  });

  /// Convert model to query parameters map for GET requests
  Map<String, dynamic> toQueryParameters() {
    return {
      if (search != null) "search": search,
      if (cityIds?.isNotEmpty == true) "cityIds": cityIds,
      if (categoryIds?.isNotEmpty == true) "categoryIds": categoryIds,
      if (status != null) "status": status,
      if (moderationStatus != null) "moderationStatus": moderationStatus,
      if (visibility != null) "visibility": visibility,
      if (sourceType != null) "sourceType": sourceType,
      if (isFeatured != null) "isFeatured": isFeatured,
      if (languageCodes?.isNotEmpty == true) "languageCodes": languageCodes,
      if (publishAfter != null) "publishAfter": publishAfter,
      if (publishBefore != null) "publishBefore": publishBefore,
      if (upcomingAfter != null) "upcomingAfter": upcomingAfter,
      if (upcomingBefore != null) "upcomingBefore": upcomingBefore,
      if (sortBy != null) "sortBy": sortBy,
      if (sortDirection != null) "sortDirection": sortDirection,
      if (eventSort != null) "eventSort": eventSort,
      if (page != null) "page": page,
      if (pageSize != null) "pageSize": pageSize,
      if (quickFilter != null) "quickFilter": quickFilter,
      if (radiusMeters != null) "radiusMeters": radiusMeters,
      if (userLat != null) "userLat": userLat,
      if (userLng != null) "userLng": userLng,
      if (parentId != null) "parentId": parentId,
      if (filterIds?.isNotEmpty == true)
        "filterIds": filterIds!.join(","),
    };
  }

  @override
  Map<String, dynamic> toJson() => toQueryParameters();

  @override
  ListingRequestModel fromJson(Map<String, dynamic> json) {
    return ListingRequestModel(
      search: json["search"],
      cityIds: (json["cityIds"] as List?)?.map((e) => e.toString()).toList(),
      categoryIds: (json["categoryIds"] as List?)?.map((e) => e.toString()).toList(),
      status: json["status"],
      moderationStatus: json["moderationStatus"],
      visibility: json["visibility"],
      sourceType: json["sourceType"],
      isFeatured: json["isFeatured"],
      languageCodes: (json["languageCodes"] as List?)?.map((e) => e.toString()).toList(),
      publishAfter: json["publishAfter"],
      publishBefore: json["publishBefore"],
      upcomingAfter: json["upcomingAfter"],
      upcomingBefore: json["upcomingBefore"],
      sortBy: json["sortBy"],
      sortDirection: json["sortDirection"],
      eventSort: json["eventSort"],
      page: json["page"],
      pageSize: json["pageSize"],
      quickFilter: json["quickFilter"],
      radiusMeters: json["radiusMeters"],
      userLat: (json["userLat"] as num?)?.toDouble(),
      userLng: (json["userLng"] as num?)?.toDouble(),
      parentId: json["parentId"],
      filterIds: (json["filterIds"] as List?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  ListingRequestModel copyWith({
    String? search,
    List<String>? cityIds,
    List<String>? categoryIds,
    String? status,
    String? moderationStatus,
    String? visibility,
    String? sourceType,
    bool? isFeatured,
    List<String>? languageCodes,
    String? publishAfter,
    String? publishBefore,
    String? upcomingAfter,
    String? upcomingBefore,
    String? sortBy,
    String? sortDirection,
    bool? eventSort,
    int? page,
    int? pageSize,
    String? quickFilter,
    int? radiusMeters,
    double? userLat,
    double? userLng,
    String? parentId,
    List<String>? filterIds,
  }) {
    return ListingRequestModel(
      search: search ?? this.search,
      cityIds: cityIds ?? this.cityIds,
      categoryIds: categoryIds ?? this.categoryIds,
      status: status ?? this.status,
      moderationStatus: moderationStatus ?? this.moderationStatus,
      visibility: visibility ?? this.visibility,
      sourceType: sourceType ?? this.sourceType,
      isFeatured: isFeatured ?? this.isFeatured,
      languageCodes: languageCodes ?? this.languageCodes,
      publishAfter: publishAfter ?? this.publishAfter,
      publishBefore: publishBefore ?? this.publishBefore,
      upcomingAfter: upcomingAfter ?? this.upcomingAfter,
      upcomingBefore: upcomingBefore ?? this.upcomingBefore,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      eventSort: eventSort ?? this.eventSort,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      quickFilter: quickFilter ?? this.quickFilter,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
      parentId: parentId ?? this.parentId,
      filterIds: filterIds ?? this.filterIds,
    );
  }
}
