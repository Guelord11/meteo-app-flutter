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
        Icon(Icons.cloud_off_rounded, size: 40, color: couleurs.error),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: couleurs.onSurface),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: onReessayer,
          style: OutlinedButton.styleFrom(
            foregroundColor: couleurs.primary,
            side: BorderSide(color: couleurs.outlineVariant),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Réessayer'),
        ),
      ],
    );
  }
}