import 'package:flutter/material.dart';
import 'package:numiguess/components/configure_card.dart';
import 'package:numiguess/components/my_app_bar.dart';
import 'package:numiguess/components/my_bottom_navigation_bar.dart';
import 'package:numiguess/views/guess_view.dart';

class ConfigureView extends StatelessWidget {
  const ConfigureView({super.key});

  @override
  Widget build(BuildContext context) {
    void startGame(int maxNumber) => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GuessView(guessNumber: maxNumber)),
    );

    return Scaffold(
      appBar: const MyAppBar(),
      body: ConfigureCard(onStartGame: startGame),
      bottomNavigationBar: const MyBottomNavigationBar()
    );
  }
}
