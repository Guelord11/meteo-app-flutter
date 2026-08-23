// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meteo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meteo _$MeteoFromJson(Map<String, dynamic> json) => Meteo(
  ville: json['name'] as String,
  coord: Coordonnees.fromJson(json['coord'] as Map<String, dynamic>),
  weather: (json['weather'] as List<dynamic>)
      .map((e) => Condition.fromJson(e as Map<String, dynamic>))
      .toList(),
  main: Mesures.fromJson(json['main'] as Map<String, dynamic>),
  wind: Vent.fromJson(json['wind'] as Map<String, dynamic>),
  dt: (json['dt'] as num).toInt(),
);

Map<String, dynamic> _$MeteoToJson(Meteo instance) => <String, dynamic>{
  'name': instance.ville,
  'coord': instance.coord,
  'weather': instance.weather,
  'main': instance.main,
  'wind': instance.wind,
  'dt': instance.dt,
};

Coordonnees _$CoordonneesFromJson(Map<String, dynamic> json) => Coordonnees(
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
);

Map<String, dynamic> _$CoordonneesToJson(Coordonnees instance) =>
    <String, dynamic>{'lat': instance.lat, 'lon': instance.lon};

Condition _$ConditionFromJson(Map<String, dynamic> json) => Condition(
  main: json['main'] as String,
  description: json['description'] as String,
  icon: json['icon'] as String,
);

Map<String, dynamic> _$ConditionToJson(Condition instance) => <String, dynamic>{
  'main': instance.main,
  'description': instance.description,
  'icon': instance.icon,
};

Mesures _$MesuresFromJson(Map<String, dynamic> json) => Mesures(
  temp: (json['temp'] as num).toDouble(),
  ressenti: (json['feels_like'] as num).toDouble(),
  tempMin: (json['temp_min'] as num).toDouble(),
  tempMax: (json['temp_max'] as num).toDouble(),
  pressure: (json['pressure'] as num).toInt(),
  humidity: (json['humidity'] as num).toInt(),
);

Map<String, dynamic> _$MesuresToJson(Mesures instance) => <String, dynamic>{
  'temp': instance.temp,
  'feels_like': instance.ressenti,
  'temp_min': instance.tempMin,
  'temp_max': instance.tempMax,
  'pressure': instance.pressure,
  'humidity': instance.humidity,
};

Vent _$VentFromJson(Map<String, dynamic> json) => Vent(
  speed: (json['speed'] as num).toDouble(),
  deg: (json['deg'] as num).toInt(),
);

Map<String, dynamic> _$VentToJson(Vent instance) => <String, dynamic>{
  'speed': instance.speed,
  'deg': instance.deg,
};
