import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Service%20Page/Payment%20page/billChoose.dart';
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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:heh_application/models/sign_up_user.dart';

class SessionPaidPage extends StatefulWidget {
  SessionPaidPage({Key? key, required this.firebaseFirestoreBase})
      : super(key: key);
  FirebaseFirestoreBase firebaseFirestoreBase;
  @override
  State<SessionPaidPage> createState() => _SessionPaidPageState();
}

class _SessionPaidPageState extends State<SessionPaidPage> {
  UserChat? opponentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            FutureBuilder<List<BookingDetail>>(
                future: CallAPI()
                    .getAllBookingDetailByUserID(sharedCurrentUser!.userID!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          DateTime tempDate = new DateFormat("yyyy-MM-dd")
                              .parse(snapshot.data![index].bookingSchedule!
                                  .schedule!.slot!.timeStart);
                          String day =
                              DateFormat("dd-MM-yyyy").format(tempDate);
                          DateTime tempStart =
                              new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(
                                  snapshot.data![index].bookingSchedule!
                                      .schedule!.slot!.timeStart);
                          String start = DateFormat("HH:mm").format(tempStart);
                          DateTime tempEnd =
                              new DateFormat("yyyy-MM-ddTHH:mm:ss").parse(
                                  snapshot.data![index].bookingSchedule!
                                      .schedule!.slot!.timeEnd);
                          String end = DateFormat("HH:mm").format(tempEnd);
                          return ServicePaid(
                              icon:
                                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fappointment.png?alt=media&token=647e3ff8-d708-4b77-b1e2-64444de5dad0",
                              name:
                                  "${snapshot.data![index].bookingSchedule!.schedule!.typeOfSlot!.typeName}",
                              date: "$day",
                              time: "$start - $end",
                              bookedFor:
                                  "${snapshot.data![index].bookingSchedule!.subProfile!.relationship!.relationName}",
                              bookingSchedule:
                                  snapshot.data![index].bookingSchedule!,
                              physiotherapist: snapshot.data![index]
                                  .bookingSchedule!.schedule!.physiotherapist!,
                              schedule: snapshot
                                  .data![index].bookingSchedule!.schedule!,
                              firebaseFirestoreBase:
                                  widget.firebaseFirestoreBase,
                              bookingDetail: snapshot.data![index]);
                        },
                      );
                    } else {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 300),
                          child: Text(
                            "Bạn chưa đăng ký dịch vụ nào",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 16),
                          ),
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: Text(
                          'Hiện tại bạn đang chưa đăng ký bất kỳ lịch nào'),
                    );
                  }
                }),
          ],
        ),
      )),
    );
  }

  Widget ServicePaid(
      {required String icon,
      name,
      time,
      bookedFor,
      date,
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
                      builder: (context) => BillChoosePage(
                          physiotherapist: physiotherapist,
                          schedule: schedule,
                          bookingSchedule: bookingSchedule)));
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

  Future<void> loadPhysioTherapistAccount(
      FirebaseFirestoreBase firebaseFirestoreBase) async {
    UserChat? userChatResult =
        await firebaseFirestoreBase.getPhysioUser(physioID: 'physiotherapist');
    opponentUser = userChatResult;
  }
}
