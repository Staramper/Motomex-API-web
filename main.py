import os
from dotenv import load_dotenv
from fastapi import FastAPI, Depends, Query, HTTPException
from pydantic import BaseModel
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker, Session
from typing import Optional

load_dotenv() # Carga las variables de entorno

USER = os.getenv("DB_USER")
PASSWORD = os.getenv("DB_PASSWORD")
HOST = os.getenv("DB_HOST")
PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")

# 1. Configuración de la BD(Apunta al contenedor)
DATABASE_URL = f"mysql+pymysql://{USER}:{PASSWORD}@{HOST}:{PORT}/{DB_NAME}"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# 2. Inicializar FastAPI
app = FastAPI(title="API Refaccionaria IA", description="API para consulta de catálogo y captura de leads")

# Dependencia para manejar la sesión de la BD
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# 3. Esquema Pydantic para validar los datos que el Chatbot enviará (POST Leads)
class LeadCreate(BaseModel):
    nombre: Optional[str] = None
    ciudad: Optional[str] = None
    estado: Optional[str] = None
    producto_interes: Optional[str] = None
    vehiculo: Optional[str] = None
    anio_vehiculo: Optional[str] = None
    direccion_envio: Optional[str] = None
    lead_completo: bool = False

# ENDPOINTS (Rutas de la API)

@app.get("/productos")
def buscar_productos(
    modelo: Optional[str] = Query(None),
    categoria: Optional[str] = Query(None),
    ciudad: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
    """Consulta el catálogo. Permite filtrar por modelo, categoría o ciudad."""
    query = "SELECT * FROM productos WHERE 1=1"
    params = {}
    
    if modelo:
        query += " AND modelo = :modelo"
        params['modelo'] = modelo
    if categoria:
        query += " AND categoria LIKE :categoria"
        params['categoria'] = f"%{categoria}%"
    if ciudad:
        query += " AND ciudad = :ciudad"
        params['ciudad'] = ciudad
        
    resultados = db.execute(text(query), params).mappings().all()
    
    if not resultados:
        return {"mensaje": "No se encontraron productos con esos criterios", "datos": []}
        
    return {"datos": resultados}

@app.post("/leads")
def registrar_lead(lead: LeadCreate, db: Session = Depends(get_db)):
    """Guarda un nuevo prospecto capturado por el chatbot."""
    query = """
        INSERT INTO leads (nombre, ciudad, estado, producto_interes, vehiculo, anio_vehiculo, direccion_envio, lead_completo)
        VALUES (:nombre, :ciudad, :estado, :producto_interes, :vehiculo, :anio_vehiculo, :direccion_envio, :lead_completo)
    """
    
    db.execute(text(query), lead.model_dump())
    db.commit()
    
    return {"mensaje": "Lead registrado exitosamente"}