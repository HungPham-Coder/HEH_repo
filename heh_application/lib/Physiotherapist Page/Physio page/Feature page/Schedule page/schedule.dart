import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/common_widget/menu_listview.dart';
import 'package:heh_application/models/schedule.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/util/date_time_format.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Khung giờ đã đăng ký",
          style: TextStyle(fontSize: 20),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Schedule>?>(
              future: CallAPI().getallSlotByPhysiotherapistID(
                  sharedPhysiotherapist!.physiotherapistID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length > 0) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          DateTime dateStart =
                              new DateFormat("yyyy-MM-ddTHH:mm:ss")
                                  .parse(snapshot.data![index].slot!.timeStart);
                          String startStr =
                              DateFormat("HH:mm").format(dateStart);
                          DateTime dateEnd =
                              new DateFormat("yyyy-MM-ddTHH:mm:ss")
                                  .parse(snapshot.data![index].slot!.timeEnd);
                          String endStr = DateFormat("HH:mm").format(dateEnd);
                          print(snapshot.data![index].slot!.slotName);
                          // print(snapshot.data![index].typeOfSlot!.typeName);
                          return ScheduleMenu(
                            icon:
                                "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fregisterd.png?alt=media&token=0b0eba33-ef11-44b4-a943-5b5b9b936cfe",
                            press: () {},
                            name: snapshot.data![index].slot!.slotName!,
                            time: "Khung giờ: $startStr - $endStr",
                            typeOfSlot: snapshot.data![index].typeOfSlot == null
                                ? "Chưa gán"
                                : snapshot.data![index].typeOfSlot!.typeName,
                          );
                        });
                  } else {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 300),
                        child: Text(
                          "Bạn chưa đăng ký khung giờ nào",
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
                        "Hiện tại không còn slot cho bạn",
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
