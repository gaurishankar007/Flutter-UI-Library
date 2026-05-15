import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// Returns a human‑friendly representation of this date.
  ///
  /// Formatting rules:
  ///
  /// * When this object's year equals the current year **and**
  ///   [excludeCurrentYear] is **false** (default), the output is
  ///   `MMM dd` (e.g. "Feb 11").
  /// * Otherwise the year is always shown as `MMM dd, yyyy` (e.g.
  ///   "Feb 11, 2026").
  ///
  /// The flag [excludeCurrentYear] forces the first format even if the
  /// year matches the current year.
  ///
  /// The method is safe and catches any exceptions; if formatting fails an
  /// empty string is returned instead of throwing.
  String formattedDate({bool excludeCurrentYear = false}) {
    try {
      final now = DateTime.now();

      if (year == now.year && excludeCurrentYear) {
        return DateFormat('MMM dd').format(this);
      }
      return DateFormat('MMM dd, yyyy').format(this);
    } catch (_) {
      return '';
    }
  }

  /// Checks if this DateTime represents the same day as [other].
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
