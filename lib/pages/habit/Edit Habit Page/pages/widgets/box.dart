import 'package:animated_digit/animated_digit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:habitt/util/colors.dart';

class box extends StatelessWidget {
  const box(
      {super.key, required this.value, required this.text, this.perc = false});

  final int value;
  final String text;
  final bool perc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width * 0.5 - 30,
      height: MediaQuery.of(context).size.width * 0.5 - 30,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.grey.shade900),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            minFontSize: 12,
            text.split(" ")[0],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          AutoSizeText(
            minFontSize: 12,
            text.split(" ")[1],
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
              if (perc)
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text("%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: AppColors.theLightColor,
                      )),
                )
            ],
          ),
        ],
      ),
    );
  }
}
