import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:geoquiz/app/sign_in_page.dart';
import 'package:geoquiz/services/auth.dart';
import 'package:provider/provider.dart';

import 'package:geoquiz/common/keys.dart';

import 'sign_in_form_test.mocks.dart';

@GenerateMocks([AuthBase, User])
void main() {
  late MockAuthBase mockAuth;

  setUp(() {
    mockAuth = MockAuthBase();
  });

  Future<void> pumpEmailSignInForm(WidgetTester tester,
      {VoidCallback? onSignedIn}) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(
              body: SignInPage(
                onSignedIn: onSignedIn,
                formType: EmailSignInFormType.login,
              )),
        ),
      ),
    );
  }

  void stubSignInWithEmailAndPasswordSucceeds() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) => Future<User>.value(MockUser()));
  }

  void stubSignInAnonymouslySucceeds() {
    when(mockAuth.signInAnonymously())
        .thenAnswer((_) => Future<User>.value(MockUser()));
  }

  testWidgets('Email sign-in - empty', (WidgetTester tester) async {
    var signedIn = false;
    await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

    final signInButton = find.byKey(Keys.signInEmailButton);
    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);

    verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
    expect(signedIn, false);
  });

  testWidgets('Email sign-in - valid email and password', (WidgetTester tester) async {
    var signedIn = false;
    await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

    stubSignInWithEmailAndPasswordSucceeds();

    const email = 'email@email.com';
    const password = 'Password.123';

    final emailField = find.byKey(Keys.signInFormEmailField);
    await tester.enterText(emailField, email);

    final passwordField = find.byKey(Keys.signInFormPasswordField);;
    await tester.enterText(passwordField, password);

    await tester.pump();

    final signInButton = find.byKey(Keys.signInEmailButton);
    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);

    verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
    expect(signedIn, true);
  });

  testWidgets('Anonymous sign-in', (WidgetTester tester) async {
    var signedIn = false;
    await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

    stubSignInAnonymouslySucceeds();

    final signInButton = find.byKey(Keys.signInAnonymouslyButton);
    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);

    verify(mockAuth.signInAnonymously()).called(1);
    expect(signedIn, true);
  });
}