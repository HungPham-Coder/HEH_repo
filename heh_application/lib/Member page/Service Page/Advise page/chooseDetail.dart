import 'package:flutter/material.dart';

import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Service%20Page/Payment%20page/billShortTerm.dart';
import 'package:heh_application/models/booking_schedule.dart';
import 'package:heh_application/models/physiotherapist.dart';
import 'package:heh_application/models/schedule.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/util/date_time_format.dart';
import 'package:intl/intl.dart';

import '../../../models/sub_profile.dart';

class ChooseDetailPage extends StatefulWidget {
  ChooseDetailPage(
      {Key? key, required this.physiotherapist, required this.typeName})
      : super(key: key);
  PhysiotherapistModel physiotherapist;
  String typeName;
  @override
  State<ChooseDetailPage> createState() => _ChooseDetailPageState();
}

class _ChooseDetailPageState extends State<ChooseDetailPage> {
  final List<String> _relationships = [
    "- Chọn -",
  ];
  bool validRelation = false;

  String selectedSubName = "- Chọn -";
  SubProfile? subProfile;

  Widget relationship(String slotID) {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          Row(
            children: const [
              Text("Bạn muốn đặt cho ai?"),
              Text(" *", style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: FutureBuilder<List<SubProfile>?>(
                future: CallAPI().getallSubProfileByUserIdAndSlotID(
                    sharedCurrentUser!.userID!, slotID),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (_relationships.length == 1) {
                      snapshot.data!.forEach((element) {
                        String field = "${element.subName}";
                        _relationships.add(field);
                      });
                      print("Co data");
                    }
                    if (_relationships.length <= 1) {
                      return Column(
                        children: const [
                          SizedBox(height: 5),
                          Text(
                            "Hiện tại không thể đặt khung giờ này vì bạn hoặc người thân của bạn đã đặt rồi.",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      );
                    } else {
                      return Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.grey))),
                          value: selectedSubName,
                          items: _relationships
                              .map((relationship) => DropdownMenuItem<String>(
                                  value: relationship,
                                  child: Text(
                                    relationship,
                                    style: const TextStyle(fontSize: 15),
                                  )))
                              .toList(),
                          validator: (value) {
                            if (value == "- Chọn -") {
                              validRelation = false;
                              return "Hãy chọn người bạn muốn đặt";
                            } else {
                              validRelation = true;
                            }
                          },
                          onChanged: (subName) => setState(() {
                            snapshot.data!.forEach((element) {
                              if (subName == element.subName) {
                                subProfile = element;
                              }
                            });
                            selectedSubName = subName!;
                          }),
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
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
          "Chọn khung giờ",
          style: TextStyle(fontSize: 23),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            PhysioProfile(
              image:
                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fphy.png?alt=media&token=bac867bc-190c-4523-83ba-86fccc649622",
              phy: "Chuyên viên",
              name: widget.physiotherapist.signUpUser!.firstName!,
              specialize: "Chuyên môn: ${widget.physiotherapist.specialize}",
              experience: "Kinh nghiệm: ${widget.physiotherapist.skill}",
              // time: "Thời gian làm việc: 10:00 AM - 12:00 AM"
            ),
            const SizedBox(height: 20),
            Center(
                child: Text("Khung giờ",
                    style: Theme.of(context).textTheme.headline6)),
            const SizedBox(height: 5),
            FutureBuilder<List<Schedule>?>(
                future: CallAPI().getallSlotByPhysiotherapistIDAndTypeOfSlot(
                    widget.physiotherapist.physiotherapistID, widget.typeName),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    int count = 0;
                    snapshot.data!.forEach((element) {
                      if (element.physioBookingStatus == true) {
                        count++;
                      }
                    });
                    if (count >= 1) {
                      return Container(
                          child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 100),
                          child: Text(
                            "Chuyên viên đang bận hết slot",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 16),
                          ),
                        ),
                      ));
                    } else {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          dynamic weekDay = new DateFormat(
                                      "yyyy-MM-ddThh:mm:ss")
                                  .parse(snapshot.data![index].slot!.timeStart)
                                  .weekday +
                              1;
                          if (weekDay == 8) {
                            weekDay = "Chủ Nhật";
                          }
                          String date = DateTimeFormat.formatDate(
                              snapshot.data![index].slot!.timeStart);
                          DateTime tempStart =
                              new DateFormat("yyyy-MM-ddThh:mm:ss")
                                  .parse(snapshot.data![index].slot!.timeStart);
                          String start = DateFormat("HH:mm").format(tempStart);
                          DateTime tempEnd =
                              new DateFormat("yyyy-MM-ddThh:mm:ss")
                                  .parse(snapshot.data![index].slot!.timeEnd);
                          String end = DateFormat("HH:mm").format(tempEnd);
                          String? notify;
                          snapshot.data![index].physioBookingStatus == true
                              ? notify = 'Slot này đã có người đặt rồi'
                              : notify = '';
                          return PhysioChooseMenu(
                              notify: notify,
                              weekDay: "Thứ ${weekDay} Ngày $date",
                              icon:
                                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fphy.png?alt=media&token=bac867bc-190c-4523-83ba-86fccc649622",
                              name: snapshot.data![index].slot!.slotName!,
                              time: "Khung giờ: ",
                              timeStart: '$start',
                              timeEnd: '$end',
                              price: snapshot.data![index].typeOfSlot!.price,
                              press: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title:
                                          const Text("Chọn người được tư vấn"),
                                      content: relationship(
                                          snapshot.data![index].slotID),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Hủy bỏ'),
                                          child: const Text('Hủy bỏ'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (selectedSubName ==
                                                "- Chọn -") {
                                              Navigator.pop(context, "Ok");
                                            } else {
                                              BookingSchedule bookingSchedule =
                                                  BookingSchedule(
                                                      userID:
                                                          sharedCurrentUser!
                                                              .userID!,
                                                      subProfileID:
                                                          '${subProfile!.profileID}',
                                                      scheduleID: snapshot
                                                          .data![index]
                                                          .scheduleID!,
                                                      dateBooking: DateFormat(
                                                              "yyyy-MM-dd")
                                                          .format(
                                                              DateTime.now()),
                                                      timeBooking: DateFormat(
                                                              "yyyy-MM-ddTHH:mm:ss")
                                                          .format(
                                                              DateTime.now()));
                                              BookingSchedule?
                                                  bookingScheduleAdd =
                                                  await CallAPI()
                                                      .addBookingSchedule(
                                                          bookingSchedule);
                                              print(bookingScheduleAdd!
                                                  .bookingScheduleID);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BillShortTermPage(
                                                            physiotherapist: widget
                                                                .physiotherapist,
                                                            schedule: snapshot
                                                                .data![index],
                                                            bookingSchedule:
                                                                bookingScheduleAdd,
                                                          )));
                                            }
                                          },
                                          child: const Text('Ok'),
                                        )
                                      ],
                                    ),
                                  ));
                        },
                      );
                    }
                  } else {
                    print("a0");
                    return Container(
                        // child: const Center(
                        //     child: Text(
                        //   "Physio dang ban het tat ca cac slot",
                        //   style: TextStyle(fontSize: 16),
                        // )),
                        );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class PhysioProfile extends StatelessWidget {
  const PhysioProfile({
    Key? key,
    required this.image,
    required this.phy,
    required this.name,
    required this.specialize,
    required this.experience,

    // required this.time,
  }) : super(key: key);

  final String image, specialize, experience, name, phy;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 50),
                    child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: const [
                            CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fphy.png?alt=media&token=bac867bc-190c-4523-83ba-86fccc649622")),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      children: [
                        Text(
                          phy,
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(specialize),
                    const SizedBox(height: 20),
                    Text(experience),
                    const SizedBox(height: 20),
                    // Text(time),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PhysioChooseMenu extends StatelessWidget {
  PhysioChooseMenu({
    Key? key,
    required this.price,
    required this.time,
    required this.timeStart,
    required this.timeEnd,
    required this.name,
    required this.icon,
    required this.press,
    required this.weekDay,
    this.notify,
  }) : super(key: key);

  final String icon, name, time;
  VoidCallback? press;
  final String? notify;
  String timeStart, timeEnd;
  bool visible = false;
  double price;
  final value = NumberFormat("###,###,###");
  String weekDay;
  @override
  Widget build(BuildContext context) {
    if (notify == '') {
      visible = false;
    } else {
      visible = true;
      press = null;
    }
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                      width: 40,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 1.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(weekDay,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                )),
                            Text('$time$timeStart - $timeEnd',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                )),
                            Text(
                              "Giá tiền: ${value.format(price.toInt())} VNĐ",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Visibility(
                                visible: visible, child: Text('$notify')),
                          ],
                        )),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Icon(Icons.add, size: 24),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
