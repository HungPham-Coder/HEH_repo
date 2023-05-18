import 'package:flutter/material.dart';
import 'package:heh_application/Member%20page/Home%20page/Paid%20page/session.dart/advicePaid.dart';
import 'package:heh_application/Member%20page/Home%20page/Paid%20page/session.dart/sessionPaid.dart';
import 'package:heh_application/models/chat_model/user_chat.dart';
import 'package:heh_application/services/firebase_firestore.dart';

class ServicePaidPage extends StatefulWidget {
  ServicePaidPage({Key? key, required this.firebaseFirestoreBase})
      : super(key: key);
  FirebaseFirestoreBase firebaseFirestoreBase;
  @override
  State<ServicePaidPage> createState() => _ServicePaidPageState();
}

class _ServicePaidPageState extends State<ServicePaidPage> {
  UserChat? opponentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            "Dịch vụ đã đăng ký",
            style: TextStyle(fontSize: 23),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Tư vấn trị liệu"),
              Tab(text: "Trị liệu dài hạn"),

            ],
          ),
          elevation: 10,
          backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        ),
        body: TabBarView(children: [
          AdvicePaidPage(firebaseFirestoreBase: widget.firebaseFirestoreBase),
          SessionPaidPage(firebaseFirestoreBase: widget.firebaseFirestoreBase),
        ]),
      ),
    ));
  }
}
