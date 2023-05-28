import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/choose_form.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Profile%20page/Family%20page/signupMed.dart';
import 'package:heh_application/SignUp%20Page/signupMed.dart';
import 'package:heh_application/main.dart';
import 'package:heh_application/models/relationship.dart';
import 'package:heh_application/models/sign_up_user.dart';
import 'package:heh_application/models/sub_profile.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

// ignore: camel_case_types
enum genderGroup { male, female, others }

class SignUpFamilyPage extends StatefulWidget {
  const SignUpFamilyPage({Key? key}) : super(key: key);

  @override
  State<SignUpFamilyPage> createState() => _SignUpFamilyPageState();
}

class _SignUpFamilyPageState extends State<SignUpFamilyPage> {
  genderGroup _genderValue = genderGroup.male;
  bool validName = false;
  bool validDOB = false;
  bool validRelationShip = false;
  bool visible = false;

  final List<String> _relationships = [
    "- Chọn -",
  ];
  late int age;
  String selectedRelationship = "- Chọn -";
  String dob = '';
  final TextEditingController _date = TextEditingController();
  final TextEditingController _firstName = TextEditingController();

  Future<void> signUp(SignUpUser signUpUser) async {
    await CallAPI().callRegisterAPI(signUpUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Đăng ký thành viên gia đình",
          style: TextStyle(fontSize: 18),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Text(
                "Hãy tham gia cùng chúng tôi!",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(
                height: 20,
              ),
              fullName(label: "Họ và Tên"),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Text("Ngày sinh"),
                  Text(" *", style: TextStyle(color: Colors.red)),
                ],
              ),
              const SizedBox(height: 5),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || _date.text == '') {
                      validDOB = false;
                      return "Hãy nhập ngày sinh";
                    }
                    else {
                      validDOB = true;
                    }
                  },
                  controller: _date,
                  readOnly: true,
                  decoration:const InputDecoration(
                    hintStyle:  TextStyle(color: Colors.black),
                    hoverColor: Colors.black,
                    // hintText: dob,
                  ),
                  onTap: () async {
                    DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1960),
                        lastDate: DateTime(2030));
                    if (pickeddate != null) {
                      setState(() {
                        age = DateTime.now().year - pickeddate.year;
                        _date.text =
                            DateFormat('dd-MM-yyyy').format(pickeddate);
                        dob = DateFormat('yyyy-MM-dd').format(pickeddate);
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
                          snapshot.data!.removeWhere((element) {
                            if (element.relationName == "Tôi"){
                              return true;
                            }
                            else {
                              return false;
                            }
                          });
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
                              decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey))),
                              value: selectedRelationship,
                              validator: (value) {
                                if (value == "- Chọn -") {
                                  validRelationShip = false;
                                  return "Hãy Chọn mối quan hệ";
                                }
                                else {
                                  validRelationShip = true;
                                }
                              },
                              items: _relationships
                                  .map((relationship) =>
                                      DropdownMenuItem<String>(
                                          value: relationship,
                                          child: Text(
                                            relationship,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          )))
                                  .toList(),
                              onChanged: (relationship) => setState(() {
                                selectedRelationship = relationship!;
                                print(selectedRelationship);
                              }),
                            ),
                          );
                        } else {
                          return Center(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: MaterialButton(
                          height: 50,
                          onPressed: () async {
                            if (validRelationShip == true
                            && validDOB == true
                            && validName == true) {
                              Relationship relationship = await CallAPI()
                                  .getRelationByRelationName(
                                  selectedRelationship);
                              SubProfile subProfile = SubProfile(
                                  userID: sharedCurrentUser!.userID,
                                  relationID: relationship.relationId,
                                  subName: _firstName.text,
                                  dob: dob);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FamilySignUpMedicalPage(
                                            subProfile: subProfile,
                                          )));
                            }
                            else {
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
                            "Tiếp Theo",
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
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
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
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormField(
            // initialValue: sharedCurrentUser!.firstName,
            textCapitalization: TextCapitalization.words,
            obscureText: obscureText,
            keyboardType: TextInputType.name,
            controller: _firstName,
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
                return "Tên không được chứ ký tự đặc biệt như ?@#";
              } else {
                if (value.isNotEmpty) {
                  validName = true;
                }
              }
            },
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
