import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/constant/firestore_constant.dart';
import 'package:heh_application/models/sign_up_user.dart';
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

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  genderGroup _genderValue = genderGroup.male;
  File? imageFile;
  bool isLoading = false;
  String imageUrl = "";
  String? dob;
  DateTime today = DateTime.now();
  late int age;
  String? firstName = sharedCurrentUser!.firstName;
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
      await CallAPI().updateUserbyUID(sharedCurrentUser!);
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
    String dobChange = DateFormat("yyyy-MM-dd").format(tempDob);
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        children: [
          avatar(),
          const SizedBox(height: 20),
          fullName(label: "Họ và Tên"),
          email(label: "Email"),
          phone(label: "Số điện thoại"),
          address(label: "Địa chỉ"),
          gender(),
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
                      dobChange = DateFormat('yyyy-MM-dd').format(pickeddate);
                      age = today.year - pickeddate.year;
                      print(age);
                      // print(dob);
                    }
                  },
                ),
              ),
            ],
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const SettingPage()));
                        Navigator.pop(context);
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
                          email: _email.text,
                          phone: _phone.text,
                          address: _address.text,
                          gender: gender,
                          dob: dobChange,
                          password: sharedCurrentUser!.password,
                        );
                        CallAPI().updateUserbyUID(signUpUser);

                        // SubProfile subProfile = SubProfile(
                        //     userID: sharedCurrentUser!.userID,
                        //     relationID: widget.listSubProfile!.relationID,
                        //     subName: widget.listSubProfile!.subName,
                        //     profileID: widget.listSubProfile!.profileID,
                        //     relationship: widget.listSubProfile!.relationship,
                        //     dob: dob,
                        //     signUpUser: signUpUser);
                        // CallAPI().updateSubprofile(subProfile);

                        await auth.upLoadFirestoreData(
                            FirestoreConstants.pathUserCollection,
                            sharedCurrentUser!.userID!,
                            {"nickname": signUpUser.firstName});
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
          )
        ],
      ),
    )));
  }

  Widget fullName({label, input, obscureText = false}) {
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
              controller: _firstName..text = firstName!,
              onChanged: (value) {
                firstName = value;

              },
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
                  return null;
                } else {
                  return null;
                }
              },
            )),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget address({label, obscureText = false}) {
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
              // initialValue: sharedCurrentUser!.address,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.streetAddress,
              controller: _address..text = sharedCurrentUser!.address!,
              obscureText: obscureText,
              decoration: const InputDecoration(
                  // hintStyle: const TextStyle(color: Colors.black),
                  // hintText: sharedCurrentUser!.address,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
              validator: (value) {
                if (value!.isEmpty) {
                  return null;
                } else {
                  return null;
                }
              },
            )),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget gender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
                readOnly: true,
                controller: _email..text = sharedCurrentUser!.email!,
                obscureText: obscureText,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black),
                    // hintText: sharedCurrentUser!.email,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
                validator: (email) {
                  if (email != null && !EmailValidator.validate(email)) {
                    return "Nhập đúng email";
                  } else if (email!.isEmpty) {
                    return "Vui lòng nhập email!";
                  } else {
                    return null;
                  }
                })),
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
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            controller: _phone..text = sharedCurrentUser!.phone!,
            obscureText: obscureText,
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.black),
                // hintText: sharedCurrentUser!.phone,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey))),
            validator: (value) {
              if (value!.isEmpty) {
                return "Hãy nhập số điện thoại";
              } else if (value.length < 10 || value.length > 10) {
                return "Hãy nhập đúng số điện thoại";
              } else {
                return null;
              }
            },
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget avatar() {
    final auth = Provider.of<AuthBase>(context, listen: false);
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
                  : sharedCurrentUser!.image!),
            ),
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
                      await auth.upLoadFirestoreData(
                          FirestoreConstants.pathUserCollection,
                          sharedCurrentUser!.userID!,
                          {"photoUrl": sharedCurrentUser!.image!});
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
}
