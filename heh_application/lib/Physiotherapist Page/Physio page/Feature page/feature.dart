import 'package:flutter/material.dart';
import 'package:heh_application/Exercise%20Page/category.dart';

import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Feature%20page/Register%20slot%20page/register.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Feature%20page/Schedule%20page/schedule.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Feature%20page/Session%20page/advise_list.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Feature%20page/Session%20page/session_Schedule.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Home%20page/Session%20Page/session.dart';
import 'package:heh_application/common_widget/menu_listview.dart';

import '../../../Login page/landing_page.dart';

class FeaturePage extends StatefulWidget {
  const FeaturePage({Key? key}) : super(key: key);

  @override
  State<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<FeaturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Tính năng",
          style: TextStyle(fontSize: 23),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FeatureMenu(
              icon:
                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fcalendar1.png?alt=media&token=0c80092a-d7d8-4f16-97cc-afa766361770",
              text: "Đăng ký lịch tư vấn",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PhysioRegisterSlotPage()));
              },
            ),
            FeatureMenu(
              icon:
                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fcalendar.jpg?alt=media&token=bcd461f3-e46a-4d99-8a59-0250c520c8f8",
              text: "Đăng ký lịch dài hạn",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdviseListPage()));
              },
            ),
            FeatureMenu(
              icon:
                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fcalendar.png?alt=media&token=45426216-f7a3-449b-8a91-05582ebc1339",
              text: "Khung giờ đã đăng ký.",
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SchedulePage()));
              },
            ),
            FeatureMenu(
              icon:
                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fexercise.png?alt=media&token=f9b0b759-2f11-431e-b821-f695bd62e78c",
              text: "Bài tập trị liệu",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoryPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
