import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostDetailScreen extends StatefulWidget {
  final int blogId;
  final String baseUrl;
  final int currentUserId;
  final http.Client? client;

  const PostDetailScreen({
    super.key,
    required this.blogId,
    required this.baseUrl,
    required this.currentUserId,
    this.client,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Map<String, dynamic>? _postDetail;
  bool _isLoading = true;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPostDetail();
  }

  Future<void> _fetchPostDetail() async {
    setState(() => _isLoading = true);

    try {
      final uri = Uri.parse('${widget.baseUrl}/posts/${widget.blogId}');
      final response = await (widget.client?.get(uri) ?? http.get(uri));

      if (response.statusCode == 200) {
        setState(() {
          _postDetail = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        _showSnackBar('Error al obtener detalle del post');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      _showSnackBar('Error de conexión: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('${widget.baseUrl}/comentarios'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'comentario': text,
          'usr_id': widget.currentUserId,
          'blog_id': widget.blogId,
        }),
      );

      if (response.statusCode == 201) {
        _commentController.clear();
        _showSnackBar('Comentario publicado');
        _fetchPostDetail(); // Actualiza los comentarios en pantalla
      } else {
        _showSnackBar('No se pudo publicar el comentario');
      }
    } catch (e) {
      _showSnackBar('Error de envío: $e');
    }
  }

  Future<void> _deleteComment(int commentId) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '${widget.baseUrl}/comentarios/$commentId?usr_id=${widget.currentUserId}',
        ),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Comentario eliminado');
        _fetchPostDetail(); // Refrescar lista de comentarios
      } else {
        _showSnackBar('No se pudo eliminar el comentario');
      }
    } catch (e) {
      _showSnackBar('Error al eliminar: $e');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          _postDetail != null ? _postDetail!['titulo'] : 'Detalle',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _postDetail == null
              ? const Center(child: Text('No se pudo cargar la información'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_postDetail!['img'] != null &&
                            _postDetail!['img'].toString().trim().isNotEmpty)
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: SizedBox(
                                width: 160,
                                child: AspectRatio(
                                  aspectRatio: 2 / 3,
                                  child: Image.network(
                                    _postDetail!['img'].toString(),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        const Icon(Icons.menu_book, size: 48),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        // Contenido del Post
                        Text(
                          _postDetail!['titulo'] ?? '',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _postDetail!['desc'] ?? 'Sin descripción',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Divider(height: 32, thickness: 1),

                        // Sección de Comentarios
                        const Text(
                          'Comentarios',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        _postDetail!['comentarios'].isEmpty
                            ? const Text('Aún no hay comentarios.')
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _postDetail!['comentarios'].length,
                                itemBuilder: (context, index) {
                                  final item =
                                      _postDetail!['comentarios'][index];
                                  final bool isMine =
                                      item['usr_id'] == widget.currentUserId;

                                  return Card(
                                    elevation: 1,
                                    child: ListTile(
                                      title: Text(
                                        item['nom_usr'] ?? 'Anónimo',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text(item['comentario'] ?? ''),
                                          const SizedBox(height: 4),
                                          Text(
                                            item['fecha'] ?? '',
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      trailing: isMine
                                          ? IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () => _deleteComment(
                                                  item['id_com']),
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: !_isLoading && _postDetail != null
          ? SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  8 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Escribe un comentario...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Theme.of(context).primaryColor,
                      onPressed: _addComment,
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
