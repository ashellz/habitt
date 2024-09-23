import 'package:flutter/material.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:lottie/lottie.dart';

class PageOne extends StatelessWidget {
  const PageOne({
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
            child: Lottie.asset("assets/images/Welcome.json"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: const TextStyle(fontFamily: "Poppins"),
                  children: <TextSpan>[
                    const TextSpan(
                        text: "Welcome to", style: TextStyle(fontSize: 16)),
                    TextSpan(
                        text: " habitt ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theLightColor)),
                    const TextSpan(
                        text: ", a minimalist habit tracking app you need!",
                        style: TextStyle(fontSize: 16))
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
