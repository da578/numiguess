import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:numiguess/theme_provider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  static const Map<String, Color> _availableColors = {
    'Red': Colors.red,
    'Orange': Colors.orange,
    'Yellow': Colors.yellow,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Indigo': Colors.indigo,
    'Purple': Colors.purple,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loadedSeedColor = themeProvider.seedColor;
    Color? displayColor;

    displayColor ??= _availableColors.values.firstWhere(
      (color) => color.toARGB32() == loadedSeedColor.toARGB32(),
      orElse: () => Colors.blue,
    );

    void onChanged(Color? seedColor) {
      if (seedColor != null) {
        Provider.of<ThemeProvider>(
          context,
          listen: false,
        ).setSeedColor(seedColor);
      }
    }

    return AppBar(
      title: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          'NumiGuess',
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
            fontSize: 30,
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<Color>(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: colorScheme.onSurface,
            items: _availableColors.entries
                .map(
                  (entry) => DropdownMenuItem<Color>(
                    value: entry.value,
                    child: Text(entry.key),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            value: displayColor,
            underline: const SizedBox(),
            icon: const SizedBox(),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
