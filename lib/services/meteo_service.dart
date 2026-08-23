import 'package:dio/dio.dart';
import 'package:meteo_app/models/meteo.dart';
import 'package:meteo_app/models/ville.dart';
import 'package:meteo_app/services/api_config.dart';
import 'package:meteo_app/services/meteo_api.dart';

/// Erreur métier remontée à l'interface, avec un message compréhensible.
class MeteoException implements Exception {
  final String message;

  MeteoException(this.message);

  @override
  String toString() => message;
}

class MeteoService {
  final MeteoApi _api;

  MeteoService({Dio? dio})
      : _api = MeteoApi(
          dio ??
              Dio(
                BaseOptions(
                  connectTimeout: const Duration(seconds: 10),
                  receiveTimeout: const Duration(seconds: 10),
                ),
              ),
        );

  Future<Meteo> chargerVille(Ville ville) async {
    if (ApiConfig.cleOpenWeather == 'A_REMPLACER') {
      throw MeteoException(
        'Clé OpenWeather absente. Renseignez-la dans lib/services/api_config.dart.',
      );
    }

    try {
      return await _api.meteoParCoordonnees(
        latitude: ville.latitude,
        longitude: ville.longitude,
        cle: ApiConfig.cleOpenWeather,
      );
    } on DioException catch (erreur) {
      throw MeteoException(_message(erreur, ville));
    }
  }

  String _message(DioException erreur, Ville ville) {
    switch (erreur.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Le serveur météo met trop de temps à répondre.';
      case DioExceptionType.connectionError:
        return 'Aucune connexion internet. Vérifiez votre réseau puis réessayez.';
      case DioExceptionType.badResponse:
        if (erreur.response?.statusCode == 401) {
          return 'Clé API OpenWeather invalide ou pas encore activée.';
        }
        if (erreur.response?.statusCode == 429) {
          return 'Trop de requêtes envoyées à OpenWeather. Patientez un instant.';
        }
        return 'Le serveur a répondu ${erreur.response?.statusCode} pour ${ville.nom}.';
      default:
        return 'Impossible de récupérer la météo de ${ville.nom}.';
    }
  }
}
