import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GetCompletionRateDays extends StatefulWidget {
  GetCompletionRateDays(
      {super.key,
      required this.everyFifthDay,
      required this.everyFifthMonth,
      required this.value});

  final List<int> everyFifthDay;
  final List<int> everyFifthMonth;
  double value;

  @override
  State<GetCompletionRateDays> createState() => _GetCompletionRateDaysState();
}

class _GetCompletionRateDaysState extends State<GetCompletionRateDays> {
  String day = "";
  int monthNumber = 13;

  @override
  Widget build(BuildContext context) {
    widget.value = widget.value - 5;
    double counter = widget.value / 5;
    if (counter > 5) {
      day = "";
      monthNumber = 13;
    } else {
      day = "${widget.everyFifthDay.reversed.toList()[counter.toInt()]}";
      monthNumber = widget.everyFifthMonth.reversed.toList()[counter.toInt()];
    }

    if (widget.value == 31) {
      day = "";
      monthNumber = 13;
    } else if (widget.value < 0) {
      day = "";
      monthNumber = 13;
    }

    if (day == "0") {
      day = "";
    }

    String month = getMonth(monthNumber - 1);

    return Text("$day $month",
        maxLines: 1,
        style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 10));
  }
}

String getMonth(int month) {
  switch (month) {
    case 0:
      return "Jan";
    case 1:
      return "Feb";
    case 2:
      return "Mar";
    case 3:
      return "Apr";
    case 4:
      return "May";
    case 5:
      return "Jun";
    case 6:
      return "Jul";
    case 7:
      return "Aug";
    case 8:
      return "Sep";
    case 9:
      return "Oct";
    case 10:
      return "Nov";
    case 11:
      return "Dec";
    default:
      return "";
  }
}
