import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Thèmes clair et sombre de l'application.
///
/// Palette pensée pour une appli météo plutôt que pour un tableau de bord
/// générique : un ambre solaire comme couleur graine, et un vert-bleu
/// (« baobab ») comme accent secondaire pour la jauge et quelques repères.
class AppTheme {
  AppTheme._();

  static const Color _graine = Color(0xFFE8A33D); // ambre solaire

  static const Color _accentClair = Color(0xFF2F8F80); // baobab
  static const Color _accentSombre = Color(0xFF3FB39F);

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
      dividerColor: couleurs.outlineVariant.withValues(alpha: .5),
      appBarTheme: AppBarTheme(
        backgroundColor: couleurs.surface,
        foregroundColor: couleurs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: texte.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: couleurs.onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: couleurs.primary,
          foregroundColor: couleurs.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: texte.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: texte.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: couleurs.onSurfaceVariant,
          letterSpacing: .4,
        ),
        dataTextStyle: texte.bodyMedium?.copyWith(color: couleurs.onSurface),
        dividerThickness: .6,
      ),
    );
  }


  static Color accentSecondaire(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? _accentSombre
        : _accentClair;
  }


  /// pas un dégradé décoratif appuyé. Conservé pour `detail_screen.dart`.
  static LinearGradient degrade(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        couleurs.primary.withValues(alpha: .05),
        couleurs.surface,
      ],
      stops: const [0, .35],
    );
  }
}