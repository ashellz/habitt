import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/services/provider/language_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({
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
            height: MediaQuery.of(context).size.width * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () =>
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<LanguageProvider>().changeLanguage("en");
                  }),
                  child: Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      color:
                          context.watch<LanguageProvider>().languageCode == "en"
                              ? AppColors.theOtherColor
                              : Colors.grey.shade900,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topLeft: Radius.circular(15)),
                    ),
                    child: const Center(
                        child: Text(
                      "EN",
                      style: TextStyle(fontSize: 22),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<LanguageProvider>().changeLanguage("ba");
                  }),
                  child: Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      color:
                          context.watch<LanguageProvider>().languageCode == "ba"
                              ? AppColors.theOtherColor
                              : Colors.grey.shade900,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15)),
                    ),
                    child: const Center(
                        child: Text(
                      "BA",
                      style: TextStyle(fontSize: 22),
                    )),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: const TextStyle(fontFamily: "Poppins"),
                  children: <TextSpan>[
                    TextSpan(
                        text: AppLocale.chooseYourLanguage1.getString(context),
                        style: const TextStyle(fontSize: 16)),
                    TextSpan(
                        text: AppLocale.chooseYourLanguage2.getString(context),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.theLightColor))
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
