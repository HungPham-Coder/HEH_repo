import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Profile%20page/setting.dart';
import 'package:heh_application/constant/firestore_constant.dart';
import 'package:heh_application/models/sign_up_user.dart';
import 'package:heh_application/services/auth.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/services/chat_provider.dart';
import 'package:heh_application/util/date_time_format.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum genderGroup { male, female }

class PhysioInformationPage extends StatefulWidget {
  const PhysioInformationPage({Key? key}) : super(key: key);

  @override
  State<PhysioInformationPage> createState() => _PhysioInformationPageState();
}

class _PhysioInformationPageState extends State<PhysioInformationPage> {
  genderGroup _genderValue = genderGroup.male;
  bool isLoading = false;
  String imageUrl = "";
  File? imageFile;
  late int age;
  DateTime today = DateTime.now();
  String? firstName = sharedCurrentUser!.firstName;
  String? phoneTxt = sharedCurrentUser!.phone;
  String dobChange = DateTimeFormat.formatDateSaveDB(sharedCurrentUser!.dob!);
  String dob = DateTimeFormat.formatDate(sharedCurrentUser!.dob!);
  final TextEditingController _date = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  @override
  void initState() {
    super.initState();
    checkGender();
  }

  void checkGender() {
    if (sharedCurrentUser!.gender == false) {
      _genderValue = genderGroup.female;
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
        sharedCurrentUser!.setImage = imageUrl;
        print(sharedCurrentUser!.image);
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
    // String dob = DateFormat('yyyy-MM-dd').format(sharedCurrentUser!.dob!);

    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            avatar(),
            const SizedBox(height: 20),
            fullName(label: "Họ và Tên"),
            email(label: "Email"),
            phone(label: "Số điện thoại"),
            Row(
              children: const <Widget>[
                Text(
                  "Giới tính ",
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  "*",
                  style: TextStyle(fontSize: 15, color: Colors.red),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text("Nam"),
                Radio(
                  value: genderGroup.male,
                  groupValue: _genderValue,
                  onChanged: (genderGroup? value) {
                    setState(() {
                      _genderValue = value!;
                    });
                  },
                ),
                const Text("Nữ"),
                Radio(
                    value: genderGroup.female,
                    groupValue: _genderValue,
                    onChanged: (genderGroup? value) {
                      setState(() {
                        _genderValue = value!;
                      });
                    }),
              ],
            ),
            dobWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: MaterialButton(
                        height: 50,
                        onPressed: () async {
                          bool gender = false;
                          if (_genderValue.index == 0) {
                            gender = true;
                          } else if (_genderValue.index == 1) {
                            gender = false;
                          }

                          SignUpUser signUpUser = SignUpUser(
                              userID: sharedCurrentUser!.userID,
                              firstName: _firstName.text,
                              image: sharedCurrentUser!.image,
                              email: sharedCurrentUser!.email,
                              phone: _phone.text,
                              address: sharedCurrentUser!.address,
                              gender: gender,
                              dob: dobChange,
                              password: sharedCurrentUser!.password);
                          print(dobChange);
                          await CallAPI().updateUserbyUID(signUpUser);
                          SignUpUser? user = await CallAPI()
                              .getUserById(sharedResultLogin!.userID!);

                          setState(() {
                            sharedCurrentUser = user;
                          });
                          final snackBar = SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  "Thành công",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.green,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        color: const Color.fromARGB(255, 46, 161, 226),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Cập nhật",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    )));
  }

  Widget avatar() {
    return Center(
      child: SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(sharedCurrentUser!.image == null
                    ? "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2F360_F_84671939_jxymoYZO8Oeacc3JRBDE8bSXBWj0ZfA9.jpg?alt=media&token=86b0417c-4b47-4207-8c1f-eea21242c91a"
                    : sharedCurrentUser!.image!)),
            Positioned(
              right: -12,
              bottom: 0,
              child: SizedBox(
                height: 46,
                width: 46,
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xfff5f6f9)),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 46, 161, 226))),
                        )),
                    onPressed: () async {
                      await getImage();
                      await CallAPI().updateUserbyUID(sharedCurrentUser!);
                    },
                    child: SvgPicture.network(
                      "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fcamera.svg?alt=media&token=afa6a202-304e-45af-8df5-870126316135",
                      width: 20,
                      height: 20,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fullName({label, obscureText = false}) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87),
            ),
            const Text(
              " *",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          // initialValue: sharedCurrentUser!.firstName,
          obscureText: obscureText,

          controller: _firstName..text = firstName!,
          onChanged: (value) {
            firstName = value;
          },
          decoration: const InputDecoration(
              // hintText: 'Họ và Tên',
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
        ),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget email({label, obscureText = false}) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87),
            ),
            const Text(
              " *",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          readOnly: true,
          // initialValue: sharedCurrentUser!.email,
          controller: _email..text = sharedCurrentUser!.email!,
          obscureText: obscureText,
          decoration: const InputDecoration(
              hintText: 'Email',
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
        ),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget phone({label, obscureText = false}) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87),
            ),
            const Text(
              " *",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: _phone..text = phoneTxt!,
          onChanged: (value) {
            phoneTxt = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return "Hãy nhập số điện thoại";
            } else if (value.length < 10 || value.length > 10) {
              return "Hãy nhập đúng số điện thoại";
            } else {
              return null;
            }
          },
          keyboardType: TextInputType.phone,
          obscureText: obscureText,
          decoration: const InputDecoration(
              hintText: 'Số điện thoại',
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
        ),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget dobWidget() {
    DateTime dateTemp =  DateFormat("yyyy-MM-dd").parse(dobChange);
    age = today.year - dateTemp.year;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          readOnly: true,
          controller: _date..text = dob,
          validator: (value) {
            if (value!.isEmpty) {
              return "Không được để trống ngày sinh!";
            } else if (age < 18) {
              return "Tuổi phải trên 18.";
            } else {
              return null;
            }
          },
          decoration: const InputDecoration(
            labelText: "Ngày sinh ",
            hintStyle: TextStyle(color: Colors.black),
            hoverColor: Colors.black,
          ),
          onTap: () async {
            DateTime? pickeddate = await showDatePicker(
                context: context,
                initialDate: today,
                firstDate: DateTime(1900),
                lastDate: DateTime(2030));
            if (pickeddate != null) {
              setState(() {
                dob = DateFormat('dd-MM-yyyy').format(pickeddate);
                dobChange = DateFormat('yyyy-MM-dd').format(pickeddate);
                age = today.year - pickeddate.year;
              });
            }
          },
        ),
      ],
    );
  }
}
