import 'package:flutter/material.dart';
import 'package:meteo_app/models/meteo.dart';
import 'package:meteo_app/models/ville.dart';
import 'package:meteo_app/screens/detail_screen.dart';
import 'package:meteo_app/services/api_config.dart';
import 'package:meteo_app/services/meteo_service.dart';
import 'package:meteo_app/theme/app_dimens.dart';
import 'package:meteo_app/widgets/bouton_theme.dart';
import 'package:meteo_app/widgets/erreur_widget.dart';
import 'package:meteo_app/widgets/jauge_widget.dart';
import 'package:meteo_app/widgets/message_attente.dart';
import 'package:meteo_app/widgets/tableau_meteo.dart';

class ChargementScreen extends StatefulWidget {
  const ChargementScreen({super.key});

  @override
  State<ChargementScreen> createState() => _ChargementScreenState();
}

class _ChargementScreenState extends State<ChargementScreen> {
  final MeteoService service = MeteoService();
  final List<Ville> villes = Ville.villeList();
  final List<Meteo> resultats = [];
  String? erreur;
  bool enCours = false;

  double get progression => resultats.length / villes.length;
  bool get termine => resultats.length == villes.length;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  /// Charge les villes restantes une par une. En cas d'erreur, la boucle
  /// s'arrête et un nouvel appel à `_charger()` (via le bouton Réessayer)
  /// reprendra à `villes[resultats.length]`, sans repartir de zéro.
  Future<void> _charger() async {
    setState(() {
      erreur = null;
      enCours = true;
    });

    while (resultats.length < villes.length) {
      await Future.delayed(ApiConfig.intervalleAppels);
      if (!mounted) return;

      try {
        final Meteo meteo = await service.chargerVille(
          villes[resultats.length],
        );
        if (!mounted) return;
        setState(() {
          resultats.add(meteo);
        });
      } on MeteoException catch (e) {
        if (!mounted) return;
        setState(() {
          erreur = e.message;
          enCours = false;
        });
        return;
      }
    }

    if (!mounted) return;
    setState(() {
      enCours = false;
    });
  }

  void recommencer() {
    setState(() {
      resultats.clear();
      erreur = null;
    });
    _charger();
  }

  /// Ouvre le détail d'une ville. Le retour repose sur la pile de navigation
  /// standard : il ramène au tableau, dont les résultats sont conservés dans
  /// l'état de cet écran, puis à l'accueil. On peut ainsi consulter plusieurs
  /// villes sans relancer le chargement.
  void _ouvrirDetail(Ville ville, Meteo meteo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(ville: ville, meteo: meteo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relevé météo'),
        actions: const [BoutonTheme(), SizedBox(width: 12)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                JaugeWidget(
                  progression: progression,
                  terminee: termine,
                  onRecommencer: recommencer,
                ),
                const SizedBox(height: AppDimens.espaceL),
                Text(
                  '${resultats.length} / ${villes.length} villes chargées',
                  style: TextStyle(
                    fontSize: 14,
                    color: couleurs.onSurfaceVariant,
                  ),
                ),
                if (enCours) ...[
                  const SizedBox(height: AppDimens.espaceXL),
                  const MessageAttente(),
                ],
                if (erreur != null) ...[
                  const SizedBox(height: AppDimens.espaceXL),
                  ErreurWidget(message: erreur!, onReessayer: _charger),
                ],
                if (termine) ...[
                  const SizedBox(height: AppDimens.espaceXXL),
                  TableauMeteo(
                    villes: villes,
                    meteos: resultats,
                    onSelection: _ouvrirDetail,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
