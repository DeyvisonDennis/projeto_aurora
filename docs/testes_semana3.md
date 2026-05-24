# Validação Técnica e Testes - Semana 3

Este documento registra a execução dos testes técnicos mínimos exigidos para a entrega da Semana 3 da Rede Comercial Aurora.

---

### Teste 1: Execução do Container e Criação do Banco
- **Objetivo do teste**: Validar se o Docker sobe corretamente o PostgreSQL na porta 5432 e cria a estrutura inicial sem falhas.
- **Passos executados**: 
  1. No terminal, acesso a pasta `infra/docker`.
  2. Comando executado: `docker-compose down -v && docker-compose up -d`.
- **Resultado esperado**: Container `aurora-db` em estado `Running` (Up).
- **Resultado obtido**: Sucesso. O container subiu normalmente e a porta 5432 foi liberada no localhost.
- **Problema encontrado**: Nenhum.

---

### Teste 2: Execução do Script SQL (Carga)
- **Objetivo do teste**: Garantir que o script `cria_banco.sql` rodou e povoou as tabelas com a massa de dados gerada na semana 2 (120 vendas).
- **Passos executados**: 
  1. Acesso via DBeaver ou psql no localhost:5432.
  2. Execução da query `SELECT COUNT(*) FROM venda;`.
- **Resultado esperado**: Retornar `120`.
- **Resultado obtido**: Retornou `120`. Tabelas criadas.
- **Problema encontrado**: Nenhum.

---

### Teste 3: Conexão da Aplicação com o Banco
- **Objetivo do teste**: Garantir que o Backend (FastAPI via Python/psycopg2) consegue obter uma sessão e realizar as consultas.
- **Passos executados**: 
  1. Na raiz do projeto, execução de `python -m uvicorn app.api:app`.
  2. Acessar `/api/filtros` pelo navegador.
- **Resultado esperado**: Retornar o JSON listando Filiais, Categorias e Produtos corretamente.
- **Resultado obtido**: O backend buscou no banco e devolveu as listas com os `ids` e `nomes`. Sucesso.
- **Problema encontrado**: Nenhum.

---

### Teste 4: Cálculo dos Indicadores (Mínimo de 3)
- **Objetivo do teste**: Validar se os cálculos de Receita Líquida, Margem Bruta e Ticket Médio estão funcionando na nova API REST sem quebra de fórmulas.
- **Passos executados**: 
  1. Acessar rota `/api/kpis` (que engloba os 8 KPIs).
- **Resultado esperado**: JSON com campos não nulos representando os cálculos financeiros aplicados. Exemplo: `{ "faturamento_bruto": 250000, "margem_bruta": 120000 }`.
- **Resultado obtido**: Sucesso. A estrutura retornada atende as expectativas da regra de negócio exigida.
- **Problema encontrado**: Nenhum.

---

### Teste 5: Abertura da Interface Principal
- **Objetivo do teste**: Garantir que o frontend é entregue corretamente e renderiza a tela.
- **Passos executados**: 
  1. Acessar http://localhost:8000 no navegador.
- **Resultado esperado**: Renderizar a tela de Dashboard com a paleta predefinida, layout das tabelas, painel lateral e carregamento sem travamentos.
- **Resultado obtido**: A interface carregou imediatamente (SSG/Estático) e buscou os dados assincronamente preenchendo as tabelas.
- **Problema encontrado**: Nenhum.

---

### Teste 6: Aplicação de Filtros (Pelo Menos 2)
- **Objetivo do teste**: Validar se o `app.js` escuta corretamente o evento de "change" nos filtros de *Filial* e *Categoria*, e se atualiza os dados na tela.
- **Passos executados**: 
  1. Selecionar "Aurora Matriz" (Filial) no dropdown.
  2. Observar a atualização dos cards.
  3. Selecionar "Eletrodomésticos" (Categoria) no dropdown de categorias.
  4. Observar a atualização.
- **Resultado esperado**: A página deve enviar nova requisição via query string (ex: `?id_filial=1&id_categoria=2`), o card de Receita Líquida e Tabelas Analíticas devem mostrar valores reduzidos (afinal o dado é menor que o global).
- **Resultado obtido**: Todos os KPIs e tabelas foram reativos, com os valores mudando logo após o clique de forma suave.
- **Problema encontrado**: Nenhum.

---

### Teste 7: Resiliência em Falha de Conexão (Lidar com ausência de BD)
- **Objetivo do teste**: Cumprir requisito obrigatório "não quebrar a página quando o banco cair".
- **Passos executados**: 
  1. Desligar o container docker com comando `docker stop aurora-db`.
  2. Com a página já aberta, tentar alterar o filtro de "Período".
- **Resultado esperado**: A aplicação tentará buscar novos dados, receberá falha do backend (503 Service Unavailable), as tabelas/cards ficarão vazios (R$ 0,00) e um banner amigável surgirá notificando a queda do banco de dados, sem tela branca da morte ou congelamento.
- **Resultado obtido**: Teste perfeito. O frontend capturou a exceção e manipulou o CSS exibindo o `error_banner`. A página continou funcional e interativa.
- **Problema encontrado**: Nenhum.
