import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heh_application/models/exercise_model/category.dart';
import 'package:heh_application/models/medical_record.dart';
import 'package:heh_application/models/problem.dart';
import 'package:heh_application/models/sub_profile.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Problem {
  final String name;

  Problem({required this.name});
}

class FamilySignUpMedicalPage extends StatefulWidget {
  FamilySignUpMedicalPage({Key? key, required this.subProfile})
      : super(key: key);
  SubProfile subProfile;
  @override
  State<FamilySignUpMedicalPage> createState() =>
      _FamilySignUpMedicalPageState();
}

class _FamilySignUpMedicalPageState extends State<FamilySignUpMedicalPage> {
  List<Problem> _problems = [];
  List _selectedProblems = [];

  late bool _visibility = false;
  TextEditingController _difficult = TextEditingController();
  TextEditingController _curing = TextEditingController();
  TextEditingController _injury = TextEditingController();
  TextEditingController _medicine = TextEditingController();
  final List<CategoryModel> _listCategory = [];
  void addProblem(List<CategoryModel> list) {
    if (_problems.isEmpty) {
      list.forEach((category) {
        _problems.add(Problem(name: category.categoryName));
        _listCategory.add(category);
      });
    }
  }

  void _itemDifferent(Problem _items, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedProblems.add(_items);
      } else {
        _selectedProblems.remove(_items);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Hồ sơ bệnh án",
          style: TextStyle(fontSize: 23),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: const <Widget>[
                    Text(
                      "Anh/Chị đang gặp vấn đề gì?",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87),
                    ),
                    Text(
                      " *",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: FutureBuilder<List<CategoryModel>>(
                      future: CallAPI().getAllCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          addProblem(snapshot.data!);
                          return MultiSelectBottomSheetField<Problem?>(
                            confirmText: const Text("Chấp nhận",
                                style: TextStyle(fontSize: 18)),
                            cancelText: const Text("Hủy",
                                style: TextStyle(fontSize: 18)),
                            initialChildSize: 0.4,
                            title: const Text("Vấn đề của bạn"),
                            buttonText: const Text(
                              "Vấn đề của bạn",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                            items: _problems
                                .map((e) => MultiSelectItem(e, e.name))
                                .toList(),
                            validator: (value) {
                              if (_selectedProblems.length == 0) {
                                return "Hãy chọn vấn đề của bạn";
                              }
                            },
                            listType: MultiSelectListType.CHIP,
                            searchable: true,
                            onConfirm: (values) {
                              setState(() {
                                _selectedProblems = values;
                              });
                            },
                            chipDisplay: MultiSelectChipDisplay(
                              onTap: (values) {
                                setState(() {
                                  _itemDifferent(values!, false);
                                });
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
                const SizedBox(height: 20),
                difficult(label: "Hoạt động khó khăn trong cuộc sống?"),
                injury(label: "Anh/Chị đã gặp chấn thương gì?"),
                curing(label: "Bệnh lý Anh/Chị đang điều trị kèm theo"),
                medicine(label: "Thuốc đang sử dụng hiện tại"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: MaterialButton(
                            height: 50,
                            onPressed: () async {
                              String problem = '';
                              if (_selectedProblems.length > 0) {
                                if (_selectedProblems.length > 1) {
                                  _selectedProblems.forEach((element) {
                                    if (element != _selectedProblems.last) {
                                      problem += '${element!.name}, ';
                                    } else {
                                      problem += '${element!.name} ';
                                    }
                                  });
                                } else {
                                  _selectedProblems.forEach((element) {
                                    problem = '${element!.name}';
                                  });
                                }
                              }

                              SubProfile subProfile = await CallAPI()
                                  .AddSubProfile(widget.subProfile);
                              if (subProfile != null) {
                                MedicalRecord medicalRecord = MedicalRecord(
                                    subProfileID: subProfile.profileID,
                                    curing: _curing.text,
                                    difficulty: _difficult.text,
                                    injury: _injury.text,
                                    medicine: _medicine.text,
                                    problem: problem);
                                MedicalRecord? medicalRecordAdd =
                                    await CallAPI()
                                        .createMedicalRecord(medicalRecord);
                                if (medicalRecordAdd != null) {
                                  //create Problem
                                  List<Problem1>? listAddProblem = [] ;
                                  _selectedProblems.forEach((elementSelected)  {
                                    _listCategory.forEach((element)   {
                                      if (elementSelected!.name ==
                                          element.categoryName) {
                                        Problem1 problem1 = Problem1(
                                            categoryID: element.categoryID,
                                            medicalRecordID:
                                            medicalRecordAdd.medicalRecordID!);


                                        listAddProblem.add(problem1);
                                      }
                                    });
                                  });
                                  if (listAddProblem.length > 0){
                                    for (var element in listAddProblem){

                                      await CallAPI().addProblem(element);
                                    }
                                  }
                                  else {
                                    print ("Add problem loi");
                                  }
                                  final snackBar = SnackBar(
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Đăng ký Thành công",
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
                                  Navigator.popUntil(context,
                                      ModalRoute.withName('/familySignUp'));
                                }
                              }
                            },
                            color: const Color.fromARGB(255, 46, 161, 226),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "Đăng ký",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget problem({label, obscureText = false}) {
  //   return Column(
  //     children: <Widget>[
  //       Row(
  //         children: <Widget>[
  //           Text(
  //             label,
  //             style: const TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.w400,
  //                 color: Colors.black87),
  //           ),
  //           const Text(
  //             " *",
  //             style: TextStyle(color: Colors.red),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 5),
  //       TextField(
  //         obscureText: obscureText,
  //         // controller: _difficult,
  //         decoration: const InputDecoration(
  //             hintText: 'Vấn đề',
  //             contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
  //             enabledBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.grey),
  //             ),
  //             border: OutlineInputBorder(
  //                 borderSide: BorderSide(color: Colors.grey))),
  //       ),
  //       const SizedBox(height: 10)
  //     ],
  //   );
  // }

  Widget difficult({label, obscureText = false}) {
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
            if (value == '') {
              return "Hãy nhập hoạt động khó khăn trong cuộc sống";
            }
          },
          controller: _difficult,
          obscureText: obscureText,
          decoration: const InputDecoration(
              hintText: 'Hoạt động',
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
        ),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget injury({label, obscureText = false}) {
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
            if (value == '') {
              return "Hãy nhập chấn thương đã gặp";
            }
          },
          controller: _injury,
          obscureText: obscureText,
          decoration: const InputDecoration(
              hintText: 'Chấn thương',
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
        ),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget curing({label, obscureText = false}) {
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
            if (value == '') {
              return "Hãy nhập bệnh lý đang điều trị";
            }
          },
          controller: _curing,
          obscureText: obscureText,
          decoration: const InputDecoration(
              hintText: 'Bệnh lý',
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
        ),
        const SizedBox(height: 15)
      ],
    );
  }

  Widget medicine({label, obscureText = false}) {
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
            if (value == '') {
              return "Hãy nhập thuốc đang sử dụng hiện tại";
            }
          },
          controller: _medicine,
          obscureText: obscureText,
          decoration: const InputDecoration(
              hintText: 'Thuốc',
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
        ),
        const SizedBox(height: 0)
      ],
    );
  }
}
