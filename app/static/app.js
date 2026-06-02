const API_BASE = '/api';

// Armazenar dados para export
const tableData = {};

// Formatadores
const formatCurrency = (value) => {
    if (value === null || value === undefined) return 'R$ 0,00';
    return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value);
};

const formatNumber = (value) => {
    if (value === null || value === undefined) return '0';
    return new Intl.NumberFormat('pt-BR').format(value);
};

const formatPercent = (value) => {
    if (value === null || value === undefined) return '-';
    const num = parseFloat(value);
    const cls = num >= 40 ? 'badge-high' : num >= 20 ? 'badge-mid' : 'badge-low';
    return `<span class="badge ${cls}">${num.toFixed(2)}%</span>`;
};

// Referências DOM
const elements = {
    data_inicial: document.getElementById('data_inicial'),
    data_final: document.getElementById('data_final'),
    id_filial: document.getElementById('id_filial'),
    id_categoria: document.getElementById('id_categoria'),
    id_produto: document.getElementById('id_produto'),
    btn_limpar: document.getElementById('btn_limpar'),
    error_banner: document.getElementById('error_banner'),
    loading_indicator: document.getElementById('loading_indicator'),
    last_update: document.getElementById('last_update'),
    
    // KPIs
    kpi_faturamento_bruto: document.getElementById('kpi_faturamento_bruto'),
    kpi_desconto_total: document.getElementById('kpi_desconto_total'),
    kpi_receita_liquida: document.getElementById('kpi_receita_liquida'),
    kpi_custo_total: document.getElementById('kpi_custo_total'),
    kpi_margem_bruta: document.getElementById('kpi_margem_bruta'),
    kpi_margem_bruta_percentual: document.getElementById('kpi_margem_bruta_percentual'),
    kpi_quantidade_vendida: document.getElementById('kpi_quantidade_vendida'),
    kpi_ticket_medio: document.getElementById('kpi_ticket_medio'),

    // Tabelas
    tbody_mensal: document.getElementById('tbody_mensal'),
    tbody_filial: document.getElementById('tbody_filial'),
    tbody_categoria: document.getElementById('tbody_categoria'),
    tbody_produtos: document.getElementById('tbody_produtos'),
    tbody_margem: document.getElementById('tbody_margem'),
};

// Obter Parâmetros de Filtro
const getFilterParams = () => {
    const params = new URLSearchParams();
    if (elements.data_inicial.value) params.append('data_inicial', elements.data_inicial.value);
    if (elements.data_final.value) params.append('data_final', elements.data_final.value);
    if (elements.id_filial.value) params.append('id_filial', elements.id_filial.value);
    if (elements.id_categoria.value) params.append('id_categoria', elements.id_categoria.value);
    if (elements.id_produto.value) params.append('id_produto', elements.id_produto.value);
    return params.toString();
};

// Carregar Opções de Filtro
const loadFiltersOptions = async () => {
    try {
        const response = await fetch(`${API_BASE}/filtros`);
        if (!response.ok) throw new Error('Falha ao carregar filtros');
        
        const data = await response.json();
        
        const populateSelect = (element, items) => {
            items.forEach(item => {
                const option = document.createElement('option');
                option.value = item.id;
                option.textContent = item.nome;
                element.appendChild(option);
            });
        };

        populateSelect(elements.id_filial, data.filiais);
        populateSelect(elements.id_categoria, data.categorias);
        populateSelect(elements.id_produto, data.produtos);

    } catch (error) {
        console.error(error);
        showError();
    }
};

// Renderizar KPIs
const renderKPIs = (data) => {
    elements.kpi_faturamento_bruto.textContent = formatCurrency(data.faturamento_bruto);
    elements.kpi_desconto_total.textContent = formatCurrency(data.desconto_total);
    elements.kpi_receita_liquida.textContent = formatCurrency(data.receita_liquida);
    elements.kpi_custo_total.textContent = formatCurrency(data.custo_total);
    elements.kpi_margem_bruta.textContent = formatCurrency(data.margem_bruta);
    elements.kpi_margem_bruta_percentual.textContent = data.margem_bruta_percentual != null ? `${data.margem_bruta_percentual}%` : '0%';
    elements.kpi_quantidade_vendida.textContent = formatNumber(data.quantidade_vendida);
    elements.kpi_ticket_medio.textContent = formatCurrency(data.ticket_medio);
};

// Renderizar Tabela Mensal (P1)
const renderTabelaMensal = (data) => {
    tableData['mensal'] = { headers: ['Mês','Fat. Bruto','Desconto Total','Receita Líquida','Qtd Vendida','Nº Vendas'], rows: data.map(r => [r.mes, r.faturamento_bruto, r.desconto_total, r.receita_liquida, r.quantidade_vendida, r.quantidade_de_vendas]) };
    elements.tbody_mensal.innerHTML = data.map(row => `
        <tr>
            <td><strong>${row.mes}</strong></td>
            <td>${formatCurrency(row.faturamento_bruto)}</td>
            <td class="text-danger">${formatCurrency(row.desconto_total)}</td>
            <td>${formatCurrency(row.receita_liquida)}</td>
            <td>${formatNumber(row.quantidade_vendida)}</td>
            <td>${formatNumber(row.quantidade_de_vendas)}</td>
        </tr>
    `).join('');
};

// Renderizar Tabela Filial (P2)
const renderTabelaFilial = (data) => {
    tableData['filial'] = { headers: ['Filial','Fat. Bruto','Desconto Total','Receita Líquida','Custo Total','Margem Bruta','Margem %'], rows: data.map(r => [r.filial, r.faturamento_bruto, r.desconto_total, r.receita_liquida, r.custo_total, r.margem_bruta, r.margem_bruta_percentual]) };
    elements.tbody_filial.innerHTML = data.map(row => `
        <tr>
            <td><strong>${row.filial}</strong></td>
            <td>${formatCurrency(row.faturamento_bruto)}</td>
            <td>${formatCurrency(row.receita_liquida)}</td>
            <td>${formatCurrency(row.custo_total)}</td>
            <td>${formatCurrency(row.margem_bruta)}</td>
            <td>${formatPercent(row.margem_bruta_percentual)}</td>
        </tr>
    `).join('');
};

// Renderizar Tabela Categoria (P3)
const renderTabelaCategoria = (data) => {
    tableData['categoria'] = { headers: ['Categoria','Qtd Vendida','Fat. Bruto','Receita Líquida','Margem Bruta','Margem %'], rows: data.map(r => [r.categoria, r.quantidade_vendida, r.faturamento_bruto, r.receita_liquida, r.margem_bruta, r.margem_bruta_percentual]) };
    elements.tbody_categoria.innerHTML = data.map(row => `
        <tr>
            <td><strong>${row.categoria}</strong></td>
            <td>${formatNumber(row.quantidade_vendida)}</td>
            <td>${formatCurrency(row.faturamento_bruto)}</td>
            <td>${formatCurrency(row.receita_liquida)}</td>
            <td>${formatCurrency(row.margem_bruta)}</td>
            <td>${formatPercent(row.margem_bruta_percentual)}</td>
        </tr>
    `).join('');
};

// Renderizar Tabela Produtos (P4)
const renderTabelaProdutos = (data) => {
    tableData['produtos'] = { headers: ['#','Produto','Categoria','Qtd Vendida','Fat. Bruto','Receita Líquida'], rows: data.map((r,i) => [i+1, r.produto, r.categoria, r.quantidade_vendida, r.faturamento_bruto, r.receita_liquida]) };
    elements.tbody_produtos.innerHTML = data.map((row, index) => `
        <tr>
            <td><span class="rank-badge">${index + 1}</span></td>
            <td><strong>${row.produto}</strong></td>
            <td>${row.categoria}</td>
            <td>${formatNumber(row.quantidade_vendida)}</td>
            <td>${formatCurrency(row.faturamento_bruto)}</td>
            <td>${formatCurrency(row.receita_liquida)}</td>
        </tr>
    `).join('');
};

// Renderizar Tabela Margem Detalhada (P5)
const renderTabelaMargem = (data) => {
    tableData['margem'] = { headers: ['Mês','Filial','Categoria','Receita Líquida','Custo Total','Margem Bruta','Margem %'], rows: data.map(r => [r.mes, r.filial, r.categoria, r.receita_liquida, r.custo_total, r.margem_bruta, r.margem_bruta_percentual]) };
    elements.tbody_margem.innerHTML = data.map(row => `
        <tr>
            <td><strong>${row.mes}</strong></td>
            <td>${row.filial}</td>
            <td>${row.categoria}</td>
            <td>${formatCurrency(row.receita_liquida)}</td>
            <td>${formatCurrency(row.custo_total)}</td>
            <td>${formatCurrency(row.margem_bruta)}</td>
            <td>${formatPercent(row.margem_bruta_percentual)}</td>
        </tr>
    `).join('');
};

// =====================================================================
// EXPORTAÇÃO CSV
// =====================================================================
const exportToCSV = (tableKey) => {
    const data = tableData[tableKey];
    if (!data || !data.rows || data.rows.length === 0) {
        alert('Sem dados para exportar. Verifique os filtros aplicados.');
        return;
    }

    const escapeCSV = (val) => {
        if (val === null || val === undefined) return '';
        const str = String(val);
        return str.includes(',') || str.includes('"') || str.includes('\n') ? `"${str.replace(/"/g, '""')}"` : str;
    };

    const lines = [
        data.headers.map(escapeCSV).join(','),
        ...data.rows.map(row => row.map(escapeCSV).join(','))
    ];

    const csvContent = '\uFEFF' + lines.join('\r\n'); // BOM for Excel UTF-8
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    const timestamp = new Date().toISOString().slice(0, 10);
    link.href = url;
    link.download = `aurora_${tableKey}_${timestamp}.csv`;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
};

// Limpar Dados Visualmente em caso de erro
const clearData = () => {
    renderKPIs({});
    elements.tbody_mensal.innerHTML = '<tr><td colspan="6" style="text-align:center;color:var(--text-secondary)">Sem dados</td></tr>';
    elements.tbody_filial.innerHTML = '<tr><td colspan="6" style="text-align:center;color:var(--text-secondary)">Sem dados</td></tr>';
    elements.tbody_categoria.innerHTML = '<tr><td colspan="6" style="text-align:center;color:var(--text-secondary)">Sem dados</td></tr>';
    elements.tbody_produtos.innerHTML = '<tr><td colspan="6" style="text-align:center;color:var(--text-secondary)">Sem dados</td></tr>';
    elements.tbody_margem.innerHTML = '<tr><td colspan="7" style="text-align:center;color:var(--text-secondary)">Sem dados</td></tr>';
};

const showError = () => {
    elements.error_banner.classList.remove('hidden');
    clearData();
};

const hideError = () => {
    elements.error_banner.classList.add('hidden');
};

const showLoading = () => elements.loading_indicator.classList.remove('hidden');
const hideLoading = () => elements.loading_indicator.classList.add('hidden');

// Atualizar o Dashboard
const updateDashboard = async () => {
    const params = getFilterParams();
    showLoading();
    hideError();

    try {
        const [kpis, mensal, filial, categoria, produtos, margem] = await Promise.all([
            fetch(`${API_BASE}/kpis?${params}`).then(r => { if(!r.ok) throw new Error(); return r.json(); }),
            fetch(`${API_BASE}/tabelas/mensal?${params}`).then(r => r.json()),
            fetch(`${API_BASE}/tabelas/filial?${params}`).then(r => r.json()),
            fetch(`${API_BASE}/tabelas/categoria?${params}`).then(r => r.json()),
            fetch(`${API_BASE}/tabelas/produtos?${params}`).then(r => r.json()),
            fetch(`${API_BASE}/tabelas/margem?${params}`).then(r => r.json()),
        ]);

        renderKPIs(kpis);
        renderTabelaMensal(mensal);
        renderTabelaFilial(filial);
        renderTabelaCategoria(categoria);
        renderTabelaProdutos(produtos);
        renderTabelaMargem(margem);

        // Atualizar timestamp
        const now = new Date();
        elements.last_update.textContent = `Atualizado às ${now.toLocaleTimeString('pt-BR')}`;

    } catch (error) {
        console.error("Erro de conexão com a API", error);
        showError();
    } finally {
        hideLoading();
    }
};

// Event Listeners
const attachEvents = () => {
    const filterInputs = [
        elements.data_inicial, elements.data_final, 
        elements.id_filial, elements.id_categoria, elements.id_produto
    ];
    
    filterInputs.forEach(input => {
        input.addEventListener('change', updateDashboard);
    });

    elements.btn_limpar.addEventListener('click', () => {
        filterInputs.forEach(input => input.value = '');
        updateDashboard();
    });
};

// Initialize
const init = async () => {
    await loadFiltersOptions();
    attachEvents();
    updateDashboard();
};

document.addEventListener('DOMContentLoaded', init);
