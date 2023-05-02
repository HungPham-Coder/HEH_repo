import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Notification%20page/adviseAppoint.dart/adviseDetail.dart';
import 'package:heh_application/Video%20call%20page/VideoCall.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/util/date_time_format.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  Widget button({required VoidCallback press}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(
                    Color.fromARGB(255, 210, 158, 36)),
                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.white)),
                )),
            onPressed: press,
            child: const Text("Thông tin",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(width: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(Colors.green),
                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.white)),
                )),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VideoCallPage()));
            },
            child: const Text(
              "Tham gia",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget ServicePaid(
      {required String icon,
      name,
      time,
      bookedFor,
      date,
      required VoidCallback press}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: const Color.fromARGB(255, 46, 161, 226),
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 235, 241, 245)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    icon,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      return child;
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                    width: 40,
                    height: 50,
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Ngày đặt: ",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                date,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Khung giờ: ",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                time,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Người điều trị: ",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                bookedFor,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          button(press: press),
                        ],
                      )),
                ],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Danh sách buổi tư vấn",
          style: TextStyle(fontSize: 23),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<BookingDetail>>(
                future: CallAPI().getAllBookingDetailByPhysioIDAndTypeOfSlot(
                    sharedPhysiotherapist!.physiotherapistID, 'Tư Vấn 1 Buổi'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            String day = DateTimeFormat.formatDate(snapshot
                                .data![index]
                                .bookingSchedule!
                                .schedule!
                                .slot!
                                .timeStart);
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

                            return ServicePaid(
                              icon:
                                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fappointment.png?alt=media&token=647e3ff8-d708-4b77-b1e2-64444de5dad0",
                              name:
                                  "${snapshot.data![index].bookingSchedule!.schedule!.typeOfSlot!.typeName}",
                              date: "$day",
                              time: "$start - $end",
                              bookedFor:
                                  "${snapshot.data![index].bookingSchedule!.subProfile!.subName}",
                              press: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdviseDetailPage(
                                            bookingSchedule: snapshot
                                                .data![index]
                                                .bookingSchedule)));
                              },
                            );
                          });
                    } else {
                      return Center(
                        child: Text("Hiện tại chưa có ai đặt list empty"),
                      );
                    }
                  } else {
                    return Center(
                      child: Text("Hiện tại chưa có ai đặt "),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
