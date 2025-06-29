import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Text(
          '© 2025 NumiGuess by DA-578',
          textAlign: TextAlign.center,
          style: TextStyle(color: colorScheme.primary),
        ),
      );
  }
}