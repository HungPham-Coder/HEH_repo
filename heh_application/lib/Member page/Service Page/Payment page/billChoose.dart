import 'package:flutter/material.dart';

import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Service%20Page/Advise%20page/physioChoose.dart';
import 'package:heh_application/Member%20page/Service%20Page/Advise%20page/result.dart';
import 'package:heh_application/Member%20page/Service%20Page/Payment%20page/paymentChoose.dart';
import 'package:heh_application/Member%20page/Service%20Page/Payment%20page/paymentTime.dart';
import 'package:heh_application/Member%20page/Service%20Page/Payment%20page/success.dart';
import 'package:heh_application/Member%20page/navigation_main.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/models/booking_schedule.dart';
import 'package:heh_application/models/physiotherapist.dart';
import 'package:heh_application/models/schedule.dart';
import 'package:heh_application/models/sub_profile.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:intl/intl.dart';

class BillChoosePage extends StatefulWidget {
  BillChoosePage(
      {Key? key,
      required this.physiotherapist,
      required this.schedule,
      required this.bookingSchedule,
      this.view,
      })
      : super(key: key);
  PhysiotherapistModel physiotherapist;
  Schedule schedule;
  BookingSchedule? bookingSchedule;
  String? view;
  @override
  State<BillChoosePage> createState() => _BillChoosePageState();
}

class _BillChoosePageState extends State<BillChoosePage> {
  String? day;
  String? timeStart;
  String? timeEnd;
  bool check = false;

  String title = "Xác nhận";
  String subTitle = "Xác nhận hóa đơn";
  void formatDateAndTime() {
    DateTime tempDate =
        new DateFormat("yyyy-MM-dd").parse(widget.schedule.slot!.timeStart);
    day = DateFormat("dd-MM-yyyy").format(tempDate);
    DateTime tempTimeStart = new DateFormat("yyyy-MM-ddTHH:mm:ss")
        .parse(widget.schedule.slot!.timeStart);
    timeStart = DateFormat("HH:mm").format(tempTimeStart);

    DateTime tempTimeEnd = new DateFormat("yyyy-MM-ddTHH:mm:ss")
        .parse(widget.schedule.slot!.timeEnd);
    timeEnd = DateFormat("HH:mm").format(tempTimeEnd);
  }

  final value = NumberFormat("###,###,###");

  @override
  void initState() {
    // TODO: implement initState
    formatDateAndTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.view == "true") {
      setState(() {
        title = "Chi Tiết Hóa Đơn";
        subTitle = "Hóa Đơn";

      });

    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text(
        title ,
          style: TextStyle(fontSize: 23),
        ),
        centerTitle: true,
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(children: [
                  const SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height / 11,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/image%2Fwelcome3.png?alt=media&token=0fbdd14a-2e64-4ed5-87ab-2733d6180051"))),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Center(
                            child: Text( subTitle,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500))),
                        const SizedBox(height: 20),
                        information(
                            name: "ID: ", info: widget.schedule.scheduleID),
                        padding(),
                        information(
                            name: "Tên chuyên viên: ",
                            info:
                                widget.physiotherapist.signUpUser!.firstName!),
                        padding(),
                        information(
                            name: "Tên người đặt: ",
                            info: sharedCurrentUser!.firstName!),
                        padding(),
                        const SizedBox(height: 15),
                        information(
                            name: "Buổi điều trị: ",
                            info: widget.schedule.slot!.slotName),
                        padding(),
                        information(name: "Ngày điều trị: ", info: day),
                        padding(),
                        information(
                            name: "Thời gian bắt đầu: ", info: timeStart),
                        padding(),
                        information(
                            name: "Thời gian kết thúc: ", info: timeEnd),
                        padding(),
                        information(
                            name: "Số tiền: ",
                            info:
                                '${value.format(widget.schedule.typeOfSlot!.price.toInt())} VNĐ'),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            widget.view == "true"
            ? Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll<Color>(
                        Colors.black12),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15)),
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.white)),
                    )),
                onPressed: () async {
                  // CallAPI().getBookingDetailByID(bookingDetail!);

                      Navigator.of(context).pop();

                },
                child: const Text(
                  "Trở lại",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ):
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                            Colors.black12),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.only(
                                left: 25, right: 25, top: 15, bottom: 15)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(color: Colors.white)),
                        )),
                    onPressed: () async {
                      // CallAPI().getBookingDetailByID(bookingDetail!);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: const Text("Bạn muốn hủy hóa đơn?"),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    BookingSchedule bookingSchedule =
                                        await CallAPI().getBookingScheduleByID(
                                            widget.bookingSchedule!
                                                .bookingScheduleID!);
                                    print(widget.bookingSchedule!);
                                    print(bookingSchedule.bookingScheduleID!);
                                    print(widget
                                        .bookingSchedule!.bookingScheduleID);
                                  },
                                  child: const Text(
                                    "Huỷ",
                                    style: TextStyle(color: Colors.red),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Navigation_Bar()));
                                  },
                                  child: const Text("Chập nhận")),
                            ],
                          );
                        },
                      );
                      // Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Trở lại",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(15)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(color: Colors.white)),
                        )),
                    onPressed: () async {
                      // BookingSchedule? bookingScheduleAdd = await CallAPI()
                      //     .addBookingSchedule(widget.bookingSchedule!);
                      BookingSchedule bookingSchedule = await CallAPI()
                          .getBookingScheduleByID(
                              widget.bookingSchedule!.bookingScheduleID!);

                      BookingDetail bookingDetail = BookingDetail(
                        bookingScheduleID: bookingSchedule.bookingScheduleID!,
                        bookingSchedule: bookingSchedule,
                        shorttermStatus: 0,
                        longtermStatus: 0,
                      );
                      BookingDetail addBookingDetail =
                          await CallAPI().addBookingDetail(bookingDetail);
                      BookingDetail getBookingDetail = await CallAPI()
                          .getBookingDetailByID(
                              addBookingDetail.bookingDetailID!);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentTimePage(
                                    bookingDetail: getBookingDetail,
                                  )));
                      // Navigator.pushNamed(
                      //   context,
                      //   '/payment',
                      //   arguments: {'bookingDetail': getBookingDetail},
                      // );
                    },
                    child: const Text(
                      "Thanh toán",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class information extends StatelessWidget {
  information({Key? key, required this.name, required this.info})
      : super(key: key);
  String? name, info;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Wrap(
        children: [
          Text(name!),
          Text(info!, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    ]);
  }
}

Widget padding() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Container(
      height: 1,
      color: Colors.grey,
    ),
  );
}
