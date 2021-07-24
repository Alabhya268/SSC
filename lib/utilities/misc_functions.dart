import 'package:intl/intl.dart';

class MiscFunctions {
  String formattedDate(DateTime dateTime) {
    return DateFormat.yMMMMd().format(dateTime);
  }
}
