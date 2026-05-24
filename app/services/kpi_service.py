from data_access.queries import Queries

class KPIService:
    def __init__(self):
        self.queries = Queries()

    def process_filters(self, kwargs):
        filters = {}
        if kwargs.get('data_inicial'):
            filters['data_inicial'] = kwargs.get('data_inicial')
        if kwargs.get('data_final'):
            filters['data_final'] = kwargs.get('data_final')
        if kwargs.get('id_filial'):
            filters['id_filial'] = kwargs.get('id_filial')
        if kwargs.get('id_produto'):
            filters['id_produto'] = kwargs.get('id_produto')
        if kwargs.get('id_categoria'):
            filters['id_categoria'] = kwargs.get('id_categoria')
        return filters

    def get_filtros_opcoes(self):
        return self.queries.get_filtros_opcoes()

    def kpis_globais(self, **kwargs):
        filters = self.process_filters(kwargs)
        return self.queries.get_kpis_globais(filters)

    def faturamento_por_mes(self, **kwargs):
        filters = self.process_filters(kwargs)
        return self.queries.get_faturamento_por_mes(filters)

    def receita_por_filial(self, **kwargs):
        filters = self.process_filters(kwargs)
        return self.queries.get_receita_por_filial(filters)

    def receita_por_categoria(self, **kwargs):
        filters = self.process_filters(kwargs)
        return self.queries.get_receita_por_categoria(filters)

    def produtos_mais_vendidos(self, **kwargs):
        filters = self.process_filters(kwargs)
        return self.queries.get_produtos_mais_vendidos(filters)
