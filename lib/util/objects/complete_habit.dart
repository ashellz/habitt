import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

Widget completeHabitDialog(int index) {
  bool amountCheck = false;

  if (habitBox.getAt(index)!.amount > 1) amountCheck = true;

  int theAmountValue = habitBox.getAt(index)!.amountCompleted;
  int theDurationValue = habitBox.getAt(index)!.durationCompleted;

  return StatefulBuilder(
    builder: (BuildContext context, StateSetter mystate) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        side: BorderSide(color: theLightGreen, width: 3.0),
      ),
      backgroundColor: Colors.black,
      content: SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NumberPicker(
                  textStyle: const TextStyle(color: Colors.white),
                  selectedTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 24),
                  axis: Axis.horizontal,
                  itemWidth: MediaQuery.of(context).size.width / 6,
                  minValue: 0,
                  maxValue: amountCheck
                      ? habitBox.getAt(index)!.amount - 1
                      : habitBox.getAt(index)!.duration - 1,
                  value: amountCheck ? theAmountValue : theDurationValue,
                  onChanged: (value) {
                    mystate(() {
                      if (amountCheck) {
                        theAmountValue = value;
                      } else {
                        theDurationValue = value;
                      }
                    });
                  }),
              Text(
                  "${amountCheck ? habitBox.getAt(index)!.amountName : "minutes"}")
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    fixedSize: const WidgetStatePropertyAll(
                      Size(110, 50),
                    ),
                    backgroundColor: WidgetStatePropertyAll(theLightGreen)),
                onPressed: () {
                  context.read<HabitProvider>().completeHabitProvider(index);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Done",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )),
            OutlinedButton(
                style: ButtonStyle(
                    fixedSize: const WidgetStatePropertyAll(
                      Size(110, 50),
                    ),
                    side: WidgetStatePropertyAll(BorderSide(
                      color: theLightGreen,
                      width: 3.0,
                    )),
                    backgroundColor:
                        const WidgetStatePropertyAll(Colors.black)),
                onPressed: () {
                  mystate(() {
                    if (amountCheck) {
                      applyAmountCompleted(index, theAmountValue);
                    } else {
                      applyDurationCompleted(index, theDurationValue);
                    }
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  "Enter",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )),
          ],
        )
      ],
    ),
  );
}

applyDurationCompleted(index, theDurationValue) {
  habitBox.putAt(
      index,
      HabitData(
          name: habitBox.getAt(index)!.name,
          completed: habitBox.getAt(index)!.completed,
          icon: habitBox.getAt(index)!.icon,
          category: habitBox.getAt(index)!.category,
          streak: habitBox.getAt(index)!.streak,
          amount: habitBox.getAt(index)!.amount,
          amountName: habitBox.getAt(index)!.amountName,
          amountCompleted: habitBox.getAt(index)!.amountCompleted,
          duration: habitBox.getAt(index)!.duration,
          durationCompleted: theDurationValue,
          skipped: habitBox.getAt(index)!.skipped));
}

applyAmountCompleted(index, theAmountValue) {
  habitBox.putAt(
      index,
      HabitData(
          name: habitBox.getAt(index)!.name,
          completed: habitBox.getAt(index)!.completed,
          icon: habitBox.getAt(index)!.icon,
          category: habitBox.getAt(index)!.category,
          streak: habitBox.getAt(index)!.streak,
          amount: habitBox.getAt(index)!.amount,
          amountName: habitBox.getAt(index)!.amountName,
          amountCompleted: theAmountValue,
          duration: habitBox.getAt(index)!.duration,
          durationCompleted: habitBox.getAt(index)!.durationCompleted,
          skipped: habitBox.getAt(index)!.skipped));
}
