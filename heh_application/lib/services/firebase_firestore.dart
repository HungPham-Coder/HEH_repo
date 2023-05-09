import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:heh_application/models/sign_up_user.dart';
import 'package:heh_application/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage ;

import '../models/chat_model/user_chat.dart';

abstract class FirebaseFirestoreBase {
  Stream<List<UserChat>> getAllUser();
  Future<UserChat?>? getPhysioUser({required String physioID});
  Future<String> getImageUrl(String imageName);
  Future<String> getIconUrl(String icon);
}

class FirebaseFirestores extends FirebaseFirestoreBase {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firestoreService = FirestoreService.instance;
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  @override
  Stream<List<UserChat>> getAllUser() => _firestoreService.collectionStream(
        path: 'user',
        builder: (data, documentId) => UserChat.fromMap(data, documentId),
      );

  @override
  Future<UserChat?>? getPhysioUser({required String physioID}) async {
    // TODO: implement getChatUser
    // final test = _firestoreService.documentStream(
    //    'user/physiotherapist', (data, documentID) => UserChat.fromMap(data!, documentID),
    // );
    // test.listen((event) {
    //   if (event == null) {
    //     print("null");
    //   }
    //   print(event.nickname);});
    // return test;
    final docSnapshot = await _firebaseFirestore.collection('user').doc(physioID).get();
    if (docSnapshot.exists){
      return UserChat.fromMap(docSnapshot.data(), docSnapshot.id);
    }
  }
  Future<List<UserChat>> getAllUserInFirestore() async {
    final snapshot = await _firebaseFirestore.collection('user').get();
    return snapshot.docs.map((e) => UserChat.fromMap(e.data(), e.id),).toList();
  }
  @override
  Future<String> getImageUrl(String imageName) async {
    // TODO: implement getImage
    String downloadUrl = await storage.ref('image/$imageName').getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }

  @override
  Future<String> getIconUrl(String icon) async {
    // TODO: implement getIcon
    String downloadUrl = await storage.ref('icon/$icon').getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }
}
