import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:habitt/data/app_locale.dart';
import 'package:habitt/pages/habit/icons_page.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:habitt/services/provider/habit_provider.dart';
import 'package:habitt/util/colors.dart';
import 'package:habitt/util/functions/validate_text.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HabitNameTextField extends StatefulWidget {
  HabitNameTextField({
    super.key,
    required this.controller,
    required this.isEdit,
  });

  TextEditingController controller = TextEditingController();
  final bool isEdit;

  @override
  State<HabitNameTextField> createState() => _HabitNameTextFieldState();
}

class _HabitNameTextFieldState extends State<HabitNameTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 15),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        keyboardAppearance: Theme.of(context).brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light,
        onChanged: (value) {
          if (widget.isEdit) {
            context.read<HabitProvider>().updateSomethingEdited();
            Provider.of<HabitProvider>(context, listen: false)
                .updateAppearenceEdited();
          }
        },
        onSaved: (newValue) {
          widget.controller.text = newValue!;
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(35),
        ],
        cursorColor: Colors.white,
        cursorWidth: 2.0,
        cursorHeight: 22.0,
        cursorRadius: const Radius.circular(10.0),
        cursorOpacityAnimates: true,
        enableInteractiveSelection: true,
        validator: validateText,
        controller: widget.controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          labelStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.theLightColor),
          labelText: AppLocale.habitName.getString(context),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.black),
          ),
          hintStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: context.watch<ColorProvider>().greyColor,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IconsPage(),
                  ),
                );
              },
              icon: context.watch<HabitProvider>().updatedIcon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
