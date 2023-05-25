import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Login%20page/login.dart';
import 'package:heh_application/services/call_api.dart';

class renewForgotPass extends StatefulWidget {
  const renewForgotPass({Key? key}) : super(key: key);

  @override
  State<renewForgotPass> createState() => _renewForgotPassState();
}

class _renewForgotPassState extends State<renewForgotPass> {
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool validPassword = false;
  bool validConfirmPass = false;
  bool isObscure = false;
  bool isObscure1 = false;

  @override
  void initState() {
    super.initState();
    isObscure = true;
    isObscure1 = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Thay đổi mật khẩu",
            style: TextStyle(fontSize: 23),
          ),
          elevation: 10,
          backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              newPassword(label: "Nhập mật khẩu mới "),
              confirmPassword(label: "Nhập lại mật khẩu mới"),
              confirm(),
            ],
          ),
        ));
  }

  Widget confirm() {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        child: ElevatedButton(
            style: const ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))))),
            onPressed: () async {},
            child: Container(
              child: const Text("Thay đổi mật khẩu",
                  style: TextStyle(fontSize: 18)),
            )));
  }

  Widget newPassword({label}) {
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
            validator: (value) {
              if (value!.isEmpty) {
                validPassword = false;
                return "Hãy nhập mật khẩu";
              }
              if (value.length < 6) {
                validPassword = false;
                return "Mật khẩu phải ít nhất 6 ký tự";
              } else {
                if (value.isNotEmpty) {
                  validPassword = true;
                }
              }
            },
            controller: _newPassword,
            obscureText: isObscure,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility)),
                hintText: 'Mật khẩu',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey))),
          ),
        ),
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                validPassword = false;
                return "Hãy nhập mật khẩu";
              }
              if (value.length < 6) {
                validPassword = false;
                return "Mật khẩu phải ít nhất 6 ký tự";
              } else {
                if (value.isNotEmpty) {
                  validPassword = true;
                }
              }
            },
            controller: _newPassword,
            obscureText: isObscure,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility)),
                hintText: 'Mật khẩu',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey))),
          ),
        ),
        const SizedBox(height: 15)
      ],
    );
  }

  Widget confirmPassword({label}) {
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
            validator: (value) {
              if (value!.isEmpty) {
                validConfirmPass = false;
                return "Hãy nhập mật khẩu xác thực";
              } else if (value != _newPassword.text) {
                validConfirmPass = false;
                return "Mật Khẩu xác thực không trùng với mật khẩu";
              } else {
                if (value.isNotEmpty) {
                  validConfirmPass = true;
                }
              }
            },
            controller: _confirmPassword,
            obscureText: isObscure1,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscure1 = !isObscure1;
                      });
                    },
                    icon: Icon(
                        isObscure1 ? Icons.visibility_off : Icons.visibility)),
                hintText: 'Mật khẩu xác thực',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey))),
          ),
        ),
        const SizedBox(height: 0)
      ],
    );
  }
}
