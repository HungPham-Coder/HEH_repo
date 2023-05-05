import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Login%20page/login.dart';
import 'package:heh_application/SignUp%20Page/signup.dart';
import 'package:heh_application/services/auth.dart';
import 'package:heh_application/services/notification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/sign_up_user.dart';

Future<void> main() async {
  SharedPreferences prefs =await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification test',
            defaultColor: Colors.red,
            importance: NotificationImportance.High,
            channelShowBadge: true),
      ],
      debug: true);
  // await AwesomeNotifications().setListeners(
  //   onActionReceivedMethod: onActionReceivedMethod,
  //   onNotificationCreatedMethod: onNotificationCreatedMethod,
  //   onNotificationDisplayedMethod: onNotificationDisplayedMethod,
  //   onDismissActionReceivedMethod: onDismissActionReceivedMethod,
  // );
  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
  await Firebase.initializeApp();
  runApp(Provider<AuthBase>(
    create: (context) => Auth(),
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    ),
  ));
}
class WelcomePage extends StatefulWidget {

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const WelcomePage({Key? key}) : super(key: key);

  // static Widget create (BuildContext context){
  //   return WelcomePage();
  // }

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void dispose() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    // TODO: implement dispose
    super.dispose();
    auth.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notification'),
            content: Text('App của chúng tôi muốn truy cập quyền thông báo'),
            actions: [
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
                child: Text(
                  'Đồng ý',
                  style: TextStyle(color: Colors.teal, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Hủy bỏ',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
            ],
          ),
        );
      }
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: const <Widget>[
                  SizedBox(height: 30),
                  Text("ỨNG DỤNG CHĂM SÓC VÀ PHỤC HỒI CHỨC NĂNG",
                      style: TextStyle(fontSize: 26, fontFamily: 'Roadbrush'),
                      textAlign: TextAlign.center),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/image%2Fwelcome2.png?alt=media&token=e26f1d4f-e548-406c-aa71-65c099663f85",
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
                ),
              ),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      // AwesomeNotifications().createNotification(
                      //     content: NotificationContent(
                      //         id: 10,
                      //         channelKey: 'basic_channel',
                      //         title: 'test notification',
                      //         body: 'simple notification'));
                      NotificationService().createTestNotification();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LandingPage();
                            },
                            settings: const RouteSettings(
                              name: "/landing",
                            ),
                          ));
                    },
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Đăng nhập",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                    },
                    color: const Color.fromARGB(255, 46, 161, 226),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Tạo tài khoản",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
