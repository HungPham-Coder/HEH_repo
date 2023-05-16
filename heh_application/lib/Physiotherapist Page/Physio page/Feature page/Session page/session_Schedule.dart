import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/models/booking_schedule.dart';
import 'package:heh_application/models/schedule.dart';
import 'package:heh_application/models/slot.dart';
import 'package:heh_application/models/type_of_slot.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/util/date_time_format.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../common_widget/menu_listview.dart';

int addSlotStatus = 200;

class SessionRegisterPage extends StatefulWidget {
  SessionRegisterPage({Key? key, this.bookingDetail, this.listDetail})
      : super(key: key);
  BookingDetail? bookingDetail;
  List<BookingDetail>? listDetail;

  @override
  State<SessionRegisterPage> createState() => _SessionRegisterPageState();
}

class _SessionRegisterPageState extends State<SessionRegisterPage> {
  TextEditingController _timeStart = TextEditingController();
  TextEditingController _timeEnd = TextEditingController();

  String? startCompare;
  String? endCompare;
  String? startAdd;
  String? endAdd;

  final List<String> _time = [
    "- Chọn khung giờ -",
  ];
  bool visibleAdd = false;
  bool visibleCheckAfter = false;
  String? selectedTime = "- Chọn khung giờ -";
  Schedule? schedule;
  late Map<DateTime, List<BookingDetail>> selectedEvents = {};
  List<Slot>? listSlotDup;

  CalendarFormat _format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime today = DateTime.now();
  // final DateTime _firstDay = today.subtract(const Duration(days: 30));

  void addSlot(List<Schedule> list) {
    if (_time.length == 1) {
      list.forEach((element) {
        String start = DateTimeFormat.formateTime(element.slot!.timeStart);
        String end = DateTimeFormat.formateTime(element.slot!.timeEnd);
        _time.add("${start} - ${end}");
      });
    } else {
      _time.removeWhere((element) => element != "- Chọn khung giờ -");
      list.forEach((element) {
        String start = DateTimeFormat.formateTime(element.slot!.timeStart);
        String end = DateTimeFormat.formateTime(element.slot!.timeEnd);
        _time.add("${start} - ${end}");
      });
    }
  }

  @override
  void initState() {
    if (widget.bookingDetail != null) {
      widget.listDetail!.forEach(
        (element) {
          if (element.longtermStatus == 1) {
            DateTime dateTemp = new DateFormat("yyyy-MM-dd")
                .parse(element.bookingSchedule!.schedule!.slot!.timeStart);
            if (selectedEvents[dateTemp] == null) {
              selectedEvents[dateTemp] = [element];
            } else {
              selectedEvents[dateTemp]!.add(element);
            }
          }
        },
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<BookingDetail> _getEvents(DateTime date) {
    // if (selectedEvents[_selectedDay] == null){
    //   selectedEvents[_selectedDay] = [
    //     BookingDetail(bookingScheduleID: "")
    //   ];
    //   print(_selectedDay);
    // }
    // else {
    //   return selectedEvents[date] ?? [];
    // }
    String datefmt = DateFormat("yyyy-MM-dd").format(date);
    DateTime datePass = new DateFormat("yyyy-MM-dd").parse(datefmt);

    if (selectedEvents[datePass] == null) {
      return [];
    } else {
      return selectedEvents[datePass]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Tạo lịch",
          style: TextStyle(fontSize: 23),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(

              focusedDay: _selectedDay,
              firstDay: DateTime(2000),

              lastDay: DateTime(2099),
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  if (day.weekday == DateTime.sunday ||
                      day.weekday == DateTime.saturday) {
                    final text = DateFormat.E().format(day);
                    return Center(
                      child: Text(
                        text,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                },
              ),
              eventLoader: _getEvents,
              onHeaderTapped: (focusedDay) {},
              onFormatChanged: (format) {
                setState(() {
                  _format = format;
                });
              },
              calendarFormat: _format,
              daysOfWeekVisible: true,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration:
                    BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 46, 161, 226),
                  shape: BoxShape.circle,
                ),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  formatButtonShowsNext: true),
            ),
            ..._getEvents(_selectedDay)
                .map((BookingDetail e) {
                  String start = DateTimeFormat.formateTime(e.bookingSchedule!.schedule!.slot!.timeStart);
                  String end = DateTimeFormat.formateTime(e.bookingSchedule!.schedule!.slot!.timeEnd);
                  return SessionScheduleMenu(
                      name:
                          "Người điều trị: ${e.bookingSchedule!.subProfile!.signUpUser!.firstName}",
                      time: "Khung giờ: ${start}-${end}",
                      icon:
                          "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fbooking.png?alt=media&token=aa78656d-2651-42a4-810e-07c273cdfe5a",
                      buttonPress: () {
                        String datefmt =
                            DateFormat("dd-MM-yyyy").format(_selectedDay);
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Tạo lịch"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Time(datefmt),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Hủy'),
                                      child: const Text("Hủy"),
                                    ),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text("Tạo")),
                                  ],
                                ));
                      },
                    );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          String datefmt = DateFormat("yyyy-MM-dd").format(_selectedDay);
          DateTime dateCreate = new DateFormat("yyyy-MM-dd").parse(datefmt);
          showDialog(
              context: context,
              builder: (context) =>
                  StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: const Text("Tạo lịch dài hạn"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Time(datefmt),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'Hủy');
                            _timeStart.clear();
                            _timeEnd.clear();
                            setState(() {
                              visibleCheckAfter = false;
                              visibleAdd = false;
                            });
                          },
                          child: const Text("Hủy"),
                        ),
                        TextButton(
                            onPressed: () async {
                              //compare start và end
                              DateTime start = DateTime.parse(startCompare!);
                              DateTime end = DateTime.parse(endCompare!);
                              if (start.compareTo(end) >= 0) {
                                setState(() {
                                  visibleAdd = false;
                                  visibleCheckAfter = true;
                                });
                                // Navigator.pop(context);
                                // return Time(datefmt);
                              } else {
                                setState(() {
                                  visibleCheckAfter = false;
                                });
                                //get Type of slot
                                TypeOfSlot typeOfSlot = await CallAPI()
                                    .GetTypeOfSlotByTypeName(
                                        'Trị liệu dài hạn');
                                //add slot
                                Slot slot = Slot(
                                    timeStart: startAdd!,
                                    timeEnd: endAdd!,
                                    slotName:
                                        "Trị Liệu dài hạn cho ${widget.bookingDetail!.bookingSchedule!.subProfile!.subName}",
                                    available: true);
                                dynamic result = await CallAPI().AddSlot(slot);
                                //check add slot thành công hay không
                                if (addSlotStatus == 400) {
                                  setState(() {
                                    listSlotDup = result;
                                    visibleAdd = true;
                                  });

                                  print(listSlotDup!.length);
                                } else {
                                  setState(() {
                                    visibleAdd = false;
                                  });
                                  Slot slot = result;
                                  //add schedule
                                  Schedule schedule = Schedule(
                                      slotID: slot.slotID!,
                                      physiotherapistID: sharedPhysiotherapist!
                                          .physiotherapistID,
                                      typeOfSlotID: typeOfSlot.typeOfSlotID,
                                      description: "Slot Trị liệu dài hạn",
                                      physioBookingStatus: true);
                                  Schedule addSchedule =
                                      await CallAPI().AddSchedule(schedule);
                                  //check add schedule
                                  if (addSchedule != null) {
                                    //add booking detail
                                    BookingSchedule bookingSchedule =
                                        BookingSchedule(
                                            userID:
                                                widget.bookingDetail!
                                                    .bookingSchedule!.userID,
                                            subProfileID:
                                                widget
                                                    .bookingDetail!
                                                    .bookingSchedule!
                                                    .subProfileID,
                                            scheduleID: addSchedule.scheduleID!,
                                            dateBooking:
                                                DateFormat("yyyy-MM-dd")
                                                    .format(DateTime.now()),
                                            timeBooking: DateFormat(
                                                    "yyyy-MM-ddTHH:mm:ss")
                                                .format(DateTime.now()));
                                    BookingSchedule? bookingScheduleAdd =
                                        await CallAPI().addBookingSchedule(
                                            bookingSchedule);
                                    //add booking detail
                                    BookingDetail bookingDetail = BookingDetail(
                                        bookingScheduleID: bookingScheduleAdd!
                                            .bookingScheduleID!,
                                        shorttermStatus: 3,
                                        longtermStatus: 1,
                                        videoCallRoom: "Mới add");

                                    BookingDetail bookingDetailAdd =
                                        await CallAPI()
                                            .addBookingDetail(bookingDetail);
                                    //check add booking detail
                                    if (bookingDetailAdd != null) {
                                      //get booking detail vừa mới add
                                      BookingDetail bookingDetailGet =
                                          await CallAPI().getBookingDetailByID(
                                              bookingDetailAdd
                                                  .bookingDetailID!);
                                      if (selectedEvents[dateCreate] != null) {
                                        selectedEvents[dateCreate]!
                                            .add(bookingDetailGet);
                                      } else {
                                        selectedEvents[dateCreate] = [
                                          bookingDetailGet
                                        ];
                                      }
                                    }
                                  }
                                }
                              }

                              Navigator.pop(context);
                              _timeStart.clear();
                              _timeEnd.clear();
                              print(_selectedDay);

                            },
                            child: const Text("Tạo")),
                      ],
                    );
                  }));

        },
      ),
    );
  }

  Widget Time(String? date) {
    return Column(
      children: [
        visibleCheckAfter == true
            ? Text('Thời gian bắt đầu phải trước thời gian kết thúc')
            : Container(),
        visibleAdd == true
            ? Column(
                children: [
                  Text('Khung thời gian đăng ký đã có slot rồi'),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listSlotDup?.length,
                      itemBuilder: (context, index) {
                        String start = DateTimeFormat.formateTime(
                            listSlotDup![index].timeStart);
                        String end = DateTimeFormat.formateTime(
                            listSlotDup![index].timeEnd);

                        return Text('Khung giờ : $start-$end');
                      }),
                ],
              )
            : Container(),
        Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
                controller: _timeStart,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Thời gian bắt đầu",
                ),
                onTap: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );

                  if (selectedTime != null) {
                    final text = selectedTime.format(context);
                    setState(() {
                      startCompare = '$date $text';
                      startAdd = '${date}T$text';
                      _timeStart.text = text;
                    });
                  }
                })),
        TextFormField(
          controller: _timeEnd,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: "Thời gian kết thúc",
          ),
          onTap: () async {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );

            if (selectedTime != null) {
              final text = selectedTime.format(context);
              setState(() {
                endCompare = '$date $text';
                endAdd = '${date}T$text';
                _timeEnd.text = text;
              });
            }
          },
        ),
      ],
    );
  }
  // Widget Time(String? date) {
  //   if (date != null) {
  //     return Column(
  //       children: [
  //         Row(
  //           children: const [
  //             Text("Bạn muốn đặt khung giờ nào?"),
  //             Text(" *", style: TextStyle(color: Colors.red)),
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 5,
  //         ),
  //         SizedBox(
  //           width: MediaQuery.of(context).size.width,
  //           height: 50,
  //           child: FutureBuilder<List<Schedule>>(
  //               future: CallAPI().GetAllSlotTypeNotAssignedByDateAndPhysioID(
  //                   date, sharedPhysiotherapist!.physiotherapistID),
  //               builder: (context, snapshot) {
  //                 if (snapshot.hasData) {
  //                   addSlot(snapshot.data!);
  //                   return DropdownButtonFormField<String>(
  //                     value: selectedTime,
  //                     items: _time
  //                         .map((relationship) => DropdownMenuItem<String>(
  //                             value: relationship,
  //                             child: Padding(
  //                               padding:
  //                                   const EdgeInsets.symmetric(horizontal: 10),
  //                               child: Text(
  //                                 relationship,
  //                                 style: const TextStyle(fontSize: 13),
  //                               ),
  //                             )))
  //                         .toList(),
  //                     onChanged: (relationship) => setState(() {
  //                       selectedTime = relationship;
  //                       print(selectedTime);
  //                       var timeSplit = selectedTime!.trim().split('-');
  //                       String start = timeSplit[0].trim();
  //                       String end = timeSplit[1].trim();
  //                       snapshot.data!.forEach((element) {
  //                         if (element.slot!.timeStart.contains(start) &&
  //                             element.slot!.timeEnd.contains(end)) {
  //                           setState(() {
  //                             schedule = element;
  //                           });
  //                         }
  //                       });
  //                     }),
  //                   );
  //                 } else {
  //                   return const Center(
  //                     child: CircularProgressIndicator(),
  //                   );
  //                 }
  //               }),
  //         )
  //       ],
  //     );
  //   } else {
  //     return Container();
  //   }
  // }
}
