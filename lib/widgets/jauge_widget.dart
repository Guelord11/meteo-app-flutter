import 'dart:math';

import 'package:flutter/material.dart';

/// Jauge circulaire animée affichant la progression du chargement des
/// données météo. Une fois [terminee], le pourcentage laisse place à un
/// bouton « Recommencer » au centre.
class JaugeWidget extends StatelessWidget {
  final double progression; // 0 -> 1
  final bool terminee;
  final VoidCallback onRecommencer;

  const JaugeWidget({
    super.key,
    required this.progression,
    required this.terminee,
    required this.onRecommencer,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progression.clamp(0, 1)),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, valeur, _) {
        return SizedBox(
          width: 220,
          height: 220,
          child: CustomPaint(
            painter: _JaugePainter(
              progression: valeur,
              couleurPiste: couleurs.surfaceContainerHighest,
              couleurDebut: couleurs.primary,
              couleurFin: couleurs.tertiary,
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: terminee
                    ? _boutonRecommencer(context)
                    : Text(
                        '${(valeur * 100).round()} %',
                        key: const ValueKey<String>('pourcentage'),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: couleurs.onSurface,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _boutonRecommencer(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return Material(
      key: const ValueKey<String>('recommencer'),
      color: couleurs.primary,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onRecommencer,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh_rounded, color: couleurs.onPrimary, size: 32),
              const SizedBox(height: 4),
              Text(
                'Recommencer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: couleurs.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JaugePainter extends CustomPainter {
  final double progression;
  final Color couleurPiste;
  final Color couleurDebut;
  final Color couleurFin;

  _JaugePainter({
    required this.progression,
    required this.couleurPiste,
    required this.couleurDebut,
    required this.couleurFin,
  });

  static const double _epaisseur = 16;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset centre = size.center(Offset.zero);
    final double rayon = (min(size.width, size.height) - _epaisseur) / 2;
    final Rect rect = Rect.fromCircle(center: centre, radius: rayon);

    final Paint piste = Paint()
      ..color = couleurPiste
      ..style = PaintingStyle.stroke
      ..strokeWidth = _epaisseur
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(centre, rayon, piste);

    if (progression <= 0) return;

    final Paint arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _epaisseur
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [couleurDebut, couleurFin, couleurDebut],
        transform: const GradientRotation(-pi / 2),
      ).createShader(rect);

    canvas.drawArc(rect, -pi / 2, 2 * pi * progression, false, arc);
  }

  @override
  bool shouldRepaint(covariant _JaugePainter oldDelegate) {
    return oldDelegate.progression != progression ||
        oldDelegate.couleurPiste != couleurPiste ||
        oldDelegate.couleurDebut != couleurDebut ||
        oldDelegate.couleurFin != couleurFin;
  }
}
