import 'package:flutter/material.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/habit/habitsCompleted.dart';
import 'package:habitt/util/functions/translate_category.dart';
import 'package:provider/provider.dart';

class TagsWidgets extends StatefulWidget {
  const TagsWidgets({
    super.key,
    required this.tagSelected,
  });

  final String? tagSelected;

  @override
  State<TagsWidgets> createState() => _TagsWidgetsState();
}

class _TagsWidgetsState extends State<TagsWidgets> {
  String? previousTagSelected;
  List<String> visibleList = [];
  Map<String, GlobalKey> tagKeys = {};
  ScrollController scrollController = ScrollController();
  int counter = 0;

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

  @override
  void didUpdateWidget(covariant TagsWidgets oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (counter <= 3) {
      counter++;
      return;
    }

    print("didUpdateWidget");
    if (widget.tagSelected != previousTagSelected) {
      previousTagSelected = widget.tagSelected;

      if (widget.tagSelected != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToTag(widget.tagSelected!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    visibleList = visibleListTags(context);
    tagKeys = {for (var tag in visibleList) tag: GlobalKey()};
    Color getTextColor(category) {
      late Color color;

      if (categoryCompleted(category, context)) {
        color = Colors.grey.shade700;
      } else {
        color = Colors.white;
      }

      if (widget.tagSelected == category) {
        color = Colors.white;
      }

      return color;
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
                    if (widget.tagSelected == category) {
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
                        color: widget.tagSelected == category
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
}
