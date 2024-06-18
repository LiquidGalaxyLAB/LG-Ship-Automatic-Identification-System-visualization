import 'package:ais_visualizer/providers/lg_connection_status_provider.dart';
import 'package:ais_visualizer/providers/selected_vessel_provider.dart';
import 'package:ais_visualizer/screens/main_screen.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:ais_visualizer/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LgConnectionStatusProvider()),
        ChangeNotifierProvider(create: (_) => SelectedVesselProvider()),
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
