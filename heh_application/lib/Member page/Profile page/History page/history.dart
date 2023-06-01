import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Profile%20page/History%20page/billHistory.dart';
import 'package:heh_application/Member%20page/Service%20Page/Payment%20page/billShortTerm.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/util/date_time_format.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Lịch sử thanh toán",
            style: TextStyle(fontSize: 23),
          ),
          elevation: 10,
          backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            CallAPI().GetAllBookingDetailBill(sharedCurrentUser!.userID!);
            setState(() {});
          },
          child: FutureBuilder<List<BookingDetail>>(
              future:
                  CallAPI().GetAllBookingDetailBill(sharedCurrentUser!.userID!),
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
                          child: ServicePaid(
                            icon:
                                "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fappointment.png?alt=media&token=647e3ff8-d708-4b77-b1e2-64444de5dad0",
                            name: snapshot.data![index].bookingSchedule!
                                .schedule!.typeOfSlot!.typeName,
                            date: day,
                            time: "$start - $end",
                            bookedFor: snapshot.data![index].bookingSchedule!
                                .subProfile!.subName,
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BillHistoryPage(
                                          view: "true",
                                          physiotherapist: snapshot
                                              .data![index]
                                              .bookingSchedule!
                                              .schedule!
                                              .physiotherapist!,
                                          schedule: snapshot.data![index]
                                              .bookingSchedule!.schedule!,
                                          bookingSchedule: snapshot
                                              .data![index].bookingSchedule!)));
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
                          "Bạn chưa thanh toán dịch vụ nào",
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 16),
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 300),
                      child: Text(
                        "Bạn chưa thanh toán dịch vụ nào",
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                    ),
                  );
                }
              }),
        ));
  }
}

class ServicePaid extends StatelessWidget {
  const ServicePaid({
    Key? key,
    required this.time,
    required this.name,
    required this.icon,
    required this.press,
    required this.date,
    required this.bookedFor,
  }) : super(key: key);

  final String icon, name, time, bookedFor, date;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
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
                    width: 40,
                    height: 50,
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.7,
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
                                "Đặt cho: ",
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
}

class ServiceUnPaid extends StatelessWidget {
  const ServiceUnPaid({
    Key? key,
    required this.time,
    required this.name,
    required this.icon,
    required this.press,
    required this.date,
    required this.bookedFor,
  }) : super(key: key);

  final String icon, name, time, bookedFor, date;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
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
                    width: 40,
                    height: 50,
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.7,
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
                                "Đặt cho: ",
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
                          buttonUnpaid(press: press),
                        ],
                      )),
                ],
              )),
        ],
      ),
    );
  }
}

class button extends StatefulWidget {
  const button({Key? key, this.press}) : super(key: key);
  final VoidCallback? press;
  @override
  State<button> createState() => _buttonState();
}

class _buttonState extends State<button> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(
                    Color.fromARGB(255, 210, 158, 36)),
                padding: MaterialStateProperty.all(const EdgeInsets.only(
                    left: 30, right: 30, top: 15, bottom: 15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.white)),
                )),
            onPressed: widget.press,
            child: const Text("Xem hóa đơn",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}

class buttonUnpaid extends StatefulWidget {
  const buttonUnpaid({Key? key, this.press}) : super(key: key);
  final VoidCallback? press;
  @override
  State<buttonUnpaid> createState() => _buttonUnpaidState();
}

class _buttonUnpaidState extends State<buttonUnpaid> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll(Colors.green),
                padding: MaterialStateProperty.all(const EdgeInsets.only(
                    left: 30, right: 30, top: 15, bottom: 15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.white)),
                )),
            onPressed: widget.press,
            child: const Text("Thanh toán",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}
