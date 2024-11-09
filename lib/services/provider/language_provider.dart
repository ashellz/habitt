import 'package:flutter/material.dart';
import 'package:habitt/main.dart';
import 'package:habitt/pages/home/home_page.dart';

class LanguageProvider extends ChangeNotifier {
  String _languageCode = 'en';

  String get languageCode => _languageCode;

  LanguageProvider() {
    loadLanguage();
  }

  // Load language from SharedPreferences
  Future<void> loadLanguage() async {
    _languageCode = stringBox.get('language') ?? 'en';
    localization.translate(_languageCode);
    notifyListeners();
  }

  // Change language and save to SharedPreferences
  Future<void> changeLanguage(String languageCode) async {
    _languageCode = languageCode;
    localization.translate(languageCode);
    notifyListeners();

    await stringBox.put('language', languageCode);
  }
}
