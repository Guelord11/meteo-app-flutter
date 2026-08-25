import 'package:flutter/material.dart';
import 'package:meteo_app/theme/theme_controller.dart';

/// Bouton qui bascule entre thème clair et sombre, avec une icône
/// soleil / lune animée.
///
/// S'abonne lui-même à [ThemeController.mode] via un [ValueListenableBuilder]
/// : indispensable car ce widget est instancié en `const` dans une
/// [AppBar], et Flutter ne rappelle alors jamais `build()` tout seul.
class BoutonTheme extends StatelessWidget {
  const BoutonTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, mode, _) {
        final ColorScheme couleurs = Theme.of(context).colorScheme;
        final bool sombre = mode == ThemeMode.dark;

        return IconButton(
          tooltip:
              sombre ? 'Passer au thème clair' : 'Passer au thème sombre',
          onPressed: ThemeController.basculer,
          style: IconButton.styleFrom(
            backgroundColor:
                couleurs.surfaceContainerHighest.withValues(alpha: .6),
            foregroundColor: couleurs.onSurface,
          ),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) => RotationTransition(
              turns: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Icon(
              sombre ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              key: ValueKey<bool>(sombre),
              size: 20,
            ),
          ),
        );
      },
    );
  }
}