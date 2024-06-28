import 'package:flutter/material.dart';

class elevatedButton extends StatelessWidget {
  final String text;

  const elevatedButton({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all<Size>(const Size(170, 45)),
        backgroundColor: WidgetStateProperty.all<Color>(
          const Color.fromARGB(255, 183, 181, 151),
        ),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }
}
