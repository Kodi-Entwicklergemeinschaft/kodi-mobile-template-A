import 'package:network/network.dart';

class CityResponseModel implements BaseModel<CityResponseModel>{
  final bool? success;
  final CityData? data;
  final String? message;
  final String? timestamp;
  final String? path;
  final int? statusCode;

  CityResponseModel({
    this.success,
    this.data,
    this.message,
    this.timestamp,
    this.path,
    this.statusCode,
  });


  @override
  CityResponseModel fromJson(Map<String, dynamic> json)  {
    return CityResponseModel(
      success: json['success'],
      data: json['data'] != null ? CityData.fromJson(json['data']) : null,
      message: json['message'],
      timestamp: json['timestamp'],
      path: json['path'],
      statusCode: json['statusCode'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'message': message,
      'timestamp': timestamp,
      'path': path,
      'statusCode': statusCode,
    };
  }
}

class CityData {
  final List<City>? items;

  CityData({this.items});

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      items: json['items'] != null
          ? List<City>.from(json['items'].map((x) => City.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((x) => x.toJson()).toList(),
    };
  }
}

class City {
  final String? id;
  final String? name;
  final String? country;
  final String? state;
  final double? latitude;
  final double? longitude;
  final int? population;
  final String? timezone;
  final CityMetadata? metadata;
  final String? headerImageUrl;
  final String? parentCityId;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  City({
    this.id,
    this.name,
    this.country,
    this.state,
    this.latitude,
    this.longitude,
    this.population,
    this.timezone,
    this.metadata,
    this.headerImageUrl,
    this.parentCityId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      state: json['state'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      population: json['population'],
      timezone: json['timezone'],
      metadata: json['metadata'] != null
          ? CityMetadata.fromJson(json['metadata'])
          : null,
      headerImageUrl: json['headerImageUrl'],
      parentCityId: json['parentCityId'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'population': population,
      'timezone': timezone,
      'metadata': metadata?.toJson(),
      'headerImageUrl': headerImageUrl,
      'parentCityId': parentCityId,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class CityMetadata {
  final EmailTheme? emailTheme;

  CityMetadata({this.emailTheme});

  factory CityMetadata.fromJson(Map<String, dynamic> json) {
    return CityMetadata(
      emailTheme: json['emailTheme'] != null
          ? EmailTheme.fromJson(json['emailTheme'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailTheme': emailTheme?.toJson(),
    };
  }
}

class EmailTheme {
  final String? appName;
  final EmailThemeDetails? emailTheme;
  final String? accentColor;
  final String? primaryColor;
  final String? appNameDisplay;
  final String? secondaryColor;
  final String? greetingTemplate;

  EmailTheme({
    this.appName,
    this.emailTheme,
    this.accentColor,
    this.primaryColor,
    this.appNameDisplay,
    this.secondaryColor,
    this.greetingTemplate,
  });

  factory EmailTheme.fromJson(Map<String, dynamic> json) {
    return EmailTheme(
      appName: json['appName'],
      emailTheme: json['emailTheme'] != null
          ? EmailThemeDetails.fromJson(json['emailTheme'])
          : null,
      accentColor: json['accentColor'],
      primaryColor: json['primaryColor'],
      appNameDisplay: json['appNameDisplay'],
      secondaryColor: json['secondaryColor'],
      greetingTemplate: json['greetingTemplate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'emailTheme': emailTheme?.toJson(),
      'accentColor': accentColor,
      'primaryColor': primaryColor,
      'appNameDisplay': appNameDisplay,
      'secondaryColor': secondaryColor,
      'greetingTemplate': greetingTemplate,
    };
  }
}

class EmailThemeDetails {
  final String? buttonColor;
  final String? buttonTextColor;
  final String? footerBackgroundColor;
  final String? headerBackgroundColor;

  EmailThemeDetails({
    this.buttonColor,
    this.buttonTextColor,
    this.footerBackgroundColor,
    this.headerBackgroundColor,
  });

  factory EmailThemeDetails.fromJson(Map<String, dynamic> json) {
    return EmailThemeDetails(
      buttonColor: json['buttonColor'],
      buttonTextColor: json['buttonTextColor'],
      footerBackgroundColor: json['footerBackgroundColor'],
      headerBackgroundColor: json['headerBackgroundColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buttonColor': buttonColor,
      'buttonTextColor': buttonTextColor,
      'footerBackgroundColor': footerBackgroundColor,
      'headerBackgroundColor': headerBackgroundColor,
    };
  }
}
