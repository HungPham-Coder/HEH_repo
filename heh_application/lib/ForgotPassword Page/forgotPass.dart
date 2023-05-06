import 'package:email_otp/email_otp.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:heh_application/ForgotPassword%20Page/renewPass,.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

// enum ForgotPassPageState { resetPassword, sendOTP }

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);
  // final AuthBase auth;
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _OTPController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  EmailOTP myauth = EmailOTP();
  bool choose = false;
  // ForgotPassPageState _OTPResetPasswordState = ForgotPassPageState.sendOTP;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Quên mật khẩu",
          style: TextStyle(fontSize: 23),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          // height: MediaQuery.of(context).size.height / 3,
          // width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ForgotPass(label: "Nhập email của bạn"),
            ],
          ),
        ),
      ),
    );
  }

  Widget ForgotPass({label, obscureText = false}) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 5),
        Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
                controller: _emailController,
                obscureText: obscureText,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'Email',
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
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () async {
              myauth.setConfig(
                  appEmail: "me@rohitchouhan.com",
                  appName: "Email OTP",
                  userEmail: _emailController.text,
                  otpLength: 6,
                  otpType: OTPType.digitsOnly);
              if (await myauth.sendOTP() == true) {
                setState(() {
                  choose = true;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Mã OTP đã gửi đến email của bạn."),
                  ));
                });

              } else {
                setState(() {
                  choose = false;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Xin lỗi, gửi OTP thất bại."),
                  ));
                });

              }
            },
            child: const Text("Gửi OTP")),
        Visibility(
          visible: choose,
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                      controller: _OTPController,
                      decoration:
                          const InputDecoration(hintText: "Điền mã OTP")),
                ),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const renewPass()));
                      if (await myauth.verifyOTP(otp: _OTPController.text) ==
                          true) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Thành công"),
                        ));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Thất bại"),
                        ));
                      }
                    },
                    child: const Text("Xác thực")),
              ],
            ),
          ),
        )
      ],
    );
  }

  // void verifyPhoneNumber() {
  //   print(_phoneController.text);
  //   widget.auth.verifyUserPhoneNumber(_phoneController.text);
  //   _OTPResetPasswordState = ForgotPassPageState.resetPassword;
  //   setState(() {});
  // }

  // Future<void> verifyOTPCode() async {}
}

// ignore: non_constant_identifier_names

