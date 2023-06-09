import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Notification%20page/sessionApppoint.dart/sessionDetail.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/util/date_time_format.dart';
import 'package:intl/intl.dart';

class SessionAppointmentPage extends StatefulWidget {
  const SessionAppointmentPage({Key? key}) : super(key: key);

  @override
  State<SessionAppointmentPage> createState() => _SessionAppointmentPageState();
}

class _SessionAppointmentPageState extends State<SessionAppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Danh sách người đặt",
          ),
          elevation: 10,
          backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              FutureBuilder<List<BookingDetail>?>(
                  future: CallAPI()
                      .getAllBookingDetailByPhysioIDAndTypeOfSlotAndShortTermLongTermStatus(
                          sharedPhysiotherapist!.physiotherapistID,
                          'Trị liệu dài hạn',
                          3,
                          1,
                          ""),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              String start = DateTimeFormat.formateTime(snapshot
                                  .data![index]
                                  .bookingSchedule!
                                  .schedule!
                                  .slot!
                                  .timeStart);
                              String end = DateTimeFormat.formateTime(snapshot
                                  .data![index]
                                  .bookingSchedule!
                                  .schedule!
                                  .slot!
                                  .timeEnd);
                              return SessionMenu(
                                icon:
                                    "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fregisterd.png?alt=media&token=0b0eba33-ef11-44b4-a943-5b5b9b936cfe",
                                name:
                                    "${snapshot.data![index].bookingSchedule!.signUpUser!.firstName}",
                                press: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SessionDetailPage(
                                                  bookingSchedule: snapshot
                                                      .data![index]
                                                      .bookingSchedule)));
                                },
                                time: "Khung giờ đặt: $start' - $end",
                              );
                            });
                      } else {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 280),
                          child: const Center(
                            child: Text(
                              "Hiện tại không có lịch đặt hẹn.",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        );
                      }
                    } else {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 280),
                        child: const Center(
                          child: Text(
                            "Hiện tại không có lịch đặt hẹn.",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ));
  }
}

class SessionMenu extends StatelessWidget {
  const SessionMenu({
    Key? key,
    required this.time,
    required this.name,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String icon, name, time;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 46, 161, 226),
                              width: 2)),
                    )),
                onPressed: press,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(
                      icon,
                      width: 40,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 1.65,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              time,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 10),
                          ],
                        )),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child:
                          Icon(Icons.notifications_active_outlined, size: 30),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class dialog extends StatelessWidget {
  dialog({
    Key? key,
    required this.text,
  }) : super(key: key);

  String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bạn có lịch hẹn'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(text),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Hủy'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Xem chi tiết'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
