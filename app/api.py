from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel
from typing import Optional
import os
import sys

# Adiciona o diretório atual (app/) ao sys.path para que as importações internas funcionem de qualquer lugar
sys.path.append(os.path.dirname(__file__))

from services.kpi_service import KPIService

app = FastAPI(title="Aurora Comercial API")

# Setup the static files serving (Frontend)
static_dir = os.path.join(os.path.dirname(__file__), "static")
if not os.path.exists(static_dir):
    os.makedirs(static_dir)

app.mount("/static", StaticFiles(directory=static_dir), name="static")

@app.get("/")
def read_index():
    return FileResponse(os.path.join(static_dir, "index.html"))

# Instance of our KPI service
kpi_service = KPIService()

def handle_request(func, **kwargs):
    try:
        return func(**kwargs)
    except Exception as e:
        raise HTTPException(status_code=503, detail=str(e))

@app.get("/api/filtros")
def get_filtros():
    return handle_request(kpi_service.get_filtros_opcoes)

@app.get("/api/kpis")
def get_kpis(
    data_inicial: Optional[str] = None,
    data_final: Optional[str] = None,
    id_filial: Optional[int] = None,
    id_categoria: Optional[int] = None,
    id_produto: Optional[int] = None
):
    return handle_request(
        kpi_service.kpis_globais,
        data_inicial=data_inicial,
        data_final=data_final,
        id_filial=id_filial,
        id_categoria=id_categoria,
        id_produto=id_produto
    )

@app.get("/api/tabelas/mensal")
def get_tabela_mensal(
    data_inicial: Optional[str] = None,
    data_final: Optional[str] = None,
    id_filial: Optional[int] = None,
    id_categoria: Optional[int] = None,
    id_produto: Optional[int] = None
):
    return handle_request(
        kpi_service.faturamento_por_mes,
        data_inicial=data_inicial,
        data_final=data_final,
        id_filial=id_filial,
        id_categoria=id_categoria,
        id_produto=id_produto
    )

@app.get("/api/tabelas/filial")
def get_tabela_filial(
    data_inicial: Optional[str] = None,
    data_final: Optional[str] = None,
    id_filial: Optional[int] = None,
    id_categoria: Optional[int] = None,
    id_produto: Optional[int] = None
):
    return handle_request(
        kpi_service.receita_por_filial,
        data_inicial=data_inicial,
        data_final=data_final,
        id_filial=id_filial,
        id_categoria=id_categoria,
        id_produto=id_produto
    )

@app.get("/api/tabelas/categoria")
def get_tabela_categoria(
    data_inicial: Optional[str] = None,
    data_final: Optional[str] = None,
    id_filial: Optional[int] = None,
    id_categoria: Optional[int] = None,
    id_produto: Optional[int] = None
):
    return handle_request(
        kpi_service.receita_por_categoria,
        data_inicial=data_inicial,
        data_final=data_final,
        id_filial=id_filial,
        id_categoria=id_categoria,
        id_produto=id_produto
    )

@app.get("/api/tabelas/produtos")
def get_tabela_produtos(
    data_inicial: Optional[str] = None,
    data_final: Optional[str] = None,
    id_filial: Optional[int] = None,
    id_categoria: Optional[int] = None,
    id_produto: Optional[int] = None
):
    return handle_request(
        kpi_service.produtos_mais_vendidos,
        data_inicial=data_inicial,
        data_final=data_final,
        id_filial=id_filial,
        id_categoria=id_categoria,
        id_produto=id_produto
    )
