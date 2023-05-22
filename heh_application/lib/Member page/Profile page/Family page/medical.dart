import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Profile%20page/Family%20Page/family.dart';
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

final TextEditingController _problem = TextEditingController();
final TextEditingController _difficult = TextEditingController();
final TextEditingController _injury = TextEditingController();
final TextEditingController _curing = TextEditingController();
final TextEditingController _medicine = TextEditingController();

class FamilyMedicalPage extends StatefulWidget {
  FamilyMedicalPage({Key? key, required this.listSubProfile}) : super(key: key);
  SubProfile? listSubProfile;

  @override
  State<FamilyMedicalPage> createState() => _FamilyMedicalPageState();
}

class _FamilyMedicalPageState extends State<FamilyMedicalPage> {
  List<Problem> _problems = [];
  List<Problem?> _selectedProblems = [];
  final List<CategoryModel> _listCategory = [];

  void addProblem(List<CategoryModel> list) {
    if (_problems.isEmpty) {
      list.forEach((category) {
        _problems.add(Problem(name: category.categoryName));

        _listCategory.add(category);
      });
      // _problems.add(Problem(name: "Khác"));
      // _listCategory.forEach((element) {print(element.categoryName);});
    }
  }

  @override
  void initState() {
    super.initState();
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
                  child: Column(
                    children: [
                      FutureBuilder<List<CategoryModel>>(
                          future: CallAPI().getAllCategory(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              addProblem(snapshot.data!);
                              return MultiSelectBottomSheetField<Problem?>(
                                isDismissible: true,
                                confirmText: const Text("Chấp nhận",
                                    style: TextStyle(fontSize: 18)),
                                cancelText: const Text("Hủy",
                                    style: TextStyle(fontSize: 18)),
                                title: const Text("Tình trạng của bạn"),
                                buttonText: Text(
                                  sharedMedicalRecord!.problem!,
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
                                onConfirm: (values) {
                                  setState(() {
                                    if (values.isEmpty) {
                                      _selectedProblems = values;
                                    }
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
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                    ],
                  ),
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
                              if (_selectedProblems.length > 1) {
                                _selectedProblems.forEach((element) {
                                  if (element != _selectedProblems.last) {
                                    problem += '${element!.name}, ';
                                  } else {
                                    problem += '${element!.name} ';
                                  }
                                });
                                print("ABBC");
                              } else {
                                _selectedProblems.forEach((element) {
                                  problem = '${element!.name}';
                                });
                                print("ABBC");
                              }

                              MedicalRecord medicalRecord = MedicalRecord(
                                medicalRecordID:
                                    sharedMedicalRecord!.medicalRecordID,
                                subProfileID: sharedMedicalRecord!.subProfileID,
                                problem: problem,
                                curing: _curing.text,
                                difficulty: _difficult.text,
                                injury: _injury.text,
                                medicine: _medicine.text,
                              );

                              MedicalRecord? medical = await CallAPI()
                                  .updateMedicalRecord(medicalRecord);
                              // CallAPI().updateMedicalRecordbysubIDandMedicalID(
                              //     medicalRecord);

                              _selectedProblems.forEach((elementSelected) {
                                _listCategory.forEach((element) async {
                                  if (elementSelected!.name ==
                                      element.categoryName) {
                                    Problem1 problem1 = Problem1(
                                      problemID: sharedProblem!.problemID,
                                      categoryID: element.categoryID,
                                      medicalRecordID:
                                          medical!.medicalRecordID!,
                                    );
                                    await CallAPI().updateProblem(problem1);
                                  }
                                });
                              });
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
          // initialValue: dificult,
          controller: _difficult..text = sharedMedicalRecord!.difficulty!,
          obscureText: obscureText,
          decoration: const InputDecoration(
              // hintStyle: TextStyle(color: Colors.black),
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
          // initialValue: injury,
          controller: _injury..text = sharedMedicalRecord!.injury!,
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
          // initialValue: curing,
          controller: _curing..text = sharedMedicalRecord!.curing!,
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
          // initialValue: medicine,
          controller: _medicine..text = sharedMedicalRecord!.medicine!,
          obscureText: obscureText,
          decoration: const InputDecoration(
              // hintStyle: const TextStyle(color: Colors.black),
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
