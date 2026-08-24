import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_app/models/ville.dart';
import 'package:meteo_app/screens/accueil_screen.dart';

void main() {
  group('AccueilScreen', () {
    testWidgets(
      'affiche le message de bienvenue et le bouton de lancement',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: AccueilScreen()));

        expect(find.text('Bienvenue'), findsOneWidget);
        expect(find.text("Lancer l'expérience"), findsOneWidget);
      },
    );

    testWidgets('affiche les 5 noms de villes', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccueilScreen()));

      for (final Ville ville in Ville.villeList()) {
        expect(find.text(ville.nom), findsOneWidget);
      }
    });
  });
}
