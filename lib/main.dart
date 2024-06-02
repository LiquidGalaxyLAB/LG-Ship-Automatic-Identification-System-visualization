import 'package:ais_visualizer/screens/main_screen.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:ais_visualizer/utils/theme/theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      title: AppTexts.appName,
      home: const MainScreen(),
    );
  }
}
