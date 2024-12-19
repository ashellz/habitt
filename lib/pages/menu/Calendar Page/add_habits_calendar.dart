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
    context.read<HabitProvider>().resetSomethingEdited();

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
              historicalBox.getAt(i)!.addedHabits;
        });

        print("added habits:");
        for (var habit in historicalBox.getAt(i)!.addedHabits) {
          print(habit.name);
        }

        print("all habits:");
        for (int i = 0; i < historicalBox.getAt(i)!.data.length; i++) {
          print(historicalBox.getAt(i)!.data[i].name);
        }

        historicalHabits = historicalBox
            .getAt(i)!
            .data
            .where((habit) => !historicalBox
                .getAt(i)!
                .addedHabits
                .any((h) => h.id == habit.id))
            .toList();

        print("historical  habits:");
        for (var historicalHabit in historicalHabits) {
          print(historicalHabit.name);
        }
        break;
      }
    }

    List<HistoricalHabitData> otherHabits = [];

    for (var otherHabit in habitBox.values) {
      if (!historicalHabits.any((h) => h.id == otherHabit.id)) {
        for (var habit in historicalBox.getAt(boxIndex)!.addedHabits) {
          if (habit.id != otherHabit.id) {
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

            if (!otherHabits.contains(convertedOtherHabit)) {
              otherHabits.add(convertedOtherHabit);
            }
          }
        }
      }
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
                      Habit(habit: habit, historicalHabits: historicalHabits),
                    for (var habit
                        in Provider.of<DataProvider>(context, listen: false)
                            .addHabitsList)
                      Habit(habit: habit, historicalHabits: historicalHabits),
                    for (var habit in otherHabits)
                      Habit(habit: habit, historicalHabits: historicalHabits),
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
  });

  // ignore: prefer_typing_uninitialized_variables
  final HistoricalHabitData habit;
  final List<HistoricalHabitData> historicalHabits;

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
                convertIcon(habit.icon),
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
              // Collect IDs to be removed
              List<int> ids = historicalBox
                  .getAt(boxIndex)!
                  .addedHabits
                  .map((habit) => habit.id)
                  .toList();

              print("added habits after click:");
              for (var habit in historicalBox.getAt(boxIndex)!.addedHabits) {
                print(habit.name);
              }

              // Retrieve the entry at boxIndex
              final historicalEntry = historicalBox.getAt(boxIndex);

              // Check if entry exists to avoid null errors
              if (historicalEntry != null) {
                // Create new lists for updated data and added habits
                final updatedData =
                    List<HistoricalHabitData>.from(historicalEntry.data);
                final updatedAddedHabits =
                    List<HistoricalHabitData>.from(historicalEntry.addedHabits);

                // Remove habits from data based on IDs
                updatedData.removeWhere((habit) => ids.contains(habit.id));

                // Clear and update addedHabits
                updatedAddedHabits.clear();
                for (var toBeAddedHabit
                    in Provider.of<DataProvider>(context, listen: false)
                        .addHabitsList) {
                  updatedAddedHabits.add(toBeAddedHabit);
                  updatedData.add(toBeAddedHabit);
                }

                // Create a new HistoricalHabit object with updated values
                final updatedEntry = HistoricalHabit(
                  date: historicalEntry.date,
                  data: updatedData,
                  addedHabits: updatedAddedHabits,
                );

                // Save the updated entry back to the box
                historicalBox.putAt(boxIndex, updatedEntry);

                // Debugging: Print the updated data
                print("Updated Habits:");
                for (var habit in updatedEntry.data) {
                  print(habit.name);
                }
              } else {
                print("Historical entry at index $boxIndex is null.");
              }

              // Navigate back
              Navigator.pop(context);
            }),
      ),
    );
  }
}
