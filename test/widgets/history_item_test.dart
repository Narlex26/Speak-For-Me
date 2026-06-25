import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_for_me/features/history/data/models/history_model.dart';
import 'package:speak_for_me/features/history/presentation/widgets/history_item.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

HistoryModel _item({
  int id = 1,
  String profileType = 'Chat',
  String translatedText = 'Traduction de test',
}) =>
    HistoryModel(
      id: id,
      profileType: profileType,
      translatedText: translatedText,
      timestamp: DateTime.now(),
    );

void main() {
  group('HistoryItem', () {
    testWidgets('affiche le texte traduit', (tester) async {
      await tester.pumpWidget(_wrap(HistoryItem(
        item: _item(translatedText: 'Je veux dormir'),
        dateStr: '23 juin 2026 à 10:00',
        onDelete: () {},
      )));
      expect(find.text('Je veux dormir'), findsOneWidget);
    });

    testWidgets('affiche la date et le type de profil', (tester) async {
      await tester.pumpWidget(_wrap(HistoryItem(
        item: _item(profileType: 'Chat'),
        dateStr: '23 juin 2026 à 10:00',
        onDelete: () {},
      )));
      expect(find.textContaining('Chat'), findsWidgets);
      expect(find.textContaining('23 juin 2026'), findsOneWidget);
    });

    testWidgets('appelle onDelete au clic sur la corbeille', (tester) async {
      bool deleted = false;
      await tester.pumpWidget(_wrap(HistoryItem(
        item: _item(),
        dateStr: '23 juin 2026 à 10:00',
        onDelete: () => deleted = true,
      )));
      await tester.tap(find.byIcon(Icons.delete_outline));
      expect(deleted, isTrue);
    });

    testWidgets('se construit sans erreur', (tester) async {
      await tester.pumpWidget(_wrap(HistoryItem(
        item: _item(),
        dateStr: '23 juin 2026 à 10:00',
        onDelete: () {},
      )));
      expect(tester.takeException(), isNull);
    });
  });

  group('HistoryItem.iconForProfile', () {
    test('retourne child_care pour baby', () {
      expect(HistoryItem.iconForProfile('baby'), Icons.child_care);
    });

    test('retourne pets pour dog', () {
      expect(HistoryItem.iconForProfile('dog'), Icons.pets);
    });

    test('retourne cruelty_free pour cat', () {
      expect(HistoryItem.iconForProfile('cat'), Icons.cruelty_free);
    });

    test('retourne set_meal pour goldfish', () {
      expect(HistoryItem.iconForProfile('goldfish'), Icons.set_meal);
    });

    test('retourne record_voice_over pour profil inconnu', () {
      expect(HistoryItem.iconForProfile('unknown'), Icons.record_voice_over);
    });
  });
}
