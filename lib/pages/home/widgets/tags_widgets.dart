import 'package:flutter/material.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/habit/habitsCompleted.dart';
import 'package:habitt/util/functions/translate_category.dart';
import 'package:provider/provider.dart';

Widget tagsWidgets(String? tagSelected, BuildContext context) {
  List<String> visibleList = visibleListTags(context);
  Map<String, GlobalKey> tagKeys = {
    for (var tag in visibleList) tag: GlobalKey()
  };
  ScrollController scrollController = ScrollController();

  Color getTextColor(category) {
    late Color color;

    if (categoryCompleted(category, context)) {
      color = Colors.grey.shade700;
    } else {
      color = Colors.white;
    }

    if (tagSelected == category) {
      color = Colors.white;
    }

    return color;
  }

  void scrollToTag(String category) {
    if (tagKeys[category]?.currentContext != null) {
      RenderBox renderBox =
          tagKeys[category]!.currentContext!.findRenderObject() as RenderBox;
      double tagPosition = renderBox.localToGlobal(Offset.zero).dx;
      double screenWidth = MediaQuery.of(context).size.width;
      double targetOffset = scrollController.offset +
          tagPosition -
          (screenWidth / 2) +
          (renderBox.size.width / 2);

      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  return ListView(
    controller: scrollController,
    scrollDirection: Axis.horizontal,
    physics: const ClampingScrollPhysics(),
    children: <Widget>[
      for (final category in visibleList)
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () {
                  if (tagSelected == category) {
                    return;
                  }
                  setState(() {
                    pageController.animateToPage(
                      visibleList.indexOf(category),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  });
                  scrollToTag(category);
                },
                child: Container(
                    key: tagKeys[category],
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: tagSelected == category
                          ? AppColors.theOtherColor
                          : context.watch<ColorProvider>().greyColor,
                    ),
                    height: 30,
                    child: Center(
                      child: Text(translateBoth(category, context),
                          style: TextStyle(
                              color: getTextColor(category),
                              decorationThickness: 3.0)),
                    ))),
          ),
        )
    ],
  );
}
