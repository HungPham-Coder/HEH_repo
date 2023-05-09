import 'package:flutter/material.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Feature%20page/Session%20page/session_Schedule.dart';
import 'package:heh_application/common_widget/menu_listview.dart';

class SessionListPage extends StatefulWidget {
  const SessionListPage({Key? key}) : super(key: key);

  @override
  State<SessionListPage> createState() => _SessionListPageState();
}

class _SessionListPageState extends State<SessionListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Danh sách điều trị dài hạn",
          style: TextStyle(fontSize: 18),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ServicePaid(
              icon:
                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fcalendar.jpg?alt=media&token=bcd461f3-e46a-4d99-8a59-0250c520c8f8",
              name: "Nguyễn Văn A",
              status: "Chờ",
            ),
          ],
        ),
      ),
    );
  }

  Widget ServicePaid({required String icon, name, status}) {
    return Padding(
      padding: const EdgeInsets.all(10),
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
                      width: MediaQuery.of(context).size.width / 1.6,
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
                                "Trạng thái: ",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                status,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 10),
                          // Row(
                          //   children: [
                          //     Text(
                          //       "Khung giờ: ",
                          //       style: Theme.of(context).textTheme.bodyText2,
                          //     ),
                          //     Text(
                          //       time,
                          //       style: const TextStyle(
                          //           fontWeight: FontWeight.w600,
                          //           color: Colors.black),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 10),
                        ],
                      )),
                  button(),
                ],
              )),
        ],
      ),
    );
  }

  Widget button() {
    return IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SessionRegisterPage()));
        },
        icon: const Icon(Icons.schedule));
  }
}
