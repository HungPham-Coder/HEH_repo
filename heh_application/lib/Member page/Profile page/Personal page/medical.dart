import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Profile%20page/setting.dart';
import 'package:heh_application/models/medical_record.dart';
import 'package:heh_application/models/problem.dart';
import 'package:heh_application/models/relationship.dart';
import 'package:heh_application/models/sub_profile.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../models/exercise_model/category.dart';
import '../../../services/call_api.dart';

class MedicalPage extends StatefulWidget {
  MedicalPage({Key? key, this.medicalRecord}) : super(key: key);
  MedicalRecord? medicalRecord;
  @override
  State<MedicalPage> createState() => _MedicalPageState();
}

class Problem {
  final String name;

  Problem({required this.name});
}

class _MedicalPageState extends State<MedicalPage> {
  final TextEditingController _problem = TextEditingController();
  final TextEditingController _difficulty = TextEditingController();
  final TextEditingController _injury = TextEditingController();
  final TextEditingController _curing = TextEditingController();
  final TextEditingController _medicine = TextEditingController();
  List<Problem> _problems = [];
  List<Problem?> _selectedProblems = [];
  final List<CategoryModel> _listCategory = [];
  String? difficultTxt = sharedMedicalRecord!.difficulty;
  String? injuryTxt = sharedMedicalRecord!.injury;
  String? curingTxt = sharedMedicalRecord!.curing;
  String? medicineTxt = sharedMedicalRecord!.medicine;
  bool visible = false;
  bool validProblem = false;
  void addProblem(List<CategoryModel> list) {
    if (_problems.isEmpty) {
      list.forEach((category) {
        _problems.add(Problem(name: category.categoryName));

        _listCategory.add(category);
      });
    }
  }

  void _itemChange(Problem itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedProblems.add(itemValue);
      } else {
        _selectedProblems.remove(itemValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Row(
                  children: const <Widget>[
                    Text(
                      "Anh/Chị đang gặp tình trạng gì?",
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
                          return Form(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: MultiSelectBottomSheetField<Problem?>(
                              isDismissible: true,
                              confirmText: const Text("Chấp nhận",
                                  style: TextStyle(fontSize: 18)),
                              cancelText: const Text("Hủy",
                                  style: TextStyle(fontSize: 18)),
                              title: const Text("Tình trạng của bạn"),
                              buttonText: Text(
                                sharedMedicalRecord!.problem == null
                                    ? ""
                                    : sharedMedicalRecord!.problem!,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 13),
                              ),
                              items: _problems
                                  .map((e) =>
                                      MultiSelectItem<Problem?>(e, e.name))
                                  .toList(),
                              listType: MultiSelectListType.CHIP,
                              searchable: true,
                              validator: (value) {
                                if (sharedMedicalRecord!.problem == null) {
                                  if (_selectedProblems.isEmpty) {
                                    validProblem = false;
                                    return "Hãy chọn vấn đề của bạn";
                                  } else {
                                    validProblem = true;
                                  }
                                }
                              },
                              onConfirm: (values) {
                                setState(() {
                                  _selectedProblems = values;
                                });
                              },
                              chipDisplay:
                                  MultiSelectChipDisplay(onTap: (values) {
                                setState(
                                  () {
                                    _itemChange(values!, false);
                                  },
                                );
                              }),
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
                difficult(
                  label: "Hoạt động khó khăn trong cuộc sống?",
                ),
                injury(
                  label: "Anh/Chị đã gặp chấn thương gì?",
                ),
                curing(
                  label: "Bệnh lý Anh/Chị đang điều trị kèm theo",
                ),
                medicine(
                  label: "Thuốc đang sử dụng hiện tại",
                ),
                Visibility(
                  visible: visible,
                  child: const Text(
                    "Vui lòng nhập đầy đủ những thông tin cần thiết.",
                    style: TextStyle(fontSize: 15, color: Colors.red),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                              } else {
                                if (sharedMedicalRecord!.problem == null) {
                                  setState(() {
                                    validProblem = false;
                                  });
                                } else {
                                  problem = sharedMedicalRecord!.problem!;
                                }
                              }

                              print("problem: ${problem}");
                              if (sharedMedicalRecord!.problem == null) {
                                if (validProblem) {
                                  setState(() {
                                    visible = false;
                                  });
                                  //Get SubProfile
                                  SubProfile subProfile = await CallAPI()
                                      .getSubProfileBySubNameAndUserID(
                                          sharedCurrentUser!.firstName!,
                                          sharedCurrentUser!.userID!);
                                  //create Medical Record
                                  MedicalRecord medicalRecord = MedicalRecord(
                                    subProfileID:
                                        subProfile.profileID,
                                    problem: problem,
                                    curing: _curing.text,
                                    difficulty: _difficulty.text,
                                    injury: _injury.text,
                                    medicine: _medicine.text,

                                  );
                                 MedicalRecord? medicalRecordAdd =  await CallAPI().createMedicalRecord(medicalRecord);
                                 MedicalRecord? medicalRecordGet =  await CallAPI().getMedicalRecordBySubProfileID(subProfile.profileID!);
                                 setState(() {
                                   sharedMedicalRecord = medicalRecordGet;
                                 });
                                 //add problem
                                  _selectedProblems.forEach((elementProblem) { 
                                    
                                    _listCategory.forEach((elementCate) async { 
                                      if (elementProblem!.name == elementCate.categoryName){
                                        Problem1 problem1 = Problem1(categoryID: elementCate.categoryID, medicalRecordID: medicalRecordAdd!.medicalRecordID!);
                                        await CallAPI().addProblem(problem1);
                                      }
                                    });
                                  });
                                  final snackBar = SnackBar(
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Thành công",
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
                                  
                                } else {
                                  setState(() {
                                    visible = true;
                                  });
                                }
                              } else {
                                MedicalRecord medicalRecord = MedicalRecord(
                                  medicalRecordID:
                                      sharedMedicalRecord!.medicalRecordID,
                                  subProfileID:
                                      sharedMedicalRecord!.subProfileID,
                                  problem: problem,
                                  curing: _curing.text,
                                  difficulty: _difficulty.text,
                                  injury: _injury.text,
                                  medicine: _medicine.text,
                                );
                                //update medical record
                                MedicalRecord? medical = await CallAPI()
                                    .updateMedicalRecord(medicalRecord);
                                // update problem
                                if (_selectedProblems.length > 0) {
                                  //listDB
                                  List<Problem1>? listProblem = await CallAPI()
                                      .getProblemByMedicalRecordID(
                                          sharedMedicalRecord!
                                              .medicalRecordID!);
                                  //listAdd
                                  List<Problem1>? listAddProblem = [];
                                  //listDelete
                                  List<Problem1>? listDeleteProblem = [];
                                  //List User Choose
                                  List<Problem1> listOutput = [];
                                  _selectedProblems.forEach((elementSelected) {
                                    _listCategory.forEach((element) async {
                                      if (elementSelected!.name ==
                                          element.categoryName) {
                                        Problem1 problem1 = Problem1(
                                          // problemID: sharedProblem!.problemID,
                                          categoryID: element.categoryID,
                                          medicalRecordID:
                                              medical!.medicalRecordID!,
                                        );
                                        listOutput.add(problem1);
                                      }
                                    });
                                  });
                                  if (listOutput.length > 0) {
                                    for (var out in listOutput) {
                                      int count = 0;
                                      for (var item in listProblem!) {
                                        if (out.categoryID == item.categoryID) {
                                          // problem được lưu trong db đã có và trùng với problem user nhập vào
                                          //problem có trong db và có trong kết quả thì giữ nguyên
                                          count++;
                                        }
                                      }
                                      if (count == 0) {
                                        // add những problem có trong kết quả nhưng không có trong db
                                        listAddProblem.add(out);
                                      }
                                    }
                                    for (var item in listProblem!) {
                                      int count = 0;
                                      for (var out in listOutput) {
                                        if (out.categoryID == item.categoryID) {
                                          // problem được lưu trong db đã có và trùng với problem user nhập vào
                                          //problem có trong db và có trong kết quả thì giữ nguyên
                                          count++;
                                        }
                                      }
                                      if (count == 0) {
                                        // delete những problem có trong db nhưng không có trong output
                                        listDeleteProblem.add(item);
                                      }
                                    }
                                    if (listAddProblem != null) {
                                      for (var item in listAddProblem) {
                                        await CallAPI().addProblem(item);
                                      }
                                    }
                                    if (listDeleteProblem != null) {
                                      for (var item in listDeleteProblem) {
                                        await CallAPI()
                                            .DeleteProblem(item.problemID!);
                                      }
                                    }
                                  }
                                }

                                MedicalRecord? medicalUpdate = await CallAPI()
                                    .getMedicalRecordByUserIDAndRelationName(
                                        sharedCurrentUser!.userID!, "Tôi");
                                setState(() {
                                  sharedMedicalRecord = medicalUpdate;
                                });
                                final snackBar = SnackBar(
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Thành công",
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
                            },
                            color: const Color.fromARGB(255, 46, 161, 226),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "Cập nhật",
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
            )
            //    }
            //    else {
            //      return Center(child: CircularProgressIndicator(),);
            //    }
            //   }
            // ),
            ),
      ),
    );
  }

  Widget difficult({label, obscureText = false}) {
    if (difficultTxt == null) {
      difficultTxt = "";
    }
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
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          // initialValue: dificult,
          controller: _difficulty..text = difficultTxt!,
          onChanged: (value) {
            difficultTxt = value;
          },
          obscureText: obscureText,

          decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black),
              // hintText: sharedMedicalRecord!.difficulty,
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
    if (injuryTxt == null) {
      injuryTxt = "";
    }
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
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          // initialValue: injury,
          controller: _injury..text = injuryTxt!,
          onChanged: (value) {
            injuryTxt = value;
          },
          obscureText: obscureText,
          decoration: const InputDecoration(
              // hintStyle: const TextStyle(color: Colors.black),
              // hintText: sharedMedicalRecord!.injury,
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
    if (curingTxt == null) {
      curingTxt = "";
    }
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
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          // initialValue: curing,
          controller: _curing..text = curingTxt!,
          onChanged: (value) {
            curingTxt = value;
          },
          obscureText: obscureText,
          decoration: const InputDecoration(
              // hintStyle: const TextStyle(color: Colors.black),
              // hintText: sharedMedicalRecord!.curing,
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
    if (medicineTxt == null) {
      medicineTxt = "";
    }
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
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          // initialValue: medicine,
          controller: _medicine..text = medicineTxt!,
          onChanged: (value) {
            medicineTxt = value;
          },
          obscureText: obscureText,
          decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black),
              // hintText: sharedMedicalRecord!.medicine,
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
