# PASSO 5 — NOTEBOOKLM AUDITOR
## Loop: N8N-FASE2 · Skill esperada: n8n-orquestracao-v1.md
**Data:** 2026-06-04 | **Tipo:** Loop de Processo — não é projeto cliente

---

## INSTRUÇÕES PARA O DIRETOR

```
1. No NotebookLM de Ingrid (fontes já atualizadas hoje):
   - Arrastar 1 arquivo adicional:
     CLIENTES\INGRID\NOTEBOOKLM_FONTES\DIRETRIZ ESTRATÉGICA — Pentalateral IAH — Loop N8N-FASE2.txt

2. No chat do NotebookLM — colar o bloco abaixo:
```

---

## PROMPT PARA O NOTEBOOKLM

Você é o Auditor do Pentalateral IAH.

Antes de qualquer análise, declare o MANIFESTO_DE_FONTES_ATIVO:
- Documentos carregados: [listar os presentes]
- O que o Auditor NÃO pode ver: [o que ficou de fora]
- Impacto da ausência: [quais conclusões podem ser afetadas]

Leia a DIRETRIZ ESTRATÉGICA — Pentalateral IAH — Loop N8N-FASE2.txt e todas as fontes carregadas.
Gere a Skill completa com nome exato: **n8n-orquestracao-v1.md**

**CONTEXTO DO LOOP:**
Em 2026-06-04, o Pentalateral IAH integrou o n8n no EasyPanel como camada de orquestração. A FASE 1 entregou 4 workflows ativos (check-in, monitor Supabase, GitHub webhook, session close). A FASE 2 define os próximos 3 workflows e os documentos do processo que precisam ser atualizados. Este não é um loop de projeto cliente — é uma evolução do próprio sistema de inteligência do Pentalateral.

**DECISÕES JÁ APROVADAS PELO MÚSCULO (não auditar como proposta — são fatos):**
- W-5: ChurnWatch Universal (não Gemini API — risco de degradar qualidade deliberativa)
- W-6: Embaixador via Claude API (alto impacto, elimina Passo 7 manual)
- W-7: Veredito via Telegram MVP texto antes de botões interativos
- Gemini API gerando DIRETRIZ automaticamente: DESCARTADO (M-5.1 confirmado pelo Músculo)
- P-109: Notion é OUTPUT-ONLY — Git é a única fonte de verdade

**O QUE AUDITAR ([PARA O NOTEBOOKLM] da DIRETRIZ do Estrategista):**
1. Validar conformidade com P-102 em vanguard-protocolo.md — coexistência obrigatória scripts locais + Task Scheduler até 30 dias de uptime do n8n
2. Rastrear vazamento de escopo: automação não pode criar obrigação tecnológica nos contratos de clientes (P-013 soberania)
3. Auditar TEMPLATES_COMUNICACAO_PENTALATERAL.md — novos formatos JSON não alteram significado dos Gates Semânticos

**FORMATO OBRIGATÓRIO DA SKILL:**

A Skill DEVE ter os 4 títulos EXATOS (sem acentos — verificados por skill_parser_gate.ps1):

```
## [AUDITORIA DE COERENCIA]
## [CONEXAO HISTORICA]
## [PADRAO DE SUCESSO/FALHA]
## [PERSPECTIVA DO SOCIO]
```

**PARTE 0 — INTERVENÇÕES DO DIRETOR:**
Liste intervenções diretas de Eduardo neste loop. Relevante: Eduardo decidiu usar Notion como cockpit output-only (ARQ-1), aprovou ChurnWatch com threshold 3 dias (P-106), vetou Gemini API gerando DIRETRIZ.

**PARTE 1 — AUDITORIA DE COERÊNCIA:**
A DIRETRIZ contradiz algo do LEDGER ou de processos anteriores? Os riscos M-5 são mitigáveis com o processo atual? P-102 ainda está sendo respeitado?

**PARTE 2 — CONEXÃO HISTÓRICA:**
O que os projetos Ingrid (Loop 8) e Valdece (Loop 7) ensinaram que se aplica à automação com n8n? Onde automação falhou ou introduziu risco nestes projetos?

**PARTE 3 — A SKILL n8n-orquestracao-v1.md** com os 4 blocos acima.

**PARTE 4 — SUAS 5 IDEIAS DISRUPTIVAS COMO AUDITOR:**
O que Gemini e Músculo não estão vendo nesta transição para automação. Para cada ideia: o que é, qual o impacto, pergunta direta para o Diretor.

---

## APÓS RECEBER A SKILL — SEQUÊNCIA OBRIGATÓRIA (P-067)

```
☐ Copiar PARTES 0+1+2+4 → salvar em:
  PENTALATERAL_UNIVERSAL\HISTORICO\AUDITOR_LOOP_N8N_FASE2_2026-06-04.md

☐ Copiar PARTE 3 → salvar em:
  .claude\skills\n8n-orquestracao-v1.md

☐ Rodar: .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\n8n-orquestracao-v1.md"

☐ Atualizar PASSO7_N8N_FASE2.md com [N-1 a N-5] do Auditor
  Arquivo: PENTALATERAL_UNIVERSAL\OPERACAO\PASSO7_N8N_FASE2.md

☐ Ir ao Embaixador com o PASSO7 preenchido
```

---

*Músculo · Pentalateral IAH · 2026-06-04 · P-090: este arquivo é a fonte de verdade*
