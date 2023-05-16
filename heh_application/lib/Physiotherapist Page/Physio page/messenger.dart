import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/models/chat_model/user_chat.dart';
import 'package:heh_application/models/sign_up_user.dart';
import 'package:heh_application/services/firebase_firestore.dart';

import 'chat_page.dart';

class PhysioMessengerPage extends StatefulWidget {
  const PhysioMessengerPage({Key? key}) : super(key: key);

  @override
  State<PhysioMessengerPage> createState() => _PhysioMessengerPageState();
}

class _PhysioMessengerPageState extends State<PhysioMessengerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Tin nhắn ",
            style: TextStyle(fontSize: 23),
          ),
          backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: FutureBuilder<List<UserChat>>(
              future: FirebaseFirestores().getAllUserInFirestore(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length > 0) {
                    return ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return buildItem(snapshot.data![index]);
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: snapshot.data!.length);
                  } else {
                    return Center(
                      child: Text('Khong co user'),
                    );
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ));
  }

  Widget buildItem(UserChat signUpUser) {
    if (signUpUser != null) {
      if (signUpUser.id == 'physiotherapist') {
        return const SizedBox.shrink();
      } else {
        print(signUpUser.id);
        return TextButton(
          onPressed: () {
            // if (KeyboardUtils.isKeyboardShowing()) {
            //   KeyboardUtils.closeKeyboard(context);
            // }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          peerId: signUpUser.id,
                          peerAvatar: signUpUser.photoUrl,
                          peerNickname: signUpUser.nickname,
                          userAvatar: sharedCurrentUser!.image!,
                          currentUserID: sharedCurrentUser!.userID!,
                        )));
          },
          child: ListTile(
            leading: signUpUser.photoUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      signUpUser.photoUrl,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      loadingBuilder: (BuildContext ctx, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                                color: Colors.grey,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null),
                          );
                        }
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return const Icon(Icons.account_circle, size: 50);
                      },
                    ),
                  )
                : const Icon(
                    Icons.account_circle,
                    size: 50,
                  ),
            title: Text(
              signUpUser.nickname,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
