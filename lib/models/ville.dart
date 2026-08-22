class Ville {
  final String nom;
  final String pays;
  final double latitude;
  final double longitude;

  const Ville({
    required this.nom,
    required this.pays,
    required this.latitude,
    required this.longitude,
  });

  static List<Ville> villeList() {
    return const [
      Ville(nom: 'Dakar', pays: 'Sénégal', latitude: 14.6928, longitude: -17.4467),
      Ville(nom: 'Thiès', pays: 'Sénégal', latitude: 14.7910, longitude: -16.9256),
      Ville(nom: 'Saint-Louis', pays: 'Sénégal', latitude: 16.0179, longitude: -16.4896),
      Ville(nom: 'Ziguinchor', pays: 'Sénégal', latitude: 12.5665, longitude: -16.2733),
      Ville(nom: 'Touba', pays: 'Sénégal', latitude: 14.8500, longitude: -15.8833),
    ];
  }
}
