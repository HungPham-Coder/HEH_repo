import 'package:email_otp/email_otp.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:heh_application/ForgotPassword%20Page/otp.dart';
import 'package:heh_application/ForgotPassword%20Page/renewPass.dart';
import 'package:heh_application/models/error_model.dart';
import 'package:heh_application/services/call_api.dart';
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
  bool validEmail = false;
  EmailOTP myauth = EmailOTP();
  String errorEmail = "";
  bool choose = false;
  bool visible = false;
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
                    validEmail = false;
                    return "Nhập đúng email";
                  } else if (email!.isEmpty) {
                    validEmail = false;
                    return "Vui lòng nhập email!";
                  }
                  else if (errorEmail != ""){
                    return "$errorEmail. Vui lòng nhập email khác.";
                  }
                  else {
                    validEmail = true;
                  }
                })),
        Visibility(
          visible: visible,
          child: const Text(
            "Hãy nhập đúng email",
            style: TextStyle(fontSize: 15, color: Colors.red),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () async {
              if (validEmail == false){
                setState(() {
                  errorEmail = "";
                  validEmail = true;
                });
              }
              if ( validEmail){
                setState(() {
                  visible = false;
                });
                String result = await CallAPI().CheckExistEmail(_emailController.text);
                if (result == "Email đã tồn tại"){
                  myauth.setConfig(
                      appEmail: "hungppmse140153@fpt.edu.vn",
                      appName: "Health care and Healing system",
                      userEmail: _emailController.text,
                      otpLength: 6,
                      otpType: OTPType.digitsOnly);
                  if (await myauth.sendOTP() == true) {
                    setState(() {
                      choose = true;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Mã OTP đã gửi đến email của bạn."),
                      ));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OTPForgotPage(
                            email: _emailController.text,
                            myauth: myauth,
                          ),
                        ),
                      );
                    });
                  } else {
                    setState(() {
                      choose = false;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Xin lỗi, gửi OTP thất bại."),
                      ));
                    });
                  }
                }
                else {
                  setState(() {
                    validEmail = false;
                    errorEmail = result;
                  });
                }

              }
              else {
                setState(() {
                  visible = true;
                });
              }

            },
            child: const Text("Gửi OTP")),
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

