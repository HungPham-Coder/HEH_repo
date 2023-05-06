import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Login%20page/login.dart';
import 'package:heh_application/SignUp%20Page/signup.dart';
import 'package:heh_application/welcome.dart';

class ChooseForm extends StatefulWidget {
  const ChooseForm({Key? key}) : super(key: key);

  @override
  State<ChooseForm> createState() => _ChooseFormState();
}

class _ChooseFormState extends State<ChooseForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: const <Widget>[
                  SizedBox(height: 30),
                  Text("ỨNG DỤNG CHĂM SÓC VÀ PHỤC HỒI CHỨC NĂNG",
                      style: TextStyle(fontSize: 26, fontFamily: 'Roadbrush'),
                      textAlign: TextAlign.center),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
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
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),

              // Container(
              //   height: MediaQuery.of(context).size.height / 2,
              //   decoration: BoxDecoration(
              //       image: DecorationImage(
              //     image: const NetworkImage(
              //         "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/image%2Fwelcome2.png?alt=media&token=e26f1d4f-e548-406c-aa71-65c099663f85"),
              //     onError: (exception, stackTrace) {
              //       return setState(() {
              //         CircularProgressIndicator();
              //       });
              //     },
              //   )),
              // ),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          scaffoldKey.currentContext!,
                          MaterialPageRoute(
                            builder: (context) {
                              return LandingPage();
                            },
                            settings: const RouteSettings(
                              name: "/landing",
                            ),
                          ));
                    },
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Đăng nhập",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()));
                    },
                    color: const Color.fromARGB(255, 46, 161, 226),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Tạo tài khoản",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
