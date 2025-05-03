import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from datetime import datetime, timedelta

# Carregando os dados do CSV
df = pd.read_csv('github_project_export.csv')

# Convertendo as datas para formato datetime
df['Created At'] = pd.to_datetime(df['Created At'])
df['Closed At'] = pd.to_datetime(df['Closed At'])
df['End date'] = pd.to_datetime(df['End date'])
df['Start date'] = pd.to_datetime(df['Start date'])

# Definindo período do projeto
projeto_inicio = df['Start date'].min().date()
projeto_fim = datetime(2025, 6, 30).date()  # Ajustado para incluir todas as sprints

# Considerando TODAS as atividades para o esforço total ideal
# Filtrando apenas as que têm estimativa
df_todas_atividades = df[df['Estimate'].notna()]
total_esforco = df_todas_atividades['Estimate'].sum()

# Encontrar a última data de término das atividades concluídas
df_done = df[(df['Status'] == 'Done') & (df['End date'].notna()) & (df['Estimate'].notna())]
if not df_done.empty:
    ultima_data_concluida = df_done['End date'].max().date()
else:
    ultima_data_concluida = projeto_inicio

# Criar um range de datas entre o início e fim do projeto
all_dates = pd.date_range(start=projeto_inicio, end=projeto_fim)
df_dates = pd.DataFrame(all_dates, columns=['date'])
df_dates['date_only'] = df_dates['date'].dt.date

# DataFrame para armazenar o burndown ideal/planejado
burndown_ideal = []

# Calcular quantas tarefas deveriam ser concluídas em cada dia para um progresso constante
dias_projeto = (projeto_fim - projeto_inicio).days + 1
reducao_diaria = total_esforco / dias_projeto

# Gerar a linha ideal/planejada
esforco_restante = total_esforco
for date in all_dates:
    burndown_ideal.append({
        'date': date.date(),
        'esforco_restante': esforco_restante
    })
    esforco_restante -= reducao_diaria

df_ideal = pd.DataFrame(burndown_ideal)

# Criar o DataFrame para o burndown real apenas até a última data concluída
df_real = df_dates[df_dates['date_only'] <= ultima_data_concluida].copy()
df_real['esforco_restante'] = total_esforco  # Começa com o esforço total

# Para cada data, diminuir o esforço das tarefas concluídas até aquela data
for idx, row in df_real.iterrows():
    data_atual = row['date_only']
    
    # Encontrar tarefas concluídas até esta data
    tarefas_concluidas = df_done[pd.to_datetime(df_done['End date']).dt.date <= data_atual]
    
    # Calcular esforço já realizado
    esforco_concluido = tarefas_concluidas['Estimate'].sum()
    
    # Atualizar esforço restante
    df_real.loc[idx, 'esforco_restante'] = total_esforco - esforco_concluido

# Plotando o gráfico
plt.figure(figsize=(14, 8))

# Linha ideal/planejada
plt.plot(df_ideal['date'], df_ideal['esforco_restante'], 'b--', label='Burndown Ideal')

# Linha real (apenas até a última data concluída)
plt.plot(df_real['date_only'], df_real['esforco_restante'], 'r-', linewidth=2, label='Burndown Real')

# Datas de fim das sprints
datas_sprints = [
    datetime(2025, 5, 4).date(),
    datetime(2025, 5, 18).date(),
    datetime(2025, 6, 1).date(),
    datetime(2025, 6, 15).date(),
    datetime(2025, 6, 29).date()
]

# Adicionar marcadores para o fim de cada sprint
for i, data_sprint in enumerate(datas_sprints, 1):
    plt.axvline(x=data_sprint, color='purple', linestyle='-', alpha=0.5)
    plt.text(data_sprint, plt.ylim()[1]*0.95, f'Fim Sprint {i}', 
             rotation=90, verticalalignment='top', fontsize=10, color='purple')

# Ajustes estéticos
plt.title('Gráfico de Burndown - Projeto Ticket2Ride', fontsize=16)
plt.xlabel('Data', fontsize=12)
plt.ylabel('Esforço Restante (horas)', fontsize=12)
plt.grid(True, linestyle='--', alpha=0.7)
plt.xticks(rotation=45)
plt.tight_layout()

# Destacar a data atual
data_atual = datetime(2025, 5, 3).date()  # Usando a data fornecida na conversa
plt.axvline(x=data_atual, color='green', linestyle='-', alpha=0.5, label='Data Atual')

plt.legend()

today = datetime.now().strftime('%d-%m-%Y')
plt.savefig(f'burndown_chart_{today}.png', dpi=300, bbox_inches='tight')

plt.show()