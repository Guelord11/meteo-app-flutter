import 'package:flutter/material.dart';

/// Contrôleur global du thème de l'application (clair / sombre).
///
/// Statique et écoutable : n'importe quel widget peut s'abonner via un
/// [ValueListenableBuilder] pour se reconstruire dès que le thème change.
class ThemeController {
  ThemeController._();

  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  /// Alterne entre le mode clair et le mode sombre.
  static void basculer() {
    mode.value =
        mode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}
