import 'package:flutter/material.dart';
import 'package:habitt/util/colors.dart';

class ExpandableAppBar extends StatelessWidget {
  const ExpandableAppBar(
      {super.key, required this.actionsWidget, required this.title});

  final Widget actionsWidget;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: 60.0,
      expandedHeight: 120.0, // The height of the AppBar when expanded
      floating: false,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate the percentage of the scroll completed
          var percent = (constraints.maxHeight - kToolbarHeight) / 100.0;
          // Make sure percent is within range
          percent = (1.0 - percent).clamp(0.0, 1.0);

          Color backgroundColor = ColorTween(
            begin: Colors.black,
            end: theAppBarColor,
          ).lerp(percent)!;

          Color textColor = ColorTween(
            begin: theLightColor,
            end: Colors.white,
          ).lerp(percent * 3)!;

          return Container(
            color: backgroundColor,
            child: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 25, bottom: 15),
              centerTitle: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.translate(
                    offset: Offset(percent * 60, percent),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        actionsWidget,
      ],
    );
  }
}
