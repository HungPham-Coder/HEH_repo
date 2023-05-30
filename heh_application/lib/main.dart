import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heh_application/welcome.dart';
import 'package:heh_application/services/auth.dart';
import 'package:heh_application/services/notification.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'Login page/landing_page.dart';
import 'SignUp Page/signup.dart';
import 'models/sign_up_user.dart';

SharedPreferences? preferences;
Future<void> main() async {
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
    child: MaterialApp(
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      // home: WelcomePage1(),
      routes: {
        '/': (context) => const WelcomePage1(),
      },
    ),
  ));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
