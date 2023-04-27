import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/common_widget/menu_listview.dart';
import 'package:heh_application/models/schedule.dart';
import 'package:heh_application/services/call_api.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  Schedule? schedule;

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
            child: Column(children: [
          FutureBuilder<List<Schedule>?>(
              future: CallAPI().getallSlotByPhysiotherapistID(
                  sharedPhysiotherapist!.physiotherapistID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ScheduleMenu(
                              icon:
                                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fregisterd.png?alt=media&token=0b0eba33-ef11-44b4-a943-5b5b9b936cfe",
                              press: () {},
                              name: snapshot.data![index].physiotherapistID,
                              time: snapshot.data![index].slotID,
                            )
                          ],
                        );
                      });
                } else {
                  return const Center(
                      child: Text("Bạn chưa đăng ký slot nào."));
                }
              })
        ])));
  }
}
  // 



