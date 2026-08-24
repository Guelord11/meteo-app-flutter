import 'package:flutter/material.dart';
import 'package:meteo_app/models/ville.dart';
import 'package:meteo_app/screens/chargement_screen.dart';
import 'package:meteo_app/theme/app_dimens.dart';
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
        actions: const [BoutonTheme(), SizedBox(width: 12)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MÉTÉO EN DIRECT · SÉNÉGAL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: couleurs.primary,
                ),
              ),
              const SizedBox(height: AppDimens.espaceS),
              Text(
                'Bienvenue',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: couleurs.onSurface,
                ),
              ),
              const SizedBox(height: AppDimens.espaceM),
              Text(
                'Nous récupérons la météo en direct de 5 villes, une par '
                'une, pour vous montrer la progression en temps réel.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: couleurs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimens.espaceXXL),
              Text(
                'VILLES SUIVIES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: couleurs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimens.espaceS),
              for (int i = 0; i < villes.length; i++) ...[
                _ligneVille(context, villes[i]),
                if (i != villes.length - 1)
                  Divider(
                    height: 1,
                    color: couleurs.outlineVariant.withValues(alpha: .5),
                  ),
              ],
              const SizedBox(height: AppDimens.espaceXXL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChargementScreen(),
                      ),
                    );
                  },
                  child: const Text("Lancer l'expérience"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ligneVille(BuildContext context, Ville ville) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(Icons.place_outlined, size: 18, color: couleurs.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              ville.nom,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: couleurs.onSurface,
              ),
            ),
          ),
          Text(
            ville.pays,
            style: TextStyle(fontSize: 13, color: couleurs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}