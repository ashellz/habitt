import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/habit/notifications_page.dart';
import 'package:habit_tracker/util/colors.dart';

class ExpandableAppBar extends StatelessWidget {
  const ExpandableAppBar({
    super.key,
  });

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
          var invertedPercent =
              (constraints.maxHeight - kToolbarHeight) / 100.0;
          // Make sure percent is within range
          percent = (1.0 - percent).clamp(0.0, 1.0);
          invertedPercent = invertedPercent.clamp(0.0, 1.0);

          Color backgroundColor = ColorTween(
            begin: Colors.black,
            end: theAppBarColor,
          ).lerp(percent)!;

          return Container(
            color: backgroundColor,
            child: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 25, bottom: 4),
              centerTitle: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.translate(
                    offset: Offset(percent * 60, percent),
                    child: const Text(
                      "New Habit",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, top: 5),
                    child: Transform.translate(
                      offset: Offset(0, -invertedPercent * 2),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const NotificationsPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(0.0, 1.0);
                                  const end = Offset.zero;
                                  const curve = Curves.ease;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications,
                            size: 30,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
