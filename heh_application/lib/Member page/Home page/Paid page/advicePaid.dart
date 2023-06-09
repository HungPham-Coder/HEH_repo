import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Service%20Page/Payment%20page/billShortTerm.dart';
import 'package:heh_application/Member%20page/Service%20Page/service.dart';

import 'package:heh_application/Video%20call%20page/VideoCall.dart';
import 'package:heh_application/Video%20call%20page/views/messenger_page.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/models/booking_schedule.dart';
import 'package:heh_application/models/chat_model/user_chat.dart';
import 'package:heh_application/models/physiotherapist.dart';
import 'package:heh_application/models/schedule.dart';
import 'package:heh_application/services/auth.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/services/chat_provider.dart';
import 'package:heh_application/services/firebase_firestore.dart';
import 'package:heh_application/util/date_time_format.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:heh_application/models/sign_up_user.dart';

class AdvicePaidPage extends StatefulWidget {
  AdvicePaidPage(
      {Key? key, required this.firebaseFirestoreBase, required this.typeName})
      : super(key: key);
  FirebaseFirestoreBase firebaseFirestoreBase;
  String typeName;
  @override
  State<AdvicePaidPage> createState() => _AdvicePaidPageState();
}

class _AdvicePaidPageState extends State<AdvicePaidPage> {
  UserChat? opponentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Danh sách buổi tư vấn",
            style: TextStyle(fontSize: 20),
          ),
          elevation: 10,
          backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: FutureBuilder<List<BookingDetail>>(
                  future: CallAPI().getAllBookingDetailByUserIDAndTypeOfSlot(
                      sharedCurrentUser!.userID!, widget.typeName),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<BookingDetail> listSort = [];
                      for (var item in snapshot.data!) {
                        if (item.shorttermStatus! < 3) {
                          listSort.add(item);
                        }
                      }
                      if (listSort.isNotEmpty) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: listSort.length,
                          itemBuilder: (context, index) {
                            DateTime tempDate = new DateFormat("yyyy-MM-dd")
                                .parse(listSort[index]
                                    .bookingSchedule!
                                    .schedule!
                                    .slot!
                                    .timeStart);
                            String day =
                                DateFormat("dd-MM-yyyy").format(tempDate);
                            DateTime tempStart =
                                new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(
                                    listSort[index]
                                        .bookingSchedule!
                                        .schedule!
                                        .slot!
                                        .timeStart);
                            String start =
                                DateFormat("HH:mm").format(tempStart);
                            DateTime tempEnd =
                                new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(
                                    listSort[index]
                                        .bookingSchedule!
                                        .schedule!
                                        .slot!
                                        .timeEnd);
                            String end = DateFormat("HH:mm").format(tempEnd);
                            String weekDay =
                                "Thứ ${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(listSort[index].bookingSchedule!.schedule!.slot!.timeStart).weekday + 1}";
                            if (weekDay == "Thứ 8") {
                              weekDay = "Chủ Nhật";
                            }

                            return ServicePaid(
                                icon:
                                    "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fappointment.png?alt=media&token=647e3ff8-d708-4b77-b1e2-64444de5dad0",
                                name:
                                    "${listSort[index].bookingSchedule!.schedule!.typeOfSlot!.typeName}",
                                weekDay: weekDay,
                                date: "$day",
                                time: "$start - $end",
                                bookedFor:
                                    "${listSort[index].bookingSchedule!.subProfile!.relationship!.relationName}",
                                bookingSchedule:
                                    listSort[index].bookingSchedule!,
                                physiotherapist: listSort[index]
                                    .bookingSchedule!
                                    .schedule!
                                    .physiotherapist!,
                                schedule:
                                    listSort[index].bookingSchedule!.schedule!,
                                firebaseFirestoreBase:
                                    widget.firebaseFirestoreBase,
                                bookingDetail: listSort[index]);
                          },
                        );
                      } else {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 300),
                            child: Text(
                              "Bạn chưa đăng ký dịch vụ ${widget.typeName.toLowerCase()} nào",
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 16),
                            ),
                          ),
                        );
                      }
                    } else {
                      return Container();
                    }
                  }),
            )));
  }

  Widget ServicePaid(
      {required String icon,
      name,
      time,
      bookedFor,
      date,
      weekDay,
      required PhysiotherapistModel physiotherapist,
      required Schedule schedule,
      required BookingSchedule bookingSchedule,
      required FirebaseFirestoreBase firebaseFirestoreBase,
      required BookingDetail bookingDetail}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                                '$weekDay $date',
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
                          Text(
                            "Chuyên viên trị liệu: ",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            physiotherapist.signUpUser!.firstName!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          button(
                              schedule: schedule,
                              physiotherapist: physiotherapist,
                              bookingSchedule: bookingSchedule,
                              firebaseFirestoreBase: firebaseFirestoreBase,
                              bookingDetail: bookingDetail),
                        ],
                      )),
                ],
              )),
        ],
      ),
    );
  }

  Widget button(
      {required PhysiotherapistModel physiotherapist,
      required Schedule schedule,
      required BookingSchedule bookingSchedule,
      required FirebaseFirestoreBase firebaseFirestoreBase,
      required BookingDetail bookingDetail}) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Row(
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
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BillShortTerm(
                            view: "true",
                            physiotherapist: physiotherapist,
                            schedule: schedule,
                            bookingSchedule: bookingSchedule,
                            bookingDetail: bookingDetail,
                          )));
            },
            child: const Text("Xem hóa đơn",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(width: 10),
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
            onPressed: () async {
              await loadPhysioTherapistAccount(firebaseFirestoreBase);
              await auth.checkUserExistInFirebase(sharedCurrentUser!);

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                if (sharedCurrentUser?.image == null) {
                  sharedCurrentUser?.setImage = "Không có hình";
                }

                if (sharedCurrentUser != null) {
                  return Provider<ChatProviderBase>(
                    create: (context) => ChatProvider(),
                    child: MessengerScreenPage(
                      firebaseFirestoreBase: firebaseFirestoreBase,
                      oponentID: opponentUser!.id,
                      oponentAvartar: opponentUser!.photoUrl,
                      oponentNickName: opponentUser!.nickname,
                      userAvatar: sharedCurrentUser!.image,
                      currentUserID: sharedCurrentUser!.userID!,
                      bookingDetail: bookingDetail,
                      groupChatID: sharedCurrentUser!.userID!,
                    ),
                  );
                } else {
                  print('null');
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })).then((value) {
                setState(() {});
              });
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

  Future<void> loadPhysioTherapistAccount(
      FirebaseFirestoreBase firebaseFirestoreBase) async {
    UserChat? userChatResult =
        await firebaseFirestoreBase.getPhysioUser(physioID: 'physiotherapist');
    opponentUser = userChatResult;
  }
}

class BillShortTerm extends StatefulWidget {
  BillShortTerm({
    Key? key,
    required this.physiotherapist,
    required this.schedule,
    required this.bookingSchedule,
    required this.bookingDetail,
    this.view,
  }) : super(key: key);
  PhysiotherapistModel physiotherapist;
  Schedule schedule;
  BookingSchedule? bookingSchedule;
  BookingDetail? bookingDetail;
  String? view;
  @override
  State<BillShortTerm> createState() => _BillShortTermState();
}

class _BillShortTermState extends State<BillShortTerm> {
  String? day;
  String? timeStart;
  String? timeEnd;
  String? timeBook;
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
    timeBook = DateTimeFormat.formatDateTime(
        widget.bookingDetail!.bookingSchedule!.timeBooking);

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
        title: Text(
          title,
          style: const TextStyle(fontSize: 23),
        ),
        centerTitle: true,
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Text(subTitle,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500))),
                          const SizedBox(height: 20),
                          information(
                              name: "ID: ", info: widget.schedule.scheduleID),
                          padding(),
                          information(name: "Ngày đặt: ", info: "$timeBook"),
                          padding(),
                          information(
                              name: "Tên chuyên viên: ",
                              info: widget
                                  .physiotherapist.signUpUser!.firstName!),
                          padding(),
                          information(
                              name: "Tên người đặt: ",
                              info: sharedCurrentUser!.firstName!),
                          padding(),
                          information(
                              name: "Buổi trị liệu: ",
                              info: widget.schedule.slot!.slotName),
                          padding(),
                          information(name: "Ngày trị liệu: ", info: day),
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
                            backgroundColor:
                                const MaterialStatePropertyAll<Color>(
                                    Colors.black12),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.only(
                                    left: 25, right: 25, top: 15, bottom: 15)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
