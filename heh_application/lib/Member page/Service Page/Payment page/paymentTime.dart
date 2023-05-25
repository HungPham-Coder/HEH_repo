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

  File? imageFile;
  bool isLoading = false;
  bool visible = false;
  String imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fwhite.jpg?alt=media&token=992ffa5a-dd2b-4ff4-bf8f-285be1da997d";
  final value = NumberFormat("###,###,###");
  @override
  void initState() {
    super.initState();
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
      String imageUrlDownLoadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = imageUrlDownLoadUrl;
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

  Widget choose ({required String priceImage}){
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
                priceImage,
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
                  priceImage:
                      "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2FQR3.jpg?alt=media&token=cd4a5333-227b-491a-8365-a5334d2a491d",
                ),
                Visibility(
                  visible: visible,
                  child: const Text(
                    "Hãy chọn hình ảnh hóa đơn",
                    style: TextStyle(fontSize: 15, color: Colors.red),
                  ),
                ),

              ])),



          const SizedBox(
            height: 130,
          ),
        ],
      ))),
      bottomSheet: SizedBox(
        height: 115,
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
                  if (imageUrl == "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fwhite.jpg?alt=media&token=992ffa5a-dd2b-4ff4-bf8f-285be1da997d"){
                    setState(() {
                      visible = true;
                    });
                  }
                  else {
                    setState(() {
                      visible = false;
                    });
                    widget.bookingDetail!.imageUrl = imageUrl;
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

                  }

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
