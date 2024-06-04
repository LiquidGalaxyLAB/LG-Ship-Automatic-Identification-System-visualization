import 'package:ais_visualizer/providers.dart/lg_connection_status_provider.dart';
import 'package:ais_visualizer/screens/main_screen.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:ais_visualizer/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LgConnectionStatusProvider()),
      ],
      child: const AISVisualizerApp(),
    ),
  );
}

class AISVisualizerApp extends StatelessWidget {
  const AISVisualizerApp({Key? key});

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
