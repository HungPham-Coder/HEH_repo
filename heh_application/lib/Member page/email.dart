import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
// import 'package:heh_application/Member%20page/email2.dart';

import '../SignUp Page/otp.dart';

class Email extends StatefulWidget {
  const Email({Key? key}) : super(key: key);

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  TextEditingController email = new TextEditingController();
  TextEditingController otp = new TextEditingController();

  EmailOTP myauth = EmailOTP();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: email,
                          decoration:
                              const InputDecoration(hintText: "User Email")),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          myauth.setConfig(
                              appEmail: "me@rohitchouhan.com",
                              appName: "Email OTP",
                              userEmail: email.text,
                              otpLength: 6,
                              otpType: OTPType.digitsOnly);
                          if (await myauth.sendOTP() == true) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("OTP has been sent"),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Oops, OTP send failed"),
                            ));
                          }

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => Email1(
                          //               myauth: myauth,
                          //             )));
                        },
                        child: const Text("Send OTP")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
