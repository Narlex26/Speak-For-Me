import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_for_me/features/specimen_selection/domain/entities/specimen.dart';
import 'package:speak_for_me/features/specimen_selection/presentation/widgets/specimen_card.dart';
import 'package:speak_for_me/features/specimen_selection/presentation/widgets/specimen_header.dart';
import 'package:speak_for_me/features/specimen_selection/presentation/widgets/specimen_section_title.dart';

const _testProfile = Profile(
  type: ProfileType.cat,
  name: 'Chat',
  icon: Icons.pets,
  primaryColor: Colors.blue,
  secondaryColor: Colors.lightBlue,
  analysisMessages: ['Analyse...'],
);

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('SpecimenCard', () {
    testWidgets('affiche le nom du profil', (tester) async {
      await tester.pumpWidget(_wrap(
        SpecimenCard(profile: _testProfile, onTap: () {}),
      ));
      expect(find.text('Chat'), findsOneWidget);
    });

    testWidgets('appelle onTap au tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(_wrap(
        SpecimenCard(profile: _testProfile, onTap: () => tapped = true),
      ));
      await tester.tap(find.byType(SpecimenCard));
      expect(tapped, isTrue);
    });

    testWidgets('affiche l\'icône du profil', (tester) async {
      await tester.pumpWidget(_wrap(
        SpecimenCard(profile: _testProfile, onTap: () {}),
      ));
      expect(find.byIcon(Icons.pets), findsWidgets);
    });
  });

  group('SpecimenHeader', () {
    testWidgets('affiche le titre Speak for Me', (tester) async {
      await tester.pumpWidget(_wrap(const SpecimenHeader()));
      await tester.pump();
      expect(find.text('Speak for Me'), findsOneWidget);
    });

    testWidgets('affiche le disclaimer *Non.', (tester) async {
      await tester.pumpWidget(_wrap(const SpecimenHeader()));
      await tester.pump();
      expect(find.text('*Non.'), findsOneWidget);
    });

    testWidgets('affiche le slogan fiable', (tester) async {
      await tester.pumpWidget(_wrap(const SpecimenHeader()));
      await tester.pump();
      expect(find.textContaining('100% fiable'), findsOneWidget);
    });
  });

  group('SpecimenSectionTitle', () {
    testWidgets('affiche la question', (tester) async {
      await tester.pumpWidget(_wrap(const SpecimenSectionTitle()));
      await tester.pump();
      expect(find.text('Qui voulez-vous comprendre ?'), findsOneWidget);
    });

    testWidgets('contient un accent de couleur', (tester) async {
      await tester.pumpWidget(_wrap(const SpecimenSectionTitle()));
      await tester.pump();
      expect(find.byType(Container), findsWidgets);
    });
  });
}
