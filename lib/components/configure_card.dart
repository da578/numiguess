import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numiguess/components/my_text_button.dart';

class ConfigureCard extends StatefulWidget {
  final ValueChanged<int> onStartGame;
  const ConfigureCard({super.key, required this.onStartGame});

  @override
  State<ConfigureCard> createState() => _ConfigureCardState();
}

class _ConfigureCardState extends State<ConfigureCard> {
  late final _controller = TextEditingController();
  late final screenWidth = MediaQuery.of(context).size.width;
  late final double horizontalPadding = screenWidth < 600 ? 20 : 50;
  final int minNumber = 10;
  final int maxNumber = 1000;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
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
      } else if (parsedValue < minNumber || parsedValue > maxNumber) {
        _errorMessage = 'The number must be between $minNumber - $maxNumber';
      } else {
        _errorMessage = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.onSurface.withAlpha(50)),
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
                        Icon(Icons.games_outlined, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Configure Your Game',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 23,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Set the maximum number for the game range.',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Maximum Number $minNumber - $maxNumber',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: colorScheme.onSurface.withAlpha(50),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: colorScheme.error,
                            width: 2,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: colorScheme.error,
                            width: 3,
                          ),
                        ),
      
                        errorText: _errorMessage,
                      ),
                      onChanged: _validateInput,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: constraints.maxWidth,
                      child: MyTextButton(
                        text: 'Start Game',
                        onPressed: _errorMessage == null
                            ? () {
                                final int? parsed = int.tryParse(
                                  _controller.text,
                                );
                                if (parsed != null) widget.onStartGame(parsed);
                              }
                            : null,
                        buttonType: MyTextButtonType.primary,
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
}
