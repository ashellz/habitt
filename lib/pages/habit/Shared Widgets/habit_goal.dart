import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/validate_text.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HabitGoal extends StatefulWidget {
  const HabitGoal({
    super.key,
    required this.index,
    required this.isEdit,
  });

  final int index;
  final bool isEdit;

  @override
  State<HabitGoal> createState() => _HabitGoalState();
}

class _HabitGoalState extends State<HabitGoal> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<HabitProvider>().updateSomethingEdited();
                setState(() {
                  if (Provider.of<HabitProvider>(context, listen: false)
                          .habitGoalValue ==
                      1) {
                    Provider.of<HabitProvider>(context, listen: false)
                        .habitGoalValue = 0;
                    if (widget.isEdit) {
                      habitBox.getAt(widget.index)!.amount = 1;
                    }
                  } else {
                    Provider.of<HabitProvider>(context, listen: false).amount =
                        2;
                    Provider.of<HabitProvider>(context, listen: false)
                        .habitGoalValue = 1;
                    if (widget.isEdit) {
                      habitBox.getAt(widget.index)!.duration = 0;
                    }
                  }
                });
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                fixedSize: WidgetStateProperty.all<Size>(
                    Size(MediaQuery.of(context).size.width * 0.42, 45)),
                backgroundColor: WidgetStateProperty.all<Color>(
                  Provider.of<HabitProvider>(context, listen: false)
                              .habitGoalValue ==
                          1
                      ? AppColors.theOtherColor
                      : context.watch<ColorProvider>().greyColor,
                ),
              ),
              child: const Text("Number of times",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(
              width: 15,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<HabitProvider>().updateSomethingEdited();
                setState(() {
                  if (Provider.of<HabitProvider>(context, listen: false)
                          .habitGoalValue ==
                      2) {
                    Provider.of<HabitProvider>(context, listen: false)
                        .habitGoalValue = 0;
                    if (widget.isEdit) {
                      habitBox.getAt(widget.index)!.duration = 0;
                    }
                  } else {
                    Provider.of<HabitProvider>(context, listen: false)
                        .duration = 1;
                    Provider.of<HabitProvider>(context, listen: false)
                        .habitGoalValue = 2;
                    if (widget.isEdit) {
                      habitBox.getAt(widget.index)!.amount = 1;
                    }
                  }
                });
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                fixedSize: WidgetStateProperty.all<Size>(
                    Size(MediaQuery.of(context).size.width * 0.43, 45)),
                backgroundColor: WidgetStateProperty.all<Color>(
                  Provider.of<HabitProvider>(context, listen: false)
                              .habitGoalValue ==
                          2
                      ? AppColors.theOtherColor
                      : context.watch<ColorProvider>().greyColor,
                ),
              ),
              child:
                  const Text("Duration", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      Visibility(
        visible:
            Provider.of<HabitProvider>(context, listen: false).habitGoalValue ==
                1,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              SpinBox(
                textInputAction: TextInputAction.done,
                cursorColor: Colors.white,
                enableInteractiveSelection: true,
                iconColor: WidgetStateProperty.all<Color>(Colors.white),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  filled: true,
                  fillColor: context.watch<ColorProvider>().greyColor,
                  labelStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.theLightColor),
                  labelText: "Amount",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                ),
                min: 2,
                max: 9999,
                value: Provider.of<HabitProvider>(context, listen: false)
                    .amount
                    .toDouble(),
                onChanged: (value) {
                  context.read<HabitProvider>().updateSomethingEdited();
                  HapticFeedback.lightImpact();
                  setState(() =>
                      Provider.of<HabitProvider>(context, listen: false)
                          .amount = value.toInt());
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                textInputAction: TextInputAction.done,
                keyboardAppearance:
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.dark
                        : Brightness.light,
                onChanged: (newValue) {
                  context.read<HabitProvider>().updateSomethingEdited();
                  Provider.of<HabitProvider>(context, listen: false)
                      .habitGoalController
                      .text = newValue.toString();
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(35),
                ],
                cursorColor: Colors.white,
                cursorWidth: 2.0,
                cursorHeight: 22.0,
                cursorRadius: const Radius.circular(10.0),
                cursorOpacityAnimates: true,
                enableInteractiveSelection: true,
                validator: validateText,
                controller: Provider.of<HabitProvider>(context, listen: false)
                    .habitGoalController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  filled: true,
                  fillColor: context.watch<ColorProvider>().greyColor,
                  labelStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.theLightColor),
                  labelText: "Amount Name",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                ),
              ),
            ],
          ),
        ),
      ),
      Visibility(
        visible:
            Provider.of<HabitProvider>(context, listen: false).habitGoalValue ==
                2,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              SpinBox(
                textInputAction: TextInputAction.done,
                iconColor: WidgetStateProperty.all<Color>(Colors.white),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  filled: true,
                  fillColor: context.watch<ColorProvider>().greyColor,
                  labelStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.theLightColor),
                  labelText: "Hours",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                ),
                min: 0,
                max: 23,
                value: Provider.of<HabitProvider>(context, listen: false)
                    .durationHours
                    .toDouble(),
                onChanged: (value) {
                  context.read<HabitProvider>().updateSomethingEdited();
                  HapticFeedback.lightImpact();
                  setState(() =>
                      Provider.of<HabitProvider>(context, listen: false)
                          .durationHours = value.toInt());
                },
              ),
              const SizedBox(height: 15),
              SpinBox(
                textInputAction: TextInputAction.done,
                iconColor: WidgetStateProperty.all<Color>(Colors.white),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  filled: true,
                  fillColor: context.watch<ColorProvider>().greyColor,
                  labelStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.theLightColor),
                  labelText: "Minutes",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                ),
                min: 0,
                max: 59,
                value: Provider.of<HabitProvider>(context, listen: false)
                    .durationMinutes
                    .toDouble(),
                onChanged: (value) {
                  context.read<HabitProvider>().updateSomethingEdited();
                  HapticFeedback.lightImpact();
                  setState(() =>
                      Provider.of<HabitProvider>(context, listen: false)
                          .durationMinutes = value.toInt());
                },
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
