import 'package:flutter/material.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:lottie/lottie.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.width * 0.5,
            child: Lottie.asset("assets/images/Add.json"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: const TextStyle(fontFamily: "Poppins"),
                  children: <TextSpan>[
                    const TextSpan(
                        text: "Add your own", style: TextStyle(fontSize: 16)),
                    TextSpan(
                        text: " custom ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theLightColor)),
                    const TextSpan(
                        text: "habits, complete them and feel",
                        style: TextStyle(fontSize: 16)),
                    TextSpan(
                        text: " accomplished!",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theLightColor)),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
