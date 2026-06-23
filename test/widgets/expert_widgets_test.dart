import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_for_me/features/expert_mode/presentation/widgets/expert_result_widget.dart';
import 'package:speak_for_me/features/expert_mode/presentation/widgets/spectral_graph_widget.dart';
import 'package:speak_for_me/features/expert_mode/presentation/widgets/technical_data_widget.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('ExpertResultWidget', () {
    testWidgets('affiche ANALYSIS COMPLETE', (tester) async {
      await tester.pumpWidget(_wrap(
        ExpertResultWidget(color: Colors.purple),
      ));
      expect(find.text('ANALYSIS COMPLETE'), findsOneWidget);
    });

    testWidgets('affiche les stats simulées', (tester) async {
      await tester.pumpWidget(_wrap(
        ExpertResultWidget(color: Colors.purple),
      ));
      expect(find.text('Confidence Score'), findsOneWidget);
      expect(find.text('99.9%'), findsOneWidget);
    });

    testWidgets('se construit sans erreur', (tester) async {
      await tester.pumpWidget(_wrap(
        ExpertResultWidget(color: Colors.blue),
      ));
      expect(tester.takeException(), isNull);
    });
  });

  group('SpectralGraphWidget', () {
    testWidgets('affiche SPECTRAL ANALYSIS', (tester) async {
      await tester.pumpWidget(_wrap(
        const SpectralGraphWidget(baseColor: Colors.green, isAnimating: false),
      ));
      await tester.pump();
      expect(find.text('SPECTRAL ANALYSIS'), findsOneWidget);
    });

    testWidgets('affiche LIVE', (tester) async {
      await tester.pumpWidget(_wrap(
        const SpectralGraphWidget(baseColor: Colors.green, isAnimating: false),
      ));
      await tester.pump();
      expect(find.text('LIVE'), findsOneWidget);
    });

    testWidgets('se construit sans erreur en mode non-animé', (tester) async {
      await tester.pumpWidget(_wrap(
        const SpectralGraphWidget(baseColor: Colors.teal, isAnimating: false),
      ));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('TechnicalDataWidget', () {
    testWidgets('affiche SYSTEM LOG [DEBUG]', (tester) async {
      await tester.pumpWidget(_wrap(const TechnicalDataWidget()));
      await tester.pump();
      expect(find.text('SYSTEM LOG [DEBUG]'), findsOneWidget);
    });

    testWidgets('se construit sans erreur', (tester) async {
      await tester.pumpWidget(_wrap(const TechnicalDataWidget()));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
