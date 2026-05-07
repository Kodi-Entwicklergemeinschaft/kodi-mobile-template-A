import 'package:flutter/material.dart';
import 'package:locale/app_localization.dart';
import 'package:shared_dependencies/intl.dart';

import 'data/model/listing_model.dart';

class ListingsMethods {
  /// Format ISO string → HH:mm
  static String formatTime(String? date) {
    if (date == null) return "";
    try {
      final dt = DateTime.parse(date).toLocal();
      return DateFormat("HH:mm").format(dt);
    } catch (e) {
      return ""; // Return empty string if parsing fails
    }
  }

  /// Format ISO string → dd.MM.yyyy
  static String formatDate(String? date) {
    if (date == null) return "";
    try {
      final dt = DateTime.parse(date).toLocal();
      return DateFormat("dd.MM.yyyy").format(dt);
    } catch (e) {
      return ""; // Return empty string if parsing fails
    }
  }

  static getDateRangeUI(String? st, String? ed) {
    DateTime? start = toDateTime(st);
    DateTime? end = toDateTime(ed);
    String? todayOpeningStatus;

    if (start != null) {
      final startDate = ListingsMethods.formatDate(st);
      final startTime = ListingsMethods.formatTime(st);

      if (end == null) {
        // Rule 3: no end date
        todayOpeningStatus = "$startDate · $startTime";
      } else {
        final sameDay =
            start.year == end.year &&
            start.month == end.month &&
            start.day == end.day;

        final endDate = ListingsMethods.formatDate(ed);
        final endTime = ListingsMethods.formatTime(ed);

        if (sameDay) {
          // Rule 1: same day
          todayOpeningStatus = "$startDate · $startTime – $endTime";
        } else {
          // Rule 2: multi-day
          todayOpeningStatus =
              "$startDate · $startTime To $endDate – $endTime";
        }
      }
    }
    return todayOpeningStatus;
  }

  /// Format ISO string → dd.MM
  static String formatDateMonthOnly(String? date) {
    if (date == null) return "";
    try {
      final dt = DateTime.parse(date).toLocal();
      return DateFormat("dd.MM").format(dt);
    } catch (e) {
      return ""; // Return empty string if parsing fails
    }
  }

  static String getTodayOpeningHours(
    BuildContext context,
    List<TimeInterval> timeIntervals,
  ) {
    final now = DateTime.now();
    // Use 'EEEE' for the full day name in English (e.g., "Monday") to match keys
    final todayWeekday = DateFormat('EEEE', 'en_US').format(now);

    for (var interval in timeIntervals) {
      if (interval.weekdays?.contains(todayWeekday) ?? false) {
        if (interval.start != null && interval.end != null) {
          final start = formatTime(interval.start);
          final end = formatTime(interval.end);
          return ('open_hours')
              .tr(context)
              .replaceAll('{start}', start)
              .replaceAll('{end}', end);
        }
      }
    }
    return ('closed').tr(context);
  }

  static DateTime? toDateTime(String? date) {
    if (date == null || date.trim().isEmpty) return null;

    // Common date formats your backend / UI might return
    final formats = [
      // "yyyy-MM-dd",
      "yyyy-MM-ddTHH:mm:ss",
      // "yyyy-MM-ddTHH:mm:ss.SSS",
      // "yyyy-MM-ddTHH:mm:ss'Z'",
      // "yyyy-MM-dd HH:mm:ss",
      // "dd.MM.yyyy",
      // "MM/dd/yyyy",
    ];

    for (final f in formats) {
      try {
        return DateFormat(f).parse(date, true).toLocal();
      } catch (_) {}
    }

    // Fallback: ISO8601 parser
    try {
      return DateTime.parse(date).toLocal();
    } catch (e) {
      return null;
    }
  }
}
