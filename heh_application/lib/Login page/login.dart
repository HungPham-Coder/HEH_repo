import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heh_application/ExceptionDialog/show_exception_alert_dialog.dart';
import 'package:heh_application/ForgotPassword%20Page/forgotPass.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/SignUp%20Page/signup.dart';
import 'package:heh_application/main.dart';
import 'package:heh_application/models/login_user.dart';
import 'package:heh_application/models/sign_up_user.dart';
import 'package:heh_application/services/auth.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/services/stream_test.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/result_login.dart';
import 'choose_form.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.msg}) : super(key: key);
  String? msg;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObscure = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    isObscure = true;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? get _errorText {
    final text = passwordController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 4) {
      return 'Too short';
    }
    return null;
  }

  void _submit() {
    setState(() => _submitted = true);
    if (_errorText == null) {}
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Đăng nhập",
            style: TextStyle(fontSize: 23),
          ),
          elevation: 10,
          backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        ),
        body: SingleChildScrollView(
            child: SizedBox(
          height: MediaQuery.of(context).size.height,
          // width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 50),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/image%2Fwelcome2.png?alt=media&token=e26f1d4f-e548-406c-aa71-65c099663f85",
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            return child;
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            inputEmail(
                                obscureText: false,
                                phoneController: emailController),
                            inputPassword(
                                passwordController: passwordController),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return const ForgotPassword(
                                            // auth: auth,
                                            );
                                      }),
                                    );
                                  },
                                  child: const Text(
                                    "Quên mật khẩu?",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 46, 161, 226),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.msg == null ? '' : widget.msg!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          padding: const EdgeInsets.only(top: 0),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () {
                              Login(emailController.text,
                                  passwordController.text, auth);
                            },
                            color: const Color.fromARGB(255, 46, 161, 226),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Text(
                              "Đăng nhập",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("Bạn chưa có tài khoản ? "),
                              GestureDetector(
                                onTap: () {
                                  signUp = null;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return const SignUpPage();
                                    }),
                                  );
                                },
                                child: const Text(
                                  "Đăng ký ",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 46, 161, 226),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              const Text("tại đây!")
                            ],
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ]),
        )));
  }

  Future<void> Login(String email, String password, AuthBase authBase) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final stream = StreamTest.instance;
      LoginUser loginUser = LoginUser(email: email, password: password);
      ResultLogin? resultLogin = await CallAPI().callLoginAPI(loginUser);
      if (resultLogin != null) {

        final snackBar = SnackBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Xin chào ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                resultLogin.firstName!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
          backgroundColor: Colors.teal,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        await stream.addLoginStream(resultLogin);

        // final registerResult = 'Đăng nhập thành công';
      } else {
        ResultLogin resultLogin =
            ResultLogin(userID: "error login", firstName: 'null');
        await stream.addLoginStream(resultLogin);
        // LandingPage(
        //   msg: 'Tài khoản hoặc mật khẩu sai',
        // );
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  // Future<void> _signInWithGoogle() async {
  //   try {
  //     final auth = Provider.of<AuthBase>(context, listen: false);
  //     final stream = StreamTest.instance;
  //     User? user = await auth.signInWithGoogle();
  //     // await user!.reload();
  //     var email;
  //     for (var field in user!.providerData) {
  //       email = field.email;
  //     }
  //     // DateTime? dateTime = "2023-03-27";
  //
  //     SignUpUser signUpUser = SignUpUser(
  //         firstName: user.displayName,
  //         lastName: 'lastName',
  //         phone: '1234567890',
  //         password: '123456789',
  //         email: email,
  //         gender: true,
  //         // dob: DateFormat('yyyy-MM-dd').format(dateTime as DateTime),
  //         address: "abc",
  //         image: user.photoURL);
  //     bool checkUserExist = await auth.checkUserExistInPostgre(email);
  //
  //     if (checkUserExist == false) {
  //       await CallAPI().callRegisterAPI(signUpUser);
  //
  //       // else {
  //       //   LoginPage();
  //       // }
  //     } else {}
  //
  //     ResultLogin resultLogin = ResultLogin(
  //       userID: email,
  //       firstName: user.displayName,
  //       lastName: "google",
  //       phoneNumber: user.phoneNumber,
  //     );
  //
  //     // await  stream.addSignUpStream(signUpUser);
  //
  //     await stream.addLoginStream(resultLogin);
  //   } on Exception catch (e) {
  //     // _showSignInError(e);
  //   }
  // }

  Future<void> _signInWithFacebook() async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final stream = StreamTest.instance;
      User? user = await auth.signInWithFacebook();

      var email;
      for (var field in user.providerData) {
        email = field.email;
      }

      bool checkUserExistInPostgre = await auth.checkUserExistInPostgre(email);
      SignUpUser signUpUser = SignUpUser(
          firstName: user.displayName,
          lastName: "facebook",
          phone: "123456",
          password: "facebook",
          email: email,
          gender: true,
          // dob: '2023-04-02T15:07:52.779Z',
          address: "facebook",
          image: user.photoURL);

      if (checkUserExistInPostgre == false) {
        await CallAPI().callRegisterAPI(signUpUser);
        // else {
        //   LoginPage();
        // }
      } else {}
      ResultLogin resultLogin = ResultLogin(
          userID: email,
          firstName: user.displayName,
          phoneNumber: user.phoneNumber,
          lastName: "facebook");

      // await  stream.addSignUpStream(signUpUser);

      await stream.addLoginStream(resultLogin);
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e.message);
    }
  }

  void _showSignInError(Exception e) {
    if (e is PlatformException && e.code == "ERROR_ABORTED_BY_USER") {
      return;
    }
    showExceptionAlertDialog(context, title: "Sign In failed", exception: e);
  }

//create text field
  Widget inputEmail(
      {obscureText = true, required TextEditingController phoneController}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 5),
        Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              validator: (email) {
                if (email != null && !EmailValidator.validate(email)) {
                  return "Email phải bao gồm @.";
                } else if (email!.isEmpty) {
                  return "Vui lòng nhập email!";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              obscureText: obscureText,
              controller: phoneController,
              decoration: const InputDecoration(
                  label: Text("Email"),
                  // hintText: 'Số điện thoại',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
            )),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget inputPassword({required TextEditingController passwordController}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 5),
        Form(
            child: TextFormField(
          controller: passwordController,
          validator: (value) {
            if (value == '') {
              return "Hãy nhập mật khẩu";
            }
          },
          obscureText: isObscure,
          decoration: InputDecoration(
              label: const Text("Mật khẩu"),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
        ))
      ],
    );
  }
}
