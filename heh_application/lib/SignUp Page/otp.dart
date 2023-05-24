import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/SignUp%20Page/signupMed.dart';
import 'package:heh_application/models/exercise_model/category.dart';
import 'package:heh_application/models/medical_record.dart';
import 'package:heh_application/models/problem.dart';
import 'package:heh_application/models/relationship.dart';
import 'package:heh_application/models/sign_up_user.dart';
import 'package:heh_application/models/sub_profile.dart';
import 'package:heh_application/services/call_api.dart';

class OTPPage extends StatefulWidget {
  OTPPage(
      {Key? key,
      required this.email,
      required this.myauth,
      required this.selectedProblems,
      required this.signUpUser,
      required this.curing,
      required this.difficulty,
      required this.injury,
      required this.medicine,
      required this.listCategory})
      : super(key: key);

  String? email;
  EmailOTP myauth = EmailOTP();
  List<Problem?> selectedProblems;
  SignUpUser signUpUser;
  String curing;
  String difficulty;
  String injury;
  String medicine;
  List<CategoryModel> listCategory;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController text1 = TextEditingController();
  final TextEditingController text2 = TextEditingController();
  final TextEditingController text3 = TextEditingController();
  final TextEditingController text4 = TextEditingController();
  final TextEditingController text5 = TextEditingController();
  final TextEditingController text6 = TextEditingController();
  String _otp = "";
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Mã xác nhận",
                style: TextStyle(fontSize: 23),
              ),
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
                      print(_otp);

                      if (await widget.myauth.verifyOTP(otp: _otp) == true) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("OTP đúng."),
                        ));
                        String problem = '';
                        //get all problem
                        if (widget.selectedProblems.length > 1) {
                          widget.selectedProblems.forEach((element) {
                            if (element != widget.selectedProblems.last) {
                              problem += '${element!.name}, ';
                            } else {
                              problem += '${element!.name} ';
                            }
                          });
                          print("ABBC");
                        } else {
                          widget.selectedProblems.forEach((element) {
                            problem = '${element!.name}';
                          });
                          print("ABBC");
                        }
                        //Create user
                        String userID =
                            await CallAPI().callRegisterAPI(widget.signUpUser);

                        Relationship relationship =
                            await CallAPI().getRelationByRelationName("Tôi");
                        //Create subProfile
                        SubProfile subProfile = SubProfile(
                            userID: userID,
                            relationID: relationship.relationId,
                            subName: widget.signUpUser.firstName!,
                            dob: widget.signUpUser.dob);

                        SubProfile subProfile1 =
                            await CallAPI().AddSubProfile(subProfile);
                        //Create medical record
                        MedicalRecord medicalRecord = MedicalRecord(
                          subProfileID: subProfile1.profileID!,
                          problem: problem,
                          curing: widget.curing,
                          difficulty: widget.difficulty,
                          injury: widget.injury,
                          medicine: widget.medicine,
                        );
                        MedicalRecord? medical =
                            await CallAPI().createMedicalRecord(medicalRecord);
                        //Create problem
                        List<Problem1>? listAddProblem = [];
                        widget.selectedProblems.forEach((elementSelected) {
                          widget.listCategory.forEach((element) {
                            if (elementSelected!.name == element.categoryName) {
                              Problem1 problem1 = Problem1(
                                  categoryID: element.categoryID,
                                  medicalRecordID: medical!.medicalRecordID!);

                              listAddProblem.add(problem1);
                            }
                          });
                        });
                        if (listAddProblem.length > 0) {
                          for (var element in listAddProblem) {
                            await CallAPI().addProblem(element);
                          }
                        } else {
                          print("Add problem loi");
                        }
                        final snackBar = SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                "Đăng Ký Thành công",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.popUntil(context, ModalRoute.withName('/landing'));

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
