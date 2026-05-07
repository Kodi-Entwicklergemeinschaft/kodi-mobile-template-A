import 'package:network/network.dart';

class ListingModel extends BaseModel<ListingModel> {
  final String? id;
  final String? slug;
  final String? title;
  final String? summary;
  final String? content;
  final String? status;
  final String? moderationStatus;
  final String? visibility;
  final bool? isFeatured;
  final bool? isFavorite;
  final String? featuredUntil;
  final String? publishAt;
  final String? expireAt;
  final String? languageCode;
  final String? sourceUrl;
  final String? heroImageUrl;
  final List<Tag>? tags;
  final int? viewCount;
  final int? likeCount;
  final int? shareCount;
  final String? createdByUserId;
  final String? lastEditedByUserId;
  final String? reviewedBy;
  final String? reviewedAt;
  final String? reviewNotes;
  final String? sourceType;
  final String? externalSource;
  final String? externalId;
  final String? syncHash;
  final String? contentChecksum;
  final String? lastSyncedAt;
  final String? ingestedAt;
  final String? ingestedByService;
  final String? ingestNotes;
  final String? primaryCityId;
  final String? venueName;
  final String? address;
  final double? geoLat;
  final double? geoLng;
  final String? timezone;
  final String? contactPhone;
  final String? contactEmail;
  final String? website;
  final String? onlineAppointmentUrl;
  final String? eventStart;
  final String? eventEnd;
  final bool? isAllDay;
  final String? organizerName;
  final String? organizerContact;
  final String? registrationUrl;
  final bool? isArchived;
  final String? archivedAt;
  final String? archivedBy;
  final String? createdAt;
  final String? updatedAt;
  final List<Category>? categories;
  final List<City>? cities;
  final List<Media>? media;
  final List<TimeInterval>? timeIntervals;
  final List<TimeIntervalException>? timeIntervalExceptions;
  final String? headerBackgroundColor;
  final double? distance;

  ListingModel({
    this.id,
    this.slug,
    this.title,
    this.summary,
    this.content,
    this.status,
    this.moderationStatus,
    this.visibility,
    this.isFeatured,
    this.isFavorite,
    this.featuredUntil,
    this.publishAt,
    this.expireAt,
    this.languageCode,
    this.sourceUrl,
    this.heroImageUrl,
    this.tags,
    this.viewCount,
    this.likeCount,
    this.shareCount,
    this.createdByUserId,
    this.lastEditedByUserId,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewNotes,
    this.sourceType,
    this.externalSource,
    this.externalId,
    this.syncHash,
    this.contentChecksum,
    this.lastSyncedAt,
    this.ingestedAt,
    this.ingestedByService,
    this.ingestNotes,
    this.primaryCityId,
    this.venueName,
    this.address,
    this.geoLat,
    this.geoLng,
    this.timezone,
    this.contactPhone,
    this.contactEmail,
    this.website,
    this.onlineAppointmentUrl,
    this.eventStart,
    this.eventEnd,
    this.isAllDay,
    this.organizerName,
    this.organizerContact,
    this.registrationUrl,
    this.isArchived,
    this.archivedAt,
    this.archivedBy,
    this.createdAt,
    this.updatedAt,
    this.categories,
    this.cities,
    this.media,
    this.timeIntervals,
    this.timeIntervalExceptions,
    this.headerBackgroundColor,
    this.distance,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "slug": slug,
      "title": title,
      "summary": summary,
      "content": content,
      "status": status,
      "moderationStatus": moderationStatus,
      "visibility": visibility,
      "isFeatured": isFeatured,
      "isFavorite": isFavorite,
      "featuredUntil": featuredUntil,
      "publishAt": publishAt,
      "expireAt": expireAt,
      "languageCode": languageCode,
      "sourceUrl": sourceUrl,
      "heroImageUrl": heroImageUrl,
      "metadata": {
        "tags": tags?.map((e) => e.toJson()).toList(),
      },
      "viewCount": viewCount,
      "likeCount": likeCount,
      "shareCount": shareCount,
      "createdByUserId": createdByUserId,
      "lastEditedByUserId": lastEditedByUserId,
      "reviewedBy": reviewedBy,
      "reviewedAt": reviewedAt,
      "reviewNotes": reviewNotes,
      "sourceType": sourceType,
      "externalSource": externalSource,
      "externalId": externalId,
      "syncHash": syncHash,
      "contentChecksum": contentChecksum,
      "lastSyncedAt": lastSyncedAt,
      "ingestedAt": ingestedAt,
      "ingestedByService": ingestedByService,
      "ingestNotes": ingestNotes,
      "primaryCityId": primaryCityId,
      "venueName": venueName,
      "address": address,
      "geoLat": geoLat,
      "geoLng": geoLng,
      "timezone": timezone,
      "contactPhone": contactPhone,
      "contactEmail": contactEmail,
      "website": website,
      "onlineAppointmentUrl": onlineAppointmentUrl,
      "eventStart": eventStart,
      "eventEnd": eventEnd,
      "isAllDay": isAllDay,
      "organizerName": organizerName,
      "organizerContact": organizerContact,
      "registrationUrl": registrationUrl,
      "isArchived": isArchived,
      "archivedAt": archivedAt,
      "archivedBy": archivedBy,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "categories": categories?.map((e) => e.toJson()).toList(),
      "cities": cities?.map((e) => e.toJson()).toList(),
      "media": media?.map((e) => e.toJson()).toList(),
      "timeIntervals": timeIntervals?.map((e) => e.toJson()).toList(),
      "timeIntervalExceptions": timeIntervalExceptions?.map((e) => e.toJson()).toList(),
      "headerBackgroundColor": headerBackgroundColor,
      "distance": distance,
    };
  }

  @override
  ListingModel fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json["id"],
      slug: json["slug"],
      title: json["title"],
      summary: json["summary"],
      content: json["content"],
      status: json["status"],
      moderationStatus: json["moderationStatus"],
      visibility: json["visibility"],
      isFeatured: json["isFeatured"],
      isFavorite: json["isFavorite"]??false,
      featuredUntil: json["featuredUntil"],
      publishAt: json["publishAt"],
      expireAt: json["expireAt"],
      languageCode: json["languageCode"],
      sourceUrl: json["sourceUrl"],
      heroImageUrl: json["heroImageUrl"],
      tags: (json["tags"] as List?)
          ?.map((e) => Tag().fromJson(e as Map<String, dynamic>))
          .toList(),
      viewCount: json["viewCount"],
      likeCount: json["likeCount"],
      shareCount: json["shareCount"],
      createdByUserId: json["createdByUserId"],
      lastEditedByUserId: json["lastEditedByUserId"],
      reviewedBy: json["reviewedBy"],
      reviewedAt: json["reviewedAt"],
      reviewNotes: json["reviewNotes"],
      sourceType: json["sourceType"],
      externalSource: json["externalSource"],
      externalId: json["externalId"],
      syncHash: json["syncHash"],
      contentChecksum: json["contentChecksum"],
      lastSyncedAt: json["lastSyncedAt"],
      ingestedAt: json["ingestedAt"],
      ingestedByService: json["ingestedByService"],
      ingestNotes: json["ingestNotes"],
      primaryCityId: json["primaryCityId"],
      venueName: json["venueName"],
      address: json["address"],
      geoLat: (json["geoLat"] as num?)?.toDouble(),
      geoLng: (json["geoLng"] as num?)?.toDouble(),
      timezone: json["timezone"],
      contactPhone: json["contactPhone"],
      contactEmail: json["contactEmail"],
      website: json["website"],
      onlineAppointmentUrl: json["onlineAppointmentUrl"],
      eventStart: json["eventStart"],
      eventEnd: json["eventEnd"],
      isAllDay: json["isAllDay"],
      organizerName: json["organizerName"],
      organizerContact: json["organizerContact"],
      registrationUrl: json["registrationUrl"],
      isArchived: json["isArchived"],
      archivedAt: json["archivedAt"],
      archivedBy: json["archivedBy"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      categories: (json["categories"] as List?)
          ?.map((e) => Category().fromJson(e as Map<String, dynamic>))
          .toList(),
      cities: (json["cities"] as List?)
          ?.map((e) => City().fromJson(e as Map<String, dynamic>))
          .toList(),
      media: (json["media"] as List?)
          ?.map((e) => Media().fromJson(e as Map<String, dynamic>))
          .toList(),
      timeIntervals: (json["timeIntervals"] as List?)
          ?.map((e) => TimeInterval().fromJson(e as Map<String, dynamic>))
          .toList(),
      timeIntervalExceptions: (json["timeIntervalExceptions"] as List?)
          ?.map((e) => TimeIntervalException().fromJson(e as Map<String, dynamic>))
          .toList(),
      headerBackgroundColor: json["headerBackgroundColor"],
      distance: (json["distance"] as num?)?.toDouble(),
    );
  }

  ListingModel copyWith({ bool? isFavourite,double? distance}) {
    return ListingModel(
      id: id,
      slug: slug,
      title: title,
      summary: summary,
      content: content,
      status: status,
      moderationStatus: moderationStatus,
      visibility: visibility,
      isFeatured: isFeatured,
      isFavorite: isFavourite??isFavorite,
      featuredUntil: featuredUntil,
      publishAt: publishAt,
      expireAt: expireAt,
      languageCode: languageCode,
      sourceUrl: sourceUrl,
      heroImageUrl: heroImageUrl,
      tags: tags,
      viewCount: viewCount,
      likeCount: likeCount,
      shareCount: shareCount,
      createdByUserId: createdByUserId,
      lastEditedByUserId: lastEditedByUserId,
      reviewedBy: reviewedBy,
      reviewedAt: reviewedAt,
      reviewNotes: reviewNotes,
      sourceType: sourceType,
      externalSource: externalSource,
      externalId: externalId,
      syncHash: syncHash,
      contentChecksum: contentChecksum,
      lastSyncedAt: lastSyncedAt,
      ingestedAt: ingestedAt,
      ingestedByService: ingestedByService,
      ingestNotes: ingestNotes,
      primaryCityId: primaryCityId,
      venueName: venueName,
      address: address,
      geoLat: geoLat,
      geoLng: geoLng,
      timezone: timezone,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      website: website,
      onlineAppointmentUrl: onlineAppointmentUrl,
      eventStart: eventStart,
      eventEnd: eventEnd,
      isAllDay: isAllDay,
      organizerName: organizerName,
      organizerContact: organizerContact,
      registrationUrl: registrationUrl,
      isArchived: isArchived,
      archivedAt: archivedAt,
      archivedBy: archivedBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      categories: categories,
      cities: cities,
      media: media,
      timeIntervals: timeIntervals,
      timeIntervalExceptions: timeIntervalExceptions,
      headerBackgroundColor: headerBackgroundColor,
      distance: distance?? this.distance,
    );
  }
}

class Category {
  final String? id;
  final String? categoryId;
  final String? name;
  final String? slug;
  final String? type;

  Category({this.id, this.categoryId, this.name, this.slug, this.type});

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryId": categoryId,
    "name": name,
    "slug": slug,
    "type": type,
  };

  Category fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    categoryId: json["categoryId"],
    name: json["name"],
    slug: json["slug"],
    type: json["type"],
  );
}

class City {
  final String? id;
  final String? cityId;
  final bool? isPrimary;
  final int? displayOrder;

  City({this.id, this.cityId, this.isPrimary, this.displayOrder});

  Map<String, dynamic> toJson() => {
    "id": id,
    "cityId": cityId,
    "isPrimary": isPrimary,
    "displayOrder": displayOrder,
  };

  City fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    cityId: json["cityId"],
    isPrimary: json["isPrimary"],
    displayOrder: json["displayOrder"],
  );
}

class Media {
  final String? id;
  final String? type;
  final String? url;
  final String? altText;
  final String? caption;
  final int? order;
  final Map<String, dynamic>? metadata;

  Media({
    this.id,
    this.type,
    this.url,
    this.altText,
    this.caption,
    this.order,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "url": url,
    "altText": altText,
    "caption": caption,
    "order": order,
    "metadata": metadata,
  };

  Media fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    type: json["type"],
    url: json["url"],
    altText: json["altText"],
    caption: json["caption"],
    order: json["order"],
    metadata: json["metadata"],
  );
}

class Tag {
  final String? id;
  final String? tagId;
  final String? provider;
  final String? externalValue;
  final String? label;
  final String? languageCode;

  Tag({
    this.id,
    this.tagId,
    this.provider,
    this.externalValue,
    this.label,
    this.languageCode,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "tagId": tagId,
        "provider": provider,
        "externalValue": externalValue,
        "label": label,
        "languageCode": languageCode,
      };

  Tag fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        tagId: json["tagId"],
        provider: json["provider"],
        externalValue: json["externalValue"],
        label: json["label"],
        languageCode: json["languageCode"],
      );
}

class TimeInterval {
  final String? id;
  final List<String>? weekdays;
  final String? start;
  final String? end;
  final String? tz;
  final String? freq;
  final int? interval;
  final String? repeatUntil;
  final Map<String, dynamic>? metadata;

  TimeInterval({
    this.id,
    this.weekdays,
    this.start,
    this.end,
    this.tz,
    this.freq,
    this.interval,
    this.repeatUntil,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "weekdays": weekdays,
    "start": start,
    "end": end,
    "tz": tz,
    "freq": freq,
    "interval": interval,
    "repeatUntil": repeatUntil,
    "metadata": metadata,
  };

  TimeInterval fromJson(Map<String, dynamic> json) => TimeInterval(
    id: json["id"],
    weekdays: (json["weekdays"] as List?)?.map((e) => e.toString()).toList(),
    start: json["start"],
    end: json["end"],
    tz: json["tz"],
    freq: json["freq"],
    interval: json["interval"],
    repeatUntil: json["repeatUntil"],
    metadata: json["metadata"],
  );
}

class TimeIntervalException {
  final String? id;
  final String? date;
  final String? opensAt;
  final String? closesAt;
  final bool? isClosed;
  final Map<String, dynamic>? metadata;

  TimeIntervalException({
    this.id,
    this.date,
    this.opensAt,
    this.closesAt,
    this.isClosed,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "opensAt": opensAt,
    "closesAt": closesAt,
    "isClosed": isClosed,
    "metadata": metadata,
  };

  TimeIntervalException fromJson(Map<String, dynamic> json) => TimeIntervalException(
    id: json["id"],
    date: json["date"],
    opensAt: json["opensAt"],
    closesAt: json["closesAt"],
    isClosed: json["isClosed"],
    metadata: json["metadata"],
  );
}
