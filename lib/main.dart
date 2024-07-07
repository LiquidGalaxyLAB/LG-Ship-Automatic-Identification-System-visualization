import 'package:ais_visualizer/providers/AIS_connection_status_provider.dart';
import 'package:ais_visualizer/providers/lg_connection_status_provider.dart';
import 'package:ais_visualizer/providers/route_tracker_state_provider.dart';
import 'package:ais_visualizer/providers/selected_nav_item_provider.dart';
import 'package:ais_visualizer/providers/selected_vessel_provider.dart';
import 'package:ais_visualizer/screens/main_screen.dart';
import 'package:ais_visualizer/services/auth_service.dart';
import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:ais_visualizer/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  AuthService.removeToken();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LgConnectionStatusProvider()),
        ChangeNotifierProvider(create: (_) => SelectedVesselProvider()),
        ChangeNotifierProvider(create: (_) => RouteTrackerState()),
        ChangeNotifierProvider(create: (_) => AisConnectionStatusProvider()),
        ChangeNotifierProvider(create: (_) => SelectedNavItemProvider()),
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
