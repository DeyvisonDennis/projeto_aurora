const API_BASE = '/api';

// Global state
let currentFilters = {};
let tableData = {};
let charts = {};

// Elements
const els = {
    data_inicial: document.getElementById('data_inicial'),
    data_final: document.getElementById('data_final'),
    id_filial: document.getElementById('id_filial'),
    id_categoria: document.getElementById('id_categoria'),
    id_produto: document.getElementById('id_produto'),
    btn_limpar: document.getElementById('btn_limpar'),
    last_update: document.getElementById('last_update'),
    error_banner: document.getElementById('error_banner'),
    loading_indicator: document.getElementById('loading_indicator')
};

// Formatters
const fmtMoney = (val) => new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(val || 0);
const fmtNum = (val) => new Intl.NumberFormat('pt-BR').format(val || 0);
const fmtPerc = (val) => Number(val || 0).toFixed(2).replace('.', ',') + '%';

// Init
async function init() {
    setupEventListeners();
    await loadFilters();
    await updateDashboard();
}

function setupEventListeners() {
    const inputs = [els.data_inicial, els.data_final, els.id_filial, els.id_categoria, els.id_produto];
    inputs.forEach(input => {
        if(input) input.addEventListener('change', handleFilterChange);
    });

    if(els.btn_limpar) {
        els.btn_limpar.addEventListener('click', () => {
            inputs.forEach(input => input.value = '');
            handleFilterChange();
        });
    }
}

function handleFilterChange() {
    currentFilters = {};
    if (els.data_inicial.value) currentFilters.data_inicial = els.data_inicial.value;
    if (els.data_final.value) currentFilters.data_final = els.data_final.value;
    if (els.id_filial.value) currentFilters.id_filial = els.id_filial.value;
    if (els.id_categoria.value) currentFilters.id_categoria = els.id_categoria.value;
    if (els.id_produto.value) currentFilters.id_produto = els.id_produto.value;
    
    updateDashboard();
}

function buildQueryString() {
    const params = new URLSearchParams();
    for (const [key, value] of Object.entries(currentFilters)) {
        params.append(key, value);
    }
    const qs = params.toString();
    return qs ? `?${qs}` : '';
}

async function loadFilters() {
    try {
        const res = await fetch(`${API_BASE}/filtros`);
        const data = await res.json();
        
        populateSelect(els.id_filial, data.filiais, 'Todas as Filiais');
        populateSelect(els.id_categoria, data.categorias, 'Todas as Categorias');
        populateSelect(els.id_produto, data.produtos, 'Todos os Produtos');
    } catch (err) {
        console.error("Erro ao carregar filtros:", err);
    }
}

function populateSelect(selectEl, items, defaultText) {
    if(!selectEl) return;
    const currentVal = selectEl.value;
    selectEl.innerHTML = `<option value="">${defaultText}</option>`;
    items.forEach(item => {
        const opt = document.createElement('option');
        opt.value = item.id;
        opt.textContent = item.nome || item.id;
        selectEl.appendChild(opt);
    });
    selectEl.value = currentVal;
}

async function updateDashboard() {
    els.error_banner.classList.add('hidden');
    els.loading_indicator.classList.remove('hidden');
    els.last_update.textContent = "Atualizando...";

    const qs = buildQueryString();

    try {
        const [kpis, mensal, filial, categoria, produtos, margem] = await Promise.all([
            fetch(`${API_BASE}/kpis${qs}`).then(r => r.json()),
            fetch(`${API_BASE}/tabelas/mensal${qs}`).then(r => r.json()),
            fetch(`${API_BASE}/tabelas/filial${qs}`).then(r => r.json()),
            fetch(`${API_BASE}/tabelas/categoria${qs}`).then(r => r.json()),
            fetch(`${API_BASE}/tabelas/produtos${qs}`).then(r => r.json()),
            fetch(`${API_BASE}/tabelas/margem${qs}`).then(r => r.json())
        ]);

        renderKPIs(kpis);
        
        // Save for CSV export
        tableData = { mensal, filial, categoria, produtos, margem };
        
        renderTables();
        renderCharts();

        const now = new Date();
        els.last_update.textContent = `Atualizado às ${now.toLocaleTimeString()}`;
    } catch (err) {
        console.error("Erro ao atualizar dashboard:", err);
        els.error_banner.classList.remove('hidden');
        els.last_update.textContent = "Falha na atualização";
    } finally {
        els.loading_indicator.classList.add('hidden');
    }
}

function renderKPIs(data) {
    if(!data) return;
    document.getElementById('kpi_faturamento_bruto').textContent = fmtMoney(data.faturamento_bruto);
    document.getElementById('kpi_desconto_total').textContent = fmtMoney(data.desconto_total);
    document.getElementById('kpi_receita_liquida').textContent = fmtMoney(data.receita_liquida);
    document.getElementById('kpi_custo_total').textContent = fmtMoney(data.custo_total);
    document.getElementById('kpi_margem_bruta').textContent = fmtMoney(data.margem_bruta);
    document.getElementById('kpi_margem_bruta_percentual').textContent = fmtPerc(data.margem_bruta_percentual);
    document.getElementById('kpi_quantidade_vendida').textContent = fmtNum(data.quantidade_vendida);
    document.getElementById('kpi_ticket_medio').textContent = fmtMoney(data.ticket_medio);
}

function getBadge(val) {
    if (val >= 40) return `<span class="badge badge-high">${fmtPerc(val)}</span>`;
    if (val >= 20) return `<span class="badge badge-mid">${fmtPerc(val)}</span>`;
    return `<span class="badge badge-low">${fmtPerc(val)}</span>`;
}

function renderTables() {
    // Mensal
    const tbMensal = document.getElementById('tbody_mensal');
    if(tbMensal) {
        tbMensal.innerHTML = tableData.mensal.map(r => `
            <tr>
                <td><strong>${r.mes}</strong></td>
                <td>${fmtMoney(r.faturamento_bruto)}</td>
                <td style="color: #f43f5e">${fmtMoney(r.desconto_total)}</td>
                <td style="color: #6ee7b7; font-weight:600">${fmtMoney(r.receita_liquida)}</td>
                <td>${fmtNum(r.quantidade_vendida)}</td>
                <td>${fmtNum(r.quantidade_de_vendas)}</td>
            </tr>
        `).join('');
    }

    // Filial
    const tbFilial = document.getElementById('tbody_filial');
    if(tbFilial) {
        tbFilial.innerHTML = tableData.filial.map(r => `
            <tr>
                <td><strong>${r.filial}</strong></td>
                <td>${fmtMoney(r.faturamento_bruto)}</td>
                <td>${fmtMoney(r.receita_liquida)}</td>
                <td>${fmtMoney(r.custo_total)}</td>
                <td>${fmtMoney(r.margem_bruta)}</td>
                <td>${getBadge(r.margem_bruta_percentual)}</td>
            </tr>
        `).join('');
    }

    // Categoria
    const tbCat = document.getElementById('tbody_categoria');
    if(tbCat) {
        tbCat.innerHTML = tableData.categoria.map(r => `
            <tr>
                <td><strong>${r.categoria}</strong></td>
                <td>${fmtNum(r.quantidade_vendida)}</td>
                <td>${fmtMoney(r.faturamento_bruto)}</td>
                <td>${fmtMoney(r.receita_liquida)}</td>
                <td>${fmtMoney(r.margem_bruta)}</td>
                <td>${getBadge(r.margem_bruta_percentual)}</td>
            </tr>
        `).join('');
    }

    // Produtos
    const tbProd = document.getElementById('tbody_produtos');
    if(tbProd) {
        tbProd.innerHTML = tableData.produtos.map((r, i) => `
            <tr>
                <td><span class="rank-badge">${i+1}</span></td>
                <td><strong>${r.produto}</strong></td>
                <td>${r.categoria}</td>
                <td>${fmtNum(r.quantidade_vendida)}</td>
                <td>${fmtMoney(r.faturamento_bruto)}</td>
                <td>${fmtMoney(r.receita_liquida)}</td>
            </tr>
        `).join('');
    }

    // Margem Detalhada
    const tbMargem = document.getElementById('tbody_margem');
    if(tbMargem) {
        tbMargem.innerHTML = tableData.margem.map(r => `
            <tr>
                <td>${r.mes}</td>
                <td>${r.filial}</td>
                <td>${r.categoria}</td>
                <td>${fmtMoney(r.receita_liquida)}</td>
                <td>${fmtMoney(r.custo_total)}</td>
                <td>${fmtMoney(r.margem_bruta)}</td>
                <td>${getBadge(r.margem_bruta_percentual)}</td>
            </tr>
        `).join('');
    }
}

// Chart.js global config
Chart.defaults.color = '#8892a4';
Chart.defaults.font.family = "'Inter', sans-serif";
Chart.defaults.borderColor = 'rgba(31, 45, 69, 0.6)';

function renderCharts() {
    renderChartMensal();
    renderChartFilial();
    renderChartCategoria();
    renderChartProdutos();
    renderChartMargem();
}

function createOrUpdateChart(id, config) {
    const ctx = document.getElementById(id);
    if(!ctx) return;
    if (charts[id]) {
        charts[id].destroy();
    }
    charts[id] = new Chart(ctx, config);
}

function renderChartMensal() {
    const data = tableData.mensal;
    createOrUpdateChart('chart_mensal', {
        type: 'line',
        data: {
            labels: data.map(d => d.mes),
            datasets: [
                {
                    label: 'Faturamento Bruto',
                    data: data.map(d => d.faturamento_bruto),
                    borderColor: '#6366f1',
                    backgroundColor: 'rgba(99,102,241,0.1)',
                    borderWidth: 2,
                    tension: 0.3,
                    fill: true
                },
                {
                    label: 'Receita Líquida',
                    data: data.map(d => d.receita_liquida),
                    borderColor: '#10b981',
                    backgroundColor: 'rgba(16,185,129,0.1)',
                    borderWidth: 2,
                    tension: 0.3,
                    fill: true
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'top' } }
        }
    });
}

function renderChartFilial() {
    const data = tableData.filial;
    createOrUpdateChart('chart_filial', {
        type: 'bar',
        data: {
            labels: data.map(d => d.filial),
            datasets: [{
                label: 'Receita Líquida',
                data: data.map(d => d.receita_liquida),
                backgroundColor: '#6366f1',
                borderRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } }
        }
    });
}

function renderChartCategoria() {
    const data = tableData.categoria;
    createOrUpdateChart('chart_categoria', {
        type: 'doughnut',
        data: {
            labels: data.map(d => d.categoria),
            datasets: [{
                data: data.map(d => d.receita_liquida),
                backgroundColor: ['#6366f1', '#10b981', '#f59e0b', '#f43f5e', '#8b5cf6'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'right' } },
            cutout: '65%'
        }
    });
}

function renderChartProdutos() {
    const data = tableData.produtos.slice(0, 10); // Top 10
    createOrUpdateChart('chart_produtos', {
        type: 'bar',
        data: {
            labels: data.map(d => d.produto),
            datasets: [{
                label: 'Qtd Vendida',
                data: data.map(d => d.quantidade_vendida),
                backgroundColor: '#10b981',
                borderRadius: 4
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } }
        }
    });
}

function renderChartMargem() {
    // Calculate margin percent per month based on tableData.margem
    const margemByMonth = {};
    tableData.margem.forEach(r => {
        if(!margemByMonth[r.mes]) {
            margemByMonth[r.mes] = { receita: 0, custo: 0 };
        }
        margemByMonth[r.mes].receita += Number(r.receita_liquida);
        margemByMonth[r.mes].custo += Number(r.custo_total);
    });
    
    const labels = Object.keys(margemByMonth).sort();
    const margemPerc = labels.map(m => {
        const rl = margemByMonth[m].receita;
        const mb = rl - margemByMonth[m].custo;
        return rl > 0 ? (mb / rl) * 100 : 0;
    });

    createOrUpdateChart('chart_margem', {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Margem Bruta (%)',
                data: margemPerc,
                borderColor: '#f59e0b',
                backgroundColor: 'rgba(245,158,11,0.1)',
                borderWidth: 2,
                tension: 0.3,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { min: 0 }
            }
        }
    });
}

function exportToCSV(tableName) {
    const data = tableData[tableName];
    if(!data || data.length === 0) {
        alert("Nenhum dado para exportar");
        return;
    }
    
    const keys = Object.keys(data[0]);
    const header = keys.join(';');
    const rows = data.map(row => keys.map(k => {
        let val = row[k];
        if (val === null || val === undefined) val = '';
        if (typeof val === 'string') val = val.replace(/"/g, '""');
        return `"${val}"`;
    }).join(';'));
    
    const csvContent = '\uFEFF' + [header, ...rows].join('\n');
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    
    const link = document.createElement('a');
    link.setAttribute('href', url);
    const dateStr = new Date().toISOString().split('T')[0];
    link.setAttribute('download', `aurora_${tableName}_${dateStr}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

// Start
document.addEventListener('DOMContentLoaded', init);
