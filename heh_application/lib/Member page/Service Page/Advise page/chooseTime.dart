import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Service%20Page/Advise%20page/result.dart';
import 'package:heh_application/models/exercise_model/category.dart';
import 'package:heh_application/models/slot.dart';
import 'package:heh_application/models/sub_profile.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/util/date_time_format.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ChooseTimePage extends StatefulWidget {
  ChooseTimePage({Key? key, required this.typeName}) : super(key: key);
  String typeName;
  @override
  State<ChooseTimePage> createState() => _ChooseTimePageState();
}

class _ChooseTimePageState extends State<ChooseTimePage> {
  final List<String> _relationships = [
    "- Chọn -",
  ];
  String? dateSearch;
  String selectedSubName = "- Chọn -";
  SubProfile? subProfile;
  final TextEditingController _date = TextEditingController();

  List<Problem> _problems = [];
  List<Problem?> _selectedProblems = [];
  bool validRelationShip = false;
  bool validDate = false;
  bool validCategory = false;
  bool validTime = false;
  bool visible = false;
  bool visibleValid = false;

  final List<String> _time = [
    "- Chọn khung giờ -",
  ];
  String? selectedTime = "- Chọn khung giờ -";

  bool timeVisible = false;

  void addProblem(List<CategoryModel> list) {
    if (_problems.isEmpty) {
      list.forEach((category) {
        _problems.add(Problem(name: category.categoryName));
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

  void addSlot(List<Slot> list) {
    if (_time.length == 1) {
      list.forEach((element) {
        String start = DateTimeFormat.formateTime(element.timeStart);
        String end = DateTimeFormat.formateTime(element.timeEnd);
        _time.add("${start} - ${end}");
      });
    } else {
      _time.removeWhere((element) => element != "- Chọn khung giờ -");
      list.forEach((element) {
        String start = DateTimeFormat.formateTime(element.timeStart);
        String end = DateTimeFormat.formateTime(element.timeEnd);
        _time.add("${start} - ${end}");
      });
    }
  }

  Widget relationship() {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          Row(
            children: const [
              Text("Bạn muốn đặt cho ai?"),
              Text(" *", style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: FutureBuilder<List<SubProfile>?>(
                future: CallAPI()
                    .getallSubProfileByUserId(sharedCurrentUser!.userID!, ""),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (_relationships.length == 1) {
                      snapshot.data!.forEach((element) {
                        String field = "${element.subName}";

                        _relationships.add(field);
                      });
                    }
                    return DropdownButtonFormField<String>(
                      validator: (value) {
                        if (selectedSubName == "- Chọn -") {
                          validRelationShip = false;
                          return "Hãy chọn người cần được trị liệu";
                        } else {
                          validRelationShip = true;
                        }
                      },
                      // decoration: const InputDecoration(
                      //     enabledBorder: OutlineInputBorder(
                      //         borderSide:
                      //             BorderSide(width: 1, color: Colors.grey))),
                      value: selectedSubName,
                      items: _relationships
                          .map((relationship) => DropdownMenuItem<String>(
                              value: relationship,
                              child: Text(
                                "   $relationship",
                                style: const TextStyle(fontSize: 15),
                              )))
                          .toList(),
                      onChanged: (subName) => setState(() {
                        snapshot.data!.forEach((element) {
                          if (subName == element.subName) {
                            subProfile = element;
                          }
                        });
                        selectedSubName = subName!;
                      }),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget Date() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(children: const [
          Text("Chọn ngày muốn đặt "),
          Text("*", style: TextStyle(color: Colors.red))
        ]),
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              validDate = false;
              return "Hãy chọn ngày trị liệu";
            } else {
              validDate = true;
            }
          },
          readOnly: true,
          controller: _date,
          decoration: const InputDecoration(
            hoverColor: Colors.black,
            hintText: "Chọn ngày",
          ),
          onTap: () async {
            DateTime? pickeddate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2099));
            if (pickeddate != null) {
              _date.text = DateFormat('dd-MM-yyyy').format(pickeddate);
              setState(() {
                dateSearch = DateFormat('yyyy-MM-dd').format(pickeddate);
                selectedTime = "- Chọn khung giờ -";
                timeVisible = true;
                visible = false;
              });
            }
          },
        ),
      ],
    );
  }

  Widget Category() {
    return Column(
      children: [
        Row(children: const [
          Text("Vấn đề của bạn "),
          Text("* ", style: TextStyle(color: Colors.red))
        ]),
        const SizedBox(height: 5),
        FutureBuilder<List<CategoryModel>>(
            future: CallAPI().getAllCategory(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                addProblem(snapshot.data!);
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: MultiSelectBottomSheetField<Problem?>(
                    confirmText: const Text("Chấp nhận",
                        style: TextStyle(fontSize: 18)),
                    cancelText:
                        const Text("Hủy", style: TextStyle(fontSize: 18)),
                    initialChildSize: 0.4,
                    title: const Text("Tình trạng của bạn"),
                    buttonText: const Text(
                      "Tình trạng",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    validator: (value) {
                      if (_selectedProblems.isEmpty) {
                        validCategory = false;
                        return "Hãy chọn tình trạng";
                      } else {
                        validCategory = true;
                      }
                    },
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
      ],
    );
  }

  Widget Time(String? date) {
    if (date != null) {
      return Visibility(
        visible: timeVisible,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 90,
              child: FutureBuilder<List<Slot>>(
                  future: CallAPI()
                      .GetAllSlotByDateAndTypeOfSlot(date, widget.typeName),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty) {
                        visibleValid = false;
                        addSlot(snapshot.data!);
                        visible = true;
                        return Column(
                          children: [
                            Row(
                              children: const [
                                Text("Bạn muốn đặt khung giờ nào?"),
                                Text(" *", style: TextStyle(color: Colors.red)),
                              ],
                            ),
                            DropdownButtonFormField<String>(
                              value: selectedTime,
                              items: _time
                                  .map((relationship) =>
                                      DropdownMenuItem<String>(
                                        value: relationship,
                                        child: Text(
                                          "   $relationship",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (selectedTime == "- Chọn khung giờ -") {
                                  validTime = false;

                                  return "Hãy chọn khung giờ trị liệu";
                                } else {
                                  validTime = true;
                                }
                              },
                              onChanged: (relationship) => setState(() {
                                selectedTime = relationship;
                                print(selectedTime);
                              }),
                            ),
                          ],
                        );
                      } else {
                        visible = false;
                        visibleValid = false;
                        DateTime dateTemp =
                            DateFormat("yyyy-MM-dd").parse(date);
                        String datefmt =
                            DateFormat("dd-MM-yyyy").format(dateTemp);
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Ngày $datefmt không còn slot trống",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: Text(
                            "Hiện tại không còn slot trống",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 16),
                          ),
                        ),
                      );
                    }
                  }),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (selectedTime != '- Chọn khung giờ -' && _date.text != '') {
    //   DateTime tempDate = new DateFormat("dd-MM-yyyy").parse(_date.text);
    //
    //   String date = DateFormat("yyyy-MM-dd").format(tempDate);
    //   print(date);
    //
    //   var a = selectedTime!.trim().split('-');
    //   String start = a[0].trim();
    //   String end = a[1].trim();
    //   DateTime dateStart = new DateFormat("HH:mm").parse(start);
    //   String startStr = DateFormat("HH:mm:ss").format(dateStart);
    //   String b = '${date}T${startStr}';
    //   print(b);
    // }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Chọn khung giờ",
            style: TextStyle(fontSize: 23),
          ),
          elevation: 10,
          backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  relationship(),
                  const SizedBox(height: 5),
                  Category(),
                  const SizedBox(height: 20),
                  Date(),
                  const SizedBox(height: 20),
                  Time(dateSearch),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: visibleValid,
                    child: const Text(
                      "Hãy nhập điền đầy đủ thông tin cần thiết",
                      style: TextStyle(fontSize: 15, color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: visible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(15)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: const BorderSide(color: Colors.white)),
                            )),
                        onPressed: () async {
                          if (validTime == true &&
                              validCategory == true &&
                              validDate == true &&
                              validRelationShip == true) {
                            setState(() {
                              visibleValid = false;
                            });

                            SubProfile subProfile = await CallAPI()
                                .getSubProfileBySubNameAndUserID(
                                    selectedSubName.trim(),
                                    sharedCurrentUser!.userID!);
                            String problem = '';
                            _selectedProblems.forEach((element) {
                              if (element != _selectedProblems.last) {
                                problem += '${element!.name}, ';
                              } else {
                                problem += '${element!.name} ';
                              }
                            });

                            DateTime tempDate =
                                new DateFormat("dd-MM-yyyy").parse(_date.text);

                            String date =
                                DateFormat("yyyy-MM-dd").format(tempDate);

                            var timeSplit = selectedTime!.trim().split('-');
                            String start = timeSplit[0].trim();
                            String end = timeSplit[1].trim();
                            DateTime dateStart =
                                new DateFormat("HH:mm").parse(start);
                            String startStr =
                                DateFormat("HH:mm:ss").format(dateStart);
                            String timeStart = '${date}T${startStr}';
                            DateTime dateEnd =
                                new DateFormat("HH:mm").parse(end);
                            String endStr =
                                DateFormat("HH:mm:ss").format(dateEnd);
                            String timeEnd = '${date}T${endStr}';

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TimeResultPage(
                                          subProfile: subProfile,
                                          timeStart: timeStart,
                                          timeEnd: timeEnd,
                                          problem: problem,
                                        )));
                          } else {
                            setState(() {
                              visibleValid = true;
                            });
                          }
                        },
                        child: const Text(
                          "Tìm kiếm",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class ClockMenu extends StatefulWidget {
  ClockMenu({Key? key, required this.label, required this.time})
      : super(key: key);

  String label, time;

  @override
  State<ClockMenu> createState() => _ClockMenuState();
}

class _ClockMenuState extends State<ClockMenu> {
  TimeOfDay time = const TimeOfDay(hour: 00, minute: 00);

  @override
  Widget build(BuildContext context) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(widget.time, style: const TextStyle(fontSize: 15)),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text("${hours}:${minutes}",
                            style: const TextStyle(fontSize: 18)),
                      )),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PhysioChooseMenu extends StatelessWidget {
  const PhysioChooseMenu({
    Key? key,
    required this.time,
    required this.name,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String icon, name, time;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 46, 161, 226),
                              width: 2)),
                    )),
                onPressed: press,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(
                      icon,
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
                      width: 40,
                      height: 50,
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 1.75,
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              time,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        )),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class Problem {
  final String name;

  Problem({required this.name});
}
