import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:howelsaday/main.dart';

void main() {
  testWidgets('Mood slider shows and sends mood', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text("How's Elsa Day?"), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.drag(find.byType(Slider), const Offset(200, 0));
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
  });
}
