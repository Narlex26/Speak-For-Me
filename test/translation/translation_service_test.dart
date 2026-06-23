import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_for_me/features/specimen_selection/domain/entities/specimen.dart';
import 'package:speak_for_me/features/translation_generator/data/datasources/translation_phrases.dart';
import 'package:speak_for_me/features/translation_generator/data/datasources/translation_service.dart';

void main() {
  group('TranslationService', () {
    late TranslationService service;

    setUp(() {
      service = TranslationService();
    });

    test('getPhrases returns default phrases for a profile type', () {
      final phrases = service.getPhrases(ProfileType.cat);

      expect(phrases, isNotEmpty);
      expect(phrases, containsAll(TranslationPhrases.phrases[ProfileType.cat]!));
    });

    test('addCustomPhrase adds a valid custom phrase', () {
      const phrase = 'This is a valid custom phrase.';

      final added = service.addCustomPhrase(ProfileType.dog, phrase);

      expect(added, isTrue);
      expect(service.getCustomPhrases(ProfileType.dog), contains(phrase));
      expect(service.getPhrases(ProfileType.dog), contains(phrase));
    });

    test('addCustomPhrase rejects empty and too short phrases', () {
      expect(service.addCustomPhrase(ProfileType.baby, '   '), isFalse);
      expect(service.addCustomPhrase(ProfileType.baby, 'abcd'), isFalse);
    });

    test('addCustomPhrase rejects duplicates on same profile', () {
      const phrase = 'Unique phrase for duplicate test';

      expect(service.addCustomPhrase(ProfileType.goldfish, phrase), isTrue);
      expect(service.addCustomPhrase(ProfileType.goldfish, phrase), isFalse);
    });

    test('addCustomPhrase blocks prohibited standalone words', () {
      expect(
        service.addCustomPhrase(ProfileType.cat, 'This phrase contains con as a standalone word.'),
        isFalse,
      );
      expect(
        service.addCustomPhrase(ProfileType.cat, 'This phrase contains MERDE too.'),
        isFalse,
      );
    });

    test('addCustomPhrase does not block clean substrings like Constitution', () {
      const phrase = 'Constitution is allowed here.';

      final added = service.addCustomPhrase(ProfileType.cat, phrase);

      expect(added, isTrue);
      expect(service.getCustomPhrases(ProfileType.cat), contains(phrase));
    });

    test('translate returns one phrase from the available list', () {
      const customPhrase = 'Custom phrase that may be returned.';
      service.addCustomPhrase(ProfileType.dog, customPhrase);

      final translation = service.translate(ProfileType.dog);
      final available = service.getPhrases(ProfileType.dog);

      expect(available, contains(translation));
    });

    test('generateTranslation flags easter eggs correctly and uses the right pools', () {
      final eggs = TranslationPhrases.easterEggs;
      expect(eggs, isNotEmpty);

      final normalPhrases = service.getPhrases(ProfileType.cat);
      var sawEasterEgg = false;

      // 100k tirages à 1% : un easter egg doit forcément apparaître
      // (proba de n'en voir aucun ≈ 0.99^100000 ≈ 0), donc non flaky.
      for (var i = 0; i < 100000; i++) {
        final result = service.generateTranslation(ProfileType.cat);
        if (result.isEasterEgg) {
          sawEasterEgg = true;
          expect(eggs, contains(result.text));
        } else {
          expect(normalPhrases, contains(result.text));
        }
      }

      expect(sawEasterEgg, isTrue,
          reason: 'Sur 100k tirages à 1%, au moins un easter egg doit sortir');
    });

    test('getRandomAnalysisMessage returns fallback for empty profile messages', () {
      const emptyProfile = Profile(
        type: ProfileType.baby,
        name: 'EmptyProfile',
        icon: Icons.pets,
        primaryColor: Colors.black,
        secondaryColor: Colors.white,
        analysisMessages: <String>[],
      );

      final message = service.getRandomAnalysisMessage(emptyProfile);

      expect(message, 'Analyse en cours...');
    });

    test('translateWithDelay returns a valid phrase', () async {
      final translation = await service.translateWithDelay(
        ProfileType.goldfish,
        delay: const Duration(milliseconds: 1),
      );

      expect(service.getPhrases(ProfileType.goldfish), contains(translation));
    });
  });
}
