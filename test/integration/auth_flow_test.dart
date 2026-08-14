import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/app_widget.dart';
import 'package:fitcoin/core/config/app_config.dart';
import 'package:fitcoin/core/config/flavor.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    AppConfig.initialize(Flavor.development);
  });

  testWidgets('Full registration flow', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AppWidget(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Join FitCoin'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('first_name_field')),
      'Test',
    );
    await tester.enterText(
      find.byKey(const Key('last_name_field')),
      'User',
    );
    await tester.enterText(
      find.byKey(const Key('email_field')),
      'test@integration.com',
    );
    await tester.enterText(
      find.byKey(const Key('password_field')),
      'password123',
    );
    await tester.enterText(
      find.byKey(const Key('confirm_password_field')),
      'password123',
    );

    await tester.tap(find.byKey(const Key('create_account_button')));
    await tester.pumpAndSettle();

    expect(find.text('Verify OTP'), findsOneWidget);
  });
}