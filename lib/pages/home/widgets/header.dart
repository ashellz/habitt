import 'package:flutter/material.dart';
import 'package:habitt/util/colors.dart';

Widget header(username, String greetingText) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        greetingText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        username,
        style: TextStyle(
          height: 1,
          color: theLightColor,
          fontSize: 42,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
