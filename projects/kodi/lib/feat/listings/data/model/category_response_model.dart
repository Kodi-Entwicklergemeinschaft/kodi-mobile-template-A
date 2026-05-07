// Root Response Model
import 'package:network/network.dart';

import 'category_model.dart';

class CategoryResponse extends BaseModel<CategoryResponse>{
  final bool? success;
  final List<CategoryModel>? data;
  final String? message;
  final String? timestamp;
  final String? path;
  final int? statusCode;

  CategoryResponse({
     this.success,
     this.data,
     this.message,
     this.timestamp,
     this.path,
     this.statusCode,
  });


  @override
  CategoryResponse fromJson(Map<String, dynamic> json){
    return CategoryResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
      message: json['message'] ?? "",
      timestamp: json['timestamp'] ?? "",
      path: json['path'] ?? "",
      statusCode: json['statusCode'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((e) => e.toJson()).toList(),
      'message': message,
      'timestamp': timestamp,
      'path': path,
      'statusCode': statusCode,
    };
  }
}
