import 'package:intl/intl.dart';

List<String> formatDateAndTime(DateTime dateTime) {
  final formattedDate = DateFormat("MMM dd 'yy").format(dateTime);
  final formattedTime = DateFormat.jm().format(dateTime);
  return [formattedDate.toString(), formattedTime.toString()];
}
