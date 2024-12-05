import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/data/habit_data.dart';
import 'package:habitt/data/historical_habit.dart';
import 'package:habitt/data/tags.dart';
import 'package:habitt/pages/habit/add_habit_page.dart';
import 'package:habitt/pages/home/widgets/All%20Habits%20Page/all_habits_page.dart';
import 'package:habitt/pages/home/functions/fillTagsList.dart';
import 'package:habitt/pages/home/widgets/adaptable_page_view.dart';
import 'package:habitt/pages/home/widgets/additional_tasks.dart';
import 'package:habitt/pages/home/widgets/header.dart';
import 'package:habitt/pages/home/widgets/main_category.dart';
import 'package:habitt/pages/home/widgets/other_categories.dart';
import 'package:habitt/pages/home/widgets/selected_tag.dart';
import 'package:habitt/pages/home/widgets/tags_widgets.dart';
import 'package:habitt/pages/menu/menu_page.dart';
import 'package:habitt/services/ad_mob_service.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

const startIcon = Icon(Icons.book);
final habitBox = Hive.box<HabitData>('habits');
final metadataBox = Hive.box<DateTime>('metadata');
final streakBox = Hive.box<int>('streak');
final boolBox = Hive.box<bool>('bool');
final stringBox = Hive.box<String>('string');
final listBox = Hive.box<List>('list');
final tagBox = Hive.box<TagData>('tags');
final historicalBox = Hive.box<HistoricalHabit>('historicalHabits');
final accessTokenBox = Hive.box<String>('accessToken');
final historicalHabitDataBox =
    Hive.box<HistoricalHabitData>('historicalHabitData');
late HabitData myHabit;
String habitTag = "";
final player = AudioPlayer();

bool changed = false, keepData = false, deleted = false;

List<String> categoriesList = ['All'];

final pageController = PageController(initialPage: 0);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  double? height;
  InterstitialAd? interstitialAd;
  bool isAdLoaded = false;

  GlobalKey sizeKey = GlobalKey();

  initInterstitialAd() {
    if (!isAdLoaded) {
      InterstitialAd.load(
          adUnitId: AdMobService.interstitialAdUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (ad) => setState(() {
                    interstitialAd = ad;
                    isAdLoaded = true;
                  }),
              onAdFailedToLoad: (error) {
                isAdLoaded = false;
                interstitialAd = null;
              }));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final boxHeight = sizeKey.currentContext?.size?.height;

      setState(() {
        height = boxHeight;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (interstitialAd == null) {
      initInterstitialAd();
    }

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<HabitProvider>().updateLastOpenedDate(context);
      context.read<HabitProvider>().chooseMainCategory(context);
      context.read<HabitProvider>().updateMainCategoryHeight(context);
      if (interstitialAd == null) {
        initInterstitialAd();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    fillTagsList(context);
    String? tagSelected = context.watch<HabitProvider>().tagSelected;

    String mainCategory = context.watch<HabitProvider>().mainCategory;
    double mainCategoryHeight =
        context.watch<HabitProvider>().mainCategoryHeight;
    String username = stringBox.get('username') ?? 'Guest';

    TextEditingController createcontroller = TextEditingController();
    TextEditingController editcontroller = TextEditingController();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openAddHabitPage(context, createcontroller);
        },
        backgroundColor: AppColors.theLightColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: context.watch<ColorProvider>().blackColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: context.watch<ColorProvider>().blackColor,
              actions: [
                IconButton(
                  icon: const Icon(Icons.list),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AllHabitsPage(
                        editcontroller: editcontroller,
                      );
                    })).whenComplete(() {
                      if (context.mounted) {
                        context.read<DataProvider>().updateHabits(context);
                      }
                    });
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const MenuPage();
                    }));
                  },
                ),
              ]),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      header(
                          username, context.watch<DataProvider>().greetingText),
                      const SizedBox(height: 20),
                      SizedBox(
                          height: 30, child: tagsWidgets(tagSelected, context)),
                    ],
                  ),
                ),
                Column(children: [
                  PageViewHeightAdaptable(
                    isHomePage: true,
                    key: sizeKey,
                    controller: pageController,
                    children: [
                      for (String tag in visibleListTags(context))
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 40),
                          child: Column(
                            children: [
                              const SizedBox(height: 40),
                              if (tag == 'All')
                                Column(children: [
                                  mainCategoryList(
                                      mainCategoryHeight,
                                      mainCategory,
                                      editcontroller,
                                      context,
                                      isAdLoaded,
                                      interstitialAd),
                                  const SizedBox(height: 20),
                                  otherCategoriesList(
                                      context,
                                      mainCategory,
                                      editcontroller,
                                      isAdLoaded,
                                      interstitialAd),
                                  AdditionalTasks(
                                      editcontroller: editcontroller,
                                      isAdLoaded: isAdLoaded,
                                      interstitialAd: interstitialAd),
                                ]),
                              if (tag != 'All')
                                tagSelectedWidget(tag, editcontroller,
                                    isAdLoaded, interstitialAd, context),
                              SizedBox(
                                height: height == null
                                    ? 0
                                    : height! >
                                            MediaQuery.of(context).size.height
                                        ? 0
                                        : MediaQuery.of(context).size.height -
                                            height!,
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ])
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<String> visibleListTags(BuildContext context) {
  final habitsList = context.read<DataProvider>().habitsList;
  int habitsListLength = habitsList.length;
  List<String> visibleList = ["All"];

  for (int i = 0; i < habitsListLength; i++) {
    final category = habitsList[i].category;

    if (!visibleList.contains(category)) {
      visibleList.add(category);
    }
  }

  visibleList.sort((a, b) {
    const order = ["All", "Any time", "Morning", "Afternoon", "Evening"];
    return order.indexOf(a).compareTo(order.indexOf(b));
  });

  for (int i = 0; i < habitsListLength; i++) {
    final tag = habitsList[i].tag;
    if (!visibleList.contains(tag)) {
      if (tag != "No tag") {
        visibleList.add(tag);
      }
    }
  }

  return visibleList;
}

Future<void> playSound() async {
  await player.play(AssetSource('sound/complete3.mp3'));
}

void openAddHabitPage(
    BuildContext context, TextEditingController createcontroller) {
  Provider.of<HabitProvider>(context, listen: false).additionalTask = false;
  Provider.of<HabitProvider>(context, listen: false).notescontroller.clear();
  habitTag = "No tag";
  Provider.of<HabitProvider>(context, listen: false).updatedIcon = startIcon;
  Provider.of<HabitProvider>(context, listen: false).habitGoalValue = 0;
  Provider.of<HabitProvider>(context, listen: false).dropDownValue = 'Any time';
  Provider.of<HabitProvider>(context, listen: false).habitGoalController.text =
      AppLocale.times.getString(context);
  Provider.of<HabitProvider>(context, listen: false).amount = 2;
  Provider.of<HabitProvider>(context, listen: false).durationMinutes = 0;
  Provider.of<HabitProvider>(context, listen: false).durationHours = 0;
  Provider.of<HabitProvider>(context, listen: false).duration = 0;
  createcontroller.text = AppLocale.habitName.getString(context);
  Provider.of<HabitProvider>(context, listen: false).categoriesExpanded = false;
  Provider.of<HabitProvider>(context, listen: false).habitNotifications = [];
  context.read<DataProvider>().setCustomValueSelected(2);
  context.read<DataProvider>().setMonthValueSelected(1);
  context.read<DataProvider>().setWeekValueSelected(1);
  context.read<DataProvider>().unselectAllDaysAWeek();
  context.read<DataProvider>().unselectAllDaysAMonth();
  Provider.of<DataProvider>(context, listen: false)
      .updateHabitType(AppLocale.daily.getString(context), context);

  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return AddHabitPage(
      createcontroller: createcontroller,
    );
  })).whenComplete(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitProvider>().setTagSelected("All");
    });
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    if (context.mounted) {
      Provider.of<HabitProvider>(context, listen: false)
          .notescontroller
          .clear();

      Provider.of<HabitProvider>(context, listen: false).dropDownValue =
          'Any time';
    }
    habitTag = "No tag";

    amountNameController.text = "times";
    createcontroller.text = "Habit Name";
  });
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: "Morning", child: Text("Morning")),
    const DropdownMenuItem(value: "Afternoon", child: Text("Afternoon")),
    const DropdownMenuItem(value: "Evening", child: Text("Evening")),
    const DropdownMenuItem(value: "Any time", child: Text("Any Time")),
  ];
  return menuItems;
}
