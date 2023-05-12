import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';

class Email1 extends StatefulWidget {
  Email1({
    Key? key,
    required this.myauth,
  }) : super(key: key);

  EmailOTP myauth = EmailOTP();

  @override
  State<Email1> createState() => _Email1State();
}

class _Email1State extends State<Email1> {
  TextEditingController email = new TextEditingController();
  TextEditingController otp = new TextEditingController();

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
                          controller: otp,
                          decoration:
                              const InputDecoration(hintText: "Enter OTP")),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (await widget.myauth.verifyOTP(otp: otp.text) ==
                              true) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("OTP is verified"),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Invalid OTP"),
                            ));
                          }
                        },
                        child: const Text("Verify")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
