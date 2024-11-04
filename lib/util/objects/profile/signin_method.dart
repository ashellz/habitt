import 'package:flutter/material.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:provider/provider.dart';

class SignInMethod extends StatelessWidget {
  const SignInMethod({
    super.key,
    required this.icon,
    required this.signInFunction,
  });

  final IconData icon;
  final Future<void> Function(BuildContext context) signInFunction;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: const EdgeInsets.all(30),
        onPressed: () async {
          await signInFunction(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: context.watch<ColorProvider>().greyColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
        icon: Icon(icon, color: Colors.white38, size: 100));
  }
}
