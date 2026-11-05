import 'package:blog_flutter_app/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post_detail_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
    this.client,
  });

  final int currentUserId;
  final String currentUserName;
  final http.Client? client;

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  // Ajusta esta URL según tu entorno (10.0.2.2 para emulador Android, 127.0.0.1 para Web)
  final String baseUrl = "https://9wc8k4l0-8000.usw3.devtunnels.ms";

  // Mantener estos valores sincronizados con el ENUM generos de la tabla blog.
  static const List<String> _generos = [
    'Romance',
    'Terror',
    'Fantasía',
    'Ciencia Ficción',
    'Aventura y Acción',
    'Adaptaciones Cinematográficas',
  ];

  static IconData _iconoGenero(String genero) => switch (genero) {
        'Romance' => Icons.favorite_border,
        'Terror' => Icons.nights_stay_outlined,
        'Fantasía' => Icons.auto_awesome_outlined,
        'Ciencia Ficción' => Icons.science_outlined,
        'Aventura y Acción' => Icons.hiking_outlined,
        'Adaptaciones Cinematográficas' => Icons.movie_outlined,
        _ => Icons.category_outlined,
      };

  List<dynamic> _posts = [];
  String? _generoSeleccionado;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final uri = Uri.parse('$baseUrl/posts');
      final response = await (widget.client?.get(uri) ?? http.get(uri));

      if (response.statusCode == 200) {
        setState(() {
          _posts = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Error al cargar posts (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión. Revisa CORS/URL base: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsVisibles = _generoSeleccionado == null
        ? _posts
        : _posts
            .where((post) => post['generos'] == _generoSeleccionado)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_generoSeleccionado ?? 'Posts del Blog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPosts,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Libria App',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.currentUserName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Esta opción restablece el listado para mostrar todos los posts.
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: const Text('Posts'),
              selected: _generoSeleccionado == null,
              onTap: () {
                setState(() => _generoSeleccionado = null);
                Navigator.pop(context);
              },
            ),

            const Divider(),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                'Géneros',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            ..._generos.map(
              (genero) => ListTile(
                leading: Icon(_iconoGenero(genero)),
                title: Text(genero),
                selected: _generoSeleccionado == genero,
                onTap: () {
                  setState(() => _generoSeleccionado = genero);
                  Navigator.pop(context);
                },
              ),
            ),

            const Divider(),

            // Opción para Cerrar Sesión
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                // Te regresa al login y borra el historial para que no pueda volver con "atrás"
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(baseUrl: baseUrl),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                            onPressed: _fetchPosts,
                            child: const Text('Reintentar'))
                      ],
                    ),
                  ),
                )
              : postsVisibles.isEmpty
                  ? Center(
                      child: Text(
                        _generoSeleccionado == null
                            ? 'No hay publicaciones.'
                            : 'No hay publicaciones de $_generoSeleccionado.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: postsVisibles.length,
                      itemBuilder: (context, index) {
                        final post = postsVisibles[index];
                        final imageUrl = post['img']?.toString();
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: imageUrl != null && imageUrl.trim().isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        CircleAvatar(
                                      child: Text('${post['id_blog']}'),
                                    ),
                                  )
                                : CircleAvatar(
                                    child: Text('${post['id_blog']}'),
                                  ),
                            title: Text(
                              post['titulo'] ?? 'Sin título',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${post['generos'] ?? 'Sin género'} · ${post['desc'] ?? ''}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetailScreen(
                                    blogId: post['id_blog'],
                                    baseUrl: baseUrl,
                                    currentUserId: widget.currentUserId,
                                  ),
                                ),
                              ).then(
                                  (_) => _fetchPosts()); // Recargar al volver
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
