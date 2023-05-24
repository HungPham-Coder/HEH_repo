import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heh_application/Change%20password/renewPass,.dart';

class OTPChangePage extends StatefulWidget {
  OTPChangePage({
    Key? key,
    required this.email,
    required this.myauth,
  }) : super(key: key);

  String? email;
  EmailOTP myauth = EmailOTP();

  @override
  State<OTPChangePage> createState() => _OTPChangePageState();
}

class _OTPChangePageState extends State<OTPChangePage> {
  final TextEditingController text1 = TextEditingController();
  final TextEditingController text2 = TextEditingController();
  final TextEditingController text3 = TextEditingController();
  final TextEditingController text4 = TextEditingController();
  final TextEditingController text5 = TextEditingController();
  final TextEditingController text6 = TextEditingController();
  String _otp = "";

  @override
  void dispose() {
    super.dispose();
    text1.dispose();
    text2.dispose();
    text3.dispose();
    text4.dispose();
    text5.dispose();
    text6.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Mã xác nhận",
          style: TextStyle(fontSize: 23),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   "Mã xác nhận",
              //   style: TextStyle(fontSize: 23),
              // ),
              const SizedBox(height: 10),
              const Text("Chúng tôi đã gửi mã OTP đến "),
              const SizedBox(height: 10),
              Text(
                "Email: ${widget.email!.replaceRange(0, widget.email!.indexOf("@") - 2, "******")}",
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  field(text1, true),
                  field(text2, false),
                  field(text3, false),
                  field(text4, false),
                  field(text5, false),
                  field(text6, false),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      _otp = text1.text +
                          text2.text +
                          text3.text +
                          text4.text +
                          text5.text +
                          text6.text;


                      if (await widget.myauth.verifyOTP(otp: _otp) == true) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("OTP đúng."),
                        ));

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => renewChangePass()));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Sai OTP. Vui lòng nhập lại."),
                        ));
                      }
                    },
                    child: const Icon(Icons.arrow_forward_ios_outlined)),
              ),
              const SizedBox(height: 10),
            ],
          )),
    );
  }

  Widget field(TextEditingController text, bool autocfocus) {
    return Container(
      width: 40,
      height: 60,
      child: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        controller: text,
        autofocus: autocfocus,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: Theme.of(context).textTheme.headline6,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
      ),
    );
  }
}
