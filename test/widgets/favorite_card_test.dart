import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_for_me/features/favorites/domain/entities/favorite_tts.dart';
import 'package:speak_for_me/features/favorites/presentation/widgets/favorite_card.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

FavoriteTTS _fav({
  String text = 'Phrase de test',
  String profileType = 'cat',
  Duration age = Duration.zero,
}) =>
    FavoriteTTS(
      id: 'test_id',
      text: text,
      profileType: profileType,
      createdAt: DateTime.now().subtract(age),
    );

void main() {
  group('FavoriteCard', () {
    testWidgets('affiche le texte de la traduction', (tester) async {
      await tester.pumpWidget(_wrap(FavoriteCard(
        favorite: _fav(text: 'Je veux manger maintenant'),
        onReListen: () {},
        onDelete: () {},
      )));
      expect(find.text('Je veux manger maintenant'), findsOneWidget);
    });

    testWidgets('affiche le type de profil', (tester) async {
      await tester.pumpWidget(_wrap(FavoriteCard(
        favorite: _fav(profileType: 'dog'),
        onReListen: () {},
        onDelete: () {},
      )));
      expect(find.text('Profile: dog'), findsOneWidget);
    });

    testWidgets('appelle onReListen au clic sur Réécouter', (tester) async {
      bool listened = false;
      await tester.pumpWidget(_wrap(FavoriteCard(
        favorite: _fav(),
        onReListen: () => listened = true,
        onDelete: () {},
      )));
      await tester.tap(find.text('Réécouter'));
      expect(listened, isTrue);
    });

    testWidgets('appelle onDelete au clic sur la croix', (tester) async {
      bool deleted = false;
      await tester.pumpWidget(_wrap(FavoriteCard(
        favorite: _fav(),
        onReListen: () {},
        onDelete: () => deleted = true,
      )));
      await tester.tap(find.byIcon(Icons.close));
      expect(deleted, isTrue);
    });

    testWidgets('affiche À l\'instant pour un favori récent', (tester) async {
      await tester.pumpWidget(_wrap(FavoriteCard(
        favorite: _fav(age: const Duration(seconds: 30)),
        onReListen: () {},
        onDelete: () {},
      )));
      expect(find.text('À l\'instant'), findsOneWidget);
    });

    testWidgets('affiche il y a X min pour un favori vieux d\'une heure', (tester) async {
      await tester.pumpWidget(_wrap(FavoriteCard(
        favorite: _fav(age: const Duration(minutes: 30)),
        onReListen: () {},
        onDelete: () {},
      )));
      expect(find.text('Il y a 30 min'), findsOneWidget);
    });
  });
}
