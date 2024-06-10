import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 211, 190),
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        toolbarHeight: 80.0,
        backgroundColor: const Color.fromARGB(255, 37, 67, 54),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
            child: Text(
              "Notifications",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 37, 67, 54),
                  padding: const EdgeInsets.all(10),
                ),
                onPressed: () {},
                child: const Text(
                  "Request notification access",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          ),
        ],
      ),
    );
  }
}
