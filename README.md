# Météo App — Examen de Développement Mobile

Application Flutter qui relève la météo en temps réel de 5 villes du Sénégal via l'API
OpenWeather, affiche la progression du chargement dans une jauge animée, puis présente
les résultats dans un tableau interactif relié à Google Maps.

**L3 IAGE — ISI — Année 2026**

## Membres du groupe

| Membre | Rôle principal |
| --- | --- |
| **Guelord KANYAMANDA MUMBERE** | Données & réseau : modèles, interface Retrofit, service météo, gestion des erreurs, écran de détail et intégration Google Maps |
| **Aman SOULE** | Interface & animations : thèmes clair/sombre, écran d'accueil, jauge animée, messages d'attente, tableau interactif, navigation |

## Fonctionnalités

- **Écran d'accueil** : message de bienvenue, liste des villes suivies et bouton de lancement.
- **Écran principal** : jauge circulaire animée qui se remplit au fil des appels API (une ville
  toutes les 2 secondes), accompagnée de messages d'attente qui défilent en boucle.
- **Tableau interactif** : dès la jauge remplie, les 5 villes s'affichent avec température,
  humidité et condition du ciel. Chaque ligne est cliquable.
- **Page de détail** : relevé complet (ressenti, min/max, humidité, pression, vent et sa
  direction) et localisation exacte de la ville sur une carte Google Maps.
- **Gestion des erreurs** : en cas d'échec d'un appel, un message explicite s'affiche avec un
  bouton *Réessayer* qui reprend le chargement là où il s'était arrêté.
- **Mode clair / mode sombre** : bascule disponible depuis n'importe quel écran.
- **Rejouabilité** : une fois pleine, la jauge devient le bouton *Recommencer*. Le bouton retour
  ramène à l'écran d'accueil à tout moment.

## Architecture

```
lib/
├── main.dart                       Point d'entrée, thème et navigation initiale
├── models/
│   ├── ville.dart                  Les 5 villes suivies et leurs coordonnées
│   ├── meteo.dart                  Modèle de la réponse OpenWeather (json_serializable)
│   └── meteo.g.dart                Généré par build_runner
├── services/
│   ├── api_config.dart             Clés et intervalles de l'application
│   ├── meteo_api.dart              Interface Retrofit vers OpenWeather
│   ├── meteo_api.g.dart            Généré par build_runner
│   └── meteo_service.dart          Orchestration des appels et traduction des erreurs
├── screens/
│   ├── accueil_screen.dart         Écran 1 : accueil
│   ├── chargement_screen.dart      Écran 2 : jauge, messages, tableau
│   └── detail_screen.dart          Écran 3 : détail d'une ville + Google Maps
├── widgets/
│   ├── jauge_widget.dart           Jauge circulaire (CustomPainter) et bouton Recommencer
│   ├── message_attente.dart        Messages d'attente en boucle
│   ├── tableau_meteo.dart          Tableau interactif des 5 villes
│   ├── erreur_widget.dart          Message d'erreur et relance de la requête
│   └── bouton_theme.dart           Bascule clair / sombre
└── theme/
    ├── app_theme.dart              Thèmes clair et sombre
    └── theme_controller.dart       État du mode d'affichage
```

## Technologies

| Usage | Package |
| --- | --- |
| Appels HTTP typés | `retrofit` + `dio` |
| Sérialisation JSON | `json_serializable` / `json_annotation` |
| Génération de code | `build_runner` |
| Cartographie | `google_maps_flutter` |
| Typographie | `google_fonts` |
| Dates localisées | `intl` |

## Installation

```bash
git clone https://github.com/Guelord11/meteo-app-flutter.git
cd meteo-app-flutter
flutter pub get
dart run build_runner build
flutter run
```

### Clé Google Maps

La carte de l'écran de détail nécessite une clé Google Maps. Ajoutez-la dans
`android/local.properties` (fichier non versionné) :

```properties
googleMapsApiKey=VOTRE_CLE_ANDROID
```

Pour iOS, renseignez la clé dans `ios/Runner/AppDelegate.swift`.

### Clé OpenWeather

Une clé de démonstration est fournie dans `lib/services/api_config.dart`. Pour utiliser la
vôtre sans modifier le code :

```bash
flutter run --dart-define=OPENWEATHER_API_KEY=VOTRE_CLE
```

## Tests

```bash
flutter test
```

## Répartition du travail

Le détail des contributions de chaque membre est visible dans l'historique Git
(`git log`) ainsi que dans l'onglet *Insights → Contributors* du dépôt GitHub.
Chaque fonctionnalité a été développée sur une branche dédiée puis intégrée via une
Pull Request relue par l'autre membre du groupe.
