import 'package:flutter/material.dart';
import 'package:heh_application/models/slot.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/util/date_time_format.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../common_widget/menu_listview.dart';

class SessionRegisterPage extends StatefulWidget {
  const SessionRegisterPage({Key? key}) : super(key: key);

  @override
  State<SessionRegisterPage> createState() => _SessionRegisterPageState();
}

class _SessionRegisterPageState extends State<SessionRegisterPage> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _timeStart = TextEditingController();
  final TextEditingController _timeEnd = TextEditingController();

  DateTime datetime = DateTime(5, 30);
  // final hours = datetime.hour.toString().padLeft(2, '0');
  // final minutes = datetime.minute.toString().padLeft(2, '0');

  CalendarFormat _format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  String? dateSearch;
  final List<String> _time = [
    "- Chọn khung giờ -",
  ];
  String? selectedTime = "- Chọn khung giờ -";

  // final events = LinkedHashMap(
  //   equals: isSameDay,
  //   // hashCode: getHashCode,
  // );

  // List<Event> _getEventsForDay(DateTime day) {
  //   return events[day] ?? [];
  // }

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
              firstDay: DateTime(1960),
              lastDay: DateTime(2099),
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  if (day.weekday == DateTime.sunday) {
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
            SessionScheduleMenu(
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
                              onPressed: () => Navigator.pop(context, 'Hủy'),
                              child: const Text("Hủy"),
                            ),
                            TextButton(
                                onPressed: () {}, child: const Text("Tạo")),
                          ],
                        ));
              },
            )
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
                      TextButton(onPressed: () {}, child: const Text("Tạo")),
                    ],
                  ));
        },
      ),
    );
  }

  Widget Time() {
    return Column(
      children: [
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
                _timeStart.text = text;
              });
            }
          },
        ),
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
