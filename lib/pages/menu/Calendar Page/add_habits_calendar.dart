import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/pages/home/functions/getIcon.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/shared%20widgets/expandable_app_bar.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:provider/provider.dart';

class AddHabitsCalendar extends StatelessWidget {
  const AddHabitsCalendar({
    super.key,
    required this.selectedDay,
  });

  final DateTime selectedDay;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().resetSomethingEdited();
    });

    List<HistoricalHabitData> historicalHabits = [];
    int boxIndex = 0;

    for (int i = 0; i < historicalBox.length; i++) {
      List<int> habitDate = [
        historicalBox.getAt(i)!.date.year,
        historicalBox.getAt(i)!.date.month,
        historicalBox.getAt(i)!.date.day
      ];
      if (const ListEquality().equals(
          habitDate, [selectedDay.year, selectedDay.month, selectedDay.day])) {
        boxIndex = i;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<DataProvider>(context, listen: false).addHabitsList =
              List.from(historicalBox.getAt(i)!.addedHabits);
        });

        historicalHabits = historicalBox
            .getAt(i)!
            .data
            .where((habit) => !historicalBox
                .getAt(i)!
                .addedHabits
                .any((h) => h.id == habit.id))
            .toList();

        break;
      }
    }

    List<HistoricalHabitData> otherHabits = [];

    for (var otherHabit in habitBox.values) {
      if (!historicalHabits.any((h) => h.id == otherHabit.id)) {
        HistoricalHabitData convertedOtherHabit = HistoricalHabitData(
          id: otherHabit.id,
          name: otherHabit.name,
          category: otherHabit.category,
          amount: otherHabit.amount,
          icon: otherHabit.icon,
          completed: otherHabit.completed,
          amountCompleted: otherHabit.amountCompleted,
          amountName: otherHabit.amountName,
          duration: otherHabit.duration,
          durationCompleted: otherHabit.durationCompleted,
          skipped: otherHabit.skipped,
          task: otherHabit.task,
          type: otherHabit.type,
          weekValue: otherHabit.weekValue,
          monthValue: otherHabit.monthValue,
          customValue: otherHabit.customValue,
          selectedDaysAWeek: otherHabit.selectedDaysAWeek,
          selectedDaysAMonth: otherHabit.selectedDaysAMonth,
        );
        if (historicalBox.getAt(boxIndex)!.addedHabits.isEmpty) {
          if (!otherHabits.contains(convertedOtherHabit)) {
            otherHabits.add(convertedOtherHabit);
          }
        } else {
          for (var habit in historicalBox.getAt(boxIndex)!.addedHabits) {
            if (habit.id != otherHabit.id) {
              if (!otherHabits.contains(convertedOtherHabit)) {
                otherHabits.add(convertedOtherHabit);
              }
            }
          }
        }
      }
    }

    for (var addedHabit in historicalBox.getAt(boxIndex)!.addedHabits) {
      print("added habit: ${addedHabit.name} id: ${addedHabit.id}");
    }

    return Scaffold(
        backgroundColor: context.watch<ColorProvider>().blackColor,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
              ExpandableAppBar(
                  actionsWidget: Container(),
                  title: AppLocale.addHabits.getString(context)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(children: [
                    for (var habit in historicalHabits)
                      Habit(
                          habit: habit,
                          historicalHabits: historicalHabits,
                          boxIndex: boxIndex),
                    for (var habit
                        in Provider.of<DataProvider>(context, listen: false)
                            .addHabitsList)
                      Habit(
                          habit: habit,
                          historicalHabits: historicalHabits,
                          boxIndex: boxIndex),
                    for (var habit in otherHabits)
                      Habit(
                          habit: habit,
                          historicalHabits: historicalHabits,
                          boxIndex: boxIndex),
                    const SizedBox(height: 50)
                  ]),
                ),
              ),
            ]),
            SaveButton(
              boxIndex: boxIndex,
            )
          ],
        ));
  }
}

class Habit extends StatelessWidget {
  const Habit({
    super.key,
    required this.habit,
    required this.historicalHabits,
    required this.boxIndex,
  });

  // ignore: prefer_typing_uninitialized_variables
  final HistoricalHabitData habit;
  final List<HistoricalHabitData> historicalHabits;
  final int boxIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: context.watch<ColorProvider>().darkGreyColor,
          ),
          child: ListTile(
              leading: Icon(
                getIconFromString(habit.icon),
              ),
              title: Text(
                habit.name,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Checkbox.adaptive(
                  value: historicalHabits.contains(habit)
                      ? true
                      : context
                          .watch<DataProvider>()
                          .addHabitsList
                          .contains(habit),
                  activeColor: historicalHabits.contains(habit)
                      ? const Color.fromARGB(255, 49, 72, 58)
                      : AppColors.theLightColor,
                  onChanged: (value) {
                    context.read<DataProvider>().selectHabit(habit, value);
                    for (var addedHabit
                        in historicalBox.getAt(boxIndex)!.addedHabits) {
                      print(
                          "added habit on click: ${addedHabit.name} id: ${addedHabit.id}");
                    }
                    context.read<HabitProvider>().updateSomethingEdited();
                  })),
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.boxIndex,
  });

  final int boxIndex;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.watch<HabitProvider>().somethingEdited,
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.theLightColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
            ),
            child: Text(AppLocale.saveChanges.getString(context),
                style: const TextStyle(color: Colors.white)),
            onPressed: () {
              var entry = historicalBox.getAt(boxIndex)!;

              List<HistoricalHabitData> addedHabits =
                  List.from(entry.addedHabits);

              List<HistoricalHabitData> data = List.from(entry.data);
              List<HistoricalHabitData> habitsToRemove = [];

              for (var habit in data) {
                for (var addedHabit in addedHabits) {
                  print("added habit: ${addedHabit.name} id: ${addedHabit.id}");

                  if (habit.id == addedHabit.id) {
                    habitsToRemove.add(habit);
                    print(
                        "added habit to be removed: ${habit.name} id: ${habit.id}");
                  }
                }
              }

              for (var habit in habitsToRemove) {
                data.remove(habit);
                print("removed habit ${habit.name}");
              }

              addedHabits = Provider.of<DataProvider>(context, listen: false)
                  .addHabitsList;

              data.addAll(addedHabits);

              historicalBox.putAt(
                  boxIndex,
                  HistoricalHabit(
                      date: entry.date, data: data, addedHabits: addedHabits));

              Navigator.pop(context);
            }),
      ),
    );
  }
}
