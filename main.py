import os
from dotenv import load_dotenv
from fastapi import FastAPI, Depends, Query, HTTPException, status, Security
from fastapi.security.api_key import APIKeyHeader
from pydantic import BaseModel
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker, Session
from typing import Optional

# Cargar las variables del .env
load_dotenv()

# Configuración de BD desde .env
USER = os.getenv("DB_USER")
PASSWORD = os.getenv("DB_PASSWORD")
HOST = os.getenv("DB_HOST")
PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")

DATABASE_URL = f"mysql+pymysql://{USER}:{PASSWORD}@{HOST}:{PORT}/{DB_NAME}"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

app = FastAPI(title="API Motomex IA", description="API segura para consulta y leads")

# ---------------------------------------------------------
# CONFIGURACIÓN DE SEGURIDAD (API KEY)
# ---------------------------------------------------------
API_KEY = os.getenv("API_KEY")
api_key_header = APIKeyHeader(name="X-API-Key", auto_error=False)

def validar_token(api_key: str = Security(api_key_header)):
    if api_key != API_KEY or not API_KEY:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Acceso denegado: API Key inválida o ausente"
        )

# Dependencia de la BD
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

class LeadCreate(BaseModel):
    nombre: Optional[str] = None
    ciudad: Optional[str] = None
    estado: Optional[str] = None
    producto_interes: Optional[str] = None
    vehiculo: Optional[str] = None
    anio_vehiculo: Optional[str] = None
    direccion_envio: Optional[str] = None
    lead_completo: bool = False

# ---------------------------------------------------------
# ENDPOINTS (Protegidos con la dependencia validar_token)
# ---------------------------------------------------------

@app.get("/productos", dependencies=[Depends(validar_token)])
def buscar_productos(
    modelo: Optional[str] = Query(None),
    categoria: Optional[str] = Query(None),
    ciudad: Optional[str] = Query(None),
    db: Session = Depends(get_db)
):
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
        return {"mensaje": "No se encontraron productos", "datos": []}
        
    return {"datos": resultados}

@app.post("/leads", dependencies=[Depends(validar_token)])
def registrar_lead(lead: LeadCreate, db: Session = Depends(get_db)):
    query = """
        INSERT INTO leads (nombre, ciudad, estado, producto_interes, vehiculo, anio_vehiculo, direccion_envio, lead_completo)
        VALUES (:nombre, :ciudad, :estado, :producto_interes, :vehiculo, :anio_vehiculo, :direccion_envio, :lead_completo)
    """
    db.execute(text(query), lead.model_dump())
    db.commit()
    
    return {"mensaje": "Lead registrado exitosamente"}