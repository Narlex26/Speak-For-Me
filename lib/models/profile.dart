import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ProfileType { baby, dog, cat, goldfish }

class Profile {
  final ProfileType type;
  final String name;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final List<String> analysisMessages;

  const Profile({
    required this.type,
    required this.name,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.analysisMessages,
  });

  static List<Profile> getAllProfiles() {
    return [
      Profile(
        type: ProfileType.baby,
        name: 'Bébé',
        icon: FontAwesomeIcons.baby,
        primaryColor: const Color(0xFFFF9AA2),
        secondaryColor: const Color(0xFFFFB7B2),
        analysisMessages: [
          'Analyse des gazouillis...',
          'Décodage de la philosophie infantile...',
          'Traduction des pleurs existentiels...',
          'Interprétation du langage pré-verbal...',
        ],
      ),
      Profile(
        type: ProfileType.dog,
        name: 'Chien',
        icon: FontAwesomeIcons.dog,
        primaryColor: const Color(0xFF8B4513),
        secondaryColor: const Color(0xFFD2691E),
        analysisMessages: [
          'Analyse des aboiements...',
          'Décodage de la loyauté canine...',
          'Traduction des jappements...',
          'Interprétation des gémissements...',
        ],
      ),
      Profile(
        type: ProfileType.cat,
        name: 'Chat',
        icon: FontAwesomeIcons.cat,
        primaryColor: const Color(0xFF6B5B95),
        secondaryColor: const Color(0xFF9B8DC3),
        analysisMessages: [
          'Analyse des miaulements...',
          'Décryptage du mépris félin...',
          'Traduction du ronronnement calculateur...',
          'Interprétation du jugement silencieux...',
        ],
      ),
      Profile(
        type: ProfileType.goldfish,
        name: 'Poisson Rouge',
        icon: FontAwesomeIcons.fish,
        primaryColor: const Color(0xFFFF6B35),
        secondaryColor: const Color(0xFFFFB347),
        analysisMessages: [
          'Analyse des bulles...',
          'Décodage... euh... quoi déjà ?',
          'Traduction des... oh un château !',
          'Inter... c\'est quoi un poisson ?',
        ],
      ),
    ];
  }
}

