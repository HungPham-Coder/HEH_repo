import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'dart:convert';
import 'package:heh_application/Member%20page/Service%20Page/Payment%20page/success.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:flutter/services.dart';

import 'package:crypto/crypto.dart';
import 'package:heh_application/services/chat_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';

// enum paymentGroup { male, female, others }

class PaymentTimePage extends StatefulWidget {
  PaymentTimePage({Key? key, this.bookingDetail}) : super(key: key);
  BookingDetail? bookingDetail;
  @override
  State<PaymentTimePage> createState() => _PaymentTimePageState();
}

class _PaymentTimePageState extends State<PaymentTimePage> {
  // paymentGroup _paymentValue = paymentGroup.male;
  @override
  void initState() {
    super.initState();
  }

  File? imageFile;
  bool isLoading = false;
  String imageUrl = "";
  final value = NumberFormat("###,###,###");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Thanh toán",
          style: TextStyle(fontSize: 23),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
              // height: MediaQuery.of(context).size.height * 2,
              child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(children: [
                  const SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height / 11,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/image%2Fwelcome2.png?alt=media&token=e26f1d4f-e548-406c-aa71-65c099663f85"))),
                  ),
                  const SizedBox(height: 10),
                  const Text("Chi tiết giao dịch",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Người thanh toán: "),
                            Text(
                                "${widget.bookingDetail!.bookingSchedule!.signUpUser!.firstName}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Số tiền: "),
                            Row(
                              children: [
                                Text(
                                    value.format(widget
                                        .bookingDetail!
                                        .bookingSchedule!
                                        .schedule!
                                        .typeOfSlot!
                                        .price
                                        .toInt()),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const Text(" VNĐ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                choose(
                  icon:
                      "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2FQR.jpg?alt=media&token=cf838750-d192-44cf-831d-4cf7fc0d1802",
                )
              ])),
          const SizedBox(
            height: 130,
          )
        ],
      ))),
      bottomSheet: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Số tiền:"),
                  Text(
                      value.format(widget.bookingDetail!.bookingSchedule!
                          .schedule!.typeOfSlot!.price
                          .toInt()),
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const Text(" VND"),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll<Color>(
                      Color.fromARGB(255, 46, 161, 226),
                    ),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 14)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.white)),
                    )),
                onPressed: () async {
                  BookingDetail addBookingDetail =
                      await CallAPI().addBookingDetail(widget.bookingDetail!);
                  if (addBookingDetail != null) {
                    widget.bookingDetail!.bookingSchedule!.schedule!
                        .physioBookingStatus = true;
                    await CallAPI().updateSchedule(
                        widget.bookingDetail!.bookingSchedule!.schedule!);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SuccessPage()));
                  }
                  // else {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>  FailPage()));
                  // }
                },
                child: const Text(
                  "Thanh toán",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class choose extends StatefulWidget {
  choose({Key? key, required this.icon}) : super(key: key);

  String icon;
  @override
  State<choose> createState() => _chooseState();
}

class _chooseState extends State<choose> {
  File? imageFile;
  bool isLoading = false;
  String imageUrl =
      "https://t3.ftcdn.net/jpg/02/18/26/20/360_F_218262069_OCqHqqKWlwVeZWB8pn32WVFkoZCbWiel.jpg";

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
        await uploadImageFile();
      }
    }
  }

  Future<void> uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask =
        ChatProvider().upLoadImageFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        // imageUrl = imageUrl;
        // sharedCurrentUser!.setImage = imageUrl;
        // print(sharedCurrentUser!.image);
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text("Hình thức thanh toán",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Center(
              child: Image.network(
                widget.icon,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Hình ảnh hóa đơn",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await getImage();
                  },
                  child: const Text(
                    "Chọn",
                    style: TextStyle(fontSize: 16),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Center(
              child: Image.network(
                imageUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
