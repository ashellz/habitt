import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habitt/util/functions/validate_text.dart';

class ChangeUsernameWidget extends StatelessWidget {
  const ChangeUsernameWidget({
    super.key,
    required this.changeController,
    required this.formKey,
  });

  final TextEditingController changeController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: TextFormField(
          keyboardAppearance: Theme.of(context).brightness == Brightness.dark
              ? Brightness.dark
              : Brightness.light,
          validator: validateUsername,
          inputFormatters: [LengthLimitingTextInputFormatter(20)],
          cursorColor: Colors.white,
          cursorWidth: 2.0,
          cursorHeight: 22.0,
          cursorRadius: const Radius.circular(10.0),
          cursorOpacityAnimates: true,
          enableInteractiveSelection: true,
          controller: changeController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            labelStyle: const TextStyle(
                fontSize: 16.0,
                color: Colors.white38,
                fontWeight: FontWeight.bold),
            labelText: "NEW USERNAME",
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide(color: Colors.black),
            ),
            filled: true,
            fillColor: Colors.grey.shade900,
          ),
        ),
      ),
    );
  }
}
