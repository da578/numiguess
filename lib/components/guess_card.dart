import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numiguess/components/my_text_button.dart';
import 'package:numiguess/components/my_text_field.dart';

class GuessCard extends StatefulWidget {
  final int guessNumber;
  final VoidCallback? onStartNewGame;
  const GuessCard({super.key, required this.guessNumber, this.onStartNewGame});

  @override
  State<GuessCard> createState() => _GuessCardState();
}

class _GuessCardState extends State<GuessCard> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _controller = TextEditingController();
  late final screenWidth = MediaQuery.of(context).size.width;
  final _audioPlayer = AudioPlayer();
  late final double horizontalPadding = screenWidth < 600 ? 20 : 50;
  late int attempts;
  int minNumber = 1;
  String? _errorMessage;
  late int _targetNumber;
  String? _hintMessage;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  Future<void> _playSound(String soundFileName) async =>
      await _audioPlayer.play(AssetSource('sounds/$soundFileName'));

  void _resetGame() {
    setState(() {
      _targetNumber = Random().nextInt(widget.guessNumber) + 1;
      attempts = 0;
      _errorMessage = null;
      _hintMessage =
          'I\'ve picked a number between 1 and ${widget.guessNumber}. Make your guess!';
    });
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _validateInput(String value) {
    _errorMessage = null;
    int? parsedValue = int.tryParse(value);

    setState(() {
      if (value.isEmpty) {
        _errorMessage = 'Please enter a number.';
      } else if (parsedValue == null) {
        _errorMessage = 'The input is not a valid number';
      } else if (parsedValue < minNumber || parsedValue > widget.guessNumber) {
        _errorMessage =
            'The number is must be between $minNumber - ${widget.guessNumber}';
      }
    });
  }

  void _submitGuess() {
    _validateInput(_controller.text);
    setState(() {
      if (_errorMessage == null) {
        final int userGuess = int.parse(_controller.text);
        attempts++;

        if (userGuess == _targetNumber) {
          _hintMessage =
              'You guessed the number in $attempts attempt${attempts > 1 ? 's' : ''}!';
              _playSound('ding.mp3');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: _colorScheme.surface,
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 60,
                    color: _colorScheme.primary,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Congratulations!',
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _hintMessage ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: _colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: MyTextButton(
                      text: 'Play Again',
                      onPressed: () {
                        Navigator.of(context).pop();
                        _resetGame();
                      },
                      buttonType: MyTextButtonType.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
        _hintMessage = userGuess < _targetNumber
            ? 'Too low! Try a higher number.'
            : 'Too high! Try a lower number.';
            _playSound('wrong.mp3');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: _colorScheme.onSurface.withAlpha(50)),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(25),
            child: LayoutBuilder(
              builder: (_, constraints) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.question_mark_rounded,
                        color: _colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Guess the Number',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: _colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'A number has been picked between 1 and ${widget.guessNumber}. Good luck!',
                    style: TextStyle(color: _colorScheme.onSurface, fontSize: 15),
                  ),
                  const SizedBox(height: 25),
                  LayoutBuilder(
                    builder: (context, boxConstraints) {
                      if (boxConstraints.maxWidth < 500) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: _colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.list,
                                          color: _colorScheme.primary,
                                        ),
                                        const SizedBox(width: 5),
                                        Text.rich(
                                          TextSpan(
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: _colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: 'Attempts: ',
                                                style: TextStyle(),
                                              ),
                                              TextSpan(
                                                text: attempts.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: _colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.games_outlined,
                                    color: _colorScheme.primary,
                                  ),
                                  const SizedBox(width: 5),
                                  Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: _colorScheme.onSecondaryContainer,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Range: ',
                                          style: TextStyle(),
                                        ),
                                        TextSpan(
                                          text: '1 - ${widget.guessNumber}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            color: _colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(Icons.list, color: _colorScheme.primary),
                                    const SizedBox(width: 5),
                                    Text.rich(
                                      TextSpan(
                                        style: TextStyle(
                                          fontSize: 17,
                                          color:
                                              _colorScheme.onSecondaryContainer,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Attempts: ',
                                            style: TextStyle(),
                                          ),
                                          TextSpan(
                                            text: attempts.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.games_outlined,
                                    color: _colorScheme.primary,
                                  ),
                                  const SizedBox(width: 5),
                                  Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: _colorScheme.onSecondaryContainer,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Range: ',
                                          style: TextStyle(),
                                        ),
                                        TextSpan(
                                          text: '1 - ${widget.guessNumber}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 25),
                  Container(
                    decoration: BoxDecoration(
                      color: _colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.electric_bolt_rounded),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            _hintMessage ?? '',
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: _colorScheme.onSecondaryContainer,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Your Guess',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    errorMessage: _errorMessage,
                    onChanged: _validateInput,
                    labelText: 'Enter your guess',
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: constraints.maxWidth,
                    child: MyTextButton(
                      text: 'Submit Guess',
                      onPressed: _errorMessage == null ? _submitGuess : null,
                      buttonType: MyTextButtonType.primary,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: constraints.maxWidth,
                    child: MyTextButton(
                      text: 'Start New Game',
                      onPressed: widget.onStartNewGame,
                      buttonType: MyTextButtonType.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
