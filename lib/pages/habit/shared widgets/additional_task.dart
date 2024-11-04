import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:provider/provider.dart';

class AdditionalTask extends StatefulWidget {
  const AdditionalTask({super.key, required this.isEdit});

  final bool isEdit;

  @override
  State<AdditionalTask> createState() => _AdditionalTaskState();
}

class _AdditionalTaskState extends State<AdditionalTask> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 10),
        decoration: BoxDecoration(
          color: context.watch<ColorProvider>().greyColor,
          borderRadius: BorderRadius.circular(20),
        ),
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              AppLocale.additionalTask.getString(context),
              style: const TextStyle(fontSize: 16),
            ),
            Checkbox.adaptive(
              value: context.watch<HabitProvider>().additionalTask,
              onChanged: (value) {
                if (widget.isEdit) {
                  context.read<HabitProvider>().updateSomethingEdited();
                }
                context.read<HabitProvider>().updateAdditionalTasks(value!);
              },
              activeColor: AppColors.theLightColor,
            )
          ],
        ),
      ),
    );
  }
}
