import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Notification%20page/adviseAppoint.dart/adviseDetail.dart';
import 'package:heh_application/Video%20call%20page/VideoCall.dart';
import 'package:heh_application/Video%20call%20page/views/messenger_page.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/models/chat_model/user_chat.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/services/firebase_firestore.dart';
import 'package:heh_application/util/date_time_format.dart';
import 'package:intl/intl.dart';

class SessionPage extends StatefulWidget {
  SessionPage({Key? key, required this.firebaseFirestoreBase})
      : super(key: key);
  FirebaseFirestoreBase firebaseFirestoreBase;
  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  UserChat? currentUser;

  Widget button({
    required VoidCallback press,
    required FirebaseFirestoreBase firebaseFirestoreBase,
    required BookingDetail bookingDetail,
  }) {
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
            onPressed: () async {
              await loadPhysioTherapistAccount(firebaseFirestoreBase);

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MessengerScreenPage(
                  currentUserID: currentUser!.id,
                  userAvatar: currentUser!.photoUrl,
                  oponentID: bookingDetail.bookingSchedule!.signUpUser!.userID!,
                  oponentNickName:
                      bookingDetail.bookingSchedule!.signUpUser!.firstName!,
                  oponentAvartar:
                      bookingDetail.bookingSchedule!.signUpUser!.image!,
                  firebaseFirestoreBase: firebaseFirestoreBase,
                  bookingDetail: bookingDetail,
                  groupChatID:
                      bookingDetail.bookingSchedule!.signUpUser!.userID!,
                );
              }));
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
      required FirebaseFirestoreBase firebaseFirestoreBase,
      required BookingDetail bookingDetail,
      name,
      time,
      bookedFor,
      date,
      weekDay,
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
                                "Người được trị liệu: ",
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
                          button(
                            bookingDetail: bookingDetail,
                            press: press,
                            firebaseFirestoreBase: firebaseFirestoreBase,
                          ),
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
          "Danh sách buổi trị liệu",
          style: TextStyle(fontSize: 23),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder<List<BookingDetail>?>(
            future: CallAPI()
                .getAllBookingDetailByPhysioIDAndTypeOfSlotAndShortTermLongTermStatus(
                    sharedPhysiotherapist!.physiotherapistID,
                    'Trị liệu dài hạn',
                    1,
                    1,
                    ""),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<BookingDetail> listSort = [];
                for (var item in snapshot.data!) {
                  if (item.shorttermStatus! < 3) {
                    listSort.add(item);
                  }
                }
                if (listSort.length > 0) {
                  return ListView.builder(
                      itemCount: listSort.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (listSort[index].longtermStatus! < 3) {
                          String day = DateTimeFormat.formatDate(listSort[index]
                              .bookingSchedule!
                              .schedule!
                              .slot!
                              .timeStart);
                          String start = DateTimeFormat.formateTime(
                              listSort[index]
                                  .bookingSchedule!
                                  .schedule!
                                  .slot!
                                  .timeStart);
                          String end = DateTimeFormat.formateTime(
                              listSort[index]
                                  .bookingSchedule!
                                  .schedule!
                                  .slot!
                                  .timeEnd);
                          String weekDay =
                              "Thứ ${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(listSort[index].bookingSchedule!.schedule!.slot!.timeStart).weekday + 1}";
                          if (weekDay == "Thứ 8") {
                            weekDay = "Chủ Nhật";
                          }
                          return ServicePaid(
                            bookingDetail: listSort[index],
                            firebaseFirestoreBase: widget.firebaseFirestoreBase,
                            icon:
                                "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fappointment.png?alt=media&token=647e3ff8-d708-4b77-b1e2-64444de5dad0",
                            name:
                                "${listSort[index].bookingSchedule!.schedule!.typeOfSlot!.typeName}",
                            date: "$day",
                            weekDay: weekDay,
                            time: "$start - $end",
                            bookedFor:
                                "${listSort[index].bookingSchedule!.subProfile!.subName}",
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdviseDetailPage(
                                          bookingSchedule: listSort[index]
                                              .bookingSchedule)));
                            },
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 280),
                            child: const Center(
                              child: Text(
                                "Hiện tại không có lịch đặt hẹn",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ),
                          );
                        }
                      });
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
      ),
    );
  }

  Future<void> loadPhysioTherapistAccount(
      FirebaseFirestoreBase firebaseFirestoreBase) async {
    UserChat? userChatResult =
        await firebaseFirestoreBase.getPhysioUser(physioID: 'physiotherapist');
    currentUser = userChatResult;
  }
}
