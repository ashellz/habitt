import 'package:flutter/material.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:provider/provider.dart';

class CustomWidgets extends StatefulWidget {
  const CustomWidgets({super.key});

  @override
  State<CustomWidgets> createState() => _CustomWidgetsState();
}

class _CustomWidgetsState extends State<CustomWidgets> {
  List<String> values = [
    "other",
    "third",
    "fourth",
    "fifth",
    "sixth",
    "seventh",
    "eighth",
    "ninth",
    "tenth"
  ];

  String getCustomText() {
    String text = "";
    if (context.watch<DataProvider>().customValueSelected < 9) {
      text = "${values[context.watch<DataProvider>().customValueSelected]} day";
    } else {
      text = "${context.watch<DataProvider>().customValueSelected + 2} days";
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Every",
              style: TextStyle(
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
                      27) {
                    context.read<DataProvider>().setCustomValueSelected(0);
                  } else {
                    context.read<DataProvider>().increaseCustomValueSelected();
                  }
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
          "This habit will appear every ${getCustomText().toLowerCase()} starting from today.",
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
