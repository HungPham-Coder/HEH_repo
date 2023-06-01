import 'package:flutter/material.dart';
import 'package:heh_application/Member%20page/Profile%20page/History%20page/history.dart';
import 'package:heh_application/Member%20page/Profile%20page/Unpaid%20page/billLongTerm.dart';
import 'package:heh_application/Member%20page/Service%20Page/Payment%20page/billShortTerm.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/util/date_time_format.dart';

import '../../../Login page/landing_page.dart';
import '../../../services/call_api.dart';

class UnPaidServicePage extends StatefulWidget {
  UnPaidServicePage({Key? key, required this.bookingdetail}) : super(key: key);

  List<BookingDetail>? bookingdetail;

  @override
  State<UnPaidServicePage> createState() => _UnPaidServicePageState();
}

class _UnPaidServicePageState extends State<UnPaidServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dịch vụ chưa thanh toán",
          style: TextStyle(fontSize: 23),
        ),
        centerTitle: true,
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          CallAPI().GetAllBookingDetailLongTermNotPayment(
              sharedCurrentUser!.userID!);
          setState(() {});
        },
        child: FutureBuilder<List<BookingDetail>>(
            future: CallAPI().GetAllBookingDetailLongTermNotPayment(
                sharedCurrentUser!.userID!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
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
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ServiceUnPaid(
                          icon:
                              "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fappointment.png?alt=media&token=647e3ff8-d708-4b77-b1e2-64444de5dad0",
                          name: snapshot.data![index].bookingSchedule!.schedule!
                              .typeOfSlot!.typeName,
                          date: day,
                          time: "$start - $end",
                          bookedFor: snapshot.data![index].bookingSchedule!
                              .subProfile!.subName,
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BillLongTermPage(
                                          view: "false",
                                          physiotherapist: snapshot
                                              .data![index]
                                              .bookingSchedule!
                                              .schedule!
                                              .physiotherapist!,
                                          schedule: snapshot.data![index]
                                              .bookingSchedule!.schedule!,
                                          bookingSchedule: snapshot
                                              .data![index].bookingSchedule!,
                                          bookingDetailID: snapshot
                                              .data![index].bookingDetailID,
                                        )));
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 300),
                      child: Text(
                        "Bạn chưa có hóa đơn để thanh toán",
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                    ),
                  );
                }
              } else {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 300),
                    child: Text(
                      "Bạn chưa có hóa đơn để thanh toán",
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
