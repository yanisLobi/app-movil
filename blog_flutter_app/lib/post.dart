class Post {
  final int idBlog;
  final String titulo;
  final String? desc;
  final String? img;
  final String? tags;
  final String generos;

  Post({
    required this.idBlog,
    required this.titulo,
    required this.generos,
    this.desc,
    this.img,
    this.tags,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      // Coincide con el JSON que devuelve FastAPI según tu base de datos
      idBlog: json['id_blog'] ?? 0,
      titulo: json['titulo'] ?? '',
      desc: json['desc'],
      img: json['img'],
      tags: json['tags'],
      generos: json['generos'] ?? '',
    );
  }
}
