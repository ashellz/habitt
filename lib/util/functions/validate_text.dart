import 'package:flutter/services.dart';
import 'package:habitt/pages/home/home_page.dart';

String? validateUsername(String? value) {
  if (value?.isEmpty ?? true) {
    return 'This field cannot be empty';
  } else if (value == null || value.trim().isEmpty) {
    return 'Input cannot be just spaces';
  } else if (value.length < 2) {
    return 'Username must be at least 2 characters long';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value?.isEmpty ?? true) {
    return 'This field cannot be empty';
  } else if (value == null || value.trim().isEmpty) {
    return 'Input cannot be just spaces';
  } else if (!value.contains("@") || !value.contains(".")) {
    return 'The email is invalid';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value?.isEmpty ?? true) {
    return 'This field cannot be empty';
  } else if (value == null || value.trim().isEmpty) {
    return 'Input cannot be just spaces';
  } else if (value.length < 6) {
    return 'Password must be at least 6 characters long';
  } else if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase character';
  } else if (!value.contains(RegExp(r'[a-z]'))) {
    return 'Password must contain at least one lowercase character';
  } else if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one digit';
  }
  return null;
}

String? validatePasswordLogin(String? value) {
  if (value?.isEmpty ?? true) {
    return 'This field cannot be empty';
  } else if (value == null || value.trim().isEmpty) {
    return 'Input cannot be just spaces';
  }
  return null;
}

String? validateAmount(String? value) {
  if (value?.isEmpty ?? true) {
    return 'Please enter a number';
  } else if (value == null || value.trim().isEmpty) {
    return 'Please enter a number';
  } else if (int.parse(value) < 2) {
    return 'Please enter a number greater than 1';
  }
  return null;
}

String? validateText(String? value) {
  if (value?.isEmpty ?? true) {
    return 'Please enter some text';
  } else if (value == null || value.trim().isEmpty) {
    return 'Input cannot be just spaces';
  }
  return null;
}

String? validateTag(String? value) {
  bool tagAlreadyExists = false;

  for (int i = 0; i < tagBox.length; i++) {
    if (value == tagBox.getAt(i)?.tag) {
      tagAlreadyExists = true;
    }
  }

  if (value?.isEmpty ?? true) {
    return 'Please enter some text';
  } else if (value == null || value.trim().isEmpty) {
    return 'Input cannot be just spaces';
  } else if (tagAlreadyExists) {
    return 'A tag with that name already exists';
  }
  return null;
}

class LowerCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
