import 'package:flutter/material.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/onboarding/page_five.dart';
import 'package:habitt/pages/onboarding/page_four.dart';
import 'package:habitt/pages/onboarding/page_one.dart';
import 'package:habitt/pages/onboarding/page_three.dart';
import 'package:habitt/pages/onboarding/page_two.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<ColorProvider>().blackColor,
      body: Stack(
        children: [
          PageView(
            physics: const BouncingScrollPhysics(),
            onPageChanged: (value) {
              setState(() {
                currentPage = value;
              });
            },
            controller: controller,
            children: const [
              PageOne(),
              PageTwo(),
              PageThree(),
              PageFour(),
              PageFive()
            ],
          ),
          Container(
              alignment: const Alignment(0, 0.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  currentPage < 4
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.animateToPage(4,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                            });
                          },
                          child: const SizedBox(
                            width: 50,
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        )
                      : const SizedBox(width: 50),
                  SmoothPageIndicator(
                    controller: controller,
                    count: 5,
                    effect: ExpandingDotsEffect(
                        activeDotColor: AppColors.theLightColor,
                        dotColor: Colors.grey.shade800),
                  ),
                  currentPage != 4
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                            });
                          },
                          child: const SizedBox(
                            width: 50,
                            child: Text(
                              "Next",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          )),
                          child: const SizedBox(
                            width: 50,
                            child: Text(
                              "Done",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        )
                ],
              ))
        ],
      ),
    );
  }
}
