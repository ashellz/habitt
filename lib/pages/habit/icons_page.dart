import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:icons_flutter/icons_flutter.dart';

Icon chosenIcon = const Icon(Icons.book);
Icon theIcon = chosenIcon;

class IconsPage extends StatelessWidget {
  const IconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: const [
          const Padding(
            padding: EdgeInsets.only(
              top: 20.0,
              left: 25.0,
              bottom: 10.0,
            ),
            child: Text(
              "Choose an icon",
              style: TextStyle(
                fontSize: 32.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Wrap(
              spacing: 30,
              children: [
                IconWidget(icon: Icon(Icons.add)),
                IconWidget(icon: Icon(Icons.fastfood_outlined)),
                IconWidget(icon: Icon(Icons.shopping_bag_outlined)),
                IconWidget(icon: Icon(Icons.attach_money_rounded)),
                IconWidget(icon: Icon(Icons.audiotrack)),
                IconWidget(icon: Icon(Icons.delete_rounded)),
                IconWidget(icon: Icon(Icons.book)),
                IconWidget(icon: Icon(Icons.edit_document)),
                IconWidget(icon: Icon(Icons.laptop_mac_rounded)),
                IconWidget(icon: Icon(Ionicons.md_shirt)),
                IconWidget(icon: Icon(Icons.directions_bike)),
                IconWidget(icon: Icon(Icons.directions_car)),
                IconWidget(icon: Icon(Icons.camera_alt_rounded)),
                IconWidget(icon: Icon(Icons.celebration)),
                IconWidget(icon: Icon(Icons.cake_rounded)),
                IconWidget(icon: Icon(Icons.call)),
                IconWidget(icon: Icon(Icons.checkroom_rounded)),
                IconWidget(icon: Icon(MaterialCommunityIcons.puzzle)),
                IconWidget(icon: Icon(Icons.clean_hands_rounded)),
                IconWidget(icon: Icon(MaterialCommunityIcons.tooth)),
                IconWidget(icon: Icon(Icons.coffee_rounded)),
                IconWidget(icon: Icon(Icons.science_rounded)),
                IconWidget(icon: Icon(Icons.door_front_door_rounded)),
                IconWidget(icon: Icon(Icons.sports_esports_rounded)),
                IconWidget(icon: Icon(Icons.sports_football_rounded)),
                IconWidget(icon: Icon(MaterialIcons.fitness_center)),
                IconWidget(icon: Icon(MaterialIcons.directions_walk)),
                IconWidget(icon: Icon(Icons.water_drop_rounded)),
                IconWidget(icon: Icon(Icons.egg_alt)),
                IconWidget(icon: Icon(MaterialIcons.hotel)),
                IconWidget(icon: Icon(FontAwesome.shower)),
                IconWidget(icon: Icon(FontAwesome.book)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IconWidget extends StatelessWidget {
  final Icon icon;

  const IconWidget({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: SizedBox(
        width: 65,
        height: 65,
        child: ElevatedButton(
          onPressed: () {
            theIcon = icon;
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            backgroundColor: theGreen,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
          child: Icon(
            icon.icon,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
