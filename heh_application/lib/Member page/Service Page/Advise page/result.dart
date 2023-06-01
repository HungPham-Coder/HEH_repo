import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Service%20Page/Payment%20page/billShortTerm.dart';
import 'package:heh_application/models/booking_schedule.dart';
import 'package:heh_application/models/schedule.dart';
import 'package:heh_application/models/sub_profile.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/util/date_time_format.dart';
import 'package:intl/intl.dart';

import '../../../common_widget/menu_listview.dart';

class TimeResultPage extends StatefulWidget {
  TimeResultPage(
      {Key? key,
      required this.timeStart,
      required this.timeEnd,
      required this.problem,
      required this.subProfile})
      : super(key: key);
  String timeStart;
  String timeEnd;
  String problem;
  SubProfile subProfile;
  @override
  State<TimeResultPage> createState() => _TimeResultPageState();
}

class _TimeResultPageState extends State<TimeResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Kết quả tìm kiếm",
            style: TextStyle(fontSize: 23),
          ),
          elevation: 10,
          backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // const SizedBox(height: 20),
                // CurrentTime(),
                FutureBuilder<List<Schedule>>(
                    future: CallAPI()
                        .getallPhysiotherapistBySlotTimeAndSkillAndTypeOfSlot(
                            widget.timeStart,
                            widget.timeEnd,
                            'Đau Lưng',
                            'Tư vấn trị liệu'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return RefreshIndicator(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  String startStr = DateTimeFormat.formateTime(
                                      snapshot.data![index].slot!.timeStart);
                                  String endStr = DateTimeFormat.formateTime(
                                      snapshot.data![index].slot!.timeEnd);

                                  return PhysioChooseMenu(
                                    slotName:
                                        '${snapshot.data![index].slot!.slotName}',
                                    icon:
                                        "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fphy.png?alt=media&token=bac867bc-190c-4523-83ba-86fccc649622",
                                    name:
                                        "${snapshot.data![index].physiotherapist!.signUpUser!.firstName}",
                                    time: "Khung giờ: $startStr - $endStr",
                                    press: () async {
                                      String date = DateFormat("yyyy-MM-dd")
                                          .format(DateTime.now());
                                      String time = DateFormat("HH:mm:ss")
                                          .format(DateTime.now());
                                      print("Khung giờ: $startStr - $endStr");
                                      BookingSchedule bookingSchedule =
                                          BookingSchedule(
                                              userID:
                                                  sharedCurrentUser!.userID!,
                                              subProfileID:
                                                  widget.subProfile.profileID!,
                                              scheduleID: snapshot
                                                  .data![index].scheduleID!,
                                              dateBooking: date,
                                              timeBooking: time);
                                      BookingSchedule?
                                      bookingScheduleAdd =
                                      await CallAPI()
                                          .addBookingSchedule(
                                          bookingSchedule);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BillShortTermPage(
                                                      physiotherapist: snapshot
                                                          .data![index]
                                                          .physiotherapist!,
                                                      schedule:
                                                          snapshot.data![index],
                                                      bookingSchedule:
                                                      bookingScheduleAdd)));
                                    },
                                  );
                                }),
                            onRefresh: () async {
                           setState(() {

                           });
                            });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}

class CurrentTime extends StatelessWidget {
  CurrentTime({Key? key}) : super(key: key);

  final TextEditingController _date = TextEditingController();

  String getCurrentDate() {
    var date = DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate =
        "Ngày ${dateParse.day} Tháng ${dateParse.month} Năm ${dateParse.year}";
    return formattedDate.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(getCurrentDate(), style: const TextStyle(fontSize: 20))
        ],
      ),
    );
  }
}
