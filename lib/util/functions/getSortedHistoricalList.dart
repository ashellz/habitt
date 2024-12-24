import 'package:habitt/pages/home/home_page.dart';

List getSortedHistoricalList() {
  var historicalList = historicalBox.values.toList();

  historicalList.sort((a, b) {
    DateTime dateA = a.date;
    DateTime dateB = b.date;
    return dateB.compareTo(dateA);
  }); // today is 0

  return historicalList;
}
