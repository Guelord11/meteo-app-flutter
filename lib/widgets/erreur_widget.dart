import 'package:flutter/material.dart';

/// Message d'erreur avec bouton de reprise, affiché lorsqu'un appel réseau
/// échoue pendant le chargement.
class ErreurWidget extends StatelessWidget {
  final String message;
  final VoidCallback onReessayer;

  const ErreurWidget({
    super.key,
    required this.message,
    required this.onReessayer,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cloud_off_rounded, size: 48, color: couleurs.error),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: couleurs.onSurface),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onReessayer,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Réessayer'),
        ),
      ],
    );
  }
}
