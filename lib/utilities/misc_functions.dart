import 'package:intl/intl.dart';

class MiscFunctions {
  String formattedDate(DateTime dateTime) {
    return DateFormat.yMMMMd().format(dateTime);
  }

  String noSpaceStringFormat(String text) {
    return text.replaceAll(' ', '');
  }
}
