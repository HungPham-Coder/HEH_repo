import 'package:intl/intl.dart';

class DateTimeFormat {
  static String formatDate(String date) {
    DateTime dateTemp = new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date);
    String datefmt = DateFormat("dd-MM-yyyy").format(dateTemp);
    return datefmt;
  }

  static String formateTime(String time) {
    DateTime timeTemp = new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(time);
    String timefmt = DateFormat("HH:mm").format(timeTemp);
    return timefmt;
  }
}
