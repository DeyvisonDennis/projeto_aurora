# Entrega Semana 3: Aplicação e Visualizações

Nesta semana, transformamos nossa estrutura técnica de dados em uma aplicação com interface completa para visualização e análise de indicadores comerciais da **Rede Comercial Aurora**.

## O Que Foi Implementado?

### Backend (API REST)
Construído utilizando **Python com FastAPI**. O backend agora é capaz de:
- Servir arquivos de frontend dinamicamente.
- Fornecer endpoints JSON para todos os indicadores.
- Processar filtros via Query Parameters de forma segura, acoplado à classe `KPIService` e `Queries`.
- Lidar graciosamente com quedas de banco de dados, retornando erros mapeados (Status 503) em vez de travamentos (crashes).

### Frontend (Dashboard)
Construído com **HTML5, CSS Vanilla e JavaScript puro**. Nenhuma biblioteca de gráficos pesada foi usada.
- **Estética Moderna**: Aplicação de Glassmorphism, paleta de cores harmoniosa, Dark Mode padrão e Layout Responsivo com CSS Grid.
- **Cards Analíticos**: 8 Indicadores obrigatórios exibidos de forma destacada no topo da página.
- **Filtros Dinâmicos**: Barra lateral contendo opções de período, seleção de filial, categoria e produto. Ao alterar, os dados buscam novamente.
- **Tabelas Analíticas (No lugar de Gráficos)**: Como requisitado, foram implementadas as 4 visualizações analíticas em formato tabular.
- **Tratamento de Queda do Banco**: Se o backend não conseguir acesso ao banco de dados (Container caiu, portas alteradas), um banner de erro vermelho amigável e limpo surge, sem travar a navegação.

## Como Executar a Aplicação

A execução é incrivelmente simples e necessita de apenas dois terminais.

### 1. Banco de Dados (Via Docker)
Certifique-se de que o PostgreSQL está rodando. Se precisar reiniciar do zero com a carga completa:
```bash
cd infra/docker
docker-compose down -v
docker-compose up -d
```

### 2. Subindo a Aplicação
Instale as dependências caso não possua:
```bash
pip install -r app/requirements.txt
```

Dentro da pasta principal do projeto (onde está a pasta `app/`), execute a inicialização do FastAPI:
```bash
python -m uvicorn app.api:app --reload
```
Isso iniciará o servidor na porta 8000.

### 3. Acessando a Interface Principal
Abra no seu navegador:
**[http://localhost:8000](http://localhost:8000)**

## Evidência de Testes
O documento com a validação técnica exigida com 7 cenários mínimos de testes foi incluído na documentação em: [docs/testes_semana3.md](testes_semana3.md).
