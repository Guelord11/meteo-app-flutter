import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_app/models/meteo.dart';
import 'package:meteo_app/models/ville.dart';

/// Réponse réelle de l'API OpenWeather pour Dakar, utilisée comme référence.
const Map<String, dynamic> reponseDakar = {
  'coord': {'lon': -17.4467, 'lat': 14.6928},
  'weather': [
    {'id': 801, 'main': 'Clouds', 'description': 'peu nuageux', 'icon': '02d'}
  ],
  'main': {
    'temp': 31.25,
    'feels_like': 38.25,
    'temp_min': 31.25,
    'temp_max': 32.07,
    'pressure': 1013,
    'humidity': 79,
  },
  'wind': {'speed': 4.12, 'deg': 140},
  'dt': 1787416244,
  'name': 'Dakar',
};

void main() {
  group('Ville', () {
    test('la liste contient les 5 villes attendues', () {
      expect(Ville.villeList().length, 5);
    });

    test('chaque ville possède des coordonnées valides', () {
      for (final Ville ville in Ville.villeList()) {
        expect(ville.nom, isNotEmpty);
        expect(ville.latitude, inInclusiveRange(-90, 90));
        expect(ville.longitude, inInclusiveRange(-180, 180));
      }
    });
  });

  group('Meteo', () {
    final Meteo meteo = Meteo.fromJson(reponseDakar);

    test('désérialise correctement la réponse OpenWeather', () {
      expect(meteo.ville, 'Dakar');
      expect(meteo.temperature, 31.25);
      expect(meteo.ressenti, 38.25);
      expect(meteo.humidite, 79);
      expect(meteo.pression, 1013);
      expect(meteo.condition.description, 'peu nuageux');
    });

    test('met une majuscule au libellé de la condition', () {
      expect(meteo.condition.libelle, 'Peu nuageux');
    });

    test('convertit la vitesse du vent en km/h', () {
      expect(meteo.vitesseVent, closeTo(4.12 * 3.6, 0.001));
    });

    test('déduit la direction cardinale du vent', () {
      expect(Vent(speed: 4.12, deg: 140).direction, 'Sud-Est');
      expect(Vent(speed: 2.0, deg: 0).direction, 'Nord');
      expect(Vent(speed: 2.0, deg: 270).direction, 'Ouest');
    });
  });
}
