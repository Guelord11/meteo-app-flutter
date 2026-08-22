import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meteo.g.dart';

/// Réponse de l'endpoint `/data/2.5/weather` d'OpenWeather.
@JsonSerializable()
class Meteo {
  @JsonKey(name: 'name')
  final String ville;
  final Coordonnees coord;
  final List<Condition> weather;
  final Mesures main;
  final Vent wind;
  final int dt;

  Meteo({
    required this.ville,
    required this.coord,
    required this.weather,
    required this.main,
    required this.wind,
    required this.dt,
  });

  factory Meteo.fromJson(Map<String, dynamic> json) => _$MeteoFromJson(json);

  Map<String, dynamic> toJson() => _$MeteoToJson(this);

  Condition get condition => weather.first;

  double get temperature => main.temp;

  double get ressenti => main.ressenti;

  double get temperatureMin => main.tempMin;

  double get temperatureMax => main.tempMax;

  int get humidite => main.humidity;

  int get pression => main.pressure;

  double get vitesseVent => wind.speed * 3.6; // m/s converti en km/h

  DateTime get releveLe => DateTime.fromMillisecondsSinceEpoch(dt * 1000);

  /// Icône Material associée à la condition, pour rester lisible hors ligne.
  IconData get icone {
    switch (condition.main) {
      case 'Clear':
        return Icons.wb_sunny_rounded;
      case 'Clouds':
        return Icons.cloud_rounded;
      case 'Rain':
      case 'Drizzle':
        return Icons.grain_rounded;
      case 'Thunderstorm':
        return Icons.flash_on_rounded;
      case 'Snow':
        return Icons.ac_unit_rounded;
      default:
        return Icons.foggy;
    }
  }

  Color get couleur {
    switch (condition.main) {
      case 'Clear':
        return Colors.orange;
      case 'Clouds':
        return Colors.blueGrey;
      case 'Rain':
      case 'Drizzle':
        return Colors.blue;
      case 'Thunderstorm':
        return Colors.deepPurple;
      case 'Snow':
        return Colors.lightBlue;
      default:
        return Colors.teal;
    }
  }
}

@JsonSerializable()
class Coordonnees {
  final double lat;
  final double lon;

  Coordonnees({required this.lat, required this.lon});

  factory Coordonnees.fromJson(Map<String, dynamic> json) =>
      _$CoordonneesFromJson(json);

  Map<String, dynamic> toJson() => _$CoordonneesToJson(this);
}

@JsonSerializable()
class Condition {
  final String main;
  final String description;
  final String icon;

  Condition({required this.main, required this.description, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);

  Map<String, dynamic> toJson() => _$ConditionToJson(this);

  /// « nuageux » -> « Nuageux »
  String get libelle =>
      description.isEmpty ? description : description[0].toUpperCase() + description.substring(1);
}

@JsonSerializable()
class Mesures {
  final double temp;

  @JsonKey(name: 'feels_like')
  final double ressenti;

  @JsonKey(name: 'temp_min')
  final double tempMin;

  @JsonKey(name: 'temp_max')
  final double tempMax;

  final int pressure;
  final int humidity;

  Mesures({
    required this.temp,
    required this.ressenti,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory Mesures.fromJson(Map<String, dynamic> json) => _$MesuresFromJson(json);

  Map<String, dynamic> toJson() => _$MesuresToJson(this);
}

@JsonSerializable()
class Vent {
  final double speed;
  final int deg;

  Vent({required this.speed, required this.deg});

  factory Vent.fromJson(Map<String, dynamic> json) => _$VentFromJson(json);

  Map<String, dynamic> toJson() => _$VentToJson(this);

  /// Direction cardinale déduite de l'angle renvoyé par l'API.
  String get direction {
    const points = ['Nord', 'Nord-Est', 'Est', 'Sud-Est', 'Sud', 'Sud-Ouest', 'Ouest', 'Nord-Ouest'];
    return points[(((deg % 360) / 45).round()) % 8];
  }
}
