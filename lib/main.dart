import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meteo_app/screens/accueil_screen.dart';
import 'package:meteo_app/theme/app_theme.dart';
import 'package:meteo_app/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');
  runApp(const MeteoApp());
}

class MeteoApp extends StatelessWidget {
  const MeteoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Météo',
          theme: AppTheme.clair,
          darkTheme: AppTheme.sombre,
          themeMode: mode,
          debugShowCheckedModeBanner: false,
          home: const AccueilScreen(),
        );
      },
    );
  }
}
