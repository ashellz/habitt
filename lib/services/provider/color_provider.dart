import 'package:flutter/material.dart';
import 'package:habitt/util/colors.dart';

class ColorProvider extends ChangeNotifier {
  bool isTrueBlack = false;
  Color _blackColor = AppColors.theAccentBlack;

  Color get blackColor => _blackColor;

  void updateDarkColor(bool value) {
    if (value) {
      _blackColor = AppColors.theBlack;
      isTrueBlack = true;
    } else {
      _blackColor = AppColors.theAccentBlack;
      isTrueBlack = false;
    }
    notifyListeners();
  }
}
