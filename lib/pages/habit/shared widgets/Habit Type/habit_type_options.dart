import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/habit/shared%20widgets/Habit%20Type/Custom%20Widgets/custom_widgets.dart';
import 'package:habitt/pages/habit/shared%20widgets/Habit%20Type/Monthly%20Widgets/monthly_widgets.dart';
import 'package:habitt/pages/habit/shared%20widgets/Habit%20Type/Weekly%20Widgets/weekly_widgets.dart';

void showHabitTypeOptions(BuildContext context, String type) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, bottom: 10, right: 20),
              child: Column(
                children: [
                  if (type == AppLocale.weekly.getString(context))
                    const WeeklyWidgets()
                  else if (type == AppLocale.monthly.getString(context))
                    const MonthlyWidgets()
                  else if (type == AppLocale.custom.getString(context))
                    const CustomWidgets(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
