import 'package:flutter/material.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../common_widget/menu_listview.dart';

class SessionRegisterPage extends StatefulWidget {
  const SessionRegisterPage({Key? key}) : super(key: key);

  @override
  State<SessionRegisterPage> createState() => _SessionRegisterPageState();
}

class _SessionRegisterPageState extends State<SessionRegisterPage> {
  final TextEditingController _timeStart = TextEditingController();
  final TextEditingController _timeEnd = TextEditingController();

  late Map<DateTime, List<BookingDetail>> selectedEvents;

  CalendarFormat _format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime today = DateTime.now();
  // final DateTime _firstDay = today.subtract(const Duration(days: 30));

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  @override
  void dispose() {
    _timeStart.dispose();
    _timeEnd.dispose();
    super.dispose();
  }

  List<BookingDetail> _getEvents(DateTime date) {
    return selectedEvents[date] ?? [];
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
              focusedDay: _focusedDay,
              firstDay: DateTime.now(),
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
                .map((BookingDetail e) => SessionScheduleMenu(
                      name: "Người điều trị: ABC",
                      time: "Khung giờ: ABC",
                      icon:
                          "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fbooking.png?alt=media&token=aa78656d-2651-42a4-810e-07c273cdfe5a",
                      buttonPress: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Tạo lịch"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Time(),
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
                    )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Tạo lịch dài hạn"),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          Time(),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Hủy'),
                        child: const Text("Hủy"),
                      ),
                      TextButton(
                          onPressed: () {
                            if (_timeStart.text.isEmpty &&
                                _timeEnd.text.isEmpty) {
                              return;
                            } else {
                              if (selectedEvents[_selectedDay] != null) {
                                selectedEvents[_selectedDay]!
                                    .add(BookingDetail(bookingScheduleID: ""));
                              } else {
                                selectedEvents[_selectedDay] = [
                                  BookingDetail(bookingScheduleID: "")
                                ];
                              }
                            }
                            Navigator.pop(context);
                            _timeStart.clear();
                            _timeEnd.clear();
                            setState(() {});
                            return;
                          },
                          child: const Text("Tạo")),
                    ],
                  ));
        },
      ),
    );
  }

  Widget Time() {
    return Column(
      children: [
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
                _timeEnd.text = text;
              });
            }
          },
        )
      ],
    );
  }
}
