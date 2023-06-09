import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Profile%20page/setting.dart';
import 'package:heh_application/models/exercise_model/category.dart';
import 'package:heh_application/models/physiotherapist.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../../../models/physiotherapist.dart';

class PhysioCertificatePage extends StatefulWidget {
  PhysioCertificatePage({Key? key, this.physiotherapist}) : super(key: key);
  PhysiotherapistModel? physiotherapist;
  @override
  State<PhysioCertificatePage> createState() => _PhysioCertificatePageState();
}

class Problem {
  final String name;

  Problem({required this.name});
}

class _PhysioCertificatePageState extends State<PhysioCertificatePage> {
  final TextEditingController _specialize = TextEditingController();
  final TextEditingController _skill = TextEditingController();
  final List<CategoryModel> _listCategory = [];
  List<Problem> _problems = [];
  bool validSpecialize = true ;
  bool visible = false ;


  List<Problem?> _selectedProblems = [];
  String specializeTxt = sharedPhysiotherapist!.specialize!;
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
  Future<bool> checkValidSkill () async {
    List<CategoryModel> listCate =  await CallAPI().getAllCategory();
    int count = 0;
    listCate.forEach((element) {
      if (sharedPhysiotherapist!.skill!.contains(element.categoryName) || element.categoryName.contains(sharedPhysiotherapist!.skill!) )
      {
        count ++;
      }
    });
    if (count == 0) {
      return false;
    }
    else {
      return true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: FutureBuilder<PhysiotherapistModel>(
                future: CallAPI()
                    .getPhysiotherapistByUserID(sharedCurrentUser!.userID!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Form(autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          specialize(
                            label: "Chuyên môn của chuyên viên.",
                          ),
                          skill(
                              label: "Kỹ năng của chuyên viên.",
                              skill: snapshot.data!.skill),
                          Visibility(
                            visible: visible,
                            child: const Text(
                              "Hãy nhập đúng những field cần thiết",
                              style: TextStyle(fontSize: 15, color: Colors.red),
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.only(top: 10, bottom: 10),
                            child: MaterialButton(
                              height: 50,
                              onPressed: () async {
                                if (validSpecialize == true) {
                                  //get Skill concatenate String
                                  if (visible) {
                                    setState(() {
                                      visible = false;
                                    });
                                  }
                                  String skill = '';
                                  if (_selectedProblems.length > 0) {
                                    if (_selectedProblems.length > 1) {
                                      _selectedProblems.forEach((element) {
                                        if (element != _selectedProblems.last) {
                                          skill += '${element!.name}, ';
                                        } else {
                                          skill += '${element!.name} ';
                                        }
                                      });
                                    } else {
                                      _selectedProblems.forEach((element) {
                                        skill = '${element!.name}';
                                      });
                                    }
                                  } else {
                                    skill = sharedPhysiotherapist!.skill!;
                                  }


                                    //update physio
                                    PhysiotherapistModel physio =
                                    PhysiotherapistModel(
                                      physiotherapistID: sharedPhysiotherapist!
                                          .physiotherapistID,
                                      scheduleStatus:
                                      sharedPhysiotherapist!.scheduleStatus,
                                      userID: sharedCurrentUser!.userID,
                                      skill: skill,
                                      specialize: _specialize.text,
                                    );
                                    bool result =
                                    await CallAPI().updatePhysio(physio);
                                    if (result) {
                                      PhysiotherapistModel physio = await CallAPI().getPhysiotherapistByUserID(
                                          sharedCurrentUser!.userID!);
                                      setState(() {
                                        sharedPhysiotherapist = physio;
                                      });
                                      final snackBar = SnackBar(
                                        content: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
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


                                }
                                else {
                                  setState(() {
                                    visible = true;
                                  });
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
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Text("ABC");
                  }
                })),
      ),
    );
  }

  Widget specialize({label, obscureText = false}) {
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
          // initialValue: specialize,
          obscureText: obscureText,
          controller: _specialize..text = specializeTxt,
          onChanged: (value) {
            specializeTxt = value;
          },
          validator: (value) {
            if (value!.isEmpty){
              validSpecialize = false;
              return "Hãy nhập chuyên môn của bạn";
            }
            else {
              validSpecialize = true;
            }
          },
          decoration: const InputDecoration(
              hintText: 'Chuyên môn',
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

  Widget skill({label, obscureText = false, String? skill}) {

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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: MultiSelectBottomSheetField<Problem?>(
                      isDismissible: true,
                      confirmText: const Text("Chấp nhận",
                          style: TextStyle(fontSize: 18)),
                      cancelText:
                          const Text("Hủy", style: TextStyle(fontSize: 18)),
                      title: const Text("Kỹ năng"),
                      buttonText: Text(
                        sharedPhysiotherapist!.skill!,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(color: Colors.black, fontSize: 13),
                      ),
                      items: _problems
                          .map((e) => MultiSelectItem<Problem?>(e, e.name))
                          .toList(),
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      onConfirm: (values) {
                        setState(() {
                          _selectedProblems = values;
                        });
                      },
                      // validator: (value) {
                      //   if (validSkill== false){
                      //     return "Hãy chọn kỹ năng của bạn";
                      //   }
                      // },
                      chipDisplay: MultiSelectChipDisplay(onTap: (values) {
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
        const SizedBox(height: 10)
      ],
    );
  }
}
