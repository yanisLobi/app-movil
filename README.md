# Blog de reseñas de libros y adaptaciones cinematográficas

Proyecto de clase de Desarrollo de Software para crear una aplicación móvil donde los lectores puedan consultar publicaciones de reseñas y participar con comentarios. El repositorio reúne una aplicación Android hecha con Flutter y una API REST hecha con FastAPI, conectada a una base de datos MySQL mediante SQLAlchemy.

## Objetivo del proyecto

El objetivo es ofrecer una experiencia móvil sencilla para:

- Mostrar publicaciones relacionadas con libros y sus adaptaciones cinematográficas.
- Permitir a los usuarios registrarse e iniciar sesión.
- Consultar publicaciones y su información detallada.
- Permitir la creación de comentarios y la eliminación de comentarios propios.
- Facilitar la navegación por categorías y adaptar la interfaz a dispositivos Android.

La navegación por categorías forma parte del objetivo planteado para el proyecto, pero no se encontró implementada en las pantallas ni en las rutas actuales de la API. Este README distingue ese objetivo de las funciones que sí se observan en el código.

## Tecnologías

- **Flutter y Dart:** interfaz móvil y navegación entre pantallas.
- **Paquete `http`:** solicitudes desde Flutter hacia el servidor.
- **FastAPI:** rutas REST y validación de los datos recibidos.
- **Pydantic:** esquemas para los datos de las solicitudes y respuestas.
- **SQLAlchemy:** modelos y consultas a la base de datos.
- **MySQL:** almacenamiento de usuarios, publicaciones y comentarios.

La versión de Dart indicada en `blog_flutter_app/pubspec.yaml` es `^3.6.1`.

## Cómo se comunican las partes

1. La aplicación Flutter muestra las pantallas y recoge las acciones del usuario.
2. Para obtener o enviar información, Flutter realiza solicitudes HTTP con datos JSON.
3. FastAPI recibe las solicitudes, valida los datos y ejecuta las consultas mediante SQLAlchemy.
4. SQLAlchemy se conecta a MySQL y devuelve los datos que FastAPI responde a la aplicación.

## Funciones que aparecen en el código actual

- Una pantalla de bienvenida que lleva al inicio de sesión.
- Formularios de inicio de sesión y registro.
- Un listado de publicaciones cargado desde `GET /posts`, filtrable por género desde el menú lateral.
- Una pantalla de detalle que muestra la publicación y sus comentarios.
- La creación de comentarios y la eliminación de comentarios propios.
- Indicadores de carga, mensajes de error y opciones para volver a intentar algunas solicitudes.

La tabla `blog` incluye los campos `tags` y `generos`; el listado y el detalle reciben el género de cada publicación, y el menú lateral permite filtrar por los géneros definidos en la base de datos. No se encontró un modelo separado para adaptaciones cinematográficas; el proyecto actual presenta publicaciones del blog.

### Aspectos que conviene tener en cuenta

- La dirección del servidor está escrita en el código Flutter y debe apuntar a una dirección accesible desde el dispositivo o emulador Android. La dirección que se usa en un entorno de desarrollo puede no funcionar en otro; no se incluye aquí porque puede ser temporal.
- El inicio de sesión pasa el identificador y el nombre del usuario autenticado a la aplicación: el identificador se usa para crear o eliminar comentarios y el nombre se muestra en el menú lateral.
- El formulario Flutter de registro envía `tip_usu` como texto cuando se deja vacío, mientras que el esquema del backend lo define como número. Si se utiliza ese campo, ambos lados deben enviar y esperar el mismo tipo.
- La prueba de widgets verifica que el listado se filtre por género desde el menú lateral.

## Estructura del repositorio

```text
.
├── .github/
│   └── copilot-instructions.md
├── blog_backend/
│   ├── database.py
│   ├── main.py
│   └── static/
│       └── index.html
└── blog_flutter_app/
    ├── lib/
    │   ├── main.dart
    │   ├── post.dart
    │   └── views/
    │       ├── login_screen.dart
    │       ├── post_detail_screen.dart
    │       ├── posts_screen.dart
    │       ├── register_screen.dart
    │       └── splash_screen.dart
    ├── test/
    │   └── widget_test.dart
    └── pubspec.yaml
```

### Backend

- `blog_backend/main.py`: aplicación FastAPI, modelos SQLAlchemy, esquemas Pydantic y rutas.
- `blog_backend/database.py`: dirección de conexión a MySQL, motor SQLAlchemy y sesiones de base de datos.
- `blog_backend/static/`: contenido estático del backend.

Los modelos actuales representan tres tablas:

- `usuario`: datos del usuario y tipo de cuenta.
- `blog`: título, descripción, imagen, etiquetas y género de la publicación.
- `comentarios`: texto, fecha, estado e identificadores del usuario y de la publicación.

### Aplicación Flutter

- `blog_flutter_app/lib/main.dart`: inicialización y tema general de la aplicación.
- `blog_flutter_app/lib/views/`: pantallas de bienvenida, autenticación, publicaciones y detalle.
- `blog_flutter_app/lib/post.dart`: modelo Dart para una publicación.
- `blog_flutter_app/test/`: pruebas de widgets.
- `blog_flutter_app/pubspec.yaml`: versión del SDK y dependencias de Flutter.

## Rutas de la API

Las rutas actuales están definidas en `blog_backend/main.py`.

| Método | Ruta | Función |
|---|---|---|
| `GET` | `/posts` | Obtener las publicaciones, incluido el campo `generos`. |
| `GET` | `/posts/{blog_id}` | Obtener el detalle de una publicación (incluido `generos`) y sus comentarios activos. |
| `POST` | `/comentarios` | Crear un comentario. |
| `DELETE` | `/comentarios/{comentario_id}?usr_id={id}` | Eliminar un comentario si corresponde al usuario indicado. |
| `POST` | `/RegistroUsuario` | Registrar un usuario si su correo no existe. |
| `POST` | `/Login` | Comprobar el correo y la contraseña. |

### Datos principales de las solicitudes

- **Registro (`/RegistroUsuario`):** `nom_usr` (texto), `mail` (texto), `pass_` (texto de al menos 8 caracteres), `dir_usr` (texto opcional) y `tip_usu` (número, por defecto `1`). La API almacena las contraseñas derivadas con PBKDF2 y una sal única; las contraseñas antiguas en texto plano se actualizan cuando su titular inicia sesión correctamente.
- **Inicio de sesión (`/Login`):** `mail` y `pass_`.
- **Crear comentario (`/comentarios`):** `comentario` (texto), `usr_id` (número) y `blog_id` (número).

La API devuelve los errores de validación o de búsqueda como respuestas HTTP. Al ejecutar el servidor FastAPI localmente, su documentación interactiva normalmente está disponible en `http://127.0.0.1:8000/docs`.

## Requisitos para ejecutar el proyecto

- Flutter instalado, con una versión de Dart compatible con la indicada en `pubspec.yaml`.
- Un dispositivo o emulador Android para ejecutar la aplicación móvil.
- Python instalado y las dependencias necesarias para FastAPI, SQLAlchemy y el conector de MySQL.
- Un servidor MySQL disponible, con la base de datos y las tablas que usan los modelos.
- Una dirección del backend a la que pueda acceder el dispositivo Android.

**Configuración pendiente para cada entorno:** no se encontró un archivo de dependencias del backend, un script de creación de tablas ni datos iniciales en `blog_backend/`. Por ello, hay que preparar las dependencias y la base de datos por separado antes de iniciar la API. La conexión a MySQL se define en `blog_backend/database.py`; verifica que use tu configuración local y no publiques credenciales.

## Ejecución en desarrollo

### 1. Preparar e iniciar el backend

Una vez instalado y configurado Python, las dependencias necesarias, MySQL y sus tablas:

```powershell
cd blog_backend
python -m uvicorn main:app --reload
```

El comando usa Uvicorn para ejecutar la aplicación FastAPI durante el desarrollo. Si Uvicorn no está disponible en el entorno Python, será necesario instalarlo junto con las dependencias del backend.

### 2. Configurar y ejecutar Flutter

Antes de ejecutar la app, ajusta la dirección del backend en los puntos donde se configura en Flutter para que el Android o emulador pueda alcanzarlo.

```powershell
cd blog_flutter_app
flutter pub get
flutter run
```

## Comprobaciones

Desde `blog_flutter_app/` se pueden ejecutar:

```powershell
flutter analyze
flutter test
```

La prueba actual de `test/widget_test.dart` es la plantilla del contador de Flutter y no valida la funcionalidad del blog. No se encontraron pruebas automatizadas para el backend.
