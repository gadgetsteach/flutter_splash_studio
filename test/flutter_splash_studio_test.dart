import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_splash_studio/flutter_splash_studio.dart';

void main() {
  testWidgets('SplashStudio renders correctly with basic parameters', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashStudio(
          title: 'Test App',
          animation: SplashAnimation.fade,
          duration: Duration(seconds: 1),
        ),
      ),
    );

    // Verify the title is found
    expect(find.text('Test App'), findsOneWidget);
  });

  testWidgets('SplashStudio renders Netflix template correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashStudio(
          template: SplashTemplate.netflix,
          duration: Duration(seconds: 1),
        ),
      ),
    );

    // Netflix template should render 'NETFLIX' text
    expect(find.text('NETFLIX'), findsOneWidget);
  });
}
