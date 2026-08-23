import 'package:dio/dio.dart';
import 'package:meteo_app/models/meteo.dart';
import 'package:meteo_app/services/api_config.dart';
import 'package:retrofit/retrofit.dart';

part 'meteo_api.g.dart';

/// Interface Retrofit décrivant les appels à l'API OpenWeather.
@RestApi(baseUrl: ApiConfig.urlBase)
abstract class MeteoApi {
  factory MeteoApi(Dio dio, {String baseUrl}) = _MeteoApi;

  @GET('/weather')
  Future<Meteo> meteoParCoordonnees({
    @Query('lat') required double latitude,
    @Query('lon') required double longitude,
    @Query('appid') required String cle,
    @Query('units') String unites = 'metric',
    @Query('lang') String langue = 'fr',
  });
}
