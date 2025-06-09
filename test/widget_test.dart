import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:howelsaday/main.dart';

void main() {
  testWidgets('slider updates mood and shows snackbar', (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();

    await tester.pumpWidget(
      MaterialApp(home: MoodSliderScreen(firestore: firestore)),
    );

    // Initial mood should be neutral
    expect(find.text('😐 Bình thường'), findsOneWidget);

    // Update slider value via callback
    final sliderFinder = find.byType(Slider);
    final Slider slider = tester.widget(sliderFinder);
    slider.onChanged?.call(80);
    await tester.pump();

    // Mood text should reflect new value
    expect(find.text('😊 Vui'), findsOneWidget);

    // Tap send button to trigger SnackBar
    await tester.tap(find.text('Gửi cảm xúc 💌'));
    await tester.pump();

    expect(find.text('Đã gửi cảm xúc: 😊 Vui'), findsOneWidget);
  });
}
