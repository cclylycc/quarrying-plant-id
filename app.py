"""
Identificación de plantas
"""
import io
import os
import time
from typing import Optional, List
from contextlib import asynccontextmanager

import cv2
import numpy as np
from fastapi import FastAPI, File, UploadFile, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
from PIL import Image
from pydantic import BaseModel, Field

import plantid
from plantid.invasive import InvasiveChecker


# ==================== configs ====================

# Lifespan
@asynccontextmanager
async def lifespan(app: FastAPI):
    # run when start
    print("Loading model...")
    load_model()
    load_model()
    print("Model loaded！")
    print("Loading invasive checker...")
    load_invasive_checker()
    print("Invasive checker loaded!")
    yield
    # run when shut down
    print("Service shutting down...")

app = FastAPI(
    title="API de Identificación de plantas",
    description="https://github.com/quarrying/quarrying-plant-id",
    version="1.0.0",
    docs_url="/docs",  # Swagger UI
    redoc_url="/redoc",  # ReDoc
    lifespan=lifespan
)

# load static dics
if os.path.exists("static"):
    app.mount("/static", StaticFiles(directory="static"), name="static")

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Iniciar plant identifier
# Iniciar plant identifier
plant_identifier = None
invasive_checker = None


# ==================== Model ====================

class PlantResult(BaseModel):
    """Results plant"""
    ##chinese_name: str = Field(..., description="Chinese Name")
    latin_name: str = Field(..., description="Latin Name")
    probability: float = Field(..., description="Probabilidad", ge=0, le=1)
    invasive_info: Optional[dict] = Field(default=None, description="Invasive species information")


class IdentifyResponse(BaseModel):
    """model status result"""
    status: int = Field(..., description="Code：0-success，negative-fail")
    message: str = Field(..., description="Status")
    inference_time: float = Field(..., description="Time (sec)")
    results: List[PlantResult] = Field(default=[], description="Resultados de la clasificación")
    genus_results: List[PlantResult] = Field(default=[], description="Resultado de la identificación de la clasificación de especies")
    family_results: List[PlantResult] = Field(default=[], description="Resultados de la identificación a nivel departamental")


class HealthResponse(BaseModel):
    """Health check"""
    status: str
    model_loaded: bool
    supported_species: int
    supported_genus: int
    supported_family: int

def load_model():
    """Load model from plantid"""
    global plant_identifier
    if plant_identifier is None:
        plant_identifier = plantid.PlantIdentifier()
    return plant_identifier


def load_invasive_checker():
    """Load invasive checker"""
    global invasive_checker
    if invasive_checker is None:
        invasive_checker = InvasiveChecker()
    return invasive_checker


async def read_image_file(file: UploadFile) -> np.ndarray:
    """
    read upload picture and to Opencv

    Args:
        file: picture

    Returns:
        numpy.ndarray: OpenCV picture file

    Raises:
        HTTPException:
    """
    try:
        # read file content
        contents = await file.read()

        # use pil to read pic
        image = Image.open(io.BytesIO(contents))

        # RGB mode or RGBA
        if image.mode != 'RGB':
            image = image.convert('RGB')

        # convert to numpy arry
        image_np = np.array(image)

        # PIL use RGB, opencv use BGR convert
        image_cv = cv2.cvtColor(image_np, cv2.COLOR_RGB2BGR)

        return image_cv

    except Exception as e:
        raise HTTPException(
            status_code=400,
            detail=f"Failed to read picture file: {str(e)}"
        )


# ==================== API router ====================

@app.get("/", tags=["Root"])
async def root():
    """API root. To main page"""
    # HTML if has static html, to html
    static_index = "static/index.html"
    if os.path.exists(static_index):
        with open(static_index, 'r', encoding='utf-8') as f:
            return HTMLResponse(content=f.read())

    # or to RETURN JSON
    return {
        "message": "Identificación de plantas API",
        "web_ui": "/static/index.html",
        "docs": "/docs",
        "health": "/health",
        "version": "1.0.0"
    }


@app.get("/health", response_model=HealthResponse, tags=["System"])
async def health_check():
    """
    to check model, health, running?
    """
    identifier = load_model()
    names, family_names, genus_names = identifier.get_plant_names()

    return HealthResponse(
        status="healthy",
        model_loaded=True,
        supported_species=len(names),
        supported_genus=len(genus_names),
        supported_family=len(family_names)
    )


@app.post("/identify", response_model=IdentifyResponse, tags=["Identificación"])
async def identify_plant(
    file: UploadFile = File(..., description="Identificación de plantas API, usa jpg,png..."),
    topk: int = Query(5, ge=1, le=20, description="Return 5 results"),
    location: Optional[str] = Query(None, description="User location for invasive species check")
):
    """
    Return example：

    ```json
    {
        "status": 0,
        "message": "True",
        "inference_time": 0.123,
        "results": [
            {
                "chinese_name": "一串红",
                "latin_name": "Salvia splendens",
                "probability": 0.95
            }
        ]
    }
    ```
    """
    # file check
    if not file.content_type.startswith("image/"):
        raise HTTPException(
            status_code=400,
            detail="Tipo de archivo incorrecto. Sube un archivo de imagen."
        )

    # read image
    image = await read_image_file(file)

    # load model
    identifier = load_model()

    # run identify
    start_time = time.time()
    outputs = identifier.identify(image, topk=topk)
    
    # Invasive check for the top result
    if location and outputs['status'] == 0 and outputs['results']:
        checker = load_invasive_checker()
        top_result = outputs['results'][0]
        invasive_info = await checker.check_invasive(top_result['latin_name'], location)
        top_result['invasive_info'] = invasive_info
        
    inference_time = time.time() - start_time

    # response
    response = IdentifyResponse(
        status=outputs['status'],
        message=outputs['message'],
        inference_time=round(inference_time, 4),
        results=[PlantResult(**item) for item in outputs.get('results', [])],
        genus_results=[PlantResult(**item) for item in outputs.get('genus_results', [])],
        family_results=[PlantResult(**item) for item in outputs.get('family_results', [])]
    )

    return response


@app.post("/identify/quick", tags=["identift quick only ONE result"])
async def identify_plant_quick(
    file: UploadFile = File(..., description="Upload plant image"),
    location: Optional[str] = Query(None, description="User location for invasive species check")
):
    image = await read_image_file(file)
    identifier = load_model()
    start_time = time.time()
    outputs = identifier.identify(image, topk=1)
    
    invasive_info = None
    if location and outputs['status'] == 0 and outputs['results']:
        checker = load_invasive_checker()
        top_result = outputs['results'][0]
        invasive_info = await checker.check_invasive(top_result['latin_name'], location)
        
    inference_time = time.time() - start_time

    if outputs['status'] != 0:
        return JSONResponse(
            status_code=500,
            content={
                "status": outputs['status'],
                "message": outputs['message']
            }
        )

    result = outputs['results'][0]
    return {
        "status": 0,
        "message": "True",
        "inference_time": round(inference_time, 4),
        ##"chinese_name": result['chinese_name'],
        "latin_name": result['latin_name'],
        "probability": result['probability'],
        "invasive_info": invasive_info
    }


@app.get("/species", tags=["Species check"])
async def list_species(
    limit: int = Query(20, ge=1, le=100, description="return limit"),
    offset: int = Query(0, ge=0, description="offset?")
):
    """
    - **limit**: return limit（max 100）
    - **offset**: offset（multiple pages?）
    """
    identifier = load_model()
    names, _, _ = identifier.get_plant_names()

    total = len(names)
    species_list = names[offset:offset + limit]

    return {
        "total": total,
        "limit": limit,
        "offset": offset,
        "species": species_list
    }


@app.get("/search", tags=["Search"])
async def search_species(
    keyword: str = Query(..., min_length=1, description="keyword search"),
    limit: int = Query(20, ge=1, le=100, description="return limit")
):
    identifier = load_model()
    names, _, _ = identifier.get_plant_names()

    matched_species = [name for name in names if keyword in name][:limit]

    return {
        "keyword": keyword,
        "total": len(matched_species),
        "results": matched_species
    }


# ==================== errores ====================

@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    """global error"""
    return JSONResponse(
        status_code=500,
        content={
            "status": -999,
            "message": f"Server error: {str(exc)}"
        }
    )


# ==================== Run server ====================

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app:app",
        host="127.0.0.1",
        port=8000,
        reload=True
    )

