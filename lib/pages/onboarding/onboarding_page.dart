import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/pages/onboarding/language_page.dart';
import 'package:habitt/pages/onboarding/page_five.dart';
import 'package:habitt/pages/onboarding/page_four.dart';
import 'package:habitt/pages/onboarding/page_one.dart';
import 'package:habitt/pages/onboarding/page_three.dart';
import 'package:habitt/pages/onboarding/page_two.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/storage_service.dart';
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
              LanguagePage(),
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
                  currentPage < 5
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.animateToPage(5,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                            });
                          },
                          child: SizedBox(
                            width: 75,
                            child: Text(
                              textAlign: TextAlign.center,
                              AppLocale.skip.getString(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        )
                      : const SizedBox(width: 50),
                  SmoothPageIndicator(
                    controller: controller,
                    count: 6,
                    effect: ExpandingDotsEffect(
                        activeDotColor: AppColors.theLightColor,
                        dotColor: Colors.grey.shade800),
                  ),
                  currentPage != 5
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                            });
                          },
                          child: SizedBox(
                            width: 75,
                            child: Text(
                              textAlign: TextAlign.center,
                              AppLocale.next.getString(context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            context
                                .read<DataProvider>()
                                .initializeTagsList(context);
                            addInitialData(context);
                            context.read<DataProvider>().updateHabits(context);
                            boolBox.put("firstTimeOpened", false);
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ));
                          },
                          child: SizedBox(
                            width: 75,
                            child: Text(
                              textAlign: TextAlign.center,
                              AppLocale.done.getString(context),
                              style: const TextStyle(
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
