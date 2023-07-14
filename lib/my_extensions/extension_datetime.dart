import 'package:intl/intl.dart';

extension DateTimeFormatExtension on DateTime {
  String formatDate() {
    return DateFormat('d MMM yyyy').format(this);
  }

  String formatTime() {
    return DateFormat('h:mm a').format(this);
  }

  String formatDateAndTime() {
    return DateFormat('d MMM yyyy h:mm a').format(this);
  }
}
