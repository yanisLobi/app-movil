import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:blog_flutter_app/views/posts_screen.dart';

void main() {
  testWidgets('filtra publicaciones desde el menú por género',
      (WidgetTester tester) async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode([
          {
            'id_blog': 1,
            'titulo': 'Culpa mia',
            'generos': 'Romance',
            'desc': 'Una historia de amor',
          },
          {
            'id_blog': 2,
            'titulo': 'Noche oscura',
            'generos': 'Terror',
            'desc': 'Una historia de miedo',
          },
        ]),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    await tester.pumpWidget(
      MaterialApp(home: PostsScreen(client: client)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Culpa mia'), findsOneWidget);
    expect(find.text('Noche oscura'), findsOneWidget);

    tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Romance'));
    await tester.pumpAndSettle();

    expect(find.text('Culpa mia'), findsOneWidget);
    expect(find.text('Noche oscura'), findsNothing);
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Romance'),
      ),
      findsOneWidget,
    );
  });
}
