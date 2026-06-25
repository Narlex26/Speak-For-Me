import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_for_me/features/audio_recording/presentation/widgets/pulsating_button.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  group('PulsatingButton', () {
    testWidgets('affiche l\'icône mic quand non en enregistrement', (tester) async {
      await tester.pumpWidget(_wrap(
        PulsatingButton(
          onPressed: () {},
          isRecording: false,
          color: Colors.blue,
          icon: Icons.mic_rounded,
        ),
      ));
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
    });

    testWidgets('affiche l\'icône stop quand en enregistrement', (tester) async {
      await tester.pumpWidget(_wrap(
        PulsatingButton(
          onPressed: () {},
          isRecording: true,
          color: Colors.red,
          icon: Icons.mic_rounded,
        ),
      ));
      await tester.pump();
      expect(find.byIcon(Icons.stop_rounded), findsOneWidget);
    });

    testWidgets('appelle onPressed au tap', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(_wrap(
        PulsatingButton(
          onPressed: () => pressed = true,
          isRecording: false,
          color: Colors.blue,
          icon: Icons.mic_rounded,
        ),
      ));
      await tester.tap(find.byType(GestureDetector).first);
      expect(pressed, isTrue);
    });

    testWidgets('se construit sans erreur en mode enregistrement', (tester) async {
      await tester.pumpWidget(_wrap(
        PulsatingButton(
          onPressed: () {},
          isRecording: true,
          color: Colors.red,
          icon: Icons.mic_rounded,
        ),
      ));
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });
  });
}
