import 'package:flutter/material.dart';

enum MyTextButtonType { primary, secondary, alert }

class MyTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final MyTextButtonType buttonType;

  const MyTextButton({
    super.key,
    this.onPressed,
    required this.text,
    this.buttonType = MyTextButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide = BorderSide.none;

    switch (buttonType) {
      case MyTextButtonType.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        break;
      case MyTextButtonType.secondary:
        backgroundColor = colorScheme.surface;
        foregroundColor = colorScheme.onSurface;
        borderSide = BorderSide(color: colorScheme.onSurface.withAlpha(50));
        break;
      case MyTextButtonType.alert:
        backgroundColor =
            colorScheme.error; // Use error color for alert buttons
        foregroundColor = colorScheme.onError;
        break;
    }

    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        foregroundColor: WidgetStatePropertyAll(foregroundColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: borderSide,
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.fade,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}
