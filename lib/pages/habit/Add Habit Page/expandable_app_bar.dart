import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/habit/notifications_page.dart';

class ExpandableAppBar extends StatelessWidget {
  const ExpandableAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black,
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

          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            centerTitle: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.translate(
                  offset: Offset(percent * 40, 8 * percent),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
