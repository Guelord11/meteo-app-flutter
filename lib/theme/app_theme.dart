import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Thèmes clair et sombre de l'application, construits à partir d'une même
/// couleur graine afin de garder une identité visuelle cohérente entre les
/// deux modes.
class AppTheme {
  AppTheme._();

  static const Color _graine = Color(0xFF3D7EFF);

  static ThemeData get clair => _construire(
        ColorScheme.fromSeed(
          seedColor: _graine,
          brightness: Brightness.light,
        ),
      );

  static ThemeData get sombre => _construire(
        ColorScheme.fromSeed(
          seedColor: _graine,
          brightness: Brightness.dark,
        ),
      );

  static ThemeData _construire(ColorScheme couleurs) {
    final TextTheme texte = GoogleFonts.dmSansTextTheme(
      ThemeData(brightness: couleurs.brightness).textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: couleurs,
      scaffoldBackgroundColor: couleurs.surface,
      textTheme: texte,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: couleurs.onSurface,
        elevation: 0,
        // L'AppBar deduit la couleur des icones systeme (heure, batterie,
        // reseau) de sa couleur de fond. Celle-ci etant transparente, Flutter
        // l'estime sombre et choisit des icones blanches, invisibles en mode
        // clair : on impose donc le style correspondant au theme.
        systemOverlayStyle: couleurs.brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        titleTextStyle: texte.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: couleurs.onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: couleurs.primary,
          foregroundColor: couleurs.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: texte.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Dégradé de fond commun à tous les écrans, adapté au thème courant.
  static LinearGradient degrade(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        couleurs.primary.withValues(alpha: .16),
        couleurs.surface,
      ],
    );
  }
}
