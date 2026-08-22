/// Configuration des services externes utilisés par l'application.
///
/// Les clés peuvent être surchargées au lancement sans modifier le code :
/// flutter run --dart-define=OPENWEATHER_API_KEY=xxxxx
class ApiConfig {
  static const String urlBase = 'https://api.openweathermap.org/data/2.5';

  static const String cleOpenWeather = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
    defaultValue: '66a28585dc74051145eb4287253ee1bc',
  );

  /// Intervalle entre deux appels API pendant le remplissage de la jauge.
  static const Duration intervalleAppels = Duration(seconds: 2);

  /// Intervalle de rotation des messages d'attente.
  static const Duration intervalleMessages = Duration(seconds: 3);
}
