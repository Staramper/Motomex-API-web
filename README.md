# 🏍️ Motomex AI - Asistente Conversacional y Sistema ETL

Este repositorio contiene la infraestructura, el backend (API) y los flujos de automatización para el sistema inteligente de ventas de Motomex. La arquitectura integra un bot de WhatsApp impulsado por IA (Gemini), un sistema de extracción de datos (ETL) y una base de datos relacional para la gestión de inventario y prospectos (leads).

## 📂 Estructura del Proyecto

Todos los recursos necesarios están organizados de la siguiente manera:

* **`/Recursos Extras/BD/`**: Contiene el archivo `docker-compose.yml` para levantar MySQL y phpMyAdmin, junto con el archivo `motomex_db.sql` para importar la estructura de las tablas.
* **`/Recursos Extras/Evolution API/`**: Contiene el `docker-compose.yaml` necesario para levantar la instancia local de la API de WhatsApp.
* **`/Recursos Extras/Workflows n8n/`**: Aquí encontrarás los archivos JSON listos para importar en tu n8n:
    * `Atención de clientes Motomex.json`: El flujo principal del Agente de IA.
    * `Texto prosa a BD.json`: El pipeline ETL para la carga inicial del catálogo.
* **`main.py`**: El código fuente de nuestra API segura desarrollada en FastAPI.
* **`requirements.txt`**: Las dependencias de Python necesarias para el microservicio.
* **`.env.example`**: Plantilla base para las credenciales del sistema.

---

## 🚀 Guía de Instalación y Ejecución

Sigue estos pasos en orden para levantar el proyecto completo en tu entorno local.

### Paso 1: Variables de Entorno
1. Duplica el archivo `.env.example` y renómbralo a `.env`.
2. Llena las variables con tus credenciales locales (Usuario de BD, contraseñas, y tu API Key generada para proteger el sistema).

### Paso 2: Levantar Infraestructura (Bases de Datos y WhatsApp)
Asegúrate de tener Docker instalado y ejecutándose.

1. Ve a la carpeta de la base de datos y levanta los contenedores:
   ```bash
   cd "Recursos Extras/BD"
   docker-compose up -d

2. Importa el archivo motomex_db.sql usando phpMyAdmin (o tu gestor de base de datos preferido) para crear las tablas productos y leads.

3. Ve a la carpeta de Evolution API y levanta el servicio de WhatsApp:
    ```bash
    cd "../Evolution API"
    docker-compose up -d

### Paso 3: Configurar y Levantar la API (Python)

Para mantener las dependencias aisladas y evitar conflictos, ejecutaremos la API en un entorno virtual. Abre una terminal en la raíz del proyecto y ejecuta:

#### 1. Crear el entorno virtual
    ```bash
    python -m venv venv

#### 2. Activar el entorno virtual

**En Windows**

```bash
venv\Scripts\activate
```

**En Linux/Mac**

```bash
source venv/bin/activate
```

#### 3. Instalar las dependencias

```bash
pip install -r requirements.txt
```

#### 4. Levantar el servidor FastAPI

```bash
uvicorn main:app --reload
```

La API estará corriendo en `http://127.0.0.1:8000`.

Puedes acceder a `http://127.0.0.1:8000/docs` para ver la documentación interactiva (Swagger UI) y probar los endpoints protegidos.

---

### Paso 4: Importar los Flujos en n8n

Abre tu instancia de **n8n**.

Ve a la sección de **Workflows** y selecciona **"Import from File"**.

Importa los dos archivos `.json` ubicados en la carpeta:

```text
Recursos Extras/Workflows n8n/
```

Asegúrate de configurar tus credenciales (**API Keys de Gemini** y los **Webhooks de Evolution API**) dentro de los nodos correspondientes antes de activar los flujos.

---

### Nota

Desarrollado para evaluación técnica de Arquitectura de Soluciones e IA.