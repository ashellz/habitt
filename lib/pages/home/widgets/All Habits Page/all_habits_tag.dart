import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/services/provider/allhabits_provider.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:provider/provider.dart';

Widget allHabitsTag(BuildContext context, pageController,
    List<String> allHabitsCategoriesList) {
  String allHabitsTagSelected =
      context.watch<AllHabitsProvider>().allHabitsTagSelected;

  return ListView(
    scrollDirection: Axis.horizontal,
    physics: const PageScrollPhysics(),
    children: <Widget>[
      for (final category in allHabitsCategoriesList)
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () => setState(() {
                      pageController.animateToPage(
                        allHabitsCategoriesList.indexOf(category),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }),
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: allHabitsTagSelected == category
                          ? AppColors.theOtherColor
                          : context.watch<ColorProvider>().greyColor,
                    ),
                    height: 30,
                    child: Center(
                      child: Text(translateBoxName(category, context),
                          style: const TextStyle(
                              color: Colors.white, decorationThickness: 3.0)),
                    ))),
          ),
        )
    ],
  );
}

String translateBoxName(String boxName, BuildContext context) {
  if (boxName == "Categories") {
    return AppLocale.categories.getString(context);
  } else if (boxName == "Tags") {
    return AppLocale.tags.getString(context);
  } else {
    return AppLocale.tasks.getString(context);
  }
}
