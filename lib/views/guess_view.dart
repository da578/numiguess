import 'package:flutter/material.dart';
import 'package:numiguess/components/guess_card.dart';
import 'package:numiguess/components/my_app_bar.dart';
import 'package:numiguess/components/my_bottom_navigation_bar.dart';

class GuessView extends StatelessWidget {
  final int guessNumber;
  const GuessView({super.key, required this.guessNumber});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const MyAppBar(),
    body: GuessCard(
      guessNumber: guessNumber,
      onStartNewGame: () => Navigator.pop(context),
    ),
    bottomNavigationBar: const MyBottomNavigationBar(),
  );
}
