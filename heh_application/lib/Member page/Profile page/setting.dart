import 'dart:async';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heh_application/Change%20password/otpchange.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Home%20page/favorite.dart';
import 'package:heh_application/Member%20page/Profile%20page/Personal%20page/personal.dart';
import 'package:heh_application/models/sub_profile.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/services/stream_test.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';
import 'Family page/family.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  EmailOTP myauth = EmailOTP();
  FutureOr onGoBack (){
    setState(() {
      
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Cài đặt",
          style: TextStyle(fontSize: 23),
        ),
        centerTitle: true,
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(sharedCurrentUser!.image == null ?  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2F360_F_84671939_jxymoYZO8Oeacc3JRBDE8bSXBWj0ZfA9.jpg?alt=media&token=86b0417c-4b47-4207-8c1f-eea21242c91a":sharedCurrentUser!.image! ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(sharedCurrentUser!.firstName.toString(),
              style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 20),
          ProfileMenu(
            icon:
                "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fperson.svg?alt=media&token=7bef043d-fdb5-4c5b-bb2e-644ee7682345",
            text: "Thông tin của bạn",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PersonalPage())).then((value) => onGoBack());
            },
          ),
          ProfileMenu(
            icon:
                "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Ffamily.svg?alt=media&token=f6f01b99-6901-48be-9a69-798ea594bd77",
            text: "Thành viên gia đình",
            press: () async {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FamilyPage(

                          ),
                    settings: const RouteSettings(
                      name: "/familySignUp",
                    ),)).then((value) => onGoBack());
            },
          ),
          ProfileMenu(
            icon:
                "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fhistory.svg?alt=media&token=13ed285f-0a27-4ee5-b984-bd73d5f15ac8",
            text: "Dịch vụ chưa thanh toán",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoritePage()));
            },
          ),
          ProfileMenu(
            icon:
                "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Freset.svg?alt=media&token=f574651a-977a-4eea-a07d-61fe296f5505",
            text: "Đặt lại mật khẩu",
            press: () async {
              myauth.setConfig(
                  appEmail: "hungppmse140153@fpt.edu.vn",
                  appName: "Health care and Healing system",
                  userEmail: sharedCurrentUser!.email,
                  otpLength: 6,
                  otpType: OTPType.digitsOnly);
              if (await myauth.sendOTP() == true) {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Mã OTP đã gửi đến email của bạn."),
                  ));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OTPChangePage(
                        email: sharedCurrentUser!.email,
                        myauth: myauth,
                      ),
                    ),
                  );
                });
              } else {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Xin lỗi, gửi OTP thất bại."),
                  ));
                });
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OTPChangePage(
                            email: sharedCurrentUser!.email,
                            myauth: myauth,
                          )));
            },
          ),
          ProfileMenu(
            icon:
                "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Flogout.svg?alt=media&token=99ed3d5a-ec73-4a07-ac6f-2197f26829ef",
            text: "Đăng xuất",
            press: signout,
          ),
        ],
      )),
    );
  }

  void signout() async {
    final stream = StreamTest.instance;
    // preferences!.remove('result_login');
    final auth = Provider.of<AuthBase>(context, listen: false);
    await stream.handleLogout();
    await auth.signOut(context);
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xfff5f6f9)),
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.white)),
              )),
          onPressed: press,
          child: Row(
            children: [
              SvgPicture.network(
                icon,
                width: 30,
                color: const Color.fromARGB(255, 46, 161, 226),
              ),
              const SizedBox(
                width: 20,
                height: 10,
              ),
              Expanded(
                  child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText1,
              )),
              const Icon(Icons.arrow_forward_ios_rounded),
            ],
          )),
    );
  }
}
