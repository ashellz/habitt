import 'package:flutter/material.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:provider/provider.dart';

Widget textAndSwitchContainer(String text, Widget switchWidget) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: StatefulBuilder(builder: (context, StateSetter setState) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
              color: context.watch<ColorProvider>().greyColor,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                  child: SizedBox(
                height: 40,
                child: FittedBox(
                  child: switchWidget,
                ),
              ))
            ],
          ),
        );
      }));
}
