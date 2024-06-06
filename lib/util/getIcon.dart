import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:icons_flutter/icons_flutter.dart';

final habitBox = Hive.box<HabitData>('habits');
IconData getIcon(int index) {
  String icon = habitBox.getAt(index)!.icon;

  switch (icon) {
    case "Icons.add":
      return Icons.add;
    case "Icons.fastfood_outlined":
      return Icons.fastfood_outlined;
    case "Icons.shopping_bag_outlined":
      return Icons.shopping_bag_outlined;
    case "Icons.attach_money_rounded":
      return Icons.attach_money_rounded;
    case "Icons.audiotrack":
      return Icons.audiotrack;
    case "Icons.book":
      return Icons.book;
    case "Icons.delete_rounded":
      return Icons.delete_rounded;
    case "Icons.edit_document":
      return Icons.edit_document;
    case "Icons.edit_calendar":
      return Icons.edit_calendar;
    case "Ionicons.md_shirt":
      return Ionicons.md_shirt;
    case "Icons.directions_bike":
      return Icons.directions_bike;
    case "Icons.directions_car":
      return Icons.directions_car;
    case "Icons.camera_alt_rounded":
      return Icons.camera_alt_rounded;
    case "Icons.celebration":
      return Icons.celebration;
    case "Icons.cake_rounded":
      return Icons.cake_rounded;
    case "Icons.call":
      return Icons.call;
    case "MaterialCommunityIcons.puzzle":
      return MaterialCommunityIcons.puzzle;
    case "Icons.clean_hands_rounded":
      return Icons.clean_hands_rounded;
    case "MaterialCommunityIcons.tooth":
      return MaterialCommunityIcons.tooth;
    case "Icons.coffee_rounded":
      return Icons.coffee_rounded;
    case "Icons.science_rounded":
      return Icons.science_rounded;
    case "Icons.door_front_door_rounded":
      return Icons.door_front_door_rounded;
    case "Icons.sports_esports_rounded":
      return Icons.sports_esports_rounded;
    case "Icons.sports_football_rounded":
      return Icons.sports_football_rounded;
    case "MaterialIcons.fitness_center":
      return MaterialIcons.fitness_center;
    case "MaterialIcons.directions_walk":
      return MaterialIcons.directions_walk;
    case "Icons.water_drop_rounded":
      return Icons.water_drop_rounded;
    default:
      return Icons.book;
  }
}

String getIconString(IconData? icon) {
  switch (icon) {
    case Icons.add:
      return "Icons.add";
    case Icons.fastfood_outlined:
      return "Icons.fastfood_outlined";
    case Icons.shopping_bag_outlined:
      return "Icons.shopping_bag_outlined";
    case Icons.attach_money_rounded:
      return "Icons.attach_money_rounded";
    case Icons.audiotrack:
      return "Icons.audiotrack";
    case Icons.book:
      return "Icons.book";
    case Icons.delete_rounded:
      return "Icons.delete_rounded";
    case Icons.edit_document:
      return "Icons.edit_document";
    case Icons.edit_calendar:
      return "Icons.edit_calendar";
    case Ionicons.md_shirt:
      return "Ionicons.md_shirt";
    case Icons.directions_bike:
      return "Icons.directions_bike";
    case Icons.directions_car:
      return "Icons.directions_car";
    case Icons.camera_alt_rounded:
      return "Icons.camera_alt_rounded";
    case Icons.celebration:
      return "Icons.celebration";
    case Icons.cake_rounded:
      return "Icons.cake_rounded";
    case Icons.call:
      return "Icons.call";
    case MaterialCommunityIcons.puzzle:
      return "MaterialCommunityIcons.puzzle";
    case Icons.clean_hands_rounded:
      return "Icons.clean_hands_rounded";
    case MaterialCommunityIcons.tooth:
      return "MaterialCommunityIcons.tooth";
    case Icons.coffee_rounded:
      return "Icons.coffee_rounded";
    case Icons.science_rounded:
      return "Icons.science_rounded";
    case Icons.door_front_door_rounded:
      return "Icons.door_front_door_rounded";
    case Icons.sports_esports_rounded:
      return "Icons.sports_esports_rounded";
    case Icons.sports_football_rounded:
      return "Icons.sports_football_rounded";
    case MaterialIcons.fitness_center:
      return "MaterialIcons.fitness_center";
    case MaterialIcons.directions_walk:
      return "MaterialIcons.directions_walk";
    case Icons.water_drop_rounded:
      return "Icons.water_drop_rounded";
    default:
      return "Icons.book";
  }
}
