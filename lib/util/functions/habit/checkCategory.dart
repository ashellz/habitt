String checkCategory(String category) {
  if (category == "Morning") {
    return "Morning";
  } else if (category == "Afternoon") {
    return "Afternoon";
  } else if (category == "Evening") {
    return "Evening";
  } else if (category == "Any time") {
    return "Any time";
  }
  return "";
}
