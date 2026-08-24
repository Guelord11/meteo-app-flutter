import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meteo_app/services/api_config.dart';

/// Fait défiler en boucle une série de messages pendant l'attente d'un
/// résultat réseau, avec une transition en fondu + glissement.
class MessageAttente extends StatefulWidget {
  const MessageAttente({super.key});

  static const List<String> _messages = [
    'Nous téléchargeons les données…',
    "C'est presque fini…",
    'Plus que quelques secondes avant d\'avoir le résultat…',
  ];

  @override
  State<MessageAttente> createState() => _MessageAttenteState();
}

class _MessageAttenteState extends State<MessageAttente> {
  Timer? minuterie;
  int index = 0;

  @override
  void initState() {
    super.initState();
    minuterie = Timer.periodic(ApiConfig.intervalleMessages, (_) {
      setState(() {
        index = (index + 1) % MessageAttente._messages.length;
      });
    });
  }

  @override
  void dispose() {
    minuterie?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Text(
          MessageAttente._messages[index],
          key: ValueKey<int>(index),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: couleurs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}