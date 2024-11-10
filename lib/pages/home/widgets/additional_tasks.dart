import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/util/objects/habit/habit_tile.dart';
import 'package:provider/provider.dart';

class AdditionalTasks extends StatefulWidget {
  const AdditionalTasks(
      {super.key,
      required this.editcontroller,
      required this.isAdLoaded,
      required this.interstitialAd,
      this.tag = ""});

  final TextEditingController editcontroller;
  final bool isAdLoaded;
  final InterstitialAd? interstitialAd;
  final String tag;

  @override
  State<AdditionalTasks> createState() => _AdditionalTasksState();
}

class _AdditionalTasksState extends State<AdditionalTasks> {
  List tasks = [];
  List categories = ["Any time", "Morning", "Afternoon", "Evening"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (var habit in habitBox.values) {
      if (habit.task) {
        if (!tasks.contains(habit)) {
          if (widget.tag == "") {
            tasks.add(habit);
          } else if (categories.contains(widget.tag)) {
            if (habit.category == widget.tag) {
              tasks.add(habit);
            }
          } else {
            if (habit.tag == widget.tag) {
              tasks.add(habit);
            }
          }
        }
      }
    }

    if (tasks.isEmpty || !context.watch<DataProvider>().hasTasks) {
      return const SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 80),
        child: Column(
          children: [
            const TasksDivider(),
            for (int i = 0; i < tasks.length; i++)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: NewHabitTile(
                  id: tasks[i].id,
                  editcontroller: widget.editcontroller,
                  isAdLoaded: widget.isAdLoaded,
                  interstitialAd: widget.interstitialAd,
                ),
              ),
          ],
        ),
      );
    }
  }
}

class TasksDivider extends StatelessWidget {
  const TasksDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
      child: Row(
        children: <Widget>[
          // Left Divider
          const Expanded(
            child: Divider(
              color: Colors.grey, // Customize color
              thickness: 1, // Customize thickness
            ),
          ),
          // The Text in the middle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              AppLocale.additionalTasks.getString(context),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ), // Customize text style
            ),
          ),
          // Right Divider
          const Expanded(
            child: Divider(
              color: Colors.grey, // Customize color
              thickness: 1, // Customize thickness
            ),
          ),
        ],
      ),
    );
  }
}
