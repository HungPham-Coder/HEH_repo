import 'package:intl/intl.dart';

class DateTimeFormat {
  static String formatDate(String date) {
    DateTime dateTemp =  DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date);
    String datefmt = DateFormat("dd-MM-yyyy").format(dateTemp);
    return datefmt;
  }
  static String formatDateSaveDB(String date) {
    DateTime dateTemp =  DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date);
    String datefmt = DateFormat("yyyy-MM-dd").format(dateTemp);
    return datefmt;
  }
  static String formateTime(String time) {
    DateTime timeTemp =  DateFormat("yyyy-MM-ddTHH:mm:ss").parse(time);
    String timefmt = DateFormat("HH:mm").format(timeTemp);
    return timefmt;
  }

  static String formatDateTime(String time) {
    DateTime timeTemp =  DateFormat("yyyy-MM-ddTHH:mm:ss").parse(time);
    String timefmt = DateFormat("yyyy-MM-dd HH:mm").format(timeTemp);
    return timefmt;
  }

}
