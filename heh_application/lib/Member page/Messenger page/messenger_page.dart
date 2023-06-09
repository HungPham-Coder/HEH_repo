import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heh_application/Login%20page/login.dart';
import 'package:heh_application/constant/firestore_constant.dart';
import 'package:heh_application/services/chat_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../common_widget/chat_image.dart';
import '../../common_widget/message_bubble.dart';
import '../../models/chat_model/chat_messages.dart';
import '../../models/chat_model/message_type.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage(
      {Key? key,
      required this.oponentID,
      required this.oponentAvartar,
      required this.oponentNickName,
      required this.userAvatar,
      required this.currentUserID})
      : super(key: key);
  final String oponentID;
  final String oponentAvartar;
  final String oponentNickName;
  final String? userAvatar;
  final String currentUserID;
  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  String groupChatID = '';
  int _limit = 20;
  final int _limitIncrement = 20;
  File? imageFile;
  bool isLoading = false;
  String imageURL = '';
  final FocusNode focusNode = FocusNode();
  List<QueryDocumentSnapshot> listMessages = [];

  final ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  late TransformationController transform;

  @override
  void initState() {
    super.initState();
    readLocal();
    scrollController.addListener(_scrollListener);
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
              icon: const Icon(Icons.camera_alt, size: 30),
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
        ],
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
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
                            margin: const EdgeInsets.only(right: 5, top: 5),
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
                        //   width: 30,
                        //   height: 30,
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
                        margin: EdgeInsets.only(top: 10),
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
                        margin: const EdgeInsets.only(left: 10, top: 2),
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: const EdgeInsets.only(left: 10, top: 10),
                            child: chatImage(imageSrc: chatMessages.content),
                          )
                        : const SizedBox.shrink(),
              ],
            ),
            isMessageReceived(index)
                ? Container(
                    margin: const EdgeInsets.only(left: 50, top: 6, bottom: 8),
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
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatID.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: ChatProvider().getChatMessage(groupChatID, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessages = snapshot.data!.docs;
                  if (listMessages.isNotEmpty) {
                    return ListView.builder(
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
          title: const Text(
            "Hỗ trợ tư vấn",
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
    final chatProvider = Provider.of<ChatProviderBase>(context, listen: false);
    if (widget.currentUserID.isNotEmpty) {
      groupChatID = '${widget.currentUserID}';
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
    }
    chatProvider.upLoadFirestoreData(
        FirestoreConstants.pathUserCollection,
        widget.currentUserID,
        {FirestoreConstants.chattingWith: widget.oponentID});
  }

  void _scrollListener() {
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
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      ChatProvider().sendChatMessage(
          groupChatID, content, type, widget.currentUserID, widget.oponentID);
      // scrollController.animateTo(0,
      //     duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      if (scrollController.hasClients){
        scrollController.jumpTo(50.0);
      }

    } else {
      // Fluttertoast.showToast(
      //     msg: 'Nothing to send', backgroundColor: Colors.grey);
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
    final chatProvider = Provider.of<ChatProviderBase>(context, listen: false);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.upLoadImageFile(imageFile!, fileName);
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
}
