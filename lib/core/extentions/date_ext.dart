import 'package:intl/intl.dart';

extension DateExt on DateTime {
  //return 20/01/2022
  String getDateString() {
    return DateFormat('yyyy/MM/dd').format(this).toString();
  }

  String getDateTimeString() {
    return DateFormat('yyyy/MM/dd hh:mm:ss').format(this).toString();
  }
}
