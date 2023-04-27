import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common_widget/dialog.dart';
import '../../../../common_widget/menu_listview.dart';
import '../../../../models/slot.dart';
import '../../../../services/call_api.dart';

class PhysioRegisterSlotPage extends StatefulWidget {
  const PhysioRegisterSlotPage({Key? key}) : super(key: key);

  @override
  State<PhysioRegisterSlotPage> createState() => _PhysioRegisterSlotPageState();
}

class _PhysioRegisterSlotPageState extends State<PhysioRegisterSlotPage> {
  bool check = false;
  final TextEditingController _date = TextEditingController();
  List<Slot>? slotList;

  Widget Time() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: const [
              Text("Chọn thời gian làm việc"),
              Text(
                " *",
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          // SizedBox(height: 5),
          TextFormField(
            // initialValue: dob,
            // DateTime.parse(sharedCurrentUser!.dob as String).toString(),
            readOnly: true,
            controller: _date,
            decoration: const InputDecoration(
              labelText: "Chọn ngày",
            ),
            onTap: () async {
              DateTime? pickeddate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2999));
              if (pickeddate != null) {
                _date.text = DateFormat('dd-MM-yyyy').format(pickeddate);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: const MaterialStatePropertyAll(
                  Color.fromARGB(255, 46, 161, 226)),
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.white)),
              )),
          onPressed: () async {
            if (_date.text != '') {
              DateTime day = new DateFormat('dd-MM-yyyy').parse(_date.text);
              String dayStr = DateFormat('yyyy-MM-ddTHH:mm:ss').format(day);
              slotList = await CallAPI().getallSlotByDate(dayStr);
              if (slotList!.length > 0) {
                setState(() {
                  check = true;
                });
              } else {
                setState(() {
                  check = false;
                });
              }

              print(check);
            }
          },
          child: const Text("Tìm kiếm",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Đăng ký lịch làm việc ",
          style: TextStyle(fontSize: 20),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Time(),
            button(),
            const SizedBox(height: 10),
            check == false && _date.text != "" && slotList!.length == 0
                ? const Center(
                    child: Text("Khong co slot nao"),
                  )
                : (_date.text != "" && slotList != null)
                    ? Visibility(
                        visible: check,
                        child: Column(
                          children: [
                            const Text("Danh sách thời gian làm việc",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16)),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: slotList!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  DateTime startTime =
                                      new DateFormat('yyyy-MM-ddTHH:mm:ss')
                                          .parse(slotList![index].timeStart);
                                  String start =
                                      DateFormat('HH:mm').format(startTime);
                                  DateTime endTime =
                                      new DateFormat('yyyy-MM-ddTHH:mm:ss')
                                          .parse(slotList![index].timeEnd);
                                  String end =
                                      DateFormat('HH:mm').format(endTime);

                                  return FutureBuilder(
                                      future: CallAPI()
                                          .getNumberOfPhysioRegisterOnSlot(
                                              slotList![index].slotID),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (slotList![index].available ==
                                              true) {
                                            return RegisterMenu(
                                              icon:
                                                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fregisterd.png?alt=media&token=0b0eba33-ef11-44b4-a943-5b5b9b936cfe",
                                              name:
                                                  "${slotList![index].slotName}",
                                              time: "Khung giờ: $start - $end",
                                              full: "",
                                              choose: false,
                                              amount:
                                                  "Số lượng đăng ký: ${snapshot.data}",
                                              press: () {
                                                Navigator.push(
                                                    context,
                                                    DialogRoute(
                                                        context: context,
                                                        builder: (context) =>
                                                            dialog(
                                                              text:
                                                                  "Bạn muốn chọn thời gian này?",
                                                              des:
                                                                  "Yêu cầu của bạn đến quản lý",
                                                            )));
                                              },
                                            );
                                          } else {
                                            return RegisterMenu(
                                                icon:
                                                    "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fregisterd.png?alt=media&token=0b0eba33-ef11-44b4-a943-5b5b9b936cfe",
                                                name:
                                                    "${slotList![index].slotName}",
                                                full:
                                                    "Slot này đầy. Vui lòng chọn slot khác.",
                                                choose: true,
                                                time:
                                                    "Khung giờ: $start - $end",
                                                amount:
                                                    "Số lượng đăng ký: ${snapshot.data}",
                                                press: null);
                                          }
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      });
                                  // }
                                })
                          ],
                        ))
                    : Container()
          ],
        ),
      ),
    );
  }
}