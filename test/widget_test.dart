// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/main.dart';

Widget makeTestableWidget(Widget child) => MyApp(
      child: child,
    );

void main() {
  test('WithSort should sort alphabetically', () {
    final unsorted = 'b,j,a,k,c'.split(',');
    final sorted = withSort(unsorted);
    expect(sorted, ['a', 'b', 'c', 'j', 'k']);
  });

  test('WithSortDecending should sort alphabetically', () {
    final unsorted = 'b,j,a,k,c'.split(',');
    final sorted = withSortDescending(unsorted);
    expect(sorted, ['k', 'j', 'c', 'b', 'a']);
  });

  testWidgets(
      'dropDownWithList should return Circular progressbar if data is null',
      (WidgetTester tester) async {
    final widget = dropDownWithList('key1')(null);
    await tester.pumpWidget(widget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('dropDownWithList should return Dropdown if data is available',
      (WidgetTester tester) async {
    final widget = dropDownWithList('key1')(['a', 'b']);
    await tester.pumpWidget(makeTestableWidget(Scaffold(body: widget)));
    expect(find.byKey(Key('key1-a')), findsOneWidget);
    expect(find.byKey(Key('key1-b')), findsOneWidget);
  });

  testWidgets('Smoke test whole app', (WidgetTester tester) async {
    final widget = MyHomePage(title: 'Hook Compose Demo');
    await tester.pumpWidget(makeTestableWidget(Scaffold(body: widget)));

    expect(find.text('Hook Compose Demo'), findsOneWidget);
    await tester.pumpAndSettle();

    final firstDropdown = find.byKey(Key('state accending'));
    final secondDropdown = find.byKey(Key('state decending'));
    expect(firstDropdown, findsOneWidget);
    expect(secondDropdown, findsOneWidget);

    await tester.tap(firstDropdown);

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('state accending-Malaysia')).last);

    await tester.pumpAndSettle();

    await tester.tap(secondDropdown);

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('state decending-Indonesia')).last);

    await tester.pumpAndSettle();

    final button = find.text('selected');

    expect(button, findsOneWidget);

    await tester.tap(button);

    await tester.pumpAndSettle();

    expect(find.text('Selected is Malaysia and Indonesia'), findsOneWidget);
  });
}
