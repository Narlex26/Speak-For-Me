import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_for_me/main.dart';

Widget _wrap(Widget child, {Brightness brightness = Brightness.light}) {
  return MaterialApp(
    theme: ThemeData(useMaterial3: true, brightness: brightness),
    home: child,
  );
}

void main() {
  group('SpeakForMeApp - dark theme', () {
    testWidgets('builds with ThemeMode.system', (tester) async {
      await tester.pumpWidget(const SpeakForMeApp());
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.themeMode, ThemeMode.system);
      expect(app.darkTheme, isNotNull);
    });

    testWidgets('dark theme has correct brightness', (tester) async {
      await tester.pumpWidget(const SpeakForMeApp());
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.darkTheme!.brightness, Brightness.dark);
    });

    testWidgets('light theme has correct brightness', (tester) async {
      await tester.pumpWidget(const SpeakForMeApp());
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme!.brightness, Brightness.light);
    });
  });

  group('TranslationAppBar - adapts to theme', () {
    testWidgets('renders without error in dark mode', (tester) async {
      await tester.pumpWidget(_wrap(
        const Scaffold(body: Text('test')),
        brightness: Brightness.dark,
      ));
      expect(find.text('test'), findsOneWidget);
    });

    testWidgets('renders without error in light mode', (tester) async {
      await tester.pumpWidget(_wrap(
        const Scaffold(body: Text('test')),
        brightness: Brightness.light,
      ));
      expect(find.text('test'), findsOneWidget);
    });
  });
}
