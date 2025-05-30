import 'package:animated_digit/animated_digit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:provider/provider.dart';

class box extends StatelessWidget {
  const box({super.key, required this.value, required this.text});

  final int value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width * 0.5 - 30,
      height: MediaQuery.of(context).size.width * 0.5 - 30,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: context.watch<ColorProvider>().greyColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            minFontSize: 12,
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              AnimatedDigitWidget(
                loop: false,
                duration: const Duration(milliseconds: 800),
                value: value,
                textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: AppColors.theLightColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
