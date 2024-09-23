import "package:flutter/material.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:habit_tracker/pages/habit/Add%20Habit%20Page/expandable_app_bar.dart";
import "package:habit_tracker/pages/habit/Edit%20Habit%20Page/functions/buildEditedValues.dart";
import "package:habit_tracker/pages/habit/Edit%20Habit%20Page/pages/edit_page.dart";
import "package:habit_tracker/pages/habit/Edit%20Habit%20Page/widgets/popup_button.dart";
import "package:habit_tracker/pages/habit/Edit%20Habit%20Page/widgets/save_button.dart";
import "package:habit_tracker/pages/habit/Edit%20Habit%20Page/pages/stats_page.dart";
import "package:habit_tracker/pages/habit/Shared%20Widgets/habit_display.dart";
import "package:habit_tracker/services/ad_mob_service.dart";
import "package:habit_tracker/services/provider/habit_provider.dart";
import "package:habit_tracker/util/colors.dart";
import "package:provider/provider.dart";

bool updated = false;

final formKey = GlobalKey<FormState>();

class EditHabitPage extends StatefulWidget {
  const EditHabitPage({
    super.key,
    required this.index,
    required this.editcontroller,
  });

  final int index;
  final TextEditingController editcontroller;

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  InterstitialAd? interstitialAd;
  bool isAdLoaded = false;

  initInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.interstitialAd,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => setState(() {
            interstitialAd = ad;
            isAdLoaded = true;
          }),
          onAdFailedToLoad: (error) => setState(() => interstitialAd = null),
        ));
  }

  bool edit = false;
  bool stats = true;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    final editcontroller = widget.editcontroller;
    final desccontroller = context.watch<HabitProvider>().notescontroller;

    buildEditedValues(context, widget.index, editcontroller);

    bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    PageController pageController = PageController();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent),
        child: BottomNavigationBar(
            enableFeedback: false,
            backgroundColor: theDarkGrey,
            unselectedItemColor: Colors.grey.shade700,
            selectedItemColor: Colors.white,
            currentIndex: currentIndex,
            onTap: (int value) => setState(() {
                  currentIndex = value;
                  pageController.animateToPage(
                    value,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.percent_outlined),
                label: 'Stats',
                backgroundColor: Colors.black,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.edit,
                ),
                label: 'Edit',
              ),
            ]),
      ),
      body: Form(
        key: formKey,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
              ExpandableAppBar(
                actionsWidget:
                    PopUpButton(widget: widget, editcontroller: editcontroller),
                title: "Habit Info",
              ),
              SliverToBoxAdapter(
                  child: Column(children: [
                HabitDisplay(
                  controller: editcontroller,
                  topPadding: 20,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        //PAGE VIEW
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: PageView.builder(
                            onPageChanged: (value) {
                              if (value == 0) {
                                setState(() {
                                  currentIndex = 0;
                                });
                              } else {
                                setState(() {
                                  currentIndex = 1;
                                });
                              }
                            },
                            physics: const BouncingScrollPhysics(),
                            controller: pageController,
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: index == 0
                                    ? statsPage(context, widget.index,
                                        isAdLoaded, interstitialAd)
                                    : editPage(
                                        setState,
                                        context,
                                        editcontroller,
                                        desccontroller,
                                        widget.index),
                              );
                            },
                          ),
                        )
                      ],
                    ))
              ])),
            ]),

            // SAVE BUTTON
            SaveButton(
                keyboardOpen: keyboardOpen,
                widget: widget,
                editcontroller: editcontroller),
          ],
        ),
      ),
    );
  }
}
