import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_for_me/core/widgets/shimmer_loader.dart';

Widget _buildTestApp({required double width, required double height}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(size: Size(width, height)),
      child: Scaffold(
        body: SizedBox(
          width: width,
          height: height,
          child: ShimmerLoader(
            message: 'Analyse en cours...',
            baseColor: Colors.purple,
            progress: 0.5,
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('ShimmerLoader — responsive', () {
    testWidgets('s\'affiche sans overflow sur petit écran (320px)', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(width: 320, height: 640));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(ShimmerLoader), findsOneWidget);
      expect(find.text('Analyse en cours...'), findsOneWidget);
    });

    testWidgets('s\'affiche sans overflow sur écran standard (390px)', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(width: 390, height: 844));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(ShimmerLoader), findsOneWidget);
    });

    testWidgets('s\'affiche sans overflow sur tablette (768px)', (tester) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_buildTestApp(width: 768, height: 1024));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(ShimmerLoader), findsOneWidget);
    });

    testWidgets('affiche le bon pourcentage selon progress', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShimmerLoader(
              message: 'Chargement',
              baseColor: Colors.blue,
              progress: 0.75,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('affiche 0% quand progress est à 0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShimmerLoader(
              message: 'Début',
              baseColor: Colors.green,
              progress: 0.0,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('affiche 100% quand progress est à 1', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShimmerLoader(
              message: 'Terminé',
              baseColor: Colors.green,
              progress: 1.0,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('100%'), findsOneWidget);
    });
  });
}
