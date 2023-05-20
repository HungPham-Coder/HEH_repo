import 'package:flutter/material.dart';

import 'package:heh_application/Exercise%20Page/resource.dart';
import 'package:heh_application/common_widget/menu_listview.dart';

class UnPaidServicePage extends StatefulWidget {
  const UnPaidServicePage({Key? key}) : super(key: key);

  @override
  State<UnPaidServicePage> createState() => _UnPaidServicePageState();
}

class _UnPaidServicePageState extends State<UnPaidServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Bài tập yêu thích",
          style: TextStyle(fontSize: 23),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MenuListView(
              icon:
                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fbackache.png?alt=media&token=d725e1f5-c106-41f7-9ee5-ade77c464a54",
              text: "Bài tập mạnh cơ dang hông (đứng)",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExerciseResources(
                            // detailID: "",
                            )));
              },
            ),
          ],
        ),
      ),
    );
  }
}
