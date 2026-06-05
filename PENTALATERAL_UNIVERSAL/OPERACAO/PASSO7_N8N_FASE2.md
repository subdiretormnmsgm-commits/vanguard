# PASSO 7 — EMBAIXADOR (CLAUDE PROJECTS)
## Loop: N8N-FASE2 · Seção D — Reação ao Pentalateral
**Data:** 2026-06-04 | **Tipo:** Loop de Processo — evolução do sistema Vanguard

---

## INSTRUÇÕES PARA O DIRETOR

```
1. Abrir Claude Projects (Embaixador ativo — preferencialmente o projeto Ingrid
   que tem o histórico mais rico de comportamento do Diretor como operador do sistema)

2. Garantir que estas fontes estão no Knowledge do projeto:
   - DIRETRIZ ESTRATÉGICA — Pentalateral IAH — Loop N8N-FASE2.txt
   - n8n-orquestracao-v1.md (Skill do Auditor — gerada no PASSO5)
   - MEMORIA_EMBAIXADOR mais recente

3. Colar o bloco abaixo no chat do Embaixador
```

---

## ATIVAÇÃO DO EMBAIXADOR — LOOP N8N-FASE2

```
ATIVAÇÃO DO EMBAIXADOR — Sistema Vanguard IAH
Data: 2026-06-04
Loop: N8N-FASE2 | Tipo: Loop de Processo (não de cliente)
Última ativação: 2026-06-04

--- ELO DO CICLO ATUAL ---
DIRETRIZ em processo: DIRETRIZ ESTRATÉGICA — Pentalateral IAH — Loop N8N-FASE2
Skill gerada pelo Auditor: n8n-orquestracao-v1.md
Prioridade de build aprovada: W-5 ChurnWatch + W-6 Embaixador API + W-7 Veredito Telegram MVP
O que está fora do escopo: Gemini API gerando DIRETRIZ automaticamente (DESCARTADO)
```

---

## SEÇÃO D — REAÇÃO AO PENTALATERAL

```
Embaixador, este é um loop de processo — o Pentalateral está evoluindo seu próprio sistema de
operação com n8n. Não há cliente a filtrar. Você filtra a realidade operacional do Diretor:
o que Eduardo consegue realmente fazer, o que consome energia dele, onde o processo falha na
prática do dia a dia.

CONTEXTO DO CICLO:
- DIRETRIZ: n8n como sistema nervoso do Pentalateral IAH — FASE 2
- Skill aprovada: n8n-orquestracao-v1.md
- O que a Skill prioriza: W-5 ChurnWatch, W-6 Embaixador via API, W-7 Veredito Telegram
- O que está vetado: Gemini API gerando DIRETRIZ (risco de degradar qualidade deliberativa)

[M-1 a M-5] — IDEIAS DO MÚSCULO:

M-1: Timestamp Lock
Proteção de sobrescrita: n8n só atualiza arquivo local se payload for mais recente que disco.
Resolve Split-Brain (M-5.2 da DIRETRIZ) — sessão local e webhook nunca colidem.

M-2: ChurnWatch Universal via n8n (W-5)
Workflow diário às 08h que lê WIP_BOARD.json do GitHub e alerta via Telegram se
ultimo_contato_cliente ultrapassar churn_watch_threshold (3 dias Ingrid, 3 dias Valdece).
Substitui Task Scheduler local após 30 dias de uptime (P-102).

M-3: Embaixador via Claude API (W-6)
Workflow que recebe Skill aprovada + MEMORIA_EMBAIXADOR como input, chama claude-sonnet-4-6
com persona do Embaixador e retorna [E-1 a E-5] + DECISOES.json diretamente no Telegram.
Elimina 100% do transporte manual do Passo 7 — o maior consumo de energia do Diretor.

M-4: Circuit Breaker de Custo
Limite de $0.30 por chamada API + contador diário no WIP_BOARD. Se ultrapassar $5.00/dia:
n8n pausa automações de API e alerta via Telegram. Protege contra M-5.3 (custo explodindo).

M-5: PASSO3 Auto-preparado (não PASSO3 auto-gerado)
Ao commitar com [RESOLVE:] que fecha um loop, n8n detecta, monta o PASSO3 completo com
contexto do loop anterior e envia link para o Gemini Advanced via Telegram. O Diretor abre
o Gemini com contexto pronto — mas a DIRETRIZ ainda é gerada pelo Gemini Advanced, não pela API.

[G-1 a G-5] — IDEIAS DO ESTRATEGISTA (GEMINI):

G-1: Orquestração Híbrida Assíncrona
n8n intercepta artefatos do Git via webhooks e distribui para os sócios automaticamente.
Diretor intervém apenas para refinamento estratégico e veredito final.

G-2: Gemini API para rascunho do PASSO3
n8n invoca Google Gemini API (AI Studio) para gerar minuta da DIRETRIZ automaticamente.
[NOTA: Músculo VETOU — risco de degradar qualidade deliberativa. Gemini Advanced permanece.]

G-3: NotebookLM via .zip no Telegram
n8n compacta as fontes canônicas em .zip e envia link no Telegram para o Diretor arrastar
no NotebookLM. Minimiza esforço operacional mantendo a etapa humana necessária.

G-4: Embaixador via Claude API automático
n8n monitora aprovação da Skill e invoca Claude API com persona persistente do cliente,
gerando output do Embaixador sem abrir o navegador. [ALINHADO com M-3 do Músculo]

G-5: Veredito via Telegram com botões interativos
Painel de deliberação vira interface conversacional — cada botão grava VEREDITOS.json
e atualiza WIP_BOARD automaticamente. Diretor delibera do celular, qualquer lugar.

[N-1 a N-5] — IDEIAS DO AUDITOR (NOTEBOOKLM):

N-1: "Dead-Man's Switch" do n8n
Task Scheduler local roda ping_n8n.ps1 diariamente. Se o n8n no EasyPanel não responder
200 OK, o script local emite alerta imediato. Evita a falácia da auto-vigilância — o n8n
não consegue avisar que caiu porque está offline. Gate: ativo antes de considerar FASE 2 operante.

N-2: Idempotência Obrigatória no W-6 (Embaixador via Claude API)
O W-6 deve registrar o Hash (Idempotency Key) de cada evento. Se o webhook falhar e reenviar,
a requisição duplicada é ignorada. Protege o Burn Rate Shield [P-006] contra tokens duplicados
e evita poluição do DECISOES.json com análises repetidas.

N-3: Isolamento Visual e Semântico no ChurnWatch (W-5)
Alertas de Churn no Telegram devem ser prefixados por [B2B-VALDECE] ou [B2C-EDTECH] com
formatações visuais distintas. Protege [P-059] na interface mobile — impede que o Diretor
envie régua de cobrança B2B para cliente "Verde Frágil" B2C por erro cognitivo de velocidade.

N-4: Git Hook de Auditoria de Schema JSON (Proteção Pré-n8n)
Pre-commit hook valida estrutura do DECISOES.json contra schema v1.1 antes de qualquer commit.
Qualquer typo é barrado no PC do Diretor, impedindo que workflows da nuvem entrem em loop de
erro fatal por parser crash no n8n.

N-5: "Undo Window" no Veredito via Telegram (W-7)
W-7 aplica Wait Node intencional de 15 segundos após receber "/aprovar" antes de repassar
à API. Diretor pode enviar "/cancelar" nesse intervalo. Protege contra "dedo-gordo" ou
cliques apressados no trânsito antes do código ir para produção.

---

PEDIDO AO EMBAIXADOR — QUATRO PARTES OBRIGATÓRIAS:

PARTE 1 — FILTRO DE REALIDADE
Para cada ideia M-1 a M-5 e G-1 a G-5 acima (G-2 já vetado, confirmar se correto):
Baseado no comportamento real de Eduardo como operador do sistema Vanguard:
  CONFIRMA — Eduardo demonstrou capacidade/disposição de usar esta automação
  EXPANDE  — há contexto operacional que potencializa esta ideia
  ALERTA   — o comportamento real de Eduardo contradiz ou torna esta ideia arriscada

Foco especial: onde Eduardo REALMENTE perde mais tempo no processo atual?
O que ele verbaliza como "trabalhoso" vs. o que ele faz sem reclamar?

PARTE 2 — ANÁLISE INOVADORA
- Qual o risco operacional que nenhum sócio está vendo?
- O que esta automação pode fazer Eduardo perder que ele ainda não percebeu?
- Há algo no processo atual que parece problema mas é na verdade um recurso de qualidade?

PARTE 3 — INTELIGÊNCIA DO SISTEMA
O que o comportamento de Eduardo como operador do Pentalateral revela sobre como
sistemas de automação devem ser projetados para fundadores não-técnicos?
- Padrão de uso: o que Eduardo usa naturalmente vs. o que usa só quando lembrado
- Padrão de resistência: onde Eduardo tende a bypassar o processo
- Argumento de venda derivado: o que a Vanguard aprende aqui para vender para clientes

PARTE 4 — DECISOES.json (schema v1.1)
Gerar decisões formais do loop N8N-FASE2 com urgência e opções claras.
Incluir ao menos: ordem de build W-5/W-6/W-7, variáveis de ambiente necessárias no n8n,
critério de ativação dos workflows (active: true) após 18-06-2026.
```

---

## APÓS RECEBER O OUTPUT DO EMBAIXADOR

```
☐ Colar output completo do Embaixador no Claude Code (chat do Músculo)
☐ Músculo extrai DECISOES.json + lista decisões numeradas
☐ Diretor responde: "D1:A, D2:B, ..."
☐ Músculo executa vereditos
☐ Músculo atualiza PASSO7_N8N_FASE2.md com [N-1 a N-5] antes de rodar
   (se não rodar antes, o Embaixador reage sem as ideias do Auditor)
```

---

*Músculo · Pentalateral IAH · 2026-06-04 · [N-1 a N-5] placeholder — preencher após Skill*
