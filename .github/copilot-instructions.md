# Instrucciones para trabajar en este proyecto

## Contexto del proyecto

Este repositorio es un proyecto de clase sobre un blog de reseñas de libros y sus adaptaciones cinematográficas. Está formado por dos partes:

- `blog_flutter_app/`: aplicación móvil hecha con Flutter y Dart. Consume la API con solicitudes HTTP y JSON.
- `blog_backend/`: API hecha con FastAPI, modelos de base de datos con SQLAlchemy y conexión a MySQL.

El objetivo es que los cambios sean claros y fáciles de explicar en una presentación de desarrollo de software.

## Reglas generales

- Antes de editar, revisa el código cercano y conserva la organización y el estilo que ya usa el proyecto.
- Prefiere la solución más sencilla que resuelva la solicitud. No agregues arquitectura, patrones, paquetes ni conceptos avanzados que no hagan falta o que no se hayan pedido.
- Mantén los cambios relacionados con la solicitud; no reorganices ni reescribas partes ajenas.
- Escribe los nombres y mensajes que ve el usuario en español, siguiendo las pantallas existentes.
- Explica el código nuevo con comentarios en español: comenta el propósito de cada bloque nuevo y la lógica que podría ser difícil de entender. Evita comentarios que solo repitan una línea obvia.
- No inventes funciones que el proyecto aún no implementa. Si una solicitud describe un objetivo, comprueba el código antes de afirmar que ya existe.
- No agregues contraseñas, direcciones privadas, claves ni otros datos locales o secretos al código, a la documentación o a Git. Usa valores de ejemplo claramente ficticios cuando sea necesario.
- Si cambias una ruta, un campo o el formato de los datos de la API, revisa también el código Flutter que consume esa API y la documentación pertinente.

## Aplicación Flutter

- El punto de entrada y el tema general están en `blog_flutter_app/lib/main.dart`.
- Las pantallas están en `blog_flutter_app/lib/views/`; sigue esa separación cuando cambies una pantalla existente.
- El modelo de publicación está en `blog_flutter_app/lib/post.dart`.
- Las solicitudes HTTP usan el paquete `http`; el intercambio de datos con el backend usa JSON.
- La dirección del backend debe ser accesible desde el dispositivo o emulador Android. No des por válida una dirección temporal o local para todos los entornos.
- Después de un cambio de Flutter, ejecuta desde `blog_flutter_app/` los comandos disponibles y pertinentes: `flutter analyze` y, si el cambio afecta pruebas o widgets, `flutter test`. Informa de los errores; no afirmes que pasaron si no se ejecutaron.

## Backend FastAPI

- La aplicación FastAPI, los modelos SQLAlchemy, los esquemas Pydantic y las rutas actuales están en `blog_backend/main.py`.
- La creación de la conexión y las sesiones de base de datos están en `blog_backend/database.py`.
- Conserva los nombres de rutas y campos existentes salvo que la solicitud requiera cambiarlos. Comprueba los campos que Flutter envía y recibe.
- El backend usa MySQL. No publiques los datos de conexión ni asumas que otra computadora tiene la misma base de datos.
- No agregues instrucciones de instalación como si fueran reproducibles: actualmente no hay un manifiesto de dependencias del backend en `blog_backend/`. Si hace falta instalar o probar el backend, explica esta limitación y confirma primero las dependencias disponibles.
- Si modificas la API o el acceso a datos, verifica que el código correspondiente siga usando los mismos campos y respuestas, e indica cualquier prueba que no se pudo ejecutar.

## Pruebas y documentación

- Ejecuta la comprobación más pequeña que cubra el cambio y resume exactamente su resultado.
- Mantén `README.md` en línea con lo que sí existe. Distingue los objetivos del proyecto de las funciones presentes en el código; por ejemplo, no describas categorías como implementadas sin comprobarlas.
- Documenta requisitos locales que falten en lugar de inventar pasos de configuración o valores de conexión.

## Git

- Cada cambio solicitado debe quedar en su propio commit después de verificarlo. Separa los commits cuando los entregables o cambios sean independientes.
- Antes de confirmar, revisa `git status` y prepara únicamente los archivos de la solicitud; no incluyas cambios ajenos.
- Usa un mensaje de commit breve que describa el cambio. No borres ni modifiques cambios locales de otras personas.
