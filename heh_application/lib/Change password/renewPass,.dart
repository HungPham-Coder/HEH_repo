import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/services/call_api.dart';

class renewChangePass extends StatefulWidget {
  const renewChangePass({Key? key}) : super(key: key);

  @override
  State<renewChangePass> createState() => _renewChangePassState();
}

class _renewChangePassState extends State<renewChangePass> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool isObscure = false;
  bool isObscure1 = false;
  bool visible = false;
  bool oldPassValid = false;
  String oldPassError = "";
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
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                oldPassword(label: "Nhập mật khẩu cũ"),
                newPassword(label: "Nhập mật khẩu mới"),
                confirmPassword(label: "Nhập lại mật khẩu mới"),
                confirm(),
                returnHome()
              ],
            ),
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
            onPressed: () async {

              dynamic result =  await CallAPI().ChangePassword(sharedCurrentUser!, _oldPassword.text, _newPassword.text);
              if (result == true){
                setState(() {
                  oldPassValid = true;
                  visible = true;
                });
                final snackBar = SnackBar(
                  content: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Đổi pass thành công",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.green,
                );
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBar);

              }
              else {
                setState(() {
                  oldPassValid = false;
                  visible = false;
                  oldPassError = result;
                });

              }
            },
            child: Container(
              child: const Text("Thay đổi mật khẩu",
                  style: TextStyle(fontSize: 18)),
            )));
  }

  Widget oldPassword({label}) {
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
        TextFormField(
          controller: _oldPassword,
          validator: (value) {
            if (value!.length < 6 ) {
              return 'Mật khẩu cũ phải dài hơn 6 ký tự';
            }
            else if (value.isEmpty){
              return 'Hãy nhập mật khẩu cũ ';
            }
            else if (oldPassValid == false){
              return oldPassError;
            }
          },
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
        const SizedBox(height: 15)
      ],
    );
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
        TextFormField(
          validator: (value) {
            if (value!.length < 6 && value != '') {
              return 'Password phải dài hơn 6 ký tự';
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
        TextFormField(
          controller: _confirmPassword,
          obscureText: isObscure1,
          validator: (value) {
            if (value != _newPassword.text && value != ''){
              return 'Mật Khẩu xác thực phải trùng mật khẩu mới';
            }
          },
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
        const SizedBox(height: 0)
      ],
    );
  }
  Widget returnHome (){
    return Visibility(
      visible: visible,
      child: Container(
          padding: const EdgeInsets.only(top: 10),
          child: ElevatedButton(
              style: const ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))))),
              onPressed: () async {
                Navigator.popUntil(context, ModalRoute.withName('/landing'));
              },
              child: Container(
                child: const Text("Trở về trang chủ",
                    style: TextStyle(fontSize: 18)),
              ))),
    );
}
}
