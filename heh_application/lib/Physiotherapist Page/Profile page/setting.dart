import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heh_application/Change%20password/otpchange.dart';
import 'package:heh_application/Exercise%20Page/category.dart';
import 'package:heh_application/Member%20page/Profile%20page/History%20page/history.dart';
import 'package:heh_application/Physiotherapist%20Page/Profile%20page/Personal%20page/personal.dart';
import 'package:heh_application/Physiotherapist%20Page/Profile%20page/History%20page/history.dart';
import 'package:heh_application/services/stream_test.dart';
import 'package:provider/provider.dart';
import '../../Login page/landing_page.dart';
import '../../services/auth.dart';

class PhysioSettingPage extends StatefulWidget {
  const PhysioSettingPage({Key? key}) : super(key: key);

  @override
  State<PhysioSettingPage> createState() => _PhysioSettingPageState();
}

class _PhysioSettingPageState extends State<PhysioSettingPage> {
  EmailOTP myauth = EmailOTP();

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Đăng xuất?'),
      content: const Text('Ban có muốn đăng xuất?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Không'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Có'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
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
                        backgroundColor: Color.fromARGB(255, 220, 220, 220),
                        backgroundImage:
                            NetworkImage(sharedCurrentUser!.image.toString()))
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(sharedCurrentUser!.firstName.toString(),
                  style: const TextStyle(fontSize: 30)),
              ProfileMenu(
                icon:
                    "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fperson.svg?alt=media&token=7bef043d-fdb5-4c5b-bb2e-644ee7682345",
                text: "Thông tin của bạn",
                press: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PhysioPersonalPage()))
                      .then((value) {
                    setState(() {});
                  });
                },
              ),
              ProfileMenu(
                icon:
                    "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fhistory.svg?alt=media&token=13ed285f-0a27-4ee5-b984-bd73d5f15ac8",
                text: "Lịch sử trị liệu",
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PhysioHistoryPage()));
                },
              ),
              ProfileMenu(
                icon:
                    "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Freset.svg?alt=media&token=f574651a-977a-4eea-a07d-61fe296f5505",
                text: "Đặt lại mật khẩu",
                press: () async {
                  myauth.setConfig(
                      appEmail: "me@rohitchouhan.com",
                      appName: "Email OTP",
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
        ));
  }

  void signout() async {
    final stream = StreamTest.instance;
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
