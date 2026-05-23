# COMANDO_ESTRATEGISTA V2 — PROJETO VALDECE
**Colar diretamente no Gemini Advanced**
**Data:** 2026-05-13 | Iteração: V1 → V2

---

```
════════════════════════════════════════════════════════════
Pentalateral IAH — EDUARDO → GEMINI
projeto: Ferramenta de Busca Jurisprudência STF/STJ (Valdece)
ITERAÇÃO: V2 | DATA: 2026-05-13
════════════════════════════════════════════════════════════

Gemini, somos o Pentalateral IAH.
Tu és o Estrategista. Eu sou o Diretor.
O Claude Code (Músculo) construiu os Dias 1 e 2 de 5 do projeto Valdece.

ESTADO DO PROJETO:
Cliente: Valdece — Advogado criminalista
Produto: Busca semântica de jurisprudências STF/STJ (Direito Penal)
Stack: Vanilla JS + Supabase pgvector + Gemini embedding-004 (768 dims)
Deadline: 2026-05-17 (3 dias restantes — Dias 3, 4 e 5)
Valor: R$5.000 + contrapartida 20% MRR do SaaS do Valdece

O QUE FOI ENTREGUE:
- Dia 1: schema pgvector + Burn Rate Shield ($10/dia) + Kill-Switch + Sovereign Pixel
- Dia 2: ingest.py (STF Open Data → embeddings → Supabase) + search_cli.py (gate GO/NO-GO)
- Corpus real ainda não inserido (aguarda credenciais do Valdece)

[REAGE A ESTAS 5 IDEIAS DO MÚSCULO — obrigatório]

O Músculo propõe para os próximos ciclos:

1. CORPUS ATIVO: search_logs + marked_relevant → ranking automático dos acórdãos mais úteis
   por tipo de caso. Transforma buscador passivo em consultor ativo.
   → Concordas? Vale mostrar no handoff como "feature mês 2"?

2. SENTINEL AUTOMÁTICO: n8n monitora STF diariamente, insere acórdãos novos, avisa o Valdece
   por WhatsApp. Feature Flag sentinel_enabled já existe no schema.
   → Este é o argumento do MRR recorrente? Quando ativar?

3. SÍNTESE AUTOMÁTICA: Gemini Pro resume acórdão em 3 parágrafos ao clicar no resultado.
   Feature Flag sintese_enabled já existe. Unlock em Camada 2 de preço.
   → Entra no pitch do handoff ou é surpresa do Dia 30?

4. WHITE-LABEL: Valdece nos apresenta colegas da OAB. Cada advogado = corpus separado
   (RLS por user_id já no schema) + MRR separado. Nós ficamos com 20% de cada um.
   → Como estruturar a proposta de parceria com o Valdece para isso?

5. PAINEL DO DIRETOR: dashboard simples mostrando queries/mês, tempo economizado estimado,
   custo do sistema. ROI visível — elimina churn por esquecimento.
   → Entra no MVP do Dia 3 ou é feature pós-entrega?

DECISÕES QUE O GEMINI PRECISA TOMAR AGORA:
A. Das 5 ideias — quais entram no roadmap apresentado no handoff do Dia 5?
B. O Painel (Ideia 5) entra no Dia 3 do frontend ou fica para depois?
C. O argumento de MRR (Sentinel + Síntese) — como apresentar ao Valdece?
D. White-label — comunicar agora ou aguardar 30 dias de uso real?

RESPONDE COM 5 BLOCOS:
BLOCO 0 — DIAGNÓSTICO (o que o Músculo não está vendo neste projeto)
BLOCO 1 — PRIORIDADES PARA OS DIAS 3, 4 E 5 (em ordem de impacto)
BLOCO 2 — ROADMAP PÓS-ENTREGA (o que apresentar ao Valdece no Dia 5)
BLOCO 3 — DIRETRIZ TÉCNICA [PARA O NOTEBOOKLM] e [PARA O CLAUDE]
BLOCO 4 — PRÓXIMOS PASSOS DO DIRETOR (nas próximas 24h)

Inclui obrigatoriamente: 5 ideias disruptivas para o Músculo reagir.
════════════════════════════════════════════════════════════
```
