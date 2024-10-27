import 'package:flutter/material.dart';
import 'package:habitt/util/colors.dart';
import 'package:lottie/lottie.dart';

class PageThree extends StatelessWidget {
  const PageThree({
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
            child: Lottie.asset("assets/images/Calendar.json"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                  style: TextStyle(fontFamily: "Poppins"),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Check your", style: TextStyle(fontSize: 16)),
                    TextSpan(
                        text: " calendar ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.theLightColor)),
                    TextSpan(
                        text: "to see how well you are",
                        style: TextStyle(fontSize: 16)),
                    TextSpan(
                        text: " progressing!",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.theLightColor)),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
