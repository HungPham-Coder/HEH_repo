import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Profile%20page/Family%20page/family.dart';
import 'package:heh_application/Member%20page/Profile%20page/setting.dart';
import 'package:heh_application/constant/firestore_constant.dart';
import 'package:heh_application/models/relationship.dart';
import 'package:heh_application/models/sign_up_user.dart';
import 'package:heh_application/models/sub_profile.dart';
import 'package:heh_application/services/auth.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/services/chat_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final TextEditingController _date = TextEditingController();
final TextEditingController _firstName = TextEditingController();
final TextEditingController _address = TextEditingController();
final TextEditingController _email = TextEditingController();
final TextEditingController _phone = TextEditingController();

enum genderGroup { male, female }

class FamilyInformationPage extends StatefulWidget {
  FamilyInformationPage({Key? key, required this.listSubProfile})
      : super(key: key);
  SubProfile? listSubProfile;
  @override
  State<FamilyInformationPage> createState() => _FamilyInformationPageState();
}

class _FamilyInformationPageState extends State<FamilyInformationPage> {
  genderGroup _genderValue = genderGroup.male;
  File? imageFile;
  bool isLoading = false;
  String imageUrl = "";
  String? dob;
  DateTime today = DateTime.now();
  late int age;

  final List<String> _relationships = [
    "- Chọn -",
  ];

  String selectedRelationship = "- Chọn -";

  @override
  void initState() {
    super.initState();
    checkGender();
  }

  @override
  void dispose() {
    super.dispose();
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
        // imageUrl = imageUrl;
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
    final auth = Provider.of<AuthBase>(context, listen: false);
    DateTime tempDob =
        new DateFormat("yyyy-MM-dd").parse(sharedCurrentUser!.dob!);
    String dob = DateFormat("dd-MM-yyyy").format(tempDob);
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        children: <Widget>[
          fullName(label: "Họ và Tên"),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(children: const [
                Text("Ngày sinh "),
                Text("*", style: TextStyle(color: Colors.red))
              ]),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  readOnly: true,
                  controller: _date,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Không được để trống ngày sinh!";
                    } else if (age < 18) {
                      return "Tuổi phải trên 18.";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.black),
                    hoverColor: Colors.black,
                    hintText: dob,
                  ),
                  onTap: () async {
                    DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: today,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2030));
                    if (pickeddate != null) {
                      _date.text = DateFormat('dd-MM-yyyy').format(pickeddate);
                      // print(_date.text);
                      dob = DateFormat('yyyy-MM-dd').format(pickeddate);
                      age = today.year - pickeddate.year;
                      print(age);
                      // print(dob);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Text("Mối quan hệ"),
              Text(" *", style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              // child: SizedBox(
              child: FutureBuilder<List<Relationship>>(
                  future: CallAPI().getAllRelationship(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (_relationships.length == 1) {
                        snapshot.data!.forEach((element) {
                          String field = "${element.relationName}";
                          _relationships.add(field);
                        });
                        print("Co data");
                      }
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey))),
                        value: selectedRelationship,
                        items: _relationships
                            .map((relationship) => DropdownMenuItem<String>(
                                value: relationship,
                                child: Text(
                                  relationship,
                                  style: const TextStyle(fontSize: 15),
                                )))
                            .toList(),
                        onChanged: (relationship) => setState(() {
                          selectedRelationship = relationship!;
                        }),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })

              // ),
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      height: 50,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FamilyPage()));
                      },
                      color: Colors.grey[400],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Hủy",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      height: 50,
                      onPressed: () async {
                        // SignUpUser signUpUser = SignUpUser(
                        //     firstName: _firstName.text,
                        //     lastName: _lastName.text,
                        //     phone: _phone.text,
                        //     password: _password.text,
                        //     email: _email.text,
                        //     gender: _genderValue.index,
                        //     dob: _date.text);
                        // signUp(signUpUser);
                        bool gender = false;
                        if (_genderValue.index == 0) {
                          gender = true;
                        } else if (_genderValue == 1) {
                          gender = false;
                        }
                        SignUpUser signUpUser = SignUpUser(
                          userID: sharedCurrentUser!.userID,
                          image: imageUrl,
                          firstName: _firstName.text,
                          email: _email.text,
                          phone: _phone.text,
                          address: _address.text,
                          gender: gender,
                          dob: dob,
                          password: sharedCurrentUser!.password,
                        );
                        CallAPI().updateUserbyUID(signUpUser);

                        await auth.upLoadFirestoreData(
                            FirestoreConstants.pathUserCollection,
                            sharedCurrentUser!.userID!,
                            {"nickname": signUpUser.firstName});
                        final snackBar = SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                "Cập nhật thành công",
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
    )));
  }

  Widget fullName({label, input, obscureText = false}) {
    RegExp regExp = RegExp(r'^[^\d]*$');
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
        Form(
            autovalidateMode: AutovalidateMode.disabled,
            child: TextFormField(
              // initialValue: sharedCurrentUser!.firstName,
              textCapitalization: TextCapitalization.words,
              obscureText: obscureText,
              keyboardType: TextInputType.name,
              controller: _firstName..text = widget.listSubProfile!.subName,
              decoration: const InputDecoration(
                  // hintStyle: const TextStyle(color: Colors.black),
                  // hintText: sharedCurrentUser!.firstName,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Hãy nhập Họ và Tên của bạn.";
                } else if (!regExp.hasMatch(value)) {
                  return "Hãy nhập đúng tên";
                }
              },
            )),
        const SizedBox(height: 10)
      ],
    );
  }
}
