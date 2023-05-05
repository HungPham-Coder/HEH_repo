import 'package:flutter/material.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Notification%20page/adviseAppoint.dart/advise.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Notification%20page/sessionApppoint.dart/session.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String count = '1';
  bool isLabelVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Thông báo",
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              AppointmentMenu(
                isLabelVisible: isLabelVisible,
                count: count,
                icon:
                    "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fadvise.png?alt=media&token=73296749-85c7-415c-9287-eb044d23d6a1",
                text: "Tư vấn một buổi",
                press: () {
                  setState(() {
                    isLabelVisible = false;
                    count = '';
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdviseAppointmentPage()));
                },
              ),
              AppointmentMenu(
                isLabelVisible: isLabelVisible,
                count: "2",
                icon:
                    "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fphysio.png?alt=media&token=dcc89b01-2c15-4808-87eb-4a2ecc9667a3",
                text: "Điều trị lâu dài",
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SessionAppointmentPage()));
                },
              ),
            ],
          ),
        ],
      )),
    );
  }
}

class AppointmentMenu extends StatelessWidget {
  const AppointmentMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
    required this.count,
    required this.isLabelVisible,
  }) : super(key: key);

  final String text, icon, count;
  final bool isLabelVisible;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: TextButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xfff5f6f9)),
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.white)),
              )),
          onPressed: press,
          child: Row(
            children: [
              Badge(
                isLabelVisible: isLabelVisible,
                textStyle:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                label: Text(count),
                alignment: AlignmentDirectional.lerp(
                    AlignmentDirectional.topStart,
                    AlignmentDirectional.topEnd,
                    28),
                child: Image.network(
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
                  width: 60,
                  height: 60,
                ),
              ),
              const SizedBox(
                width: 20,
                height: 10,
              ),
              Expanded(
                  child: Text(
                text,
                style: Theme.of(context).textTheme.titleMedium,
              )),
              const Icon(Icons.arrow_forward_sharp),
            ],
          )),
    );
  }
}
