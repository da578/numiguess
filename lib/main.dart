import 'package:flutter/material.dart';
import 'package:numiguess/theme_provider.dart';
import 'package:numiguess/views/configure_view.dart';
import 'package:provider/provider.dart';
void main() => runApp(const Main());

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: Consumer<ThemeProvider>(
      builder: (_, themeProvider, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'SpaceGrotesk',
          colorScheme: ColorScheme.fromSeed(
            seedColor: themeProvider.seedColor,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: themeProvider.themeMode,
        home: const ConfigureView(),
      ),
    ),
  );
}
