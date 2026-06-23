import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_for_me/features/favorites/domain/entities/favorite_tts.dart';
import 'package:speak_for_me/features/favorites/presentation/widgets/favorites_body.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

FavoriteTTS _fav({String id = '1', String text = 'Test phrase'}) => FavoriteTTS(
      id: id,
      text: text,
      profileType: 'cat',
      createdAt: DateTime.now(),
    );

void main() {
  group('FavoritesBody', () {
    testWidgets('affiche un spinner en état chargement', (tester) async {
      await tester.pumpWidget(_wrap(FavoritesBody(
        isLoading: true,
        errorMessage: null,
        favorites: const [],
        onRetry: () {},
        onGoBack: () {},
        onDelete: (_) {},
        onReListen: (_) {},
      )));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('affiche le message d\'erreur et le bouton réessayer', (tester) async {
      await tester.pumpWidget(_wrap(FavoritesBody(
        isLoading: false,
        errorMessage: 'Erreur de chargement',
        favorites: const [],
        onRetry: () {},
        onGoBack: () {},
        onDelete: (_) {},
        onReListen: (_) {},
      )));
      expect(find.text('Erreur de chargement'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
    });

    testWidgets('appelle onRetry au clic sur Réessayer', (tester) async {
      bool retried = false;
      await tester.pumpWidget(_wrap(FavoritesBody(
        isLoading: false,
        errorMessage: 'Erreur',
        favorites: const [],
        onRetry: () => retried = true,
        onGoBack: () {},
        onDelete: (_) {},
        onReListen: (_) {},
      )));
      await tester.tap(find.text('Réessayer'));
      expect(retried, isTrue);
    });

    testWidgets('affiche l\'état vide si aucun favori', (tester) async {
      await tester.pumpWidget(_wrap(FavoritesBody(
        isLoading: false,
        errorMessage: null,
        favorites: const [],
        onRetry: () {},
        onGoBack: () {},
        onDelete: (_) {},
        onReListen: (_) {},
      )));
      expect(find.text('Aucun favori'), findsOneWidget);
    });

    testWidgets('appelle onGoBack depuis l\'état vide', (tester) async {
      bool goBack = false;
      await tester.pumpWidget(_wrap(FavoritesBody(
        isLoading: false,
        errorMessage: null,
        favorites: const [],
        onRetry: () {},
        onGoBack: () => goBack = true,
        onDelete: (_) {},
        onReListen: (_) {},
      )));
      await tester.tap(find.text('Retour'));
      expect(goBack, isTrue);
    });

    testWidgets('affiche les favoris dans une liste', (tester) async {
      await tester.pumpWidget(_wrap(FavoritesBody(
        isLoading: false,
        errorMessage: null,
        favorites: [_fav(text: 'Phrase numéro un')],
        onRetry: () {},
        onGoBack: () {},
        onDelete: (_) {},
        onReListen: (_) {},
      )));
      expect(find.text('Phrase numéro un'), findsOneWidget);
    });

    testWidgets('appelle onDelete avec le bon id', (tester) async {
      String? deletedId;
      await tester.pumpWidget(_wrap(FavoritesBody(
        isLoading: false,
        errorMessage: null,
        favorites: [_fav(id: 'fav_42', text: 'Ma phrase')],
        onRetry: () {},
        onGoBack: () {},
        onDelete: (id) => deletedId = id,
        onReListen: (_) {},
      )));
      await tester.tap(find.byIcon(Icons.close));
      expect(deletedId, 'fav_42');
    });
  });
}
