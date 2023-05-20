import 'package:flutter/material.dart';
import 'package:heh_application/Exercise%20Page/category.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Home%20page/Paid%20page/Service%20paid%20page/advicePaid.dart';
import 'package:heh_application/Member%20page/Home%20page/Paid%20page/Service%20paid%20page/sessionPaid.dart';
import 'package:heh_application/Member%20page/email.dart';
import 'package:heh_application/SignUp%20Page/otp.dart';

import 'package:heh_application/models/chat_model/user_chat.dart';
import 'package:heh_application/models/type_of_slot.dart';
import 'package:heh_application/services/auth.dart';
import 'package:heh_application/services/call_api.dart';

import 'package:heh_application/services/firebase_firestore.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/menu_listview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserChat? opponentUser;
  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  Future<bool?> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
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

  Future<void> loadPhysioTherapistAccount() async {
    final firestoreDatabase =
        Provider.of<FirebaseFirestoreBase>(context, listen: false);
    UserChat? userChatResult =
        await firestoreDatabase.getPhysioUser(physioID: 'physiotherapist');
    opponentUser = userChatResult;
  }

  @override
  Widget build(BuildContext context) {
    final firestoreDatabase =
        Provider.of<FirebaseFirestoreBase>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
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
                const SizedBox(height: 20),
                const Center(
                  child: Text("Chào mừng bạn đến với HEH",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      )),
                ),

                FutureBuilder <List<TypeOfSlot>>(
                  future: CallAPI().getAllTypeOfSlot(),
                  builder:(context, snapshot)  {
                    if (snapshot.hasData){
                      if (snapshot.data!.length > 0){
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index)  {
                            if (snapshot.data![index].typeName != "Tư vấn trị liệu 1 buổi")
                              {
                                return HomeMenu(
                                  icon:
                                  snapshot.data![index].typeName == "Tư vấn trị liệu"?
                                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fadvisor.png?alt=media&token=dae71db1-2f53-404e-92de-46838ceff9c6"
                                  :"https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fplan.png?alt=media&token=2356eeaa-f224-4b1f-ad5f-f0cb34f2e922",
                                  text: "Tham gia buổi ${snapshot.data![index].typeName}",
                                  press: () async {
                                    if (snapshot.data![index].typeName == "Tư vấn trị liệu"){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AdvicePaidPage(
                                                  firebaseFirestoreBase: firestoreDatabase,
                                                  typeName: snapshot.data![index].typeName
                                              )));
                                    }
                                    else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SessionPaidPage(
                                                  firebaseFirestoreBase: firestoreDatabase,
                                                  typeName: snapshot.data![index].typeName
                                              )));
                                    }

                                  },
                                );
                              }
                            else {
                              return Container();
                            }

                          }
                        );
                      }
                      else {
                        return Center(
                          child: Text("Type of slot rỗng"),
                        );
                      }

                    }
                    else {
                      return Center(
                        child: Text("Load type of slot loi"),
                      );
                    }

                  }
                ),

                HomeMenu(
                  icon:
                      "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fexercise.png?alt=media&token=f299c936-6f81-41e5-8448-bc587873bc67",
                  text: "Bài tập trị liệu",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CategoryPage()));
                  },
                ),
                TextButton(onPressed: () async {
                  await launchUrl(Uri.parse("https://www.google.com"),mode: LaunchMode.externalApplication);
                }, child: Text("Text"))
                // HomeMenu(
                //   icon:
                //       "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fregisterd.png?alt=media&token=0b0eba33-ef11-44b4-a943-5b5b9b936cfe",
                //   text: "OTP",
                //   press: () async {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => OTPPage(
                //                   email: sharedCurrentUser!.email,
                //                 )));
                //   },
                // ),
                // HomeMenu(
                //   icon:
                //       "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fregisterd.png?alt=media&token=0b0eba33-ef11-44b4-a943-5b5b9b936cfe",
                //   text: "Email",
                //   press: () async {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) => const Email()));
                //   },
                // ),
              ],
            ),
          ),
        ));
  }
}
