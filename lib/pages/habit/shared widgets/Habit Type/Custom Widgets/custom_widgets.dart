import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/language_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:provider/provider.dart';

class CustomWidgets extends StatefulWidget {
  const CustomWidgets({super.key});

  @override
  State<CustomWidgets> createState() => _CustomWidgetsState();
}

class _CustomWidgetsState extends State<CustomWidgets> {
  List<String> values = [];

  String getCustomText() {
    String text = "";
    if (context.watch<DataProvider>().customValueSelected < 11) {
      text =
          "${values[context.watch<DataProvider>().customValueSelected - 2]} ${AppLocale.day.getString(context)}";
    } else {
      text =
          "${context.watch<DataProvider>().customValueSelected} ${AppLocale.days.getString(context)}";
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    values = [
      AppLocale.other.getString(context),
      AppLocale.third.getString(context),
      AppLocale.fourth.getString(context),
      AppLocale.fifth.getString(context),
      AppLocale.sixth.getString(context),
      AppLocale.seventh.getString(context),
      AppLocale.eighth.getString(context),
      AppLocale.ninth.getString(context),
      AppLocale.tenth.getString(context),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocale.custom.getString(context),
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.theLightColor)),
        const SizedBox(height: 15),
        Row(
          children: [
            Text(
              "${AppLocale.every.getString(context)}${context.watch<LanguageProvider>().languageCode == "ba" && context.watch<DataProvider>().customValueSelected > 10 ? "h" : ""}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            TextButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        context.watch<ColorProvider>().greyColor)),
                onPressed: () {
                  if (Provider.of<DataProvider>(context, listen: false)
                          .customValueSelected >
                      29) {
                    context.read<DataProvider>().setCustomValueSelected(2);
                  } else {
                    context.read<DataProvider>().increaseCustomValueSelected();
                  }

                  print(Provider.of<DataProvider>(context, listen: false)
                      .customValueSelected);
                },
                child: Text(
                  "${getCustomText()}.",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                )),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          "${AppLocale.thisHabitWillAppear.getString(context)} ${AppLocale.every.getString(context).toLowerCase()} ${getCustomText().toLowerCase()} ${AppLocale.startingFromToday.getString(context)}.",
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
