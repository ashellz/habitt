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

1. Remove all spaces placed in front and the end of an input

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
25. Reset amount name after a habit is created
26. Fix only spacebars as habit name
27. Limit characters to 10 in naming the amount
28. Display minute if it's only 1 minute instead of minutes
29. Editing normal habits bring duration to 1 as default, fix so nothing apepars
30. Check if amount name is empty or just spaces
31. Redesign the app
32. Don't display the home page until all the data is downloaded when first ever launching the app

Add Features:

# Add how many times to complete the habit (the quantity of the habit).

# In the database file of a habit add a quantity field as of int (default: 1).

# When completing the habit with a quantity more than 1 you will be given more slideable options, or at least a dialog box to enter if you've done the habit that many times (default: max amount)

# Add a new field left to the completion icon displaying how many times you've done the habit out of the specified amount

# Add how long to do the task.

# In the database file of a habit add a time field as an int (default: 0).

# Add a new field left to the completion icon displaying how long you've done the habit for compared to the specified amount of time

# When creating the habit make the user choose between creating a task based on time goal or amount goal.

# Make new amount and duration features editable within a habit

Add cookie icon
Add chef top icon
Add bell icon
Add a feature so a user can edit completion values of habits the last 5 days

# Add animations

# Add notifications

# At the bottom of menu drawer add profile username and signout option

# If user is signed in, display home page right away

# Fix some bugs along the way

Add weekly habits

- Complete them 1 to 6 times a week
- Make the user select how many times a week to do it (the exact days don't matter for now)

# - Make it so the user can skip the habit for the day in the home page

- Streaks update every time the habit is done at the end of the day, it won't be reset until there are no more days in the week left for the habit to be completed that many times
- If the user decides to complete the habit more times a week than specified, the streak will go up
- All habits completed streak will grow wether the weekly habit has been done or no, except if there are no more days left for the habit to be completed that many times a week

# - Add a field above the main category to choose which category to display specifiacally, add tags + ability to create custom tags and display them on the field

# - Add ability to delete tags

# - Add vibration when habit is completed

# - Add sound when all habits are completed and a longer vibration

# - Add vibration when completing a part of the habit (vibration for each number change)

# - Add an option to disable haptic feedback

- Add more color options
- Add more languages

# - Add so user can swipe left or right on the screen to switch which tag to display

How to center tag display:
Get tag number, compare it to previous tag, scroll to the side of the current tag comparing to the previous tag:

- scroll by number of letters for each tag button in between and how many buttons there are
- use the calculation to get width of buttons and scroll to the side by that amount of width

Feature to add:

# - custom notifications for each habit
# - each habit has a new List field called notifications
# - in checkForNotifications() add for loop for checking every habit if it has a notification to true, if it does then its gonna go through a for loop in notificationData to find all notifications wiht the same id and schedule them for hour and minute
- add more notification texts for morning, afternoon, evening and daily, and make it randomly pick one of them for each time
- also add a couple diferent notification texts for the custom notification text for each habit


Later in the app add tasks page too where you will have tasks you can do once in a certain day (it will reward you with coins)
- all tasks that are completed or not completed will be put into history that you can see but not interact with
- all the task names will be saved and when creating a new task given as an option to choose that name using an algorithm