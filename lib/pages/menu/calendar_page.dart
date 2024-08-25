import "package:flutter/material.dart";
import "package:habit_tracker/pages/new_home_page.dart";
import "package:habit_tracker/util/colors.dart";
import "package:habit_tracker/util/objects/habit/calendar_habit_tile.dart";
import "package:table_calendar/table_calendar.dart";
import 'package:collection/collection.dart';

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
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                color: theDarkGrey, borderRadius: BorderRadius.circular(20)),
            child: TableCalendar(
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
          ),
          const SizedBox(height: 30),
          otherCategoriesList(today),
        ],
      ),
    );
  }
}

otherCategoriesList(today) {
  late int habitListLength = 0;
  late List habitsOnDate = [];
  late int boxIndex;
  List<int> todayDate = [today.year, today.month, today.day];

  for (int i = 0; i < historicalBox.length; i++) {
    List<int> date = [
      historicalBox.getAt(i)!.date.year,
      historicalBox.getAt(i)!.date.month,
      historicalBox.getAt(i)!.date.day
    ];

    if (const ListEquality().equals(date, todayDate)) {
      boxIndex = i;
      habitListLength = historicalBox.getAt(i)!.data.length;
      habitsOnDate = historicalBox.getAt(i)!.data;
      break;
    }
  }

  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    anyTime(habitListLength, habitsOnDate, today, boxIndex),
    morning(habitListLength, habitsOnDate, today, boxIndex),
    afternoon(habitListLength, habitsOnDate, today, boxIndex),
    evening(habitListLength, habitsOnDate, today, boxIndex),
  ]);
}

Widget anyTime(habitListLength, habitsOnDate, today, boxIndex) {
  if (historicalHasHabits("Any time", habitsOnDate, habitListLength)) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Any time",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitListLength; i++)
          if (habitsOnDate[i].category == 'Any time')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CalendarHabitTile(
                  index: i,
                  habits: habitsOnDate,
                  time: today,
                  boxIndex: boxIndex),
            ),
        const SizedBox(height: 20),
      ],
    );
  }
  if (boolBox.get("displayEmptyCategories")!) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Any time",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("No habits in this category",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 20),
        ]);
  }

  return const SizedBox(height: 0);
}

Widget morning(habitListLength, habitsOnDate, today, boxIndex) {
  if (historicalHasHabits("Morning", habitsOnDate, habitListLength)) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Morning",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitListLength; i++)
          if (habitsOnDate[i].category == 'Morning')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CalendarHabitTile(
                  index: i,
                  habits: habitsOnDate,
                  time: today,
                  boxIndex: boxIndex),
            ),
        const SizedBox(height: 20),
      ],
    );
  }

  if (boolBox.get("displayEmptyCategories")!) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Morning",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("No habits in this category",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 20),
        ]);
  }

  return const SizedBox(height: 0);
}

Widget afternoon(habitListLength, habitsOnDate, today, boxIndex) {
  if (historicalHasHabits("Afternoon", habitsOnDate, habitListLength)) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Afternoon",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitListLength; i++)
          if (habitsOnDate[i].category == 'Afternoon')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CalendarHabitTile(
                  index: i,
                  habits: habitsOnDate,
                  time: today,
                  boxIndex: boxIndex),
            ),
        const SizedBox(height: 20),
      ],
    );
  }

  if (boolBox.get("displayEmptyCategories")!) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Afternoon",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("No habits in this category",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 20),
        ]);
  }

  return const SizedBox(height: 0);
}

Widget evening(habitListLength, habitsOnDate, today, boxIndex) {
  if (historicalHasHabits("Evening", habitsOnDate, habitListLength)) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Evening",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0; i < habitListLength; i++)
          if (habitsOnDate[i].category == 'Evening')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CalendarHabitTile(
                  index: i,
                  habits: habitsOnDate,
                  time: today,
                  boxIndex: boxIndex),
            ),
        const SizedBox(height: 20),
      ],
    );
  }

  if (boolBox.get("displayEmptyCategories")!) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Evening",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("No habits in this category",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 20),
        ]);
  }

  return const SizedBox(height: 0);
}

bool historicalHasHabits(category, habitsOnDate, habitListLength) {
  for (int i = 0; i < habitListLength; i++) {
    if (habitsOnDate[i].category == category) {
      return true;
    }
  }
  return false;
}
