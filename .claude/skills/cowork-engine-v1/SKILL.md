---
name: cowork-engine-v1
description: Artifact Engine do Cowork — lê INBOX_COWORK no Drive e executa 5 fases: Inventário → Score → Cartão de Nicho → Pipeline → Conteúdo Social. Ativo permanente: Biblioteca_Nichos_Vanguard_v[N].md. Chamar com /cowork-engine a qualquer momento.
---

# COWORK ARTIFACT ENGINE — EXECUÇÃO COMPLETA

## IDENTIDADE DA SKILL
Executa as 5 fases do Artifact Engine independentemente do session_start.
Trigger: `/cowork-engine`
Resultado mínimo: ≥1 Cartão de Nicho gravado em disco + ≥1 ativo de conteúdo.
Músculo conduz tudo — sem sócio externo no fluxo.

---

## PRÉ-EXECUÇÃO — VERIFICAR ANTES DE INICIAR

1. Conta Google Drive: subdiretor.mnmsgm@gmail.com
2. Folder ID INBOX_COWORK: `1EjaH6TmsxbYpgKWb7ASm7CohFJfwSLKi`
3. Ler `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/BIBLIOTECA_NICHOS/Biblioteca_Nichos_Vanguard_v[N].md` (versão mais recente) — saber quais nichos já estão catalogados
4. Ler `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PENDING_REVIEW.md` — não duplicar sinais já registrados

### GATE NICHE_MODELER — TRIGGER AUTOMÁTICO (executar SEMPRE antes da Fase 1)

```powershell
.\scripts\niche_modeler_check_inbox.ps1 -Status
```

**Resultado:**
- `[OK] Inbox NICHE_MODELER: 0 novos sinais` → **Encerrar Engine aqui.** Não há dados novos para o Antigravity neste ciclo — prosseguir desperdiça contexto e tempo.
- `[TRIGGER] NICHE_MODELER: N run(s) nova(s)` → Continuar Engine normalmente. Ao final de tudo, notificar Diretor: "NICHE_MODELER: N run(s) nova(s) — Antigravity necessário. Execute PASSO_NICHE_MODELER.md."

**Regra:** o Músculo NUNCA propõe ida ao Antigravity sem este gate confirmar sinais novos primeiro.

---

## FASE 1 — DIAGNÓSTICO (Inventário Bruto)

```
mcp__claude_ai_Google_Drive__search_files
  parentId: "1EjaH6TmsxbYpgKWb7ASm7CohFJfwSLKi"
```

Filtrar: apenas arquivos SEM prefixo `[LIDO]` no título.

Para cada arquivo novo:
1. `mcp__claude_ai_Google_Drive__read_file_content` (pelo ID)
2. Extrair todos os nichos/setores mencionados — sem julgamento ainda
3. Anotar: frente de origem (F1/F3/F5…) + data + 3 sinais mais fortes

Construir lista de nichos únicos.
Cruzar com Biblioteca: separar **NOVOS** de **SINAL ADICIONAL** (nicho já catalogado com evidência nova).

**Output:**
```
INVENTÁRIO — [data]
Arquivos lidos: [N]
Nichos novos: [lista]
Sinais adicionais para nichos existentes: [lista]
```

---

## FASE 2 — PLANEJAMENTO (Score Vanguard 1–5)

Para cada nicho NOVO, calcular score em 5 dimensões:

| Dimensão | Pontua máximo quando… |
|---|---|
| D1 — Custo da dor | Número real documentado (R$, %, tCO₂…) |
| D2 — Auditabilidade | Norma específica obriga rastro (ANEEL, CFM, SUSEP, ANVISA…) |
| D3 — Urgência temporal | Prazo regulatório ativo em 2026 ou deadline conhecido |
| D4 — Complexidade anti-genérica | Exige dados estruturados que agência não resolve |
| D5 — Volume de mercado | ≥500 empresas afetadas no Brasil |

Bônus: +0.5 se o nicho apareceu em 2+ frentes (convergência confirmada).

Classificação pela média:
- ≥ 4.0 → **MOVER AGORA** (gerar todos os 4 ativos)
- 2.5–3.9 → **MONITORAR** (registrar em PENDING_REVIEW apenas)
- < 2.5 → **ARQUIVAR** (registrar motivo para calibração futura)

Para nichos com **SINAL ADICIONAL**: recalcular score da entrada existente na Biblioteca — se subiu para MOVER AGORA, gerar ativos agora.

**Output:** tabela nicho | D1–D5 | média | classificação.

---

## FASE 3 — EXECUÇÃO (Geração dos Ativos)

Para cada nicho **MOVER AGORA** — gravar todos os 4 arquivos com Write tool antes de apresentar ao Diretor.
O Músculo analisa com profundidade própria: cruza INTELLIGENCE_LEDGER + histórico de projetos + PENDING_REVIEW.

### 3A — Cartão de Nicho
```
Arquivo: PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/BIBLIOTECA_NICHOS/[SLUG]_CARTAO.md

Campos obrigatórios:
- Setor
- Dores primárias (2–3, com número quando disponível)
- Gatilho regulatório + prazo
- Custo da dor (número real — se não tiver, marcar [ESTIMAR])
- ROI esperado Vanguard
- Filtro anti-genérico (por que agência não resolve)
- Objeções típicas (2–3)
- Argumento de abertura (1 frase com número)
- Convergência (frentes que sinalizaram)
- Data de entrada + última atualização
```

Após criar os CARTÕEs: adicionar entrada ao `Biblioteca_Nichos_Vanguard_v[N].md` no bloco correto (MOVER AGORA ou MONITORAR).

### 3B — Mensagem de Abertura
```
Arquivo: PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PIPELINE/[YYYY-MM-DD]_[SLUG]_contato.txt

- Canal: LinkedIn DM / WhatsApp / E-mail (adequado ao perfil do nicho)
- Corpo completo — Eduardo copia e envia, sem editar
- Referência ao número de dor do Cartão
- CTA: reunião de 20min ou diagnóstico gratuito
- Se nicho afeta Valdece ou Ingrid: flag [EXPANSAO_ATIVO] no início
```

### 3C — Post LinkedIn
```
Arquivo: PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/CONTEUDO/linkedin_[YYYY-MM-DD]_[SLUG].txt

- 1ª linha: gancho com número impactante
- 2 parágrafos: contexto do problema + o que deveria ser feito
- Penúltima linha: pergunta para engajamento
- Última linha: "Vanguard IAH — Inteligência que decide sozinha"
- 5 hashtags relevantes | 150–200 palavras
- Pilar: Urgência Regulatória ou Número de Dor
- NÃO fazer pitch direto, NÃO mencionar preço
```

### 3D — Card Instagram
```
Arquivo: PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/CONTEUDO/instagram_[YYYY-MM-DD]_[SLUG].txt

HEADLINE: máx 6 palavras, impacto máximo
DADO: número principal + contexto em 1 frase
CTA: "Link na bio →" ou "Saiba mais ↓"
CAPTION: 80–100 palavras + 10 hashtags
```

---

## FASE 4 — VALIDAÇÃO (Apresentação ao Diretor)

Apresentar APÓS gravar todos os arquivos.

```
ARTIFACT ENGINE CONCLUÍDO — [data]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Arquivos lidos: [N] | Nichos: [M] MOVER AGORA · [P] MONITORAR · [Q] ARQUIVAR
Ativos gerados: [4×M] arquivos em disco

[1] MOVER AGORA — [Nome do Nicho] (score [X.X])
    Cartão · Pipeline · LinkedIn · Instagram — gravados
    APROVAR (commitar) / EDITAR [o que] / DESCARTAR

[2] MOVER AGORA — [Nome do Nicho] (score [X.X])
    APROVAR / EDITAR / DESCARTAR

[N+1] MONITORAR — [Nome] (score [X.X]) — PENDING_REVIEW atualizado
      MANTER / ELEVAR PARA MOVER_AGORA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Diretor responde: "1-APROVAR 2-EDITAR [o que] 3-DESCARTAR"
```

Após vereditos:
- **APROVADO** → commit `feat(cowork): Cartao+Pipeline+Conteudo [Nicho] [data]`
- **EDITADO** → incorporar + re-gravar + confirmar ao Diretor
- **DESCARTADO** → deletar arquivos + registrar motivo em `BIBLIOTECA_NICHOS/CALIBRACAO.md`

---

## FASE 5 — OTIMIZAÇÃO (Calibração Contínua)

Ao final de cada execução, registrar em `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/BIBLIOTECA_NICHOS/CALIBRACAO.md`:

```
[YYYY-MM-DD] | Frentes: [lista] | Aprovados: [N] / Total: [M]
Nichos aprovados: [lista]
Descartados: [nicho — motivo]
Insight: [1 linha para próxima execução]
```

Mensal (1º de cada mês):
1. Ler CALIBRACAO.md completo
2. Nichos MONITORAR com 3+ sinais acumulados → propor promoção para MOVER AGORA
3. Nichos MOVER AGORA sem prospect contatado há 60+ dias → propor arquivamento
4. Incrementar versão da Biblioteca (v1 → v2 → …)

---

## REGRAS DESTA SKILL

- Não executar as frentes do Cowork (F1–F22) — papel do Embaixador
- Não criar cópia local do SKILL_EMBAIXADOR (canônico no Drive)
- Artefatos são RASCUNHOS até aprovação do Diretor na Fase 4
- `Biblioteca_Nichos_Vanguard_v[N].md` é TIPO 1 UNIVERSAL_PURO: editar só em `PENTALATERAL_UNIVERSAL/`
- Após qualquer alteração em `PENTALATERAL_UNIVERSAL/` → rodar `sync_vanguard_docs.ps1` (P-033)
- Músculo que exibe score sem gravar arquivo = Fase 3 ausente = Engine incompleto
