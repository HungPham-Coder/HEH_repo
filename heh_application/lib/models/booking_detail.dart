import 'package:heh_application/models/booking_schedule.dart';
import 'package:heh_application/models/schedule.dart';

class BookingDetail {
  String? bookingDetailID;
  String bookingScheduleID;
  BookingSchedule? bookingSchedule;
  String? videoCallRoom;
  int? longtermStatus;
  int? shorttermStatus;

  BookingDetail(
      { this.bookingDetailID,
      required this.bookingScheduleID,
       this.bookingSchedule,
        this.videoCallRoom,
        this.longtermStatus,
        this.shorttermStatus
      });
  factory BookingDetail.fromMap(Map<String, dynamic> json) {
    return BookingDetail(
        bookingDetailID: json['bookingDetailID'],
        bookingScheduleID: json['bookingScheduleID'],
        bookingSchedule:BookingSchedule.fromMap(json['bookingSchedule']) ,
        videoCallRoom: json['videoCallRoom'],
        shorttermStatus: json['shorttermStatus'],
    longtermStatus: json['longtermStatus']);
  }
}
