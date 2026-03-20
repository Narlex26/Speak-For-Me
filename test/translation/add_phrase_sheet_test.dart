import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_for_me/features/specimen_selection/domain/entities/specimen.dart';
import 'package:speak_for_me/features/translation_generator/data/datasources/translation_service.dart';
import 'package:speak_for_me/features/translation_generator/presentation/widgets/add_phrase_sheet.dart';

const testProfile = Profile(
  type: ProfileType.cat,
  name: 'Chat',
  icon: Icons.pets,
  primaryColor: Colors.blue,
  secondaryColor: Colors.lightBlue,
  analysisMessages: <String>['Analyse...'],
);

void main() {
  group('Add phrase bottom sheet', () {
    testWidgets('opens and displays expected content', (tester) async {
      final service = TranslationService();
      await tester.pumpWidget(_buildTestApp(service));

      await tester.tap(find.byKey(const Key('open_sheet_button')));
      await tester.pumpAndSettle();

      expect(find.text('Ajouter une phrase personnalisee'), findsOneWidget);
      expect(find.text('Mode ${testProfile.name}'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Ajouter la phrase'), findsOneWidget);
    });

    testWidgets('shows an error for empty phrase and keeps sheet open', (tester) async {
      final service = TranslationService();
      await tester.pumpWidget(_buildTestApp(service));

      await tester.tap(find.byKey(const Key('open_sheet_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ajouter la phrase'));
      await tester.pumpAndSettle();

      expect(find.text('La phrase ne peut pas etre vide.'), findsOneWidget);
      expect(find.text('Ajouter une phrase personnalisee'), findsOneWidget);
      expect(find.text('result:null'), findsOneWidget);
    });

    testWidgets('shows moderation error for prohibited words', (tester) async {
      final service = TranslationService();
      await tester.pumpWidget(_buildTestApp(service));

      await tester.tap(find.byKey(const Key('open_sheet_button')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Tu es un con.');
      await tester.tap(find.text('Ajouter la phrase'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Phrase refusee'), findsOneWidget);
      expect(find.text('Ajouter une phrase personnalisee'), findsOneWidget);
      expect(service.getCustomPhrases(ProfileType.cat), isEmpty);
      expect(find.text('result:null'), findsOneWidget);
    });

    testWidgets('adds a valid phrase and closes with true', (tester) async {
      final service = TranslationService();
      await tester.pumpWidget(_buildTestApp(service));

      await tester.tap(find.byKey(const Key('open_sheet_button')));
      await tester.pumpAndSettle();

      const newPhrase = 'Je suis un chat philosophe tres calme.';
      await tester.enterText(find.byType(TextField), newPhrase);
      await tester.tap(find.text('Ajouter la phrase'));
      await tester.pumpAndSettle();

      expect(find.text('Ajouter une phrase personnalisee'), findsNothing);
      expect(service.getCustomPhrases(ProfileType.cat), contains(newPhrase));
      expect(find.text('result:true'), findsOneWidget);
    });
  });
}

Widget _buildTestApp(TranslationService service) {
  return MaterialApp(
    home: Scaffold(
      body: _SheetTestHost(service: service),
    ),
  );
}

class _SheetTestHost extends StatefulWidget {
  final TranslationService service;

  const _SheetTestHost({required this.service});

  @override
  State<_SheetTestHost> createState() => _SheetTestHostState();
}

class _SheetTestHostState extends State<_SheetTestHost> {
  bool? _result;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          key: const Key('open_sheet_button'),
          onPressed: () async {
            final result = await showAddPhraseBottomSheet(
              context: context,
              profile: testProfile,
              translationService: widget.service,
            );
            if (!mounted) {
              return;
            }
            setState(() {
              _result = result;
            });
          },
          child: const Text('Open sheet'),
        ),
        Text('result:${_result?.toString() ?? 'null'}'),
      ],
    );
  }
}
