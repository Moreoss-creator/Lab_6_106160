import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_reservation_app/dashboard.dart';

void main() {
  testWidgets('error when guest name is empty', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    await tester.ensureVisible(find.text('Book Now'));
    await tester.tap(find.text('Book Now'));
    await tester.pump();

    expect(find.text('Guest name is required'), findsOneWidget);
  });

  testWidgets('no error when guest name is filled', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    await tester.enterText(find.byKey(const Key('guestName')), 'Aminah');
    await tester.ensureVisible(find.text('Book Now'));
    await tester.tap(find.text('Book Now'));
    await tester.pump();

    expect(find.text('Guest name is required'), findsNothing);
  });

  testWidgets('error when email is missing @', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    await tester.enterText(find.byKey(const Key('guestEmail')), 'aminah.example.com');
    await tester.ensureVisible(find.text('Book Now'));
    await tester.tap(find.text('Book Now'));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsOneWidget);
  });

  testWidgets('no error when email is valid', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    await tester.enterText(find.byKey(const Key('guestEmail')), 'aminah@unimas.my');
    await tester.ensureVisible(find.text('Book Now'));
    await tester.tap(find.text('Book Now'));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsNothing);
  });

  testWidgets('error when check-out is not after check-in', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    // Pick today for check-in
    await tester.tap(find.byKey(const Key('checkInButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Pick same day (not after check-in) for check-out
    await tester.tap(find.byKey(const Key('checkOutButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(DateTime.now().day.toString()).last);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Book Now'));
    await tester.tap(find.text('Book Now'));
    await tester.pump();

    expect(find.text('Check-out must be after check-in'), findsOneWidget);
  });

  testWidgets('navigates to room list when all fields are valid', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    await tester.enterText(find.byKey(const Key('guestName')), 'Aminah');
    await tester.enterText(find.byKey(const Key('guestEmail')), 'aminah@unimas.my');

    // Select check-in (default today)
    await tester.tap(find.byKey(const Key('checkInButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Select check-out (default tomorrow)
    await tester.tap(find.byKey(const Key('checkOutButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Book Now'));
    await tester.tap(find.text('Book Now'));
    await tester.pumpAndSettle();

    expect(find.text('Select Your Room'), findsOneWidget);
  });
}