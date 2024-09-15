import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/habit/Edit%20Habit%20Page/edit_habit_page.dart';
import 'package:habit_tracker/pages/habit/notifications_page.dart';
import 'package:habit_tracker/pages/new_home_page.dart';
import 'package:habit_tracker/util/functions/checkForNotifications.dart';
import 'package:habit_tracker/util/objects/habit/confirm_delete_habit.dart';

class PopUpButton extends StatelessWidget {
  const PopUpButton({
    super.key,
    required this.widget,
    required this.editcontroller,
  });

  final EditHabitPage widget;
  final TextEditingController editcontroller;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.grey.shade900,
      itemBuilder: (context) => [
        PopupMenuItem(
            onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const NotificationsPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
                ).whenComplete(() => checkForNotifications()),
            value: 0,
            child: const Row(
              children: [
                Icon(Icons.notifications),
                SizedBox(width: 5),
                Text(
                  "Notifications",
                  style: TextStyle(color: Colors.white),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () => showDialog(
                        context: context,
                        builder: (context) =>
                            confirmDeleteHabit(widget.index, editcontroller))
                    .then((value) {
                  if (deleted) {
                    if (context.mounted) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  }
                }),
            value: 1,
            child: const Row(
              children: [
                Icon(Icons.delete),
                SizedBox(width: 5),
                Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                )
              ],
            )),
      ],
    );
  }
}
