import 'dart:math';
import '../../../specimen_selection/domain/entities/specimen.dart';
import 'translation_phrases.dart';

class TranslationService {
  final Random _random = Random();

  /// Returns a random phrase based on the profile type
  String translate(ProfileType profileType) {
    final phrases = TranslationPhrases.phrases[profileType] ?? [];
    if (phrases.isEmpty) {
      return "Erreur de traduction...";
    }
    return phrases[_random.nextInt(phrases.length)];
  }

  /// Returns a random analysis message for the given profile
  String getRandomAnalysisMessage(Profile profile) {
    if (profile.analysisMessages.isEmpty) {
      return "Analyse en cours...";
    }
    return profile.analysisMessages[_random.nextInt(profile.analysisMessages.length)];
  }

  /// Simulates a translation delay (for effect)
  Future<String> translateWithDelay(ProfileType profileType, {Duration delay = const Duration(seconds: 3)}) async {
    await Future.delayed(delay);
    return translate(profileType);
  }
}

