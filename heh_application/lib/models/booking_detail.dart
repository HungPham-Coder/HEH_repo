import 'package:heh_application/models/booking_schedule.dart';
import 'package:heh_application/models/schedule.dart';

class BookingDetail {
  String? bookingDetailID;
  String bookingScheduleID;
  BookingSchedule? bookingSchedule;
  String? imageUrl;
  double? paymentMoney;
  int? longtermStatus;
  int? shorttermStatus;

  BookingDetail(
      {this.bookingDetailID,
      required this.bookingScheduleID,
      this.bookingSchedule,
      this.imageUrl,
      this.paymentMoney,
      this.longtermStatus,
      this.shorttermStatus});
  factory BookingDetail.fromMap(Map<String, dynamic> json) {
    if (json['bookingSchedule'] != null && json['paymentMoney'] != null) {
      return BookingDetail(
          bookingDetailID: json['bookingDetailID'],
          bookingScheduleID: json['bookingScheduleID'],
          bookingSchedule: BookingSchedule.fromMap(json['bookingSchedule']),
          imageUrl: json['imageUrl'],
          paymentMoney: json['paymentMoney'],
          shorttermStatus: json['shorttermStatus'],
          longtermStatus: json['longtermStatus']);
    } else if (json['paymentMoney'] == null &&
        json['bookingSchedule'] != null) {
      return BookingDetail(
          bookingDetailID: json['bookingDetailID'],
          bookingScheduleID: json['bookingScheduleID'],
          bookingSchedule: BookingSchedule.fromMap(json['bookingSchedule']),
          imageUrl: json['imageUrl'],
          shorttermStatus: json['shorttermStatus'],
          longtermStatus: json['longtermStatus']);
    } else {
      return BookingDetail(
          bookingDetailID: json['bookingDetailID'],
          bookingScheduleID: json['bookingScheduleID'],
          imageUrl: json['imageUrl'],
          shorttermStatus: json['shorttermStatus'],
          longtermStatus: json['longtermStatus']);
    }
  }
}
