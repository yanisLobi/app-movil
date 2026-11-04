from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship, Session
from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

from database import Base, get_db

#============================================================
# 1. APLICACIÓN Y CONFIGURACIÓN DE CORS
#============================================================

app = FastAPI(title="Blog API Integrador")

# Configuración explicita de CORS para permitir peticiones desde Flutter
# origins =["*"] permite conexiones desde cualquier cliente (Web, Android,i0S, Desktop)
origins = [
    "*",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins, #Permite todos los orígenes
    allow_credentials=True,  # Permite credenciales/cookies si fuera necesario
    allow_methods=["*"], # Permite todos los métodos HTTP (GET, POST, DELETE, OPTIONS, etc.)
    allow_headers=["*"],  # Permite todos los encabezados HTTP (Content-Type, Authorization, etc.)
)


# ============================================================
# 2. MODELOS DE SQLALCHEMY (Mapeo de la Base de Datos)
# ============================================================

class Usuario(Base):
    __tablename__ = "usuario"

    id_usr = Column(Integer, primary_key=True, index=True, autoincrement=True)
    nom_usr = Column(String(100), nullable=False)
    mail = Column(String(150), nullable=False, unique=True)
    pass_ = Column("pass", String(255), nullable=False)
    dir_usr = Column(String(255), nullable=True)
    tip_usu = Column(Integer, default=1, nullable=False)

    comentarios = relationship("Comentario", back_populates="autor")

class Blog(Base):
    __tablename__ = "blog"

    id_blog = Column(Integer, primary_key=True, index=True, autoincrement=True)
    titulo = Column(String(200), nullable=False)
    desc = Column(String(500), nullable=True)
    img = Column(String(255), nullable=True)
    tags = Column(String(255), nullable=True)

    comentarios = relationship("Comentario", back_populates="post")

class Comentario(Base):
    __tablename__ = "comentarios"

    id_com = Column(Integer, primary_key=True, index=True, autoincrement=True)
    comentario = Column(String(500), nullable=False)
    fecha = Column(DateTime, default=datetime.utcnow, nullable=False)
    estatus = Column(Integer, default=1, nullable=False)
    usr_id = Column(Integer, ForeignKey("usuario.id_usr"), nullable=False)
    blog_id = Column(Integer, ForeignKey("blog.id_blog"), nullable=False)

    autor = relationship("Usuario", back_populates="comentarios")
    post = relationship("Blog", back_populates="comentarios")


# ============================================================
# 3. ESQUEMAS DE PYDANTIC (Validación y Serialización JSON)
# ============================================================

class ComentarioCreate(BaseModel):
    comentario: str
    usr_id: int
    blog_id: int

class ComentarioResponse(BaseModel):
    id_com: int
    comentario: str
    fecha: datetime
    usr_id: int
    nom_usr: str

    class Config:
        from_attributes = True

class BlogBase(BaseModel):
    id_blog: int
    titulo: str
    desc: Optional[str] = None
    img: Optional[str] = None
    tags: Optional[str] = None

    class Config:
        from_attributes = True

class BlogDetailResponse(BlogBase):
    comentarios: List[ComentarioResponse] = []


# ============================================================
# 4. ENDPOINTS DE LA API
# ============================================================

# Endpoint 1: Obtener lista de todos los posts
@app.get("/posts", response_model=List[BlogBase])
def get_posts(db: Session = Depends(get_db)):
    posts = db.query(Blog).all()
    return posts

# Endpoint 2: Obtener detalle de un post con comentarios y autor
@app.get("/posts/{blog_id}", response_model=BlogDetailResponse)
def get_post_detail(blog_id: int, db: Session = Depends(get_db)):
    post = db.query(Blog).filter(Blog.id_blog == blog_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Post no encontrado")
    
    comentarios_dto = []
    for com in post.comentarios:
        if com.estatus == 1:  # Solo activos
            comentarios_dto.append(
                ComentarioResponse(
                    id_com=com.id_com,
                    comentario=com.comentario,
                    fecha=com.fecha,
                    usr_id=com.usr_id,
                    nom_usr=com.autor.nom_usr if com.autor else "Usuario Anónimo"
                )
            )
            
    return BlogDetailResponse(
        id_blog=post.id_blog,
        titulo=post.titulo,
        desc=post.desc,
        img=post.img,
        tags=post.tags,
        comentarios=comentarios_dto
    )

# Endpoint 3: Publicar un comentario
@app.post("/comentarios", response_model=ComentarioResponse, status_code=status.HTTP_201_CREATED)
def create_comentario(data: ComentarioCreate, db: Session = Depends(get_db)):
    usr = db.query(Usuario).filter(Usuario.id_usr == data.usr_id).first()
    if not usr:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    blog = db.query(Blog).filter(Blog.id_blog == data.blog_id).first()
    if not blog:
        raise HTTPException(status_code=404, detail="Post no encontrado")

    nuevo_comentario = Comentario(
        comentario=data.comentario,
        usr_id=data.usr_id,
        blog_id=data.blog_id
    )
    db.add(nuevo_comentario)
    db.commit()
    db.refresh(nuevo_comentario)

    return ComentarioResponse(
        id_com=nuevo_comentario.id_com,
        comentario=nuevo_comentario.comentario,
        fecha=nuevo_comentario.fecha,
        usr_id=nuevo_comentario.usr_id,
        nom_usr=usr.nom_usr
    )

# Endpoint 4: Eliminar un comentario (Validando pertenencia)
@app.delete("/comentarios/{comentario_id}")
def delete_comentario(comentario_id: int, usr_id: int, db: Session = Depends(get_db)):
    comentario = db.query(Comentario).filter(Comentario.id_com == comentario_id).first()
    
    if not comentario:
        raise HTTPException(status_code=404, detail="Comentario no encontrado")
    
    if comentario.usr_id != usr_id:
        raise HTTPException(status_code=403, detail="No tienes permiso para eliminar este comentario")
    
    db.delete(comentario)
    db.commit()
    
    return {"message": "Comentario eliminado exitosamente"}

class UsuarioCreate(BaseModel):
    nom_usr: str
    mail: str
    pass_: str
    dir_usr: Optional[str] = None
    tip_usu: int = 1

class UsuarioResponse(BaseModel):
    id_usr: int
    nom_usr: str
    mail: str
    tip_usu: int

    class Config:
        from_attributes = True

class LoginRequest(BaseModel):
    mail: str
    pass_: str

# Endpoint de Registro de Usuario
@app.post("/RegistroUsuario", response_model=UsuarioResponse, status_code=status.HTTP_201_CREATED)
def registrar_usuario(usuario: UsuarioCreate, db: Session = Depends(get_db)):
    # Verificar si el correo ya existe
    existe_usuario = db.query(Usuario).filter(Usuario.mail == usuario.mail).first()
    if existe_usuario:
        raise HTTPException(status_code=400, detail="El correo electrónico ya está registrado")
    
    nuevo_usuario = Usuario(
        nom_usr=usuario.nom_usr,
        mail=usuario.mail,
        pass_=usuario.pass_, 
        dir_usr=usuario.dir_usr,
        tip_usu=usuario.tip_usu
    )
    db.add(nuevo_usuario)
    db.commit()
    db.refresh(nuevo_usuario)
    return nuevo_usuario

# Endpoint de Login
@app.post("/Login")
def login(credenciales: LoginRequest, db: Session = Depends(get_db)):
    # Buscar al usuario por su correo
    usuario = db.query(Usuario).filter(Usuario.mail == credenciales.mail).first()
    
    if not usuario:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    
    # Validar contraseña 
    if usuario.pass_ != credenciales.pass_:
        raise HTTPException(status_code=401, detail="Contraseña incorrecta")
    
    return {
        "message": "Login exitoso",
        "user": {
            "id_usr": usuario.id_usr,
            "nom_usr": usuario.nom_usr,
            "mail": usuario.mail,
            "tip_usu": usuario.tip_usu
        }
    }