import "package:flutter/material.dart";
import "package:habit_tracker/util/colors.dart";
import "package:table_calendar/table_calendar.dart";

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime today = DateTime.now();

  void onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text("Calendar",
                style: TextStyle(
                    fontSize: 42,
                    color: theLightColor,
                    fontWeight: FontWeight.bold)),
          ),
          TableCalendar(
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: theOtherColor,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              todayDecoration: BoxDecoration(
                color: theColor,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              outsideDaysVisible: false,
              weekendTextStyle: const TextStyle(color: Colors.white),
              weekendDecoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white, width: 1),
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              defaultDecoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white, width: 1),
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(
                    color: theLightColor, fontWeight: FontWeight.bold),
                weekdayStyle: TextStyle(
                    color: theLightColor, fontWeight: FontWeight.bold)),
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: today,
            selectedDayPredicate: (day) => isSameDay(day, today),
            onDaySelected: onDaySelected,
          ),
        ],
      ),
    );
  }
}
