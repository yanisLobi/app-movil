import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:blog_flutter_app/views/login_screen.dart';
import 'package:blog_flutter_app/views/posts_screen.dart';
import 'package:blog_flutter_app/views/post_detail_screen.dart';
import 'package:blog_flutter_app/views/register_screen.dart';

void main() {
  testWidgets('el formulario de inicio permite desplazarse con el teclado',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          viewInsets: EdgeInsets.only(bottom: 300),
        ),
        child: const MaterialApp(
          home: LoginScreen(baseUrl: 'https://example.invalid'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('el formulario de registro se desplaza en pantallas pequeñas',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          viewInsets: EdgeInsets.only(bottom: 280),
        ),
        child: const MaterialApp(
          home: RegisterScreen(baseUrl: 'https://example.invalid'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

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
      MaterialApp(
        home: PostsScreen(
          currentUserId: 1,
          currentUserName: 'Ana',
          client: client,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Culpa mia'), findsOneWidget);
    expect(find.text('Noche oscura'), findsOneWidget);

    tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Ana'), findsOneWidget);

    const iconosPorGenero = {
      'Romance': Icons.favorite_border,
      'Terror': Icons.nights_stay_outlined,
      'Fantasía': Icons.auto_awesome_outlined,
      'Ciencia Ficción': Icons.science_outlined,
      'Aventura y Acción': Icons.hiking_outlined,
      'Adaptaciones Cinematográficas': Icons.movie_outlined,
    };
    for (final entry in iconosPorGenero.entries) {
      expect(
        find.descendant(
          of: find.widgetWithText(ListTile, entry.key),
          matching: find.byIcon(entry.value),
        ),
        findsOneWidget,
      );
    }

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

  testWidgets('la lista admite textos largos en una pantalla pequeña',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const titulo =
        'Una publicación con un título muy largo para comprobar el ajuste';
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode([
          {
            'id_blog': 1,
            'titulo': titulo,
            'generos': 'Adaptaciones Cinematográficas',
            'desc': 'Descripción extensa. ' * 20,
            'tags': 'etiqueta, ' * 20,
          },
        ]),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    await tester.pumpWidget(
      MaterialApp(
        home: PostsScreen(
          currentUserId: 1,
          currentUserName: 'Ana',
          client: client,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(titulo), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('el detalle se desplaza con descripción y comentarios largos',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const titulo =
        'Un título de publicación suficientemente largo para ocupar varias líneas';
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'titulo': titulo,
          'desc': 'Descripción extensa. ' * 80,
          'comentarios': [
            {
              'usr_id': 2,
              'nom_usr': 'Lector',
              'comentario': 'Comentario detallado. ' * 40,
              'fecha': '2026-11-04',
            },
          ],
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    await tester.pumpWidget(
      MaterialApp(
        home: PostDetailScreen(
          blogId: 1,
          baseUrl: 'https://example.invalid',
          currentUserId: 1,
          client: client,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
