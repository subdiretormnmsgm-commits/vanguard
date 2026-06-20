---
name: market-stats-analysis
description: Use when turning a Cowork niche-intelligence product (INBOX_COWORK / produto Vanguard) into a defensible quantitative read — market sizing, trend, correlation, segmentation — or whenever a number is asserted about a market and must be backed by statistics, confidence interval and source. Camada analítica fria do Motor de Inteligência de Nicho.
---

# Avaliador Estatístico de Mercado · market-stats-analysis · VANGUARD

> Órgão de rigor quantitativo do **Motor de Inteligência de Nicho** (ver `MOTOR_INTELIGENCIA_NICHO.md`).
> Processa inteligência de nicho via métodos quantitativos rigorosos e extrai conclusões verificáveis.
> Produz **camada analítica fria** (número + incerteza + fonte). NÃO produz discurso de venda — isso é do Projetista (R-3).

## IDENTIDADE

Quem usa: o **Músculo** ao processar o INBOX_COWORK (análise base) e a encarnação **Agentada** do Cowork ao robustecer (tarefa agendada M-STATS). Escopo: mercado e nicho — nunca dados de cliente ativo (P-059). Linguagem do output: técnica, sem adjetivo apelativo; toda afirmação ancorada em número + nível de confiança.

## GATE DE ENTRADA DE DADOS (espinha — não negociável)

Antes de qualquer parecer, declarar a fonte e o regime de dados:

- **Regime A — dado estruturado** (CSV/JSON/SQL): rodar a análise quantitativa completa abaixo.
- **Regime B — dado esparso/qualitativo** (entrega do Cowork: tendências YouTube, sinais, fontes públicas): usar o **Módulo Market Sizing** (estimação por fonte pública) — nunca regressão sobre N insuficiente.
- **Sem fonte verificável (URL/data ausente):** BLOQUEIO. Não opinar. Registrar lacuna.

Toda execução registra: fonte (URL), data da coleta, N amostral, método aplicado.

## TABELA DE SELEÇÃO DE MÉTODO

| Pergunta de mercado | Método | Ferramenta |
|---|---|---|
| Duas variáveis se movem juntas? | Correlação (Pearson/Spearman) + valor-p | `scipy.stats` |
| Qual fator explica/prevê Y? | Regressão (OLS/logística) | `statsmodels` |
| Para onde vai a série no tempo? | ARIMA/SARIMA; Prophet se sazonalidade múltipla | `statsmodels` / `prophet` |
| Existem grupos distintos de clientes? | Cluster (K-means/hierárquico) | `scikit-learn` |
| Quais atributos importam mais? | **MaxDiff** (prioriza atributos) | survey + `pandas` |
| Qual pacote/oferta ótima? | **Conjoint** (monta a oferta) — sempre após MaxDiff | survey + `statsmodels` |
| Reduzir muitas variáveis a poucos eixos? | Análise Fatorial / PCA | `scikit-learn` |
| Tamanho do mercado? | **Módulo Market Sizing** (abaixo) | `pandas` |

## DISCIPLINA DE INCERTEZA (obrigatória)

- Todo número pontual vem com **intervalo de confiança/predição**. Número sem intervalo = inválido.
- A incerteza **alarga com o horizonte**: previsão distante é declarada como mais incerta, nunca como ponto firme.
- Séries temporais: identificar ordem por ACF/PACF + AIC/BIC; validar com diagnóstico de resíduos.

## MÓDULO MARKET SIZING — TAM/SAM/SOM (dupla via)

Calcular o tamanho por **dois caminhos independentes**:
- **Top-down:** parte de um agregado público (relatório setorial/dado governamental) e aplica filtros sucessivos.
- **Bottom-up:** parte de unidades reais (clientes/transações típicas) e escala para cima.

**Regra dos 15%:** se top-down e bottom-up convergem dentro de **±15%**, o número é confiável. Divergência maior = revisar premissas/taxas de adoção, não publicar. Sempre registrar as duas estimativas e o gap.

## GATE DE HONESTIDADE — N PEQUENO (P-010 aplicado à estatística)

Com 0 clientes e amostras mínimas, é **proibido fabricar significância**. Se N é insuficiente para o método, declarar **"INCONCLUSIVO — N insuficiente (N=x)"** e indicar qual coleta resolveria. Inconclusivo honesto vence número inventado.

## FIAÇÃO AO MOTOR

- **Entrada:** produto Vanguard mais recente (Cartões de Nicho / entrega do Cowork em `INBOX_COWORK` / Biblioteca de Nichos).
- **Saída:** parecer quantitativo → **`INTELLIGENCE_HUB/PENDING_REVIEW.md`** (AGUARDANDO_VEREDITO). Nunca direto a DECISOES.json ou ao acervo (P-124 — escrita única após veredito do Diretor).
- **Handoff:** a camada fria segue ao **Projetista**, que a traduz em PLANOS/CAMPANHA com linguagem blindada (R-3 — "especialistas da Vanguard", nunca IA/ferramenta).
- **Calibração:** o resultado real da prospecção realimenta a precisão dos parâmetros (loop de calibração do motor).
- Arquivos consumidos por atores remotos → propagar ao Drive via rclone (G2).

## EXEMPLO — projeção com intervalo (statsmodels)

```python
import pandas as pd
import statsmodels.api as sm

# Série mensal de demanda do nicho (fonte pública registrada: URL + data de coleta)
y = pd.read_csv("nicho_demanda.csv", parse_dates=["mes"], index_col="mes")["demanda"]

# SARIMAX simples — ordem identificada por ACF/PACF + AIC; não chutar
model = sm.tsa.statespace.SARIMAX(y, order=(1, 1, 1), seasonal_order=(0, 1, 1, 12))
fit = model.fit(disp=False)

# Previsão SEMPRE com intervalo — número pontual sozinho é inválido
fc = fit.get_forecast(steps=6)
pred = fc.predicted_mean
ci = fc.conf_int(alpha=0.05)           # IC 95%; alarga com o horizonte

print(pred)                            # estimativa pontual
print(ci)                              # intervalo — reportar SEMPRE junto
print(f"AIC={fit.aic:.1f}")            # justificar escolha do modelo
```

## ERROS COMUNS

- Reportar ponto sem intervalo → inválido.
- Rodar regressão/ARIMA sobre N pequeno em vez de declarar inconcluso.
- Market sizing por um caminho só (sem checar convergência 15%).
- Output já em linguagem de venda → invade o papel do Projetista (R-3).
- Esquecer de registrar fonte/data/N → resultado não reproduzível, não publicável.
- Gravar parecer direto no acervo sem passar por PENDING_REVIEW (viola P-124).
