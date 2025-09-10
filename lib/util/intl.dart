import 'package:intl/intl.dart';

class DateTimeService {
  /// Convert epoch (milliseconds) to formatted date
  static String epochToFormattedDate(int epoch, {String format = "dd/MM/yyyy"}) {
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(epoch);
      return DateFormat(format).format(date);
    } catch (_) {
      return "";
    }
  }

  /// Convert formatted date to epoch (milliseconds)
  static int? formattedDateToEpoch(String dateString, {String format = "dd/MM/yyyy"}) {
    try {
      final date = DateFormat(format).parse(dateString);
      return date.millisecondsSinceEpoch;
    } catch (_) {
      return null;
    }
  }

  /// Convert ISO string (e.g. "2024-09-07T00:00:00.000Z") to formatted date
  static String isoToFormattedDate(String isoString, {String format = "dd/MM/yyyy"}) {
    try {
      final date = DateTime.parse(isoString).toLocal();
      return DateFormat(format).format(date);
    } catch (_) {
      return "";
    }
  }

  /// Convert formatted date to ISO string
  static String? formattedDateToIso(String dateString, {String format = "dd/MM/yyyy"}) {
    try {
      final date = DateFormat(format).parse(dateString);
      return date.toIso8601String();
    } catch (_) {
      return null;
    }
  }

  /// Convert DateTime to formatted string
  static String dateTimeToFormatted(DateTime dateTime, {String format = "dd/MM/yyyy"}) {
    try {
      return DateFormat(format).format(dateTime);
    } catch (_) {
      return "";
    }
  }
}
