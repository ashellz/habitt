import 'package:flutter/material.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/habit/edit_habit_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/util/functions/habit/checkCategory.dart';

late String category;

Future<void> deleteHabit(int index, context, editcontroller) async {
  category = checkCategory(habitBox.getAt(index)!.category.toString());
  int categoryHabits = 0;

  for (int i = 0; i < habitBox.length; i++) {
    if (habitBox.getAt(i)?.category == category) {
      categoryHabits += 1;
    }
  }
  if (categoryHabits == 1) {
    if (category == "Morning") {
      morningHasHabits = false;
      morningVisible = false;
    } else if (category == "Afternoon") {
      afternoonHasHabits = false;
      afternoonVisible = false;
    } else if (category == "Evening") {
      eveningHasHabits = false;
      eveningVisible = false;
    } else if (category == "Any time") {
      anytimeHasHabits = false;
      anyTimeVisible = false;
    }
  }

  habitBox.deleteAt(index);

  deleted = true;
  editcontroller.text = "";
  await Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const NewHomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
    (route) => false,
  );

  habitGoalEdit = 0;
  updated = false;
  dropDownChanged = false;
  editcontroller.clear();
  changed = false;
  updatedIcon = startIcon;
}
