import sys
import os

# Ensure Python path includes the app directory
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.services.kpi_service import KPIService

def print_table(data, columns):
    if not data:
        print("Nenhum resultado encontrado.\n")
        return
    
    # Simple table formatting
    col_widths = [max(len(str(item)) for item in col) for col in zip(*data, columns)]
    header = " | ".join(str(col).ljust(width) for col, width in zip(columns, col_widths))
    print("-" * len(header))
    print(header)
    print("-" * len(header))
    
    for row in data:
        row_str = " | ".join(str(item).ljust(width) if item is not None else "NULL".ljust(width) for item, width in zip(row, col_widths))
        print(row_str)
    print("-" * len(header))
    print()

def main():
    service = KPIService()
    
    print("=========================================")
    print("Rede Comercial Aurora - Indicadores (CLI)")
    print("=========================================")
    print("Exibindo testes de requisição com filtros")
    print("=========================================\n")

    # Exemplo sem filtros
    print("1. Faturamento Total Por Mês (Sem Filtros)")
    data1 = service.faturamento_por_mes()
    print_table(data1, ["Mês", "Faturamento Bruto", "Desconto Total", "Receita Líquida", "Qtd Vendida", "Qtd Vendas"])

    # Exemplo com filtros: Filial = 1
    print("2. Receita Líquida Por Filial (Filtro: filial = 1 [Aurora Matriz])")
    data2 = service.receita_por_filial(id_filial=1)
    print_table(data2, ["Filial", "Faturamento Bruto", "Desconto Total", "Receita Líquida", "Custo Total", "Margem Bruta", "Margem Bruta %"])

    # Exemplo com filtros: Período
    print("3. Receita Líquida Por Categoria (Filtro: data >= '2024-03-01' e data <= '2024-05-31')")
    data3 = service.receita_por_categoria(data_inicial='2024-03-01', data_final='2024-05-31')
    print_table(data3, ["Categoria", "Qtd Vendida", "Faturamento Bruto", "Receita Líquida", "Margem Bruta", "Margem Bruta %"])

    print("4. Produtos Mais Vendidos (Filtro: categoria = 5 [Celulares])")
    data4 = service.produtos_mais_vendidos(id_categoria=5)
    print_table(data4, ["Produto", "Categoria", "Qtd Vendida", "Faturamento Bruto", "Receita Líquida"])

    print("5. Margem Bruta por Mês, Filial e Categoria (Filtro: mês de Janeiro de 2024)")
    data5 = service.margem_por_mes_filial_categoria(data_inicial='2024-01-01', data_final='2024-01-31')
    print_table(data5, ["Mês", "Filial", "Categoria", "Receita Líquida", "Custo Total", "Margem Bruta", "Margem Bruta %"])

if __name__ == "__main__":
    main()
