import 'package:flutter/material.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:provider/provider.dart';

class AllHabitsProvider extends ChangeNotifier {
  List<String> allHabitCategoriesList = [];
  String allHabitsTagSelected = "Categories";
  List<double> habitBoxSizes = [];
  List<double> tagsSizes = [];
  double taskSize = 0;

  void initAllHabitsPage(BuildContext context) {
    context.read<DataProvider>().updateAllHabits();

    List habits =
        Provider.of<DataProvider>(context, listen: false).allHabitsList;
    List tagsList = Provider.of<DataProvider>(context, listen: false).tagsList;

    allHabitCategoriesList.clear();
    habitBoxSizes = [0, 0, 0, 0];
    tagsSizes = [];

    for (int i = 0; i < habits.length; i++) {
      if (!habits[i].task) {
        if (!allHabitCategoriesList.contains("Categories")) {
          allHabitCategoriesList.add("Categories");
        }

        if (habits[i].category == "Any time") {
          habitBoxSizes[0] += 65.5;
        } else if (habits[i].category == "Morning") {
          habitBoxSizes[1] += 65.5;
        } else if (habits[i].category == "Afternoon") {
          habitBoxSizes[2] += 65.5;
        } else if (habits[i].category == "Evening") {
          habitBoxSizes[3] += 65.5;
        }
      } else if (habits[i].task) {
        if (!allHabitCategoriesList.contains("Tasks")) {
          allHabitCategoriesList.add("Tasks");
        }
        taskSize += 65.5;
      }
    }

    for (int i = 0; i < tagsList.length; i++) {
      if (tagsList[i] != "No tag") {
        tagsSizes.add(0);
        for (int j = 0; j < habits.length; j++) {
          if (habits[j].tag == tagsList[i] && !habits[j].task) {
            if (!allHabitCategoriesList.contains("Tags")) {
              allHabitCategoriesList.add("Tags");
            }
            tagsSizes[i] += 65.5;
          }
        }
      } else {
        tagsSizes.add(0);
      }
    }
  }

  void updateAllHabitCategoriesList(List<String> categories) {
    allHabitCategoriesList = categories;
    notifyListeners();
  }

  void setAllHabitsTagSelected(String value) {
    allHabitsTagSelected = value;
    notifyListeners();
  }
}
