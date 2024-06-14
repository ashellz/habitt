# habit_tracker

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Things to fix:

1. Change the way animations work
2. Redesign the app

Fixed things:

1. When a new habit is created, open the category it's created in
2. When a new habit is created, if the category is opened, update the height of the category
3. When a habit is edited to be in another category, update both categories heights (firstCategoryHeight -= 71, secondCategoryHeight += 71)
4. Habit name going into the second row
5. Apply 1 second delay to every category open and close
6. Hide categories with no habits
7. Change 1 second delay to half a second
8. Fix app freeze on start
9. When app is opened, open all the visible categories
10. Add a bed icon
11. Add an egg icon
12. Add a shower icon
13. Add a better book icon
14. Show a banner after a task is created, edited or deleted
15. When opening edit set dropdownvalue to category it's in, not any time
16. Add a laptop icon
17. Habit completion value changes every other day + streak
18. Add notifications
19. Fix design issues
20. When the app is launched for the first time ever, ask for notifications
21. Notify the user for category habits only if he has any habits in that category
22. FINALLY make notifications and streaks work
23. Make the streak number update right away when the habit is completed and undo if habit is undone
24. Implement Custom notifications feature
