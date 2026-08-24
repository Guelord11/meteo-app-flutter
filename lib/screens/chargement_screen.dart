import 'package:flutter/material.dart';
import 'package:meteo_app/models/meteo.dart';
import 'package:meteo_app/models/ville.dart';
import 'package:meteo_app/screens/detail_screen.dart';
import 'package:meteo_app/services/api_config.dart';
import 'package:meteo_app/services/meteo_service.dart';
import 'package:meteo_app/theme/app_theme.dart';
import 'package:meteo_app/widgets/bouton_theme.dart';
import 'package:meteo_app/widgets/erreur_widget.dart';
import 'package:meteo_app/widgets/jauge_widget.dart';
import 'package:meteo_app/widgets/message_attente.dart';
import 'package:meteo_app/widgets/tableau_meteo.dart';

/// Écran qui pilote le chargement séquentiel de la météo des 5 villes :
/// jauge de progression, messages d'attente, gestion des erreurs (avec
/// reprise là où ça s'est arrêté) puis tableau des résultats.
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
        final Meteo meteo =
            await service.chargerVille(villes[resultats.length]);
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

  void _ouvrirDetail(Ville ville, Meteo meteo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        // Le bouton retour doit ramener directement à l'accueil, quel que
        // soit l'écran. Depuis le détail, on intercepte donc le pop pour
        // dépiler jusqu'à la première route plutôt que de repasser par
        // l'écran de chargement.
        builder: (routeContext) => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              Navigator.of(routeContext).popUntil((route) => route.isFirst);
            }
          },
          child: DetailScreen(ville: ville, meteo: meteo),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chargement'),
        actions: const [BoutonTheme(), SizedBox(width: 8)],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: AppTheme.degrade(context)),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              children: [
                JaugeWidget(
                  progression: progression,
                  terminee: termine,
                  onRecommencer: recommencer,
                ),
                const SizedBox(height: 16),
                Text(
                  '${resultats.length} / ${villes.length} villes chargées',
                  style:
                      TextStyle(fontSize: 15, color: couleurs.onSurfaceVariant),
                ),
                if (enCours) ...[
                  const SizedBox(height: 20),
                  const MessageAttente(),
                ],
                if (erreur != null) ...[
                  const SizedBox(height: 20),
                  ErreurWidget(message: erreur!, onReessayer: _charger),
                ],
                if (termine) ...[
                  const SizedBox(height: 24),
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
