import "package:flutter/material.dart";
import "package:flutter_localization/flutter_localization.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:habitt/data/app_locale.dart";
import "package:habitt/pages/habit/Edit%20Habit%20Page/functions/buildEditedValues.dart";
import "package:habitt/pages/habit/Edit%20Habit%20Page/pages/edit_page.dart";
import "package:habitt/pages/habit/Edit%20Habit%20Page/pages/stats_page.dart";
import "package:habitt/pages/habit/Edit%20Habit%20Page/widgets/popup_button.dart";
import "package:habitt/pages/habit/Edit%20Habit%20Page/widgets/save_button.dart";
import "package:habitt/pages/habit/shared%20widgets/habit_display.dart";
import "package:habitt/pages/shared%20widgets/expandable_app_bar.dart";
import "package:habitt/services/ad_mob_service.dart";
import "package:habitt/services/provider/color_provider.dart";
import "package:habitt/services/provider/habit_provider.dart";
import "package:provider/provider.dart";

bool updated = false;

final formKey = GlobalKey<FormState>();

class EditHabitPage extends StatefulWidget {
  const EditHabitPage({
    super.key,
    required this.id,
    required this.editcontroller,
  });

  final int id;
  final TextEditingController editcontroller;

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  final TextEditingController habitTypeController = TextEditingController();
  InterstitialAd? interstitialAd;
  bool isAdLoaded = false;
  bool firstPage = true;

  initInterstitialAd() {
    if (interstitialAd == null) {
      InterstitialAd.load(
          adUnitId: AdMobService.interstitialAdUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (ad) => setState(() {
                    interstitialAd = ad;
                    isAdLoaded = true;
                  }),
              onAdFailedToLoad: (error) {
                setState(() {
                  interstitialAd = null;
                });
                initInterstitialAd();
              }));
    }
  }

  bool edit = false;
  bool stats = true;
  int currentIndex = 0;
  double? lowestCompletionRate;
  List<double> completionRates = [];
  double? highestCompletionRate;
  List<int> everyFifthDay = [];
  List<int> everyFifthMonth = [];

  @override
  void initState() {
    super.initState();
    habitTypeController.text = "Daily";
    initInterstitialAd();
    context.read<HabitProvider>().getPageHeight(firstPage);
  }

  @override
  Widget build(BuildContext context) {
    final int index = context.read<HabitProvider>().getIndexFromId(widget.id);
    final editcontroller = widget.editcontroller;
    final desccontroller = context.watch<HabitProvider>().notescontroller;

    buildEditedValues(context, widget.id, editcontroller, lowestCompletionRate,
        completionRates, highestCompletionRate, everyFifthDay, everyFifthMonth);

    bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    PageController pageController = PageController();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.watch<ColorProvider>().blackColor,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent),
        child: BottomNavigationBar(
            enableFeedback: false,
            backgroundColor: context.watch<ColorProvider>().darkGreyColor,
            unselectedItemColor: Colors.grey.shade700,
            selectedItemColor: Colors.white,
            currentIndex: currentIndex,
            onTap: (int value) => setState(() {
                  currentIndex = value;
                  pageController.animateToPage(
                    value,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.percent_outlined),
                label: AppLocale.stats.getString(context),
                backgroundColor: Colors.black,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.edit,
                ),
                label: AppLocale.edit.getString(context),
              ),
            ]),
      ),
      body: Form(
          key: formKey,
          child: Stack(alignment: Alignment.bottomCenter, children: [
            CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
              ExpandableAppBar(
                actionsWidget:
                    PopUpButton(index: index, editcontroller: editcontroller),
                title: AppLocale.habitInfo.getString(context),
              ),
              SliverToBoxAdapter(
                  child: Column(children: [
                HabitDisplay(
                  controller: editcontroller,
                  topPadding: 20,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      height: Provider.of<HabitProvider>(context, listen: false)
                          .editHabitPageHeight,
                      child: PageView.builder(
                        onPageChanged: (value) {
                          if (value == 0) {
                            setState(() {
                              currentIndex = 0;
                              firstPage = true;
                              context
                                  .read<HabitProvider>()
                                  .getPageHeight(firstPage);
                            });
                          } else {
                            setState(() {
                              currentIndex = 1;
                              firstPage = false;
                              context
                                  .read<HabitProvider>()
                                  .getPageHeight(firstPage);
                            });
                          }
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        controller: pageController,
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: index == 0
                                ? statsPage(
                                    context,
                                    widget.id,
                                    isAdLoaded,
                                    interstitialAd,
                                    lowestCompletionRate,
                                    completionRates,
                                    highestCompletionRate,
                                    everyFifthDay,
                                    everyFifthMonth)
                                : editPage(setState, context, editcontroller,
                                    desccontroller, habitTypeController, index),
                          );
                        },
                      ),
                    ))
              ])),
            ]),

            // SAVE BUTTON
            SaveButton(
                index: index,
                keyboardOpen: keyboardOpen,
                editcontroller: editcontroller),
          ])),
    );
  }
}
