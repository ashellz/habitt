import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/provider/habit_provider.dart';
import 'package:habit_tracker/util/colors.dart';
import 'package:habit_tracker/util/objects/habit/add_tag.dart';
import 'package:habit_tracker/util/objects/habit/delete_tag.dart';
import 'package:provider/provider.dart';

class ChooseTag extends StatefulWidget {
  const ChooseTag({
    super.key,
    required this.isEdit,
  });

  final bool isEdit;

  @override
  State<ChooseTag> createState() => _ChooseTagState();
}

class _ChooseTagState extends State<ChooseTag> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 30,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            for (int i = 0; i < tagBox.length; i++)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => selectTag(i, context, widget.isEdit, setState),
                  onLongPress: () {
                    deleteTag(i, context, widget.isEdit, setState);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: habitTag == tagBox.getAt(i)!.tag
                            ? theOtherColor
                            : Colors.grey.shade900,
                      ),
                      height: 30,
                      child: Center(child: Text(tagBox.getAt(i)!.tag))),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  enableDrag: true,
                  builder: (context) => AddTagWidget(mystate: setState),
                ),
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: theDarkGrey,
                    ),
                    height: 30,
                    child: const Center(child: Text("+"))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

selectTag(int i, BuildContext context, bool isEdit, StateSetter setState) {
  setState(() {
    habitTag = tagBox.getAt(i)!.tag;
    if (!isEdit) {
      context.read<HabitProvider>().updateSomethingEdited();
    }
  });
}

void deleteTag(int i, BuildContext context, bool isEdit, StateSetter setState) {
  String? tempHabitTag = tagBox.getAt(i)!.tag;
  if (tagBox.getAt(i)!.tag != "No tag") {
    showDialog(
      context: context,
      builder: (context) => deleteTagWidget(i, context),
    ).then((value) {
      setState(() {
        if (habitTag == tempHabitTag.toString()) {
          habitTag = "No tag";
          if (!isEdit) {
            context.read<HabitProvider>().updateSomethingEdited();
          }
        }
      });
    });
  }
}
