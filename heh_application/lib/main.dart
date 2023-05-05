import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heh_application/welcome.dart';
import 'package:heh_application/services/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

// class WelcomePage extends StatelessWidget {
//   const WelcomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthBase>(context, listen: false);
// =======
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Provider<AuthBase>(
//       create: (context) =>  Auth() ,
//       child: const MaterialApp(
//
//         debugShowCheckedModeBanner: false,
//         home: WelcomePage(),
//       ),
//     );
//   }
// }

