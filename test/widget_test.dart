
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/app_widget.dart';

void main() {
  testWidgets('App should render correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AppWidget(),
      ),
    );

    expect(find.text('Join FitCoin'), findsOneWidget);
  });
}