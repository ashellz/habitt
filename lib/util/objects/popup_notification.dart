import 'package:flutter/material.dart';
import 'package:habitt/services/provider/color_provider.dart';
import 'package:provider/provider.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();

  factory NotificationManager() => _instance;

  NotificationManager._internal();

  OverlayEntry? _overlayEntry;

  void showNotification(BuildContext context, String message) {
    // If a notification is already visible, remove it first
    _removeNotification();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _SlidingNotification(message: message),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Hide the notification after 2 seconds
    Future.delayed(
        const Duration(seconds: 2, milliseconds: 500), _removeNotification);
  }

  void _removeNotification() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _SlidingNotification extends StatefulWidget {
  final String message;

  const _SlidingNotification({required this.message});

  @override
  _SlidingNotificationState createState() => _SlidingNotificationState();
}

class _SlidingNotificationState extends State<_SlidingNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: const Offset(0.0, 0.5),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.25, vertical: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
              color: context.watch<ColorProvider>().greyColor,
              borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.center,
          child: Text(
            widget.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
