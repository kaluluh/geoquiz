import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tap on the given button (found by the key) specified number of times
Future<void> _tapButton(WidgetTester tester, Key key, {int times = 1}) async {
  final Finder button = find.byKey(key);
  for (var i = 0; i < times; ++i) {
    await tester.tap(button);
    await tester.pump();
  }
}