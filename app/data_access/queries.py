from config.database import DatabaseConfig

class Queries:
    def __init__(self):
        self.db = DatabaseConfig()

    def _execute_query(self, base_query, filters):
        conn = self.db.get_connection()
        if not conn:
            return []

        where_clauses = []
        params = []

        # Aplicação dos filtros obrigatórios
        if filters.get('data_inicial'):
            where_clauses.append("v.data_venda >= %s")
            params.append(filters['data_inicial'])
        if filters.get('data_final'):
            where_clauses.append("v.data_venda <= %s")
            params.append(filters['data_final'])
        if filters.get('id_filial'):
            where_clauses.append("v.id_filial = %s")
            params.append(filters['id_filial'])
        if filters.get('id_produto'):
            where_clauses.append("iv.id_produto = %s")
            params.append(filters['id_produto'])
        if filters.get('id_categoria'):
            where_clauses.append("p.id_categoria = %s")
            params.append(filters['id_categoria'])

        # Inserir cláusulas WHERE antes do GROUP BY
        if where_clauses:
            where_string = " WHERE " + " AND ".join(where_clauses)
            base_query = base_query.replace("GROUP BY", f"{where_string} GROUP BY")

        try:
            with conn.cursor() as cursor:
                cursor.execute(base_query, tuple(params))
                return cursor.fetchall()
        except Exception as e:
            print(f"Erro ao executar consulta: {e}")
            return []
        finally:
            conn.close()

    def get_faturamento_por_mes(self, filters):
        query = """
            SELECT 
                TO_CHAR(v.data_venda, 'YYYY-MM') AS mes,
                SUM(iv.quantidade * iv.preco_unitario) AS faturamento_bruto,
                SUM(iv.desconto_item) AS desconto_total,
                SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) AS receita_liquida,
                SUM(iv.quantidade) AS quantidade_vendida,
                COUNT(DISTINCT v.id_venda) AS quantidade_de_vendas
            FROM venda v
            JOIN item_venda iv ON v.id_venda = iv.id_venda
            JOIN produto p ON iv.id_produto = p.id_produto
            GROUP BY TO_CHAR(v.data_venda, 'YYYY-MM')
            ORDER BY mes;
        """
        return self._execute_query(query, filters)

    def get_receita_por_filial(self, filters):
        query = """
            SELECT 
                f.nome AS filial,
                SUM(iv.quantidade * iv.preco_unitario) AS faturamento_bruto,
                SUM(iv.desconto_item) AS desconto_total,
                SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) AS receita_liquida,
                SUM(iv.quantidade * p.custo_unitario) AS custo_total,
                SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario) AS margem_bruta,
                ROUND(
                    ( (SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario)) / 
                    NULLIF(SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item), 0) ) * 100, 2
                ) AS margem_bruta_percentual
            FROM filial f
            JOIN venda v ON f.id_filial = v.id_filial
            JOIN item_venda iv ON v.id_venda = iv.id_venda
            JOIN produto p ON iv.id_produto = p.id_produto
            GROUP BY f.nome
            ORDER BY receita_liquida DESC;
        """
        return self._execute_query(query, filters)

    def get_receita_por_categoria(self, filters):
        query = """
            SELECT 
                c.nome AS categoria,
                SUM(iv.quantidade) AS quantidade_vendida,
                SUM(iv.quantidade * iv.preco_unitario) AS faturamento_bruto,
                SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) AS receita_liquida,
                SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario) AS margem_bruta,
                ROUND(
                    ( (SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario)) / 
                    NULLIF(SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item), 0) ) * 100, 2
                ) AS margem_bruta_percentual
            FROM categoria c
            JOIN produto p ON c.id_categoria = p.id_categoria
            JOIN item_venda iv ON p.id_produto = iv.id_produto
            JOIN venda v ON iv.id_venda = v.id_venda
            GROUP BY c.nome
            ORDER BY receita_liquida DESC;
        """
        return self._execute_query(query, filters)

    def get_produtos_mais_vendidos(self, filters):
        query = """
            SELECT 
                p.nome AS produto,
                c.nome AS categoria,
                SUM(iv.quantidade) AS quantidade_vendida,
                SUM(iv.quantidade * iv.preco_unitario) AS faturamento_bruto,
                SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) AS receita_liquida
            FROM produto p
            JOIN categoria c ON p.id_categoria = c.id_categoria
            JOIN item_venda iv ON p.id_produto = iv.id_produto
            JOIN venda v ON iv.id_venda = v.id_venda
            GROUP BY p.nome, c.nome
            ORDER BY quantidade_vendida DESC;
        """
        return self._execute_query(query, filters)

    def get_margem_por_mes_filial_categoria(self, filters):
        query = """
            SELECT 
                TO_CHAR(v.data_venda, 'YYYY-MM') AS mes,
                f.nome AS filial,
                c.nome AS categoria,
                SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) AS receita_liquida,
                SUM(iv.quantidade * p.custo_unitario) AS custo_total,
                SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario) AS margem_bruta,
                ROUND(
                    ( (SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item) - SUM(iv.quantidade * p.custo_unitario)) / 
                    NULLIF(SUM((iv.quantidade * iv.preco_unitario) - iv.desconto_item), 0) ) * 100, 2
                ) AS margem_bruta_percentual
            FROM venda v
            JOIN filial f ON v.id_filial = f.id_filial
            JOIN item_venda iv ON v.id_venda = iv.id_venda
            JOIN produto p ON iv.id_produto = p.id_produto
            JOIN categoria c ON p.id_categoria = c.id_categoria
            GROUP BY TO_CHAR(v.data_venda, 'YYYY-MM'), f.nome, c.nome
            ORDER BY mes, filial, categoria;
        """
        return self._execute_query(query, filters)
