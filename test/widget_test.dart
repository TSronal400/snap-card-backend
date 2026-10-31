import 'package:flutter_test/flutter_test.dart';
import 'package:snap_card/main.dart';

void main() {
  testWidgets('SnapCardApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SnapCardApp());

    // Verify that the welcome title is displayed.
    expect(find.text('SNAP CARD'), findsWidgets);
  });
}
