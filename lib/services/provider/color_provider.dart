import 'package:flutter/material.dart';
import 'package:habitt/util/colors.dart';

class ColorProvider extends ChangeNotifier {
  bool isTrueBlack = false;
  bool isTrueDarkGrey = false;
  bool isTrueGrey = false;

  Color _blackColor = AppColors.theAccentBlack;
  Color _darkGreyColor = AppColors.theDarkGrey;
  Color _greyColor = AppColors.theGrey;

  Color get blackColor => _blackColor;
  Color get darkGreyColor => _darkGreyColor;
  Color get greyColor => _greyColor;

  void updateDarkColor(bool value) {
    if (value) {
      _blackColor = AppColors.theBlack;
      _darkGreyColor = AppColors.theDarkGrey;
      _greyColor = AppColors.theGrey;
      isTrueBlack = true;
      isTrueDarkGrey = true;
      isTrueGrey = true;
    } else {
      _blackColor = AppColors.theAccentBlack;
      _darkGreyColor = AppColors.theAccentDarkGrey;
      _greyColor = AppColors.theAccentGrey;
      isTrueBlack = false;
      isTrueDarkGrey = false;
      isTrueGrey = false;
    }
    notifyListeners();
  }
}
