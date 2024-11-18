import 'package:flutter/material.dart';
import 'package:habitt/pages/habit/shared%20widgets/Habit%20Type/Custom%20Widgets/custom_widgets.dart';
import 'package:habitt/pages/habit/shared%20widgets/Habit%20Type/Monthly%20Widgets/monthly_widgets.dart';
import 'package:habitt/pages/habit/shared%20widgets/Habit%20Type/Weekly%20Widgets/weekly_widgets.dart';
import 'package:habitt/util/colors.dart';

void showHabitTypeOptions(BuildContext context, String type) {
  showModalBottomSheet(
    context: context,
    builder: (context) =>
        StatefulBuilder(builder: (context, StateSetter setState) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 20, bottom: 10, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.theLightColor)),
                    const SizedBox(height: 15),
                    if (type == "Weekly")
                      const WeeklyWidgets()
                    else if (type == "Monthly")
                      const MonthlyWidgets()
                    else if (type == "Custom")
                      const CustomWidgets(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }),
  );
}
