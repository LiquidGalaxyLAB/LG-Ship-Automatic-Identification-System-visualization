import 'package:ais_visualizer/providers/AIS_connection_status_provider.dart';
import 'package:ais_visualizer/providers/filter_region_provider.dart';
import 'package:ais_visualizer/providers/lg_connection_status_provider.dart';
import 'package:ais_visualizer/providers/route_prediction_state_provider.dart';
import 'package:ais_visualizer/providers/route_tracker_state_provider.dart';
import 'package:ais_visualizer/providers/selected_kml_file_provider.dart';
import 'package:ais_visualizer/providers/selected_nav_item_provider.dart';
import 'package:ais_visualizer/providers/selected_vessel_provider.dart';
import 'package:ais_visualizer/providers/selected_types_provider.dart';
import 'package:ais_visualizer/providers/draw_on_map_provider.dart';
import 'package:ais_visualizer/screens/splash_screen.dart';
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
        ChangeNotifierProvider(create: (_) => SelectedKmlFileProvider()),
        ChangeNotifierProvider(create: (_) => RoutePredictionState()),
        ChangeNotifierProvider(create: (_) => SelectedTypesProvider()),
        ChangeNotifierProvider(create: (_) => DrawOnMapProvider()),
        ChangeNotifierProvider(create: (_) => FilterRegionProvider()),
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
      home: const SplashScreen(),
    );
  }
}
