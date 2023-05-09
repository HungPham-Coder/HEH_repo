import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../common_widget/menu_listview.dart';

class SessionRegisterPage extends StatefulWidget {
  const SessionRegisterPage({Key? key}) : super(key: key);

  @override
  State<SessionRegisterPage> createState() => _SessionRegisterPageState();
}

class _SessionRegisterPageState extends State<SessionRegisterPage> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
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
          "Tính năng",
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
            SessionMenu(
              type: "ABC",
              name: "ABC",
              time: "ABC",
              icon:
                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fbooking.png?alt=media&token=aa78656d-2651-42a4-810e-07c273cdfe5a",
              buttonPress: () {},
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: Text("Tạo lịch"),
                    actions: [],
                  ));
        },
      ),
    );
  }
}
