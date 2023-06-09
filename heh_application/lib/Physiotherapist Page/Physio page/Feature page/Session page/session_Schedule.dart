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
import 'package:url_launcher/url_launcher.dart';

int addSlotStatus = 200;
int updateSlotStatus = 200;

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
  String? startTime;
  String? endTime;

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
  // DateTime today = DateTime.now();
  // final DateTime _firstDay = today.subtract(const Duration(days: 30));

  // void addSlot(List<Schedule> list) {
  //   if (_time.length == 1) {
  //     list.forEach((element) {
  //       String start = DateTimeFormat.formateTime(element.slot!.timeStart);
  //       String end = DateTimeFormat.formateTime(element.slot!.timeEnd);
  //       _time.add("${start} - ${end}");
  //     });
  //   } else {
  //     _time.removeWhere((element) => element != "- Chọn khung giờ -");
  //     list.forEach((element) {
  //       String start = DateTimeFormat.formateTime(element.slot!.timeStart);
  //       String end = DateTimeFormat.formateTime(element.slot!.timeEnd);
  //       _time.add("${start} - ${end}");
  //     });
  //   }
  // }

  @override
  void initState() {
    if (widget.bookingDetail != null) {
      widget.listDetail!.forEach(
        (element) {
          DateTime dateTemp = new DateFormat("yyyy-MM-dd")
              .parse(element.bookingSchedule!.schedule!.slot!.timeStart);
          if (selectedEvents[dateTemp] == null) {
            selectedEvents[dateTemp] = [element];
          } else {
            selectedEvents[dateTemp]!.add(element);
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
              firstDay: DateTime.now().subtract(const Duration(days: 31)),
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
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarFormat: _format,
              daysOfWeekVisible: true,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
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
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  formatButtonShowsNext: true),
            ),
            ..._getEvents(_selectedDay).map((BookingDetail bookingDetail) {
              String start = DateTimeFormat.formateTime(
                  bookingDetail.bookingSchedule!.schedule!.slot!.timeStart);
              String end = DateTimeFormat.formateTime(
                  bookingDetail.bookingSchedule!.schedule!.slot!.timeEnd);
              Color color;
              bool visible = true;
              print(bookingDetail.bookingSchedule!.subProfile!.subName);
              print(widget.bookingDetail!.bookingSchedule!.subProfile!.subName);
              if (widget.bookingDetail!.bookingSchedule!.signUpUser!
                          .firstName ==
                      bookingDetail.bookingSchedule!.signUpUser!.firstName &&
                  widget.bookingDetail!.bookingSchedule!.subProfile!.subName ==
                      bookingDetail.bookingSchedule!.subProfile!.subName) {
                color = const Color.fromARGB(255, 46, 161, 226);
                //  color = Colors.blue ;
              } else {
                visible = false;
                color = Colors.green;
              }
              String weekDay =
                  "Thứ ${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(bookingDetail.bookingSchedule!.schedule!.slot!.timeStart).weekday + 1}";
              if (weekDay == "Thứ 8") {
                weekDay = "Chủ Nhật";
              }
              String day = DateTimeFormat.formatDate(
                  bookingDetail.bookingSchedule!.schedule!.slot!.timeStart);
              return SessionScheduleMenu(
                visible: visible,
                color: color,
                name:
                    "Người được trị liệu: ${bookingDetail.bookingSchedule!.subProfile!.subName}",
                time: "Khung giờ: ${start}-${end}",
                day: "$weekDay ngày $day",
                icon:
                    "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fbooking.png?alt=media&token=aa78656d-2651-42a4-810e-07c273cdfe5a",
                buttonPress: () {
                  String datefmt =
                      DateFormat("yyyy-MM-dd").format(_selectedDay);
                  DateTime dateCreate =
                      new DateFormat("yyyy-MM-dd").parse(datefmt);
                  setState(() {
                    _timeStart.text = start;
                    _timeEnd.text = end;
                    startTime = "${datefmt}T${start}:00";
                    endTime = "${datefmt}T${end}:00";
                    startCompare = "$datefmt $start";
                    endCompare = "$datefmt $end";
                  });

                  showDialog(
                      context: context,
                      builder: (context) =>
                          StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: const Text("Cập nhật lịch"),
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
                                      DateTime start =
                                          DateTime.parse(startCompare!);
                                      DateTime end =
                                          DateTime.parse(endCompare!);
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

                                        //update slot
                                        Slot slot = Slot(
                                          slotID: bookingDetail.bookingSchedule!
                                              .schedule!.slotID,
                                          timeStart: startTime!,
                                          timeEnd: endTime!,
                                          available: true,
                                        );
                                        dynamic result = await CallAPI()
                                            .updateSlot(
                                                slot,
                                                sharedPhysiotherapist!
                                                    .physiotherapistID);
                                        //check update slot thành công hay không
                                        if (updateSlotStatus == 400) {
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
                                          if (slot != null) {
                                            //update event của lịch hiện tại
                                            selectedEvents[dateCreate]!
                                                .forEach((element) {
                                              if (element == bookingDetail) {
                                                element
                                                    .bookingSchedule!
                                                    .schedule!
                                                    .slot!
                                                    .timeStart = startTime!;
                                                element
                                                    .bookingSchedule!
                                                    .schedule!
                                                    .slot!
                                                    .timeEnd = endTime!;
                                              }
                                            });
                                          }
                                          Navigator.pop(context);
                                        }
                                      }

                                      _timeStart.clear();
                                      _timeEnd.clear();
                                    },
                                    child: const Text("Cập nhật")),
                              ],
                            );
                          }));
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
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
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
                            print(
                                "Giá tiền: ${widget.bookingDetail!.bookingSchedule!.schedule!.typeOfSlot!.price}");
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
                                  .GetTypeOfSlotByTypeName('Trị liệu dài hạn');
                              //add slot
                              Slot slot = Slot(
                                timeStart: startTime!,
                                timeEnd: endTime!,
                                slotName:
                                    "Trị Liệu dài hạn cho ${widget.bookingDetail!.bookingSchedule!.subProfile!.subName}",
                                available: true,
                              );
                              dynamic result = await CallAPI()
                                  .AddLongTermSlotByPhysioID(slot,
                                      sharedPhysiotherapist!.physiotherapistID);
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
                                    description: "Slot Trị liệu dài hạn ",
                                    physioBookingStatus: true);
                                Schedule addSchedule =
                                    await CallAPI().AddSchedule(schedule);
                                print("ScheduleID: ${addSchedule.scheduleID}");
                                //check add schedule
                                if (addSchedule != null) {
                                  //add booking schedule
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
                                              DateFormat(
                                                      "yyyy-MM-dd")
                                                  .format(DateTime.now()),
                                          timeBooking:
                                              DateFormat("yyyy-MM-ddTHH:mm:ss")
                                                  .format(DateTime.now()));

                                  BookingSchedule? bookingScheduleAdd =
                                      await CallAPI()
                                          .addBookingSchedule(bookingSchedule);
                                  //add booking detail
                                  print(
                                      "ID: ${bookingScheduleAdd!.bookingScheduleID!}");

                                  BookingSchedule getBookingSchedule =
                                      await CallAPI().getBookingScheduleByID(
                                          bookingScheduleAdd
                                              .bookingScheduleID!);

                                  BookingDetail bookingDetail = BookingDetail(
                                    bookingScheduleID:
                                        bookingScheduleAdd.bookingScheduleID!,
                                    shorttermStatus: 0,
                                    longtermStatus: 1,
                                    // imageUrl: "Dài hạn",
                                    paymentMoney: widget
                                        .bookingDetail!
                                        .bookingSchedule!
                                        .schedule!
                                        .typeOfSlot!
                                        .price,
                                  );

                                  BookingDetail bookingDetailAdd =
                                      await CallAPI()
                                          .addBookingDetail(bookingDetail);

                                  //check add booking detail
                                  if (bookingDetailAdd != null) {
                                    //get booking detail vừa mới add
                                    BookingDetail bookingDetailGet =
                                        await CallAPI().getBookingDetailByID(
                                            bookingDetailAdd.bookingDetailID!);
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
                                Navigator.pop(context);
                              }
                            }

                            _timeStart.clear();
                            _timeEnd.clear();
                          },
                          child: const Text("Tạo")),
                    ],
                  );
                });
              });
          setState(() {});
          return;
        },
      ),
    );
  }

  Widget Time(String? date) {
    return Column(
      children: [
        visibleCheckAfter == true
            ? const Text('Thời gian bắt đầu phải trước thời gian kết thúc')
            : Container(),
        visibleAdd == true
            ? Column(
                children: [
                  Text('Khung thời gian đăng ký đã có slot rồi'),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listSlotDup?.length,
                      itemBuilder: (context, index) {
                        String start = DateTimeFormat.formateTime(
                            listSlotDup![index].timeStart);
                        String end = DateTimeFormat.formateTime(
                            listSlotDup![index].timeEnd);

                        return Text('Khung giờ : $start-$end');
                      })
                ],
              )
            : Container(),
        TextFormField(
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
                  startTime = '${date}T$text:00';
                  _timeStart.text = text;
                });
              }
            }),
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
                endTime = '${date}T$text:00';
                _timeEnd.text = text;
              });
            }
          },
        ),
      ],
    );
  }
}
