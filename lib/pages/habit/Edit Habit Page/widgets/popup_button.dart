import 'package:flutter/material.dart';
import 'package:habitt/pages/habit/notifications_page.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/functions/checkForNotifications.dart';
import 'package:habitt/util/functions/showCustomDialog.dart';
import 'package:provider/provider.dart';

class PopUpButton extends StatelessWidget {
  const PopUpButton({
    super.key,
    required this.index,
    required this.editcontroller,
  });
  final TextEditingController editcontroller;
  final int index;

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
            onTap: () => showCustomDialog(
                        context,
                        "Delete Habit",
                        const Text(
                            "Are you sure you want to delete this habit? This action cannot be undone."),
                        () => context.read<HabitProvider>().deleteHabitProvider(
                            index, context, editcontroller),
                        "Yes",
                        "No")
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
