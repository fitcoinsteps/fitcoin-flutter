import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/auth/presentation/screens/register_screen.dart';

void main() {
  testWidgets('RegisterScreen should render form fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    expect(find.text('Join FitCoin'), findsOneWidget);
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.byKey(const Key('create_account_button')), findsOneWidget);
  });

  testWidgets('RegisterScreen should show validation errors when empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('create_account_button')));
    await tester.pump();

    expect(find.text('First name required'), findsOneWidget);
    expect(find.text('Last name required'), findsOneWidget);
    expect(find.text('Email required'), findsOneWidget);
    expect(find.text('Password required'), findsOneWidget);
  });

  testWidgets('RegisterScreen should show password mismatch error', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('password_field')), 'password123');
    await tester.enterText(find.byKey(const Key('confirm_password_field')), 'password456');
    await tester.tap(find.byKey(const Key('create_account_button')));
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}