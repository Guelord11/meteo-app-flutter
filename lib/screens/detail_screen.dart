import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meteo_app/models/meteo.dart';
import 'package:meteo_app/models/ville.dart';
import 'package:meteo_app/theme/app_theme.dart';
import 'package:meteo_app/widgets/bouton_theme.dart';

class DetailScreen extends StatelessWidget {
  final Ville ville;
  final Meteo meteo;

  const DetailScreen({super.key, required this.ville, required this.meteo});

  LatLng get position => LatLng(meteo.coord.lat, meteo.coord.lon);

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(ville.nom),
        actions: const [BoutonTheme(), SizedBox(width: 8)],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(gradient: AppTheme.degrade(context)),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _entete(context),
                const SizedBox(height: 24),
                Text(
                  'Détails du relevé',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: couleurs.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _mesure(context, Icons.thermostat_rounded, 'Ressenti',
                        '${meteo.ressenti.round()} °C'),
                    _mesure(context, Icons.water_drop_outlined, 'Humidité',
                        '${meteo.humidite} %'),
                    _mesure(context, Icons.air_rounded, 'Vent',
                        '${meteo.vitesseVent.round()} km/h ${meteo.wind.direction}'),
                    _mesure(context, Icons.speed_rounded, 'Pression',
                        '${meteo.pression} hPa'),
                    _mesure(context, Icons.arrow_downward_rounded, 'Minimale',
                        '${meteo.temperatureMin.round()} °C'),
                    _mesure(context, Icons.arrow_upward_rounded, 'Maximale',
                        '${meteo.temperatureMax.round()} °C'),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Localisation sur Google Maps',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: couleurs.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 280,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: position,
                        zoom: 11,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId(ville.nom),
                          position: position,
                          infoWindow: InfoWindow(
                            title: ville.nom,
                            snippet:
                                '${meteo.temperature.round()} °C · ${meteo.condition.libelle}',
                          ),
                        ),
                      },
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Latitude ${meteo.coord.lat.toStringAsFixed(4)} · '
                  'Longitude ${meteo.coord.lon.toStringAsFixed(4)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: couleurs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _entete(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: meteo.couleur.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: meteo.couleur.withValues(alpha: .35)),
      ),
      child: Column(
        children: [
          Icon(meteo.icone, size: 76, color: meteo.couleur),
          const SizedBox(height: 12),
          Text(
            '${meteo.temperature.round()} °C',
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: couleurs.onSurface,
            ),
          ),
          Text(
            meteo.condition.libelle,
            style: TextStyle(fontSize: 18, color: couleurs.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          Text(
            '${ville.nom}, ${ville.pays}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: couleurs.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Relevé du ${DateFormat('d MMMM yyyy à HH:mm', 'fr_FR').format(meteo.releveLe)}',
            style: TextStyle(fontSize: 13, color: couleurs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _mesure(
    BuildContext context,
    IconData icone,
    String libelle,
    String valeur,
  ) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: couleurs.surfaceContainerHighest.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: couleurs.outlineVariant),
      ),
      child: Column(
        // Alignement en haut : sans cela, une valeur sur deux lignes (le vent
        // et sa direction) decale son libelle par rapport a la carte voisine.
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, size: 18, color: couleurs.primary),
              const SizedBox(width: 6),
              Text(
                libelle,
                style: TextStyle(
                  fontSize: 13,
                  color: couleurs.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            valeur,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: couleurs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
