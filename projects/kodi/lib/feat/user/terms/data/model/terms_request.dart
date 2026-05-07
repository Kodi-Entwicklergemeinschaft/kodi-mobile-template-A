import 'package:common_components/extensions/string_extension.dart';

class TermsRequest {
  final String? termsId;
  final String? locale;
  final String? version;

  TermsRequest({
    this.termsId,
    this.locale,
    this.version,
  });

  /// ✅ Factory constructor for null-safe JSON parsing
  factory TermsRequest.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TermsRequest();
    return TermsRequest(
      termsId: json['termsId'] as String?,
      locale: json['locale'] as String?,
      version: json['version'] as String?,
    );
  }

  /// ✅ Convert object to JSON safely
  Map<String, dynamic> toJson() {
    return {
      if(termsId.isNotNullAndEmpty)'termsId': termsId,
      'locale': locale,
      if(version.isNotNullAndEmpty)
      'version': version,
    };
  }
}
