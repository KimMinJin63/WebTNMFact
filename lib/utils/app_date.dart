import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppDate {
  static String format(dynamic timestamp) {
    if (timestamp == null) return '';

    if (timestamp is Timestamp) {
      return DateFormat('yyyy.MM.dd').format(timestamp.toDate());
    }

    if (timestamp is String) {
      final parsed = DateTime.tryParse(timestamp);
      if (parsed != null) {
        return DateFormat('yyyy.MM.dd').format(parsed);
      }
      try {
        return DateFormat('yyyy.MM.dd')
            .format(DateFormat('yyyy-MM-dd HH:mm').parse(timestamp));
      } catch (_) {
        return timestamp;
      }
    }

    return '';
  }
}
