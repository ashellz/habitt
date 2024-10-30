bool historicalHasHabits(category, habitsOnDate, habitListLength) {
  for (int i = 0; i < habitListLength; i++) {
    if (habitsOnDate[i].category == category && !habitsOnDate[i].task) {
      return true;
    }
  }
  return false;
}
