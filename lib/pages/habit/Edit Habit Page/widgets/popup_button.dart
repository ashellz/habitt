import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/pages/habit/notifications_page.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
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
    HabitData habit = habitBox.getAt(index)!;

    return PopupMenuButton(
      color: context.watch<ColorProvider>().greyColor,
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
                ).whenComplete(() {
                  if (context.mounted) {
                    checkForNotifications(context);
                  }
                }),
            value: 0,
            child: Row(
              children: [
                const Icon(Icons.notifications),
                const SizedBox(width: 5),
                Text(
                  AppLocale.notifications.getString(context),
                  style: const TextStyle(color: Colors.white),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () => showCustomDialog(
                        context,
                        habit.paused
                            ? AppLocale.unpauseHabit.getString(context)
                            : AppLocale.pauseHabit.getString(context),
                        Text(
                            habit.paused
                                ? AppLocale.areYouSureUnpauseHabit
                                    .getString(context)
                                : AppLocale.areYouSurePauseHabit
                                    .getString(context),
                            textAlign: TextAlign.center),
                        () => context
                            .read<HabitProvider>()
                            .pauseHabit(habit, context),
                        AppLocale.yes.getString(context),
                        AppLocale.no.getString(context))
                    .then((value) {
                  if (context.mounted) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                }),
            value: 1,
            child: Row(
              children: [
                const Icon(Icons.pause_circle_outline),
                const SizedBox(width: 5),
                Text(
                  habit.paused
                      ? AppLocale.unpauseHabit.getString(context)
                      : AppLocale.pauseHabit.getString(context),
                  style: const TextStyle(color: Colors.white),
                )
              ],
            )),
        PopupMenuItem(
            onTap: () => showCustomDialog(
                        context,
                        AppLocale.deleteHabit.getString(context),
                        Text(AppLocale.areYouSureDeleteHabit.getString(context),
                            textAlign: TextAlign.center),
                        () => context.read<HabitProvider>().deleteHabitProvider(
                            index, context, editcontroller),
                        AppLocale.yes.getString(context),
                        AppLocale.no.getString(context))
                    .then((value) {
                  if (deleted) {
                    if (context.mounted) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  }
                }),
            value: 2,
            child: Row(
              children: [
                const Icon(Icons.delete),
                const SizedBox(width: 5),
                Text(
                  AppLocale.delete.getString(context),
                  style: const TextStyle(color: Colors.white),
                )
              ],
            )),
      ],
    );
  }
}
