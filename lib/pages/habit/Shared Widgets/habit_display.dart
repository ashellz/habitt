import 'package:flutter/material.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/translate_category.dart';
import 'package:provider/provider.dart';

class HabitDisplay extends StatelessWidget {
  const HabitDisplay({
    super.key,
    required this.controller,
    required this.topPadding,
  });

  final TextEditingController controller;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: 10.0, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              width: 70,
              height: 70,
              child: FittedBox(
                child: Icon(
                  context.watch<HabitProvider>().updatedIcon.icon,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    controller.text,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                      translateCategory(
                          context.watch<HabitProvider>().dropDownValue,
                          context),
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.theLightColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
