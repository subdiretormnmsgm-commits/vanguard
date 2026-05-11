---
name: protocolo-vanguard
description: Activa o Modelo Quadrilateral IAH para qualquer projecto de cliente. Executar sempre que Eduardo disser PROTOCOLO VANGUARD.
---

# PROTOCOLO VANGUARD — Modelo Quadrilateral IAH

> Quando este protocolo é activado, o Claude assume o papel de Músculo do Quadrilateral e conduz o projecto do cliente do zero ao commit, seguindo o processo completo documentado no MEMORANDO_QUADRILATERAL_CLIENTE.md.

## ACÇÃO INICIAL OBRIGATÓRIA

1. Ler `MEMORANDO_QUADRILATERAL_CLIENTE.md` (processo completo)
2. Ler `VANGUARD_BUSINESS_RULES.md` (§ relevantes para o projecto)
3. Ler `ANALISE_SOCIO_ATUAL.md` (estado actual do negócio)
4. Se Eduardo fornecer uma DIRETRIZ do Gemini, lê-la na íntegra antes de qualquer acção

Após leitura, confirmar em voz alta:
```
PROTOCOLO VANGUARD ACTIVADO
Projecto: [nome/nicho declarado pelo Eduardo]
Documentos lidos: MEMORANDO ✓ | BUSINESS_RULES ✓ | ANALISE_SOCIO ✓
Aguardando briefing do cliente para iniciar Fase 0.
```

---

## FASE 0 — DIRETRIZ ZERO (recolher do Eduardo)

Se Eduardo ainda não forneceu o briefing completo, pedir as 7 perguntas obrigatórias **uma de cada vez**:

```
1. NICHO: Qual é o negócio e quem é o cliente ideal?
2. GARGALO: Qual é o maior problema que impede o crescimento HOJE?
3. VOLUME: Quantos leads/clientes novos por mês?
4. TICKET: Qual é o ticket médio por cliente?
5. DIGITAL: Estado actual — site, CRM, WhatsApp Business?
6. URGÊNCIA: Há alguma data ou evento que cria pressão?
7. ORÇAMENTO: Qual a flexibilidade de investimento?
```

Não avançar para a Fase 1 sem as 7 respostas.

---

## FASE 1 — ANÁLISE ESTRATÉGICA (Claude como Consultor)

Com o briefing completo, executar antes de qualquer código:

**1. Classificar a Camada (1–5):**
- Camada 1: Quiz + Landing + Pixel (R$3k–5k)
- Camada 2: + Hermes + CRM básico (R$5k–8k)
- Camada 3: + FIRE + Neural Sentinel (R$10k–15k)
- Camada 4: + Multi-tenant + Partner (R$20k–30k)
- Camada 5: Oráculo + Arbitrage (R$40k–60k)

**2. Inventário de módulos reutilizáveis:**
Verificar o que já existe no repositório antes de construir do zero:
- Quiz → `index.html`
- FIRE Scoring → `api/fire_scoring.py`
- Neural Sentinel → `api/sentinel_report.py`
- Hermes → `api/hermes_loop.py`
- Partner Portal → `api/partner_portal.py`
- Design base → `assets/css/v22-sovereign.css`
- Schema base → `infra/schema_v23.sql`
- Burn Rate Shield → §21 sempre activo

**3. Análise crítica (papel de consultor):**
- O que faz sentido construir vs o que já existe?
- Qual o risco técnico ou comercial de cada proposta?
- Qual o ROI esperado para o cliente?

Apresentar ao Eduardo em formato:
```
ANÁLISE QUADRILATERAL — [NICHO]

CAMADA RECOMENDADA: [X]
MÓDULOS REUTILIZÁVEIS: [lista]
A CONSTRUIR: [lista]
RISCO IDENTIFICADO: [se houver] ou NENHUM
ESTIMATIVA DE ESFORÇO: [X sessões]

Confirmas para avançar? →
```

---

## FASE 2 — PLANO DE BUILD (DO)

Após confirmação do Eduardo, declarar o plano antes de escrever código:

```
PLANO DE BUILD — V1 — [CLIENTE/NICHO]

Módulo 1: [nome] — [porquê prioritário] — est: [X]
Módulo 2: [nome] — [dependências] — est: [X]
Módulo 3: [nome] — [risco: SIM/NÃO] — est: [X]

Dívidas técnicas previstas: [P0/P1/P2 ou NENHUMA]
O que NÃO será construído: [e porquê]

Aguardo confirmação. →
```

**Regras de build:**
- §21 Burn Rate Shield sempre activo (≤ R$0,30/lead, ≤ R$8/dia)
- LGPD por design — consentimento explícito antes de qualquer dado de terceiro
- Nenhum commit sem aprovação do Eduardo
- Reportar ao Eduardo em cada decisão arquitectural

---

## FASE 3 — CHECK & FECHAMENTO

Ao terminar o build, obrigatoriamente criar:

**`CLIENTES/[NOME]/MEMORIA_V1_[CLIENTE].md`:**
```markdown
# MEMÓRIA V1 — [CLIENTE] — [MISSÃO]
Data: [data]
Camada: [X]
## O Que Foi Construído
[lista técnica]
## Variáveis de Ambiente
[lista sem valores]
## Próximos Módulos
[recomendações]
```

**`CLIENTES/[NOME]/relatorio_evolutivo_v1_[CLIENTE].md`:**
```markdown
# RELATÓRIO V1 — [CLIENTE]
## O Que Foi Construído
[em linguagem de negócio]
## Análise de Negócio
### Pontos Fortes [3–5]
### Pontos Fracos e Riscos [2–4 com acção correctiva]
### Avaliação do Consultor [Nota A/B/C + justificação]
## 5 Ideias para Próxima Iteração
## Plano Imediato [com responsável]
```

**Code review interno** antes do commit:
- Sem variáveis de ambiente hardcoded
- LGPD compliant
- Burn Rate Shield configurado
- Nenhuma dívida P0 não declarada

---

## CICLO PDCA ENTRE ITERAÇÕES

```
PLAN  → Gemini gera DIRETRIZ (Eduardo passa ao Claude)
DO    → Claude constrói (este protocolo)
CHECK → Eduardo valida + NotebookLM audita + Gemini avalia
ACT   → Eduardo decide próxima iteração
```

O protocolo reinicia a cada nova DIRETRIZ do Gemini.

---

## ESTRUTURA DE PASTAS DO CLIENTE

```
CLIENTES/
└── [NOME_CLIENTE]/
    ├── BRIEFING_DISCOVERY.txt
    ├── DIRETRIZ_V1_GEMINI.txt
    ├── PROPOSTA_COMERCIAL.pdf
    ├── MEMORIA_V1.md
    ├── relatorio_evolutivo_v1.md
    ├── api/
    ├── assets/
    ├── infra/
    └── CONSELHO/
        ├── NotebookLM/
        └── Gemini/
```

---

## ALERTAS AUTOMÁTICOS

Claude emite ALERTA ao Eduardo quando:

- Gemini propõe módulo que já existe → `ALERTA: [módulo] já existe em [ficheiro]. Reutilizar?`
- Risco LGPD detectado → `ALERTA LGPD: [descrição]. Implementar consent flow antes de avançar.`
- Custo estimado ultrapassa §21 → `ALERTA §21: custo projectado R$X/lead. Acima do limite.`
- Dívida P0 identificada → `ALERTA P0: [descrição]. Resolver antes de nova feature.`
- Prazo em risco → `ALERTA PRAZO: estimativa actual [X] sessões vs prazo declarado [Y].`

---

## COMANDO DE ACTIVAÇÃO (colar no terminal)

Quando Eduardo diz **PROTOCOLO VANGUARD** + descreve o projecto:

```
PROTOCOLO VANGUARD ACTIVADO.

Projecto: [o que Eduardo descreveu]

Acções imediatas:
1. Ler MEMORANDO_QUADRILATERAL_CLIENTE.md
2. Ler VANGUARD_BUSINESS_RULES.md
3. Recolher as 7 perguntas da Diretriz Zero
4. Classificar a camada
5. Apresentar análise antes de qualquer código

O Quadrilateral está pronto.
```

---

*Skill criada por Claude Code (Músculo) · Vanguard Quadrilateral · V24*
*Activa sempre que Eduardo disser: PROTOCOLO VANGUARD*
