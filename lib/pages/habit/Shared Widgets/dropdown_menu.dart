import 'package:flutter/material.dart';
import 'package:habitt/pages/habit/shared%20widgets/choose_category.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/functions/translate_category.dart';
import 'package:provider/provider.dart';

class DropDownMenu extends StatelessWidget {
  const DropDownMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const chooseCategoriesList = [
      "Any time",
      "Morning",
      "Afternoon",
      "Evening"
    ];

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: AnimatedContainer(
              decoration: BoxDecoration(
                color: context.watch<ColorProvider>().darkGreyColor,
                borderRadius: BorderRadius.circular(20),
              ),
              duration: const Duration(milliseconds: 600),
              curve: Curves.fastOutSlowIn,
              height: context.watch<HabitProvider>().categoriesExpanded
                  ? 230.0
                  : 0.0,
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 52),
                    for (int i = 0; i < chooseCategoriesList.length; i++)
                      chooseCategory(chooseCategoriesList[i], context, true)
                  ])),
        ),
        GestureDetector(
          onTap: () => context.read<HabitProvider>().toggleExpansion(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: context.watch<ColorProvider>().greyColor,
              borderRadius: BorderRadius.circular(20),
            ),
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  translateCategory(
                      context.watch<HabitProvider>().dropDownValue, context),
                  style: const TextStyle(fontSize: 16),
                ),
                Icon(
                    context.watch<HabitProvider>().categoriesExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
