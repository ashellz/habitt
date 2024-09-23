import "package:flutter/material.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:habit_tracker/data/historical_habit.dart";
import "package:habit_tracker/pages/habit/Add%20Habit%20Page/expandable_app_bar.dart";
import "package:habit_tracker/pages/home_page.dart";
import "package:habit_tracker/services/ad_mob_service.dart";
import "package:habit_tracker/services/provider/historical_habit_provider.dart";
import "package:habit_tracker/util/colors.dart";
import "package:habit_tracker/util/objects/habit/calendar_habit_tile.dart";
import "package:provider/provider.dart";
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
    context.read<HistoricalHabitProvider>().updateHistoricalHabits(today);
  }

  @override
  void initState() {
    super.initState();
    initInterstitialAd();

    context.read<HistoricalHabitProvider>().updateHistoricalHabits(today);
  }

  InterstitialAd? interstitialAd;
  bool isAdLoaded = false;

  initInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.interstitialAd,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => setState(() {
            interstitialAd = ad;
            isAdLoaded = true;
          }),
          onAdFailedToLoad: (error) => setState(() => interstitialAd = null),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          ExpandableAppBar(actionsWidget: Container(), title: "Calendar"),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(children: [
                Container(
                  decoration: BoxDecoration(
                      color: theDarkGrey,
                      borderRadius: BorderRadius.circular(20)),
                  child: TableCalendar(
                    availableGestures: AvailableGestures.horizontalSwipe,
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, date, events) =>
                          CalendarDay(date: date, selected: true),
                      defaultBuilder: (context, date, events) =>
                          CalendarDay(date: date, selected: false),
                      todayBuilder: (context, day, events) =>
                          CalendarDay(date: day, selected: false),
                    ),
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      weekendTextStyle: const TextStyle(color: Colors.white),
                      selectedDecoration: BoxDecoration(
                        color: theOtherColor,
                        shape: BoxShape.rectangle,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
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
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: today,
                    selectedDayPredicate: (day) => isSameDay(day, today),
                    onDaySelected: onDaySelected,
                  ),
                ),
                const SizedBox(height: 30),
                otherCategoriesList(context, today, isAdLoaded, interstitialAd),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarDay extends StatelessWidget {
  const CalendarDay({super.key, required this.date, required this.selected});

  final DateTime date;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    List todayHabits(selectedDay) {
      List<int> habitsOnDate = [];
      late int habitsCompleted = 0;
      late int habitsTotal = 1;

      List day = [selectedDay.year, selectedDay.month, selectedDay.day];

      for (int i = 0; i < historicalBox.length; i++) {
        List habitDay = [
          historicalBox.getAt(i)!.date.year,
          historicalBox.getAt(i)!.date.month,
          historicalBox.getAt(i)!.date.day
        ];
        if (const ListEquality().equals(habitDay, day)) {
          habitsTotal = historicalBox.getAt(i)!.data.length;

          for (var habit in historicalBox.getAt(i)!.data) {
            if (habit.completed) {
              if (!habit.skipped) {
                habitsCompleted++;
              }
            }
          }

          break;
        }
      }

      habitsOnDate = [habitsCompleted, habitsTotal];

      if (habitsTotal == 0) {
        habitsOnDate = [0, 1];
      }

      return habitsOnDate;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                color: selected ? Colors.grey.shade800 : theDarkGrey,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: RotatedBox(
              quarterTurns: -1,
              child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(
                    begin: 0,
                    end: todayHabits(date)[0] / todayHabits(date)[1],
                  ),
                  builder: (context, value, _) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: value,
                        color: theOtherColor,
                        backgroundColor: Colors.grey.shade900,
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

otherCategoriesList(
    BuildContext context, chosenDay, bool isAdLoaded, interstitialAd) {
  late int habitListLength = 0;
  late List habitsOnDate = [];
  late int boxIndex = 0;
  List<int> todayDate = [chosenDay.year, chosenDay.month, chosenDay.day];
  bool todayExists = false;

  for (int i = 0; i < historicalBox.length; i++) {
    List<int> date = [
      historicalBox.getAt(i)!.date.year,
      historicalBox.getAt(i)!.date.month,
      historicalBox.getAt(i)!.date.day
    ];

    if (const ListEquality().equals(date, todayDate)) {
      todayExists = true;
      boxIndex = i;
      habitListLength = historicalBox.getAt(i)!.data.length;
      habitsOnDate = historicalBox.getAt(i)!.data;
      break;
    }
  }

  void saveTodayHabits() {
    List<HistoricalHabitData> todayHabitsList = [];
    for (int i = 0; i < habitBox.length; i++) {
      var habit = habitBox.getAt(i)!;

      HistoricalHabitData newHistoricalHabit = HistoricalHabitData(
        name: habit.name,
        category: habit.category,
        completed: false,
        icon: habit.icon,
        amount: habit.amount,
        amountCompleted: 0,
        amountName: habit.amountName,
        duration: habit.duration,
        durationCompleted: 0,
        skipped: false,
      );

      todayHabitsList.add(newHistoricalHabit);
    }

    historicalBox.add(HistoricalHabit(date: chosenDay, data: todayHabitsList));
    int index = historicalBox.length - 1;
    boxIndex = index;
    habitListLength = historicalBox.getAt(index)!.data.length;
    habitsOnDate = historicalBox.getAt(index)!.data;
  }

  if (habitListLength == 0 || !todayExists) {
    DateTime dayJoined = metadataBox.get('dayJoined')!;

    if (dayJoined.isBefore(chosenDay)) {
      if (chosenDay.year <= DateTime.now().year) {
        // if the year is equal or less than the current year
        if (chosenDay.year == DateTime.now().year) {
          // if the year is equal to the current year

          if (chosenDay.month <= DateTime.now().month) {
            // if the month is equal or less than the current month in the current year

            if (chosenDay.month < DateTime.now().month) {
              // if the month is less than the current month in the current year
              saveTodayHabits();
            }

            if (chosenDay.month == DateTime.now().month) {
              // if the month is equal to the current month in the current year

              if (chosenDay.day < DateTime.now().day) {
                // if the day is equal or less than the current day in the current month in the current year
                saveTodayHabits();
              }
            }
          }
        }

        if (chosenDay.year < DateTime.now().year) {
          saveTodayHabits();
        }
      }
    }
  }

  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    anyTime(context, habitListLength, habitsOnDate, chosenDay, boxIndex,
        isAdLoaded, interstitialAd),
    morning(context, habitListLength, habitsOnDate, chosenDay, boxIndex,
        isAdLoaded, interstitialAd),
    afternoon(context, habitListLength, habitsOnDate, chosenDay, boxIndex,
        isAdLoaded, interstitialAd),
    evening(context, habitListLength, habitsOnDate, chosenDay, boxIndex,
        isAdLoaded, interstitialAd),
  ]);
}

Widget anyTime(BuildContext context, habitListLength, habitsOnDate, today,
    boxIndex, bool isAdLoaded, InterstitialAd? interstitialAd) {
  if (historicalHasHabits("Any time", habitsOnDate, habitListLength)) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Any time",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0;
            i <
                context
                    .watch<HistoricalHabitProvider>()
                    .historicalHabits
                    .length;
            i++)
          if (context
                  .watch<HistoricalHabitProvider>()
                  .historicalHabits[i]
                  .category ==
              'Any time')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CalendarHabitTile(
                index: i,
                habits: habitsOnDate,
                time: today,
                boxIndex: boxIndex,
                isAdLoaded: isAdLoaded,
                interstitialAd: interstitialAd,
              ),
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

Widget morning(BuildContext context, habitListLength, habitsOnDate, today,
    boxIndex, bool isAdLoaded, InterstitialAd? interstitialAd) {
  if (historicalHasHabits("Morning", habitsOnDate, habitListLength)) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Morning",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0;
            i <
                context
                    .watch<HistoricalHabitProvider>()
                    .historicalHabits
                    .length;
            i++)
          if (context
                  .watch<HistoricalHabitProvider>()
                  .historicalHabits[i]
                  .category ==
              'Morning')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CalendarHabitTile(
                index: i,
                habits: habitsOnDate,
                time: today,
                boxIndex: boxIndex,
                isAdLoaded: isAdLoaded,
                interstitialAd: interstitialAd,
              ),
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

Widget afternoon(BuildContext context, habitListLength, habitsOnDate, today,
    boxIndex, bool isAdLoaded, InterstitialAd? interstitialAd) {
  if (historicalHasHabits("Afternoon", habitsOnDate, habitListLength)) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Afternoon",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0;
            i <
                context
                    .watch<HistoricalHabitProvider>()
                    .historicalHabits
                    .length;
            i++)
          if (context
                  .watch<HistoricalHabitProvider>()
                  .historicalHabits[i]
                  .category ==
              'Afternoon')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CalendarHabitTile(
                index: i,
                habits: habitsOnDate,
                time: today,
                boxIndex: boxIndex,
                isAdLoaded: isAdLoaded,
                interstitialAd: interstitialAd,
              ),
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

Widget evening(BuildContext context, habitListLength, habitsOnDate, today,
    boxIndex, bool isAdLoaded, InterstitialAd? interstitialAd) {
  if (historicalHasHabits("Evening", habitsOnDate, habitListLength)) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Evening",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        for (int i = 0;
            i <
                context
                    .watch<HistoricalHabitProvider>()
                    .historicalHabits
                    .length;
            i++)
          if (context
                  .watch<HistoricalHabitProvider>()
                  .historicalHabits[i]
                  .category ==
              'Evening')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CalendarHabitTile(
                index: i,
                habits: habitsOnDate,
                time: today,
                boxIndex: boxIndex,
                isAdLoaded: isAdLoaded,
                interstitialAd: interstitialAd,
              ),
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
