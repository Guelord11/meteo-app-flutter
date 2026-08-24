import 'package:flutter/material.dart';
import 'package:meteo_app/models/meteo.dart';
import 'package:meteo_app/models/ville.dart';

/// Tableau des résultats météo des villes chargées.
///
/// [villes] et [meteos] doivent avoir la même longueur et être alignés
/// index par index. La sélection d'une ligne remonte le couple
/// (Ville, Meteo) correspondant via [onSelection].
class TableauMeteo extends StatelessWidget {
  final List<Ville> villes;
  final List<Meteo> meteos;
  final void Function(Ville ville, Meteo meteo) onSelection;

  const TableauMeteo({
    super.key,
    required this.villes,
    required this.meteos,
    required this.onSelection,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: couleurs.surfaceContainerHighest.withValues(alpha: .35),
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          // Sans ça, DataTable ajoute automatiquement une colonne de cases à
          // cocher dès qu'une DataRow a un onSelectChanged.
          showCheckboxColumn: false,
          columnSpacing: 14,
          horizontalMargin: 16,
          headingRowColor: WidgetStateProperty.all(Colors.transparent),
          dataRowColor: WidgetStateProperty.all(Colors.transparent),
          columns: const [
            DataColumn(label: Text('Ville')),
            DataColumn(label: Text('Temp.'), numeric: true),
            DataColumn(label: Text('Hum.'), numeric: true),
            DataColumn(label: Text('Ciel')),
            DataColumn(label: Text('')),
          ],
          rows: List<DataRow>.generate(villes.length, (i) {
            final Ville ville = villes[i];
            final Meteo meteo = meteos[i];

            return DataRow(
              onSelectChanged: (_) => onSelection(ville, meteo),
              cells: [
                DataCell(Text(ville.nom)),
                DataCell(Text('${meteo.temperature.round()}°C')),
                DataCell(Text('${meteo.humidite}%')),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(meteo.icone, size: 18, color: meteo.couleur),
                      const SizedBox(width: 6),
                      // Les libellés OpenWeather vont de « Clair » à
                      // « Partiellement nuageux » : on borne plutôt que de
                      // rogner les marges pour ne pas faire déborder la ligne.
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 104),
                        child: Text(
                          meteo.condition.libelle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Icon(Icons.chevron_right_rounded,
                      size: 18, color: couleurs.onSurfaceVariant),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}