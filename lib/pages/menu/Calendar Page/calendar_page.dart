import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";

import "package:habitt/pages/menu/Calendar%20Page/widgets/additional_historical_tasks.dart";
import "package:habitt/pages/menu/Calendar%20Page/widgets/calendar_day.dart";
import "package:habitt/pages/menu/Calendar%20Page/widgets/other_categories.dart";
import "package:habitt/pages/shared%20widgets/expandable_app_bar.dart";
import "package:habitt/services/ad_mob_service.dart";
import "package:habitt/services/provider/historical_habit_provider.dart";
import "package:habitt/util/colors.dart";

import "package:provider/provider.dart";

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

    context.read<HistoricalHabitProvider>().updateHistoricalHabits(today);
  }

  @override
  void initState() {
    super.initState();
    initInterstitialAd();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoricalHabitProvider>().updateHistoricalHabits(today);
    });
  }

  InterstitialAd? interstitialAd;
  bool isAdLoaded = false;

  initInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => setState(() {
                  interstitialAd = ad;
                  isAdLoaded = true;
                }),
            onAdFailedToLoad: (error) {
              interstitialAd = null;
              isAdLoaded = false;
              initInterstitialAd();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theBlackColor,
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
                AdditionalHistoricalTasks(
                  isAdLoaded: isAdLoaded,
                  interstitialAd: interstitialAd,
                  today: today,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0, top: 20),
                  child: GestureDetector(
                    onTap: () {
                      showResetDialog(context);
                    },
                    child: const Text(
                      "Import current habits",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

void showResetDialog(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("Import current habits"),
              content: const Text(
                  "This will erase previous data on this day. Are you sure?"),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Yes"),
                  onPressed: () {
                    // context.read<HistoricalHabitProvider>().resetDayProgress();
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("No"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ));
  } else {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("Import current habits"),
              content: const Text(
                  "This will erase previous data on this day. Are you sure?"),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Yes"),
                  onPressed: () {
                    // context.read<HistoricalHabitProvider>().resetDayProgress();
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("No"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ));
  }
}
