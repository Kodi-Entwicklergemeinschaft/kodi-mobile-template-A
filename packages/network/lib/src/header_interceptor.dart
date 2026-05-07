import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HeaderInterceptor extends Interceptor {
  HeaderInterceptor(
    this.tokenReader,
    this.localeReader,
    this.refreshToken,
  );

  /// Call this to read token dynamically from Riverpod
  final String Function() tokenReader;
  final String Function() localeReader;
  final Future<void> Function() refreshToken;

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = tokenReader();
    final locale = localeReader();
    // Add bearer header if token exists
    if (token.isNotEmpty ) {
      final isRefreshRequest = options.path.endsWith('/refresh') ?? false;
      if (isTokenExpired(token) && !isRefreshRequest) {
        await refreshToken();
      }
      options.headers['Authorization'] = 'Bearer ${tokenReader()}';
    }

    // Add locale header if exists
    if (locale.isNotEmpty) {
      options.headers['Accept-Language'] = locale;
    }

    // Common headers
    options.headers['Accept'] = 'application/json';

    super.onRequest(options, handler);
  }
}
