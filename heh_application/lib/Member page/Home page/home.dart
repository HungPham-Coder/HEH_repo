import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';

import 'package:heh_application/Member%20page/Exercise%20Page/category.dart';
import 'package:heh_application/Member%20page/Home%20page/Paid%20page/servicePaid.dart';
import 'package:heh_application/Member%20page/Messenger%20page/messenger_page.dart';
import 'package:heh_application/Member%20page/email.dart';
import 'package:heh_application/Video%20call%20page/views/messenger_page.dart';
import 'package:heh_application/models/chat_model/user_chat.dart';
import 'package:heh_application/services/auth.dart';
import 'package:heh_application/services/chat_provider.dart';
import 'package:heh_application/services/firebase_firestore.dart';
import 'package:provider/provider.dart';

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
                HomeMenu(
                  icon:
                      "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fregisterd.png?alt=media&token=0b0eba33-ef11-44b4-a943-5b5b9b936cfe",
                  text: "Dịch vụ đã đăng ký",
                  press: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ServicePaidPage()));
                    await loadPhysioTherapistAccount();
                    await auth.checkUserExistInFirebase(sharedCurrentUser!);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      if (sharedCurrentUser?.image == null) {
                        sharedCurrentUser?.setImage = "Không có hình";
                      }

                      if (sharedCurrentUser != null) {
                        return Provider<ChatProviderBase>(
                          create: (context) => ChatProvider(),
                          child: MessengerScreenPage(
                              oponentID: opponentUser!.id,
                              oponentAvartar: opponentUser!.photoUrl,
                              oponentNickName: opponentUser!.nickname,
                              userAvatar: sharedCurrentUser!.image,
                              currentUserID: sharedCurrentUser!.userID!),
                        );
                      } else {
                        print('null');
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }));
                  },
                ),
                HomeMenu(
                  icon:
                      "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fregisterd.png?alt=media&token=0b0eba33-ef11-44b4-a943-5b5b9b936cfe",
                  text: "Email page",
                  press: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Email()));
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
