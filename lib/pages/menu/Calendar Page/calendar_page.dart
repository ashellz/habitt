import "package:flutter/material.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:habitt/pages/menu/Calendar%20Page/widgets/additional_historical_tasks.dart";
import "package:habitt/pages/menu/Calendar%20Page/widgets/calendar_day.dart";
import "package:habitt/pages/menu/Calendar%20Page/widgets/other_categories.dart";
import "package:habitt/pages/shared%20widgets/expandable_app_bar.dart";
import "package:habitt/services/ad_mob_service.dart";
import "package:habitt/services/provider/color_provider.dart";
import "package:habitt/services/provider/habit_provider.dart";
import "package:habitt/services/provider/historical_habit_provider.dart";
import "package:habitt/util/colors.dart";
import "package:habitt/util/functions/showCustomDialog.dart";
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
      backgroundColor: context.watch<ColorProvider>().blackColor,
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
                      color: AppColors.theDarkGrey,
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
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: false,
                      weekendTextStyle: TextStyle(color: Colors.white),
                      selectedDecoration: BoxDecoration(
                        color: AppColors.theOtherColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    daysOfWeekStyle: const DaysOfWeekStyle(
                        weekendStyle: TextStyle(
                            color: AppColors.theLightColor,
                            fontWeight: FontWeight.bold),
                        weekdayStyle: TextStyle(
                            color: AppColors.theLightColor,
                            fontWeight: FontWeight.bold)),
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
                const SizedBox(height: 20),
                if (context.watch<HabitProvider>().dayHasHabits)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 60.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showCustomDialog(
                            context,
                            "Import current habits",
                            const Text(
                                "This will erase previous data on this day. Are you sure?"),
                            () => context
                                .read<HistoricalHabitProvider>()
                                .importCurrentHabits(today),
                            "Yes",
                            "No");
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
