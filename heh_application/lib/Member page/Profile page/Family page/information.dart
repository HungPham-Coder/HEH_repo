import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heh_application/Login%20page/landing_page.dart';

import 'package:heh_application/models/relationship.dart';

import 'package:heh_application/models/sub_profile.dart';
import 'package:heh_application/services/auth.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/services/chat_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum genderGroup { male, female }

class FamilyInformationPage extends StatefulWidget {
  FamilyInformationPage({Key? key, required this.subProfile}) : super(key: key);
  SubProfile? subProfile;
  @override
  State<FamilyInformationPage> createState() => _FamilyInformationPageState();
}

class _FamilyInformationPageState extends State<FamilyInformationPage> {
  genderGroup _genderValue = genderGroup.male;
  File? imageFile;
  bool isLoading = false;
  String imageUrl = "";
  DateTime today = DateTime.now();
  late int age;
  bool visible = false;
  String firstNameTxt = sharedSubprofile!.subName;
  String selectedRelationship = sharedSubprofile!.relationship!.relationName;
  final List<String> _relationships = [
    "- Chọn -",
  ];
  final TextEditingController _date = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  bool validName = true;
  bool validDOB = true;
  bool validRelationShip = true;

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
        new DateFormat("yyyy-MM-dd").parse(widget.subProfile!.dob!);
    String dob = DateFormat("dd-MM-yyyy").format(tempDob);
    print(_date.text);
    String dobChange = DateFormat("yyyy-MM-dd").format(tempDob);
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: <Widget>[
            fullName(label: "Họ và Tên"),
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
                    validDOB = false;
                    return "Không được để trống ngày sinh!";
                  } else if (widget.subProfile!.relationship!.relationName ==
                      "Tôi") {
                    if (age < 18) {
                      validDOB = false;
                      return "Tuổi phải trên 18.";
                    } else {
                      validDOB = true;
                    }
                  } else {
                    validDOB = true;
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
                      lastDate: DateTime.now());
                  if (pickeddate != null) {
                    _date.text = DateFormat('dd-MM-yyyy').format(pickeddate);
                    dob = _date.text;
                    // print(_date.text);
                    dobChange = DateFormat('yyyy-MM-dd').format(pickeddate);
                    age = today.year - pickeddate.year;
                    print(age);
                    // print(dob);
                  }
                },
              ),
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
                        return Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: DropdownButtonFormField<String>(
                            validator: (value) {
                              if (selectedRelationship == "- Chọn -") {
                                validRelationShip = false;
                                return "Hãy chọn mối quan hệ";
                              } else {
                                validRelationShip = true;
                              }
                            },
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey))),
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
                              print(selectedRelationship);
                            }),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })

                // ),
                ),
            Visibility(
              visible: visible,
              child: const Text(
                "Hãy nhập đúng những field cần thiết",
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
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
                        onPressed: () async {
                          if (validRelationShip == true &&
                              validDOB == true &&
                              validName == true) {
                            if (visible = true) {
                              setState(() {
                                visible = false;
                              });
                            }
                            Relationship relationship = await CallAPI()
                                .getRelationByRelationName(
                                    selectedRelationship);
                            SubProfile sub = SubProfile(
                              profileID: widget.subProfile!.profileID,
                              userID: sharedCurrentUser!.userID,
                              relationID: relationship.relationId,
                              subName: _firstName.text,
                              dob: dobChange,
                            );

                            await CallAPI().updateSubprofile(sub);
                            SubProfile subPro = await CallAPI()
                                .getSubProfileBySubNameAndUserID(
                                    _firstName.text,
                                    sharedCurrentUser!.userID!);
                            setState(() {
                              sharedSubprofile = subPro;
                              if (sharedSubprofile!
                                      .relationship!.relationName ==
                                  "Tôi") {
                                sharedCurrentUser!.firstName = subPro.subName;
                                sharedCurrentUser!.dob = subPro.dob;
                              }
                            });
                            await CallAPI().updateUserbyUID(sharedCurrentUser!);
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
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            setState(() {
                              visible = true;
                            });
                          }
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

  Widget fullName({label, input, obscureText = false}) {
    RegExp regExp = RegExp(r'^[a-zA-ZÀ-ỹẠ-ỵĂăÂâĐđÊêÔôƠơƯư\s]+$');
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
          textCapitalization: TextCapitalization.words,
          obscureText: obscureText,
          keyboardType: TextInputType.name,
          controller: _firstName..text = firstNameTxt,
          onChanged: (value) {
            firstNameTxt = value;
          },
          decoration: const InputDecoration(
              // hintStyle: const TextStyle(color: Colors.black),
              // hintText: sharedCurrentUser!.firstName,
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
          validator: (value) {
            if (value!.isEmpty) {
              validName = false;
              return "Hãy nhập Họ và Tên của bạn.";
            } else if (!regExp.hasMatch(value)) {
              validName = false;
              return " Tên không được chứa ký tự đặc biệt như ?@#";
            } else {
              if (value.isNotEmpty) {
                validName = true;
              }
            }
          },
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
