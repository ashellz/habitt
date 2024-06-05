import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';

Icon chosenIcon = const Icon(Icons.book);
Icon theIcon = chosenIcon;

class IconsPage extends StatelessWidget {
  const IconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 211, 190),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25, top: 35, bottom: 5),
            child: Text(
              'Choose an icon',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconWidget(icon: Icon(Icons.add)),
              IconWidget(icon: Icon(Icons.fastfood_outlined)),
              IconWidget(icon: Icon(Icons.shopping_bag_outlined)),
              IconWidget(icon: Icon(Icons.attach_money_rounded)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconWidget(icon: Icon(Icons.audiotrack)),
              IconWidget(icon: Icon(Icons.delete_rounded)),
              IconWidget(icon: Icon(Icons.book)),
              IconWidget(icon: Icon(Icons.edit_document)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconWidget(icon: Icon(Icons.edit_calendar)),
              IconWidget(icon: Icon(Ionicons.md_shirt)),
              IconWidget(icon: Icon(Icons.directions_bike)),
              IconWidget(icon: Icon(Icons.directions_car)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconWidget(icon: Icon(Icons.camera_alt_rounded)),
              IconWidget(icon: Icon(Icons.celebration)),
              IconWidget(icon: Icon(Icons.cake_rounded)),
              IconWidget(icon: Icon(Icons.call)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconWidget(icon: Icon(Icons.checkroom_rounded)),
              IconWidget(icon: Icon(MaterialCommunityIcons.puzzle)),
              IconWidget(icon: Icon(Icons.clean_hands_rounded)),
              IconWidget(icon: Icon(MaterialCommunityIcons.tooth)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconWidget(icon: Icon(Icons.coffee_rounded)),
              IconWidget(icon: Icon(Icons.science_rounded)),
              IconWidget(icon: Icon(Icons.door_front_door_rounded)),
              IconWidget(icon: Icon(Icons.videogame_asset_rounded)),
            ],
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
        width: 60,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            theIcon = icon;
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            backgroundColor: const Color.fromARGB(255, 183, 181, 151),
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
          child: Icon(icon.icon, color: Colors.black),
        ),
      ),
    );
  }
}
