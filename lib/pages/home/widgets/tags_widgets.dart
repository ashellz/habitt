import 'package:flutter/material.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/habit/habitsCompleted.dart';

Widget tagsWidgets(String? tagSelected) {
  List<String> visibleList = visibleListTags();

  Color getTextColor(category) {
    late Color color;

    if (categoryCompleted(category)) {
      color = Colors.grey.shade700;
    } else {
      color = Colors.white;
    }

    if (tagSelected == category) {
      color = Colors.white;
    }

    return color;
  }

  return ListView(
    scrollDirection: Axis.horizontal,
    children: <Widget>[
      for (final category in visibleList)
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () => setState(() {
                      pageController.animateToPage(
                        visibleList.indexOf(category),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }),
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:
                          tagSelected == category ? theOtherColor : theDarkGrey,
                    ),
                    height: 30,
                    child: Center(
                      child: Text(category.toString(),
                          style: TextStyle(
                              color: getTextColor(category),
                              decorationThickness: 3.0)),
                    ))),
          ),
        )
    ],
  );
}
