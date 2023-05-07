import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/login.dart';
import 'package:heh_application/Member%20page/navigation_main.dart';
import 'package:heh_application/Physiotherapist%20Page/navigation_main.dart';
import 'package:heh_application/main.dart';
import 'package:heh_application/models/exercise_resource.dart';
import 'package:heh_application/models/login_user.dart';
import 'package:heh_application/models/medical_record.dart';
import 'package:heh_application/models/result_login.dart';
import 'package:heh_application/models/schedule.dart';
import 'package:heh_application/models/sign_up_user.dart';
import 'package:heh_application/services/auth.dart';
import 'package:heh_application/services/firebase_firestore.dart';
import 'package:heh_application/welcome.dart';
import 'package:provider/provider.dart';
import '../models/physiotherapist.dart';
import '../services/stream_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

ResultLogin? sharedResultLogin;
SignUpUser? sharedCurrentUser;
MedicalRecord? sharedMedicalRecord;
Physiotherapist? sharedPhysiotherapist;
ExerciseResource? sharedExerciseResource;
Schedule? schedule;

class LandingPage extends StatefulWidget {
  LandingPage({Key? key, this.msg}) : super(key: key);
  String? msg;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  ResultLogin? resultLogin;
  @override
  void initState() {
    init();
    // TODO: implement initState

    super.initState();
  }

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
    final resultLoginJson = preferences!.getString('result_login');
    print(resultLoginJson);
    if (resultLoginJson == null) {
      return;
    } else {
      resultLogin = ResultLogin.fromMap(json.decode(resultLoginJson));
      final stream = StreamTest.instance;
      await stream.addLoginStream(resultLogin!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final stream = StreamTest.instance;
    return StreamBuilder<ResultLogin?>(
      stream: stream.loginUserStream,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.active){
        //   final user = snapshot.data;
        //   if (user == null){
        //     return LoginPage(
        //       msg: msg,
        //     );
        //   }
        //   else {
        //     if (sharedResultLogin == null){
        //       LoginUser loginUser = LoginUser(email: user.email!, password: auth.currenUser.);
        //       return FutureBuilder(
        //           future: ,
        //
        //           builder: (context, snapshot)  {
        //             return Provider<FirebaseFirestoreBase>(
        //               create: (context) => FirebaseFirestores(),
        //               child: Navigation_Bar(),
        //             );
        //           }
        //       );
        //     }
        //     else {
        //       return Provider<FirebaseFirestoreBase>(
        //         create: (context) => FirebaseFirestores(),
        //         child: Navigation_Bar(),
        //       );
        //     }
        //   }
        // }
        // else {
        //   return Center(child: CircularProgressIndicator(),);
        // }
        if (snapshot.data == null) {
          return LoginPage(
            msg: widget.msg,
          );
          // return WelcomePage1();
        } else if (snapshot.data!.userID == 'error login') {
          return LoginPage(
            msg: 'Email hoặc mật khẩu của bạn sai. Vui lòng nhập lại.',
          );
        } else if (snapshot.data!.userID == 'signout') {
          return LoginPage(
            msg: widget.msg,
          );
        } else if (snapshot.data!.role!.name == "Admin" ||
            snapshot.data!.role!.name == "Staff") {
          return LandingPage(
            msg: 'Email hoặc mật khẩu của bạn sai. Vui lòng nhập lại.',
          );
        } else {
          // prefs
          sharedResultLogin = snapshot.data;
          Future<SignUpUser> futureCurrentUser =
              auth.getCurrentUser(sharedResultLogin!);
          return FutureBuilder<SignUpUser>(
              future: futureCurrentUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  sharedCurrentUser = snapshot.data;
                  if (sharedCurrentUser!.role!.name == "Member") {
                    return Provider<FirebaseFirestoreBase>(
                      create: (context) => FirebaseFirestores(),
                      child: Navigation_Bar(),
                    );
                  } else {
                    return Provider<FirebaseFirestoreBase>(
                      create: (context) => FirebaseFirestores(),
                      child: const PhyNavigation_bar(),
                    );
                  }
                } else {
                  print("khong data");
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        }
      },
    );

    // return const Navigation_Bar();
  }
}
