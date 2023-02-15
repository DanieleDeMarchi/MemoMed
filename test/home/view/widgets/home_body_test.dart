// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:memo_med/features/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memo_med/features/home/widgets/home_body.old.dart';

void main() {
  group('HomeBody', () {
    testWidgets('renders Text', (tester) async { 
      await tester.pumpWidget(
        MaterialApp(home: HomeBody()),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
