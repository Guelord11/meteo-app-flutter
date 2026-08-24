import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meteo_app/theme/app_theme.dart';

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
    final Color accent = AppTheme.accentSecondaire(context);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progression.clamp(0, 1)),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, valeur, _) {
        return SizedBox(
          width: 216,
          height: 216,
          child: CustomPaint(
            painter: _JaugePainter(
              progression: valeur,
              couleurPiste: couleurs.surfaceContainerHighest,
              couleurDebut: couleurs.primary,
              couleurFin: accent,
              couleurSurface: couleurs.surface,
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: terminee
                    ? _boutonRecommencer(context)
                    : Column(
                        key: const ValueKey<String>('pourcentage'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(valeur * 100).round()}%',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: couleurs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'CHARGEMENT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: couleurs.onSurfaceVariant,
                            ),
                          ),
                        ],
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
      color: Colors.transparent,
      shape:
          CircleBorder(side: BorderSide(color: couleurs.primary, width: 1.5)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onRecommencer,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh_rounded, color: couleurs.primary, size: 28),
              const SizedBox(height: 4),
              Text(
                'Recommencer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: couleurs.primary,
                  fontWeight: FontWeight.w700,
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
  final Color couleurSurface;

  _JaugePainter({
    required this.progression,
    required this.couleurPiste,
    required this.couleurDebut,
    required this.couleurFin,
    required this.couleurSurface,
  });

  static const double _epaisseur = 14;

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
        colors: [couleurDebut, couleurFin],
        transform: const GradientRotation(-pi / 2),
      ).createShader(rect);

    final double angleParcouru = 2 * pi * progression;
    canvas.drawArc(rect, -pi / 2, angleParcouru, false, arc);

    // Petit repère « soleil » qui suit la pointe de l'arc.
    final double angleFinal = -pi / 2 + angleParcouru;
    final Offset pointe = Offset(
      centre.dx + rayon * cos(angleFinal),
      centre.dy + rayon * sin(angleFinal),
    );
    canvas.drawCircle(
        pointe, _epaisseur / 2 + 3, Paint()..color = couleurSurface);
    canvas.drawCircle(
        pointe, _epaisseur / 2 - 1, Paint()..color = couleurDebut);
  }

  @override
  bool shouldRepaint(covariant _JaugePainter oldDelegate) {
    return oldDelegate.progression != progression ||
        oldDelegate.couleurPiste != couleurPiste ||
        oldDelegate.couleurDebut != couleurDebut ||
        oldDelegate.couleurFin != couleurFin ||
        oldDelegate.couleurSurface != couleurSurface;
  }
}