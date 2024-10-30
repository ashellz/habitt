import 'package:flutter/material.dart';
import 'package:habitt/pages/home/home_page.dart';
import 'package:habitt/util/colors.dart';

class ColorProvider extends ChangeNotifier {
  bool isTrueBlack = boolBox.get('blackColor')!;
  bool isTrueDarkGrey = boolBox.get('blackColor')!;
  bool isTrueGrey = boolBox.get('blackColor')!;

  Color _blackColor = boolBox.get('blackColor')!
      ? AppColors.theBlack
      : AppColors.theAccentBlack;
  Color _darkGreyColor = boolBox.get('blackColor')!
      ? AppColors.theDarkGrey
      : AppColors.theAccentDarkGrey;
  Color _greyColor =
      boolBox.get('blackColor')! ? AppColors.theGrey : AppColors.theAccentGrey;

  Color get blackColor => _blackColor;
  Color get darkGreyColor => _darkGreyColor;
  Color get greyColor => _greyColor;

  void updateDarkColor(bool value) {
    boolBox.put('blackColor', value);
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
