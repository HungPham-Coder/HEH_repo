import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heh_application/Login%20page/login.dart';
import 'package:heh_application/constant/firestore_constant.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/services/chat_provider.dart';
import 'package:heh_application/services/firebase_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:heh_application/Video%20call%20page/views/videoscreen.dart';
import '../../common_widget/chat_image.dart';
import '../../common_widget/message_bubble.dart';
import '../../models/chat_model/chat_messages.dart';
import '../../models/chat_model/message_type.dart';
import 'package:http/http.dart' as http;

class MessengerScreenPage extends StatefulWidget {
  MessengerScreenPage(
      {Key? key,
      required this.oponentID,
      required this.oponentAvartar,
      required this.oponentNickName,
      required this.userAvatar,
      required this.currentUserID,
      required this.firebaseFirestoreBase,
      this.bookingDetail,
      required this.groupChatID})
      : super(key: key);
  final String oponentID;
  final String oponentAvartar;
  final String oponentNickName;
  final String? userAvatar;
  final String currentUserID;
  BookingDetail? bookingDetail;
  final groupChatID;

  FirebaseFirestoreBase firebaseFirestoreBase;
  @override
  State<MessengerScreenPage> createState() => _MessengerScreenPageState();
}

class _MessengerScreenPageState extends State<MessengerScreenPage> {
  int _limit = 20;
  final int _limitIncrement = 20;
  File? imageFile;
  bool isLoading = false;
  String imageURL = '';
  final FocusNode focusNode = FocusNode();
  List<QueryDocumentSnapshot> listMessages = [];
  late RtcEngine agoraEngine;
  int? _remoteUid;
  bool _isJoined = false;
  static String serverUrl = "https://agora-token-server-i5zg.onrender.com";
  static const String appID = "1405b81aefdb475a94c00cc139ed7450";
  final ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  late TransformationController transform;
  String token = "";
  bool isTokenExpiring = false;
  String? channelName;
  int tokenExpireTime = 3600;
  @override
  void initState() {
    super.initState();
    readLocal();
    scrollController.addListener(_scrollController);
    transform = TransformationController();
  }

  @override
  void dispose() {
    transform.dispose();
    super.dispose();
  }

  Widget buildMessageInput() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 46, 161, 226),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: getImage,
              icon: const Icon(Icons.image, size: 30),
              color: Colors.white,
            ),
          ),
          Flexible(
              child: TextField(
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () => onSendMessage(
                      textEditingController.text, MessageType.text),
                  icon: const Icon(Icons.send_rounded),
                  color: Colors.blue,
                ),
                hintText: "Tin nhắn...",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            focusNode: focusNode,
            textInputAction: TextInputAction.send,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: textEditingController,
            onSubmitted: (value) {
              onSendMessage(textEditingController.text, MessageType.text);
            },
          )),
          // Container(
          //   margin: const EdgeInsets.only(left: 4),
          //   decoration: BoxDecoration(
          //       color: const Color.fromARGB(255, 46, 161, 226),
          //       borderRadius: BorderRadius.circular(30)),
          //   child: IconButton(
          //     onPressed: () =>
          //         onSendMessage(textEditingController.text, MessageType.text),
          //     icon: const Icon(Icons.send_rounded),
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
      // if (widget.currentUserID == "physiotherapist"){
      //   if (chatMessages.idTo == widget.currentUserID) {
      //     // right side (my message)
      //     return Column(
      //       crossAxisAlignment: CrossAxisAlignment.end,
      //       children: [
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.end,
      //           children: [
      //             chatMessages.type == MessageType.text
      //                 ? messageBubble(
      //               chatContent: chatMessages.content,
      //               color: Colors.blue,
      //               textColor: Colors.white,
      //               margin: const EdgeInsets.only(right: 10, top: 2),
      //             )
      //                 : chatMessages.type == MessageType.image
      //                 ? Container(
      //               margin: const EdgeInsets.only(right: 10, top: 10),
      //               child: chatImage(
      //                 imageSrc: chatMessages.content,
      //               ),
      //             )
      //                 : const SizedBox.shrink(),
      //             isMessageSent(index)
      //                 ? Container(
      //               clipBehavior: Clip.hardEdge,
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(20),
      //               ),
      //               child: Image.network(
      //                 widget.userAvatar!,
      //                 width: 40,
      //                 height: 40,
      //                 fit: BoxFit.cover,
      //                 loadingBuilder: (BuildContext ctx, Widget child,
      //                     ImageChunkEvent? loadingProgress) {
      //                   if (loadingProgress == null) return child;
      //                   return Center(
      //                     child: CircularProgressIndicator(
      //                       color: Colors.red,
      //                       value: loadingProgress.expectedTotalBytes !=
      //                           null &&
      //                           loadingProgress.expectedTotalBytes !=
      //                               null
      //                           ? loadingProgress.cumulativeBytesLoaded /
      //                           loadingProgress.expectedTotalBytes!
      //                           : null,
      //                     ),
      //                   );
      //                 },
      //                 errorBuilder: (context, object, stackTrace) {
      //                   return const Icon(
      //                     Icons.account_circle,
      //                     size: 35,
      //                     color: Colors.lightGreenAccent,
      //                   );
      //                 },
      //               ),
      //             )
      //                 : Container(
      //               width: 35,
      //             ),
      //           ],
      //         ),
      //         isMessageSent(index)
      //             ? Container(
      //           margin: const EdgeInsets.only(right: 50, top: 6, bottom: 8),
      //           child: Text(
      //             DateFormat('dd MMM yyyy, hh:mm a').format(
      //               DateTime.fromMillisecondsSinceEpoch(
      //                 int.parse(chatMessages.timestamp),
      //               ),
      //             ),
      //             style: const TextStyle(
      //                 color: Colors.blue,
      //                 fontSize: 12,
      //                 fontStyle: FontStyle.italic),
      //           ),
      //         )
      //             : const SizedBox.shrink(),
      //       ],
      //     );
      //   }
      //
      //   else {
      //     print(widget.oponentAvartar);
      //     return Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             isMessageReceived(index)
      //             // left side (received message)
      //                 ? Container(
      //               clipBehavior: Clip.hardEdge,
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(20),
      //               ),
      //               child: Image.network(
      //                 // widget.oponentAvartar,
      //                 "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/avatar%2F1684319936910?alt=media&token=8ff84f68-b91a-4e7d-893d-051e1b202c18",
      //                 width: 30,
      //                 height: 30,
      //                 fit: BoxFit.cover,
      //                 loadingBuilder: (BuildContext ctx, Widget child,
      //                     ImageChunkEvent? loadingProgress) {
      //                   if (loadingProgress == null) return child;
      //                   return Center(
      //                     child: CircularProgressIndicator(
      //                       color: Colors.blue,
      //                       value: loadingProgress.expectedTotalBytes !=
      //                           null &&
      //                           loadingProgress.expectedTotalBytes !=
      //                               null
      //                           ? loadingProgress.cumulativeBytesLoaded /
      //                           loadingProgress.expectedTotalBytes!
      //                           : null,
      //                     ),
      //                   );
      //                 },
      //                 errorBuilder: (context, object, stackTrace) {
      //                   return const Icon(
      //                     Icons.account_circle,
      //                     size: 35,
      //                     color: Colors.grey,
      //                   );
      //                 },
      //               ),
      //             )
      //                 : Container(
      //               width: 35,
      //             ),
      //             chatMessages.type == MessageType.text
      //                 ? messageBubble(
      //               color: Colors.blue,
      //               textColor: Colors.white,
      //               chatContent: chatMessages.content,
      //               margin: const EdgeInsets.only(left: 10),
      //             )
      //                 : chatMessages.type == MessageType.image
      //                 ? Container(
      //               margin: const EdgeInsets.only(left: 10, top: 10),
      //               child: chatImage(imageSrc: chatMessages.content),
      //             )
      //                 : const SizedBox.shrink(),
      //           ],
      //         ),
      //         isMessageReceived(index)
      //             ? Container(
      //           margin: const EdgeInsets.only(left: 50, top: 6, bottom: 8),
      //           child: Text(
      //             DateFormat('dd MMM yyyy, hh:mm a').format(
      //               DateTime.fromMillisecondsSinceEpoch(
      //                 int.parse(chatMessages.timestamp),
      //               ),
      //             ),
      //             style: const TextStyle(
      //                 color: Colors.grey,
      //                 fontSize: 12,
      //                 fontStyle: FontStyle.italic),
      //           ),
      //         )
      //             : const SizedBox.shrink(),
      //       ],
      //     );
      //   }
      // }
      // else {
      if (chatMessages.idFrom == widget.currentUserID) {
        // right side (my message)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                chatMessages.type == MessageType.text
                    ? messageBubble(
                        chatContent: chatMessages.content,
                        color: Colors.blue,
                        textColor: Colors.white,
                        margin: const EdgeInsets.only(right: 5, top: 2),
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: const EdgeInsets.only(right: 5, top: 10),
                            child: chatImage(
                              imageSrc: chatMessages.content,
                            ),
                          )
                        : const SizedBox.shrink(),
                isMessageSent(index)
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // child: Image.network(
                        //   widget.userAvatar!,
                        //   width: 40,
                        //   height: 40,
                        //   fit: BoxFit.cover,
                        //   loadingBuilder: (BuildContext ctx, Widget child,
                        //       ImageChunkEvent? loadingProgress) {
                        //     if (loadingProgress == null) return child;
                        //     return Center(
                        //       child: CircularProgressIndicator(
                        //         color: Colors.red,
                        //         value: loadingProgress.expectedTotalBytes !=
                        //             null &&
                        //             loadingProgress.expectedTotalBytes !=
                        //                 null
                        //             ? loadingProgress.cumulativeBytesLoaded /
                        //             loadingProgress.expectedTotalBytes!
                        //             : null,
                        //       ),
                        //     );
                        //   },
                        //   errorBuilder: (context, object, stackTrace) {
                        //     return const Icon(
                        //       Icons.account_circle,
                        //       size: 35,
                        //       color: Colors.lightGreenAccent,
                        //     );
                        //   },
                        // ),
                      )
                    : Container(),
              ],
            ),
            isMessageSent(index)
                ? Container(
                    margin: const EdgeInsets.only(right: 5, top: 6, bottom: 8),
                    child: Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatMessages.timestamp),
                        ),
                      ),
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isMessageReceived(index)
                    // left side (received message)
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.network(
                          widget.oponentAvartar,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                                value: loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 35,
                              color: Colors.grey,
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 35,
                      ),
                chatMessages.type == MessageType.text
                    ? messageBubble(
                        color: Colors.blue,
                        textColor: Colors.white,
                        chatContent: chatMessages.content,
                        margin: const EdgeInsets.only(left: 5, top: 2),
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: const EdgeInsets.only(left: 5, top: 10),
                            child: chatImage(imageSrc: chatMessages.content),
                          )
                        : const SizedBox.shrink(),
              ],
            ),
            isMessageReceived(index)
                ? Container(
                    margin: const EdgeInsets.only(left: 42, top: 6, bottom: 8),
                    child: Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatMessages.timestamp),
                        ),
                      ),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      }
      // }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: widget.groupChatID.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: ChatProvider().getChatMessage(widget.groupChatID, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessages = snapshot.data!.docs;
                  if (listMessages.isNotEmpty) {
                    return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 5),
                        itemCount: snapshot.data?.docs.length,
                        reverse: true,
                        controller: scrollController,
                        itemBuilder: (context, index) =>
                            buildItem(index, snapshot.data?.docs[index]));
                  } else {
                    return const Center(
                      child: Text('Không có tin nhắn...'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
                }
              })
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.lightBlueAccent,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    // await setupVoiceSDKEngine();
                    // await fetchToken(1, widget.bookingDetail!.bookingDetailID!, 2);
                      widget.bookingDetail!.shorttermStatus = 2;
                      await CallAPI().updateBookingDetailStatus(widget.bookingDetail!);

                    VideoCallScreen.channelName =
                        widget.bookingDetail!.bookingDetailID;
                    print(VideoCallScreen.channelName);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VideoCallScreen(bookingDetail: widget.bookingDetail!),
                    ));
                  },
                  icon: const Icon(Icons.video_call),
                )
              ],
            )
          ],
          title: Text(
            widget.oponentNickName,
            style: TextStyle(fontSize: 18),
          ),
          elevation: 10,
          backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                buildListMessage(),
                buildMessageInput(),
              ],
            ),
          ),
        ));
  }

  void readLocal() {
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     builder: (context) => LoginPage(),
    //   ),
    //   (Route<dynamic> route) => false,
    // );

    ChatProvider().upLoadFirestoreData(
        FirestoreConstants.pathUserCollection,
        widget.currentUserID,
        {FirestoreConstants.chattingWith: widget.oponentID});
  }

  void _scrollController() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  bool isMessageSent(int index) {
    if (index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) !=
                widget.currentUserID ||
        index == 0) {
      return true;
    } else {
      return false;
    }
    // }
  }

  bool isMessageReceived(int index) {
    if (index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) ==
                widget.currentUserID ||
        index == 0) {
      return true;
    } else {
      return false;
    }
    // }
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();

      ChatProvider().sendChatMessage(widget.groupChatID, content, type,
          widget.currentUserID, widget.oponentID);
      // scrollController.animateTo(0,
      //     duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      if (scrollController.hasClients){
        scrollController.jumpTo(50.0);
      }
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadImageFile();
      }
    }
  }

  void uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask =
        ChatProvider().upLoadImageFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageURL = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageURL, MessageType.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  Future<void> setupVoiceSDKEngine() async {
    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appID));

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
  }

  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
    // Prepare the Url
    String url =
        '$serverUrl/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}?expiry=${tokenExpireTime.toString()}';

    // Send the request
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      debugPrint('Token Received: $newToken');
      // Use the token to join a channel or renew an expiring token
      setToken(newToken, uid);
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }

  void setToken(String newToken, int uid) async {
    token = newToken;

    if (isTokenExpiring) {
      // Renew the token
      agoraEngine.renewToken(token);
      isTokenExpiring = false;
      showMessage("Token renewed");
    } else {
      // Join a channel.
      showMessage("Token received, joining a channel...");
      ChannelMediaOptions options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      );
      await agoraEngine.joinChannel(
        token: token,
        channelId: widget.bookingDetail!.bookingDetailID!,
        uid: uid,
        options: options,
      );
    }
  }
}
