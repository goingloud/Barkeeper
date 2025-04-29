import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import your App widget
import 'package:barkeeper/app.dart';

void main() {
  testWidgets('Smoke test: App shows Connect Scale button', (
    WidgetTester tester,
  ) async {
    // Build the App widget and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that the “Connect Scale” button is present.
    expect(find.text('Connect Scale'), findsOneWidget);

    // (Optional) tap it and ensure no exceptions:
    await tester.tap(find.text('Connect Scale'));
    await tester.pump();

    // You could also verify that the weight display starts at “-- g”
    expect(find.text('-- g'), findsOneWidget);
  });
}
