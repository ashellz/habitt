import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/app_locale.dart';
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
  late bool showTasks;
  String tag = "";
  List categories = ["Any time", "Morning", "Afternoon", "Evening"];

  @override
  void initState() {
    super.initState();
    showTasks = false;
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < context.watch<DataProvider>().tasksList.length; i++) {
      if (context.watch<DataProvider>().tasksList[i].category == widget.tag) {
        showTasks = true;
        break;
      } else if (context.watch<DataProvider>().tasksList[i].tag == widget.tag) {
        showTasks = true;
        break;
      } else if (widget.tag == "") {
        showTasks = true;
        break;
      } else {
        showTasks = false;
      }
    }

    if (!showTasks || context.watch<DataProvider>().tasksList.isEmpty) {
      return const SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TasksDivider(tag: widget.tag),
            if (widget.tag == "")
              for (int i = 0;
                  i < context.watch<DataProvider>().tasksList.length;
                  i++)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: NewHabitTile(
                    id: context.watch<DataProvider>().tasksList[i].id,
                    editcontroller: widget.editcontroller,
                    isAdLoaded: widget.isAdLoaded,
                    interstitialAd: widget.interstitialAd,
                  ),
                ),
            if (categories.contains(widget.tag))
              for (int i = 0;
                  i < context.watch<DataProvider>().tasksList.length;
                  i++)
                if (context.watch<DataProvider>().tasksList[i].category ==
                    widget.tag)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: NewHabitTile(
                      id: context.watch<DataProvider>().tasksList[i].id,
                      editcontroller: widget.editcontroller,
                      isAdLoaded: widget.isAdLoaded,
                      interstitialAd: widget.interstitialAd,
                    ),
                  ),
            for (int i = 0;
                i < context.watch<DataProvider>().tasksList.length;
                i++)
              if (context.watch<DataProvider>().tasksList[i].tag == widget.tag)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: NewHabitTile(
                    id: context.watch<DataProvider>().tasksList[i].id,
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
    required this.tag,
  });

  final String tag;

  @override
  Widget build(BuildContext context) {
    Widget newDesign() {
      return Transform.translate(
        offset: const Offset(0, -15),
        child: Text(
          "${AppLocale.additionalTasks.getString(context)}:",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ), // Customize text style
        ),
      );
    }

    if (context.watch<DataProvider>().tasksList.length ==
        context.watch<DataProvider>().habitsList.length) {
      return newDesign();
    } else if (tag != "") {
      int habits = 0;
      int tasks = 0;

      for (int i = 0;
          i < context.watch<DataProvider>().habitsList.length;
          i++) {
        if (context.watch<DataProvider>().habitsList[i].category == tag) {
          habits++;
          if (context.watch<DataProvider>().habitsList[i].task == true) {
            tasks++;
          }
        } else if (context.watch<DataProvider>().habitsList[i].tag == tag) {
          habits++;
          if (context.watch<DataProvider>().habitsList[i].task == true) {
            tasks++;
          }
        }
      }

      if (tasks == habits) {
        return newDesign();
      }
    }

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
