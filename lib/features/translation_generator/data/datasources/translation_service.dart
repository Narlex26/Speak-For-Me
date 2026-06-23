import 'dart:math';
import '../../../specimen_selection/domain/entities/specimen.dart';
import 'translation_phrases.dart';

class TranslationService {
  final Random _random = Random();

  final Map<ProfileType, List<String>> _customPhrases = {
    ProfileType.baby: [],
    ProfileType.dog: [],
    ProfileType.cat: [],
    ProfileType.goldfish: [],
  };

  /// Returns a random phrase based on the profile type
  String translate(ProfileType profileType) {
    final phrases = getPhrases(profileType);
    if (phrases.isEmpty) {
      return "Erreur de traduction...";
    }
    return phrases[_random.nextInt(phrases.length)];
  }

  /// Probabilité qu'une traduction soit un easter egg « légendaire » (1%).
  static const double easterEggProbability = 0.01;

  /// Génère une traduction destinée à l'UI : avec [easterEggProbability] de
  /// chance, renvoie une phrase légendaire (easter egg) ; sinon une phrase
  /// normale du profil. Le flag [isEasterEgg] permet à l'UI d'afficher un
  /// traitement spécial. [translate] reste volontairement « pur » (sans easter
  /// egg) pour rester testable de façon déterministe.
  ({String text, bool isEasterEgg}) generateTranslation(ProfileType profileType) {
    if (TranslationPhrases.easterEggs.isNotEmpty &&
        _random.nextDouble() < easterEggProbability) {
      final egg = TranslationPhrases
          .easterEggs[_random.nextInt(TranslationPhrases.easterEggs.length)];
      return (text: egg, isEasterEgg: true);
    }
    return (text: translate(profileType), isEasterEgg: false);
  }

  List<String> getPhrases(ProfileType profileType) {
    return [
      ...?TranslationPhrases.phrases[profileType],
      ...?_customPhrases[profileType],
    ];
  }

  List<String> getCustomPhrases(ProfileType profileType) {
    return List.unmodifiable(_customPhrases[profileType] ?? []);
  }

  /// Add a custom phrase for a profile with automatic moderation
  bool addCustomPhrase(ProfileType profileType, String phrase) {
    final normalized = phrase.trim();

    if (normalized.isEmpty || normalized.length < 5) {
      return false;
    }

    if (_containsProhibitedWord(normalized)) {
      return false;
    }

    final customList = _customPhrases[profileType] ?? [];
    if (customList.contains(normalized)) {
      return false;
    }

    customList.add(normalized);
    _customPhrases[profileType] = customList;
    return true;
  }

  bool _containsProhibitedWord(String phrase) {
    for (final word in TranslationPhrases.prohibitedWords) {
      final pattern = RegExp(
        r'(^|[^A-Za-zÀ-ÖØ-öø-ÿ])' + RegExp.escape(word) + r'([^A-Za-zÀ-ÖØ-öø-ÿ]|$)',
        caseSensitive: false,
      );
      if (pattern.hasMatch(phrase)) {
        return true;
      }
    }

    return false;
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

