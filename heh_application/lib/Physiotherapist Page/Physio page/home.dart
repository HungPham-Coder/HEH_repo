import 'package:flutter/material.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Home%20page/Advise%20page/appointment.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Home%20page/Session%20Page/session.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/messenger.dart';
import 'package:heh_application/services/firebase_firestore.dart';
import 'package:provider/provider.dart';

class PhysioHomePage extends StatefulWidget {
  const PhysioHomePage({Key? key}) : super(key: key);

  @override
  State<PhysioHomePage> createState() => _PhysioHomePageState();
}

class _PhysioHomePageState extends State<PhysioHomePage> {
  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Đăng xuất?'),
      content: const Text('Ban có muốn đăng xuất?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Không'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Có'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final firestoreDatabase =
        Provider.of<FirebaseFirestoreBase>(context, listen: false);
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Trang chủ",
              style: TextStyle(fontSize: 23),
            ),
            elevation: 10,
            backgroundColor: const Color.fromARGB(255, 46, 161, 226),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                HomeMenu(
                  icon:
                      "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fadvisor.png?alt=media&token=dae71db1-2f53-404e-92de-46838ceff9c6",
                  text: "Tham gia buổi tư vấn",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppointmentPage(
                                firebaseFirestoreBase: firestoreDatabase)));
                  },
                ),
                HomeMenu(
                  icon:
                      "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fplan.png?alt=media&token=2356eeaa-f224-4b1f-ad5f-f0cb34f2e922",
                  text: "Tham gia buổi trị liệu",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SessionPage(
                                firebaseFirestoreBase: firestoreDatabase)));
                  },
                ),
                HomeMenu(
                  icon:
                      "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fcare.png?alt=media&token=0ce5dd58-bcaf-45a8-b277-05eaad8b89b8",
                  text: "Hỗ trợ tư vấn",
                  press: () {
                    final firestoreFirebase =
                        Provider.of<FirebaseFirestoreBase>(context,
                            listen: false);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhysioMessengerPage(
                                  firestoreBase: firestoreFirebase,
                                )));
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class HomeMenu extends StatelessWidget {
  const HomeMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text, icon;
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
              Image.network(
                icon,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
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
