import 'package:flutter/material.dart';
import 'package:meteo_app/models/ville.dart';
import 'package:meteo_app/screens/chargement_screen.dart';
import 'package:meteo_app/theme/app_theme.dart';
import 'package:meteo_app/widgets/bouton_theme.dart';

/// Écran d'accueil : présentation de l'expérience et des villes suivies.
class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;
    final List<Ville> villes = Ville.villeList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Météo'),
        actions: const [BoutonTheme(), SizedBox(width: 8)],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: AppTheme.degrade(context)),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.wb_cloudy_rounded, size: 72, color: couleurs.primary),
                const SizedBox(height: 20),
                Text(
                  'Bienvenue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: couleurs.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Nous allons récupérer la météo en direct de 5 villes du '
                  'Sénégal, une par une, pour vous montrer la progression '
                  'en temps réel.',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 15, color: couleurs.onSurfaceVariant),
                ),
                const SizedBox(height: 28),
                for (final Ville ville in villes) ...[
                  _carteVille(context, ville),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChargementScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text("Lancer l'expérience"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _carteVille(BuildContext context, Ville ville) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: couleurs.surfaceContainerHighest.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: couleurs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, color: couleurs.primary),
          const SizedBox(width: 12),
          Text(
            ville.nom,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: couleurs.onSurface,
            ),
          ),
          const Spacer(),
          Text(
            ville.pays,
            style: TextStyle(fontSize: 13, color: couleurs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
