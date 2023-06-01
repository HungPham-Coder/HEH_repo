import 'package:flutter/material.dart';
import 'package:heh_application/Member%20page/Profile%20page/Family%20page/information.dart';
import 'package:heh_application/Member%20page/Profile%20page/Family%20page/medical.dart';
import 'package:heh_application/models/medical_record.dart';
import 'package:heh_application/models/sub_profile.dart';

class FamilyPersonalPage extends StatefulWidget {
  FamilyPersonalPage(
      {Key? key, required this.subProfile, required this.medicalRecord})
      : super(key: key);

  SubProfile? subProfile;
  MedicalRecord? medicalRecord;
  @override
  State<FamilyPersonalPage> createState() => _FamilyPersonalPageState();
}

class _FamilyPersonalPageState extends State<FamilyPersonalPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "Tài khoản của bạn",
                style: TextStyle(fontSize: 23),
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(text: "Thông tin chính"),
                  Tab(text: "Thông tin khác"),
                ],
              ),
              elevation: 10,
              backgroundColor: const Color.fromARGB(255, 46, 161, 226),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop()),
            ),
            body: TabBarView(children: [
              FamilyInformationPage(subProfile: widget.subProfile),
              FamilyMedicalPage(medicalRecord: widget.medicalRecord)
            ])),
      ),
    );
  }
}
