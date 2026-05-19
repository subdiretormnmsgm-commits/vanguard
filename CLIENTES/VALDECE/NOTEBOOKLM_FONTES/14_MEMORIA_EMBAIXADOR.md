# MEMORIA_EMBAIXADOR — PROJ-001 VALDECE
> Documento vivo. Atualizar a cada gate ou marco de relacionamento.
> Leitura obrigatória de abertura de sessão — 30 segundos.
> Versão: Loop 6 · 2026-05-19 (5 áudios Valdece processados · 3 features entregues · contrato pendente assinatura presencial hoje)

---

## CLIENTE

**Nome:** Valdece
**Profissão:** Advogado criminalista — Direito Penal
**O que ele pediu:** "Quero um Google melhor para jurisprudência penal."
**O que foi entregue:** Copiloto de defesa criminal — busca semântica STF/STJ com citação ABNT e interface Toga Digital Navy + Ouro.
**Prazo do projeto:** 2026-05-23 (deadline contratual)
**Gate crítico:** Entrega presencial 2026-05-19 (AMANHÃ)

---

## DOR REAL

Em julgamentos e audiências, segundos importam.
Google entrega ruído. Westlaw custa R$3.000/mês.
O Valdece precisa do precedente certo, em 10 segundos, com citação pronta.

**O que ele mais teme:** Sistema que quebra sem suporte ou que exige conhecimento técnico.
**O que o motiva:** Resultado em audiência — "usei e encontrei o precedente que mudou o julgamento."
**Canal que funciona:** Presencial (preferencial) / WhatsApp (rápido, objetivo)
**Tom que não funciona:** Técnico, detalhado em infraestrutura, demorado

---

## ESTADO DO PRODUTO

| Campo | Status |
|---|---|
| Gate atual | **GATE P-038 APROVADO — 12/12 verde** ✅ · sim 0.67–0.818 · latência 2.1–3.4s |
| Deploy | **https://toga-digital-valdece.netlify.app** · PWA instalável ✅ |
| Corpus Supabase | **61 acórdãos reais STF/STJ · 22 temas · TESTADO E VERDE** ✅ |
| Modelo embed | gemini-embedding-001 · dimensionalidade 768 · threshold 0.67 |
| commit ef3f1cd | Schema Supabase + ingest.py + kill_switch.js ✅ |
| commit 996b40d | Corpus pipeline Python + Mágico de Oz Gate ✅ |
| commit 18c617f | STJ por Tema + busca semântica threshold + UI Toga Digital ✅ |
| commit e9afb36 | Gate ABNT NBR6023 + busca precisa/ampla + redesign Navy/Ouro ✅ |
| commit 5da58f8 | Corpus 61 acórdãos + P-057/P-058 LEDGER ✅ |
| Loop evolutivo | **4 princípios extraídos (P-041/P-042/P-043/P-044)** · 3 membros deliberaram |
| Presencial 2026-05-19 | Realizado — credenciais obtidas — Sovereign Playbook apresentado (P-042) |
| commit 9709649 | **Loop 6:** ementa completa (600 chars) + badge UF + boost monocrático (+0.15) ✅ |
| fix HC 512.290/RJ | Dado errado corrigido no banco + re-embedding executado ✅ |
| 5 áudios Valdece | Feedback técnico processado: ementa ✅ UF ✅ data_dje ❌V3 repercussão ❌V3 |
| Temperatura | **QUENTE** — sistema live + 3 melhorias entregues + feedback ativo por áudio |
| Contrato | **PENDENTE ASSINATURA** — Eduardo vai presencialmente hoje · R$5k fixo + sem mensalidade |

**Sistema pronto — estado Loop 6 (2026-05-19):**
- Schema vector(768) + HNSW + SECURITY DEFINER ✅ — Supabase Vanguard (migra pós-contrato)
- 61 acórdãos STF/STJ · threshold 0.67 (Precisa) / 0.45 (Ampla) · top 3 · GATE P-038 VERDE ✅
- Gate P-038: 12/12 queries aprovadas · sim ≥ 0.67 em todas · latência máx 3.4s
- Sovereign Playbook apresentado (P-042) — objeção vendor lock-in destruída
- Loop 6: ementa completa + badge UF (regex numero_acordao) + boost monocrático (+0.15) entregues
- HC 512.290/RJ: corrigido no banco (ementa errada → certa + re-embedding)

**V3 pipeline — identificado pelos áudios · BLOQUEADO até assinatura (P-023):**
- `data_dje` (date) · `repercussao_geral` (boolean) · `recurso_repetitivo` (boolean) · `turma` (text)
- Blueprint pronto: ALTER TABLE → ingest dry-run → frontend badges → ABNT atualizado
- Gate V3: badge "VINCULANTE" — Valdece identifica sozinho, sem explicação

**V2 pipeline (gatilho: 30 dias de uso ativo pós-contrato):**
- Sovereign Upload · Radar de Divergência STJ vs STF · Citação DOCX · Expansão semântica

---

## ESTADO DO RELACIONAMENTO

| Campo | Status |
|---|---|
| Último contato | **5 áudios de feedback — 2026-05-19** (Valdece usa o sistema e avalia ativamente) |
| Próximo contato | Presencial hoje — Eduardo leva contrato + OFFBOARDING_RUNBOOK impresso |
| Canal principal | Presencial / WhatsApp |
| Tom que funciona | Direto, resultado concreto, sem jargão técnico |
| Tom que não funciona | Técnico, detalhado, longo, com termos de infraestrutura |

**O que Valdece demonstrou:** Está usando o sistema e enviando feedback técnico por áudio — nível de engajamento alto.
Pediu ementa completa ✅ · badge UF ✅ · data DJE ❌(V3) · badges vinculantes ❌(V3).
O fato de enviar 5 áudios técnicos = comprometimento real com o produto (P-046).
Contrato ainda não assinado — Eduardo vai presencialmente hoje fechar.

---

## ESTADO CONTRATUAL

| Campo | Status |
|---|---|
| Contrato | Contrato_Toga_Digital_Valdece_19052026_v2.docx |
| Status | **PENDENTE** — assinatura no presencial de 2026-05-19 |
| Modelo | R$5.000 fixo (Cláusula 4.1) + 20% MRR Revenue Share sobre SaaS derivado (4.2) |
| Mensalidade | ZERO — infra na conta do Valdece (~R$1,20/mês direto à API dele) |
| Hypercare | 30 dias inclusos |

**CRÍTICO:** Nunca mencionar mensalidade. Se perguntar: "não tem — você paga R$1,20/mês direto ao Google."
**CRÍTICO:** Revenue Share entra APENAS se Valdece lançar SaaS próprio — não confundir com mensalidade.

---

## HIPÓTESES ATIVAS

> Aguardam demo real — Valdece ainda não testou o sistema.

| # | Hipótese | Status | Baseada em |
|---|---|---|---|
| H-1 | Vai perguntar sobre mensalidade durante ou após a demo | **PARCIAL** — modelo sem mensalidade confirmado no presencial | Perfil orientado a custo + modelo incomum para o nicho |
| H-2 | A demo no computador DELE (não de Eduardo) é o momento de virada | PENDENTE — demo ainda não realizada | Perfil exigente — precisa sentir que o sistema é dele |
| H-3 | O silêncio durante a primeira busca = aprovação — não interromper | PENDENTE — demo ainda não realizada | Perfil orientado a resultado, não a explicação |
| H-4 | Pode pedir feature não existente depois do encantamento | **CONFIRMADA** — 5 áudios pedindo V3 (data_dje, badges vinculantes) | Scope creep via áudio já em curso — P-023 ativo |
| H-5 | Mencionará colega advogado criminalista se ficar satisfeito | PENDENTE — demo ainda não realizada | Advocacia criminal é comunidade densa — 1 satisfeito fala com 50 na OAB |

---

## PADRÕES OBSERVADOS

> Baseado em documentos e perfil — atualizar após o presencial com comportamento real.

- Experiente e exigente: não aceita sistema que não funciona na primeira tentativa
- Não-técnico: Supabase vira "seu servidor seguro" — nunca usar jargão técnico
- Orientado a resultado: "encontrei o precedente em 10 segundos" é o argumento que fecha
- Orgulhoso da profissão: identidade Toga Digital Navy + Ouro foi escolha dele — reforçar
- Evangelizador em potencial: 1 satisfeito fala com 50 na OAB — documentar indicações

---

## LEADS DETECTADOS

| Nome/Descrição | Contexto | Status |
|---|---|---|
| Nenhum registrado ainda | — | Monitorar ativamente no presencial |

**Gatilho:** qualquer menção a colega advogado → ALERTA VERMELHO ao Diretor imediatamente.

---

## PIPELINE COMERCIAL

| Produto | Valor | Gatilho para pitch | Timing |
|---|---|---|---|
| Toga Digital V1 | R$5.000 fixo | Gate: assinatura no presencial | 2026-05-19 |
| Hypercare | Incluso | — | 30 dias pós-entrega |
| V2 — Sovereign Upload + Radar + Citação DOCX | R$8.500–12.000 + R$300/mês opcional | Corpus ≥ 500 docs OU 30 dias de uso ativo | 2026-06-19 |
| Indicação de nicho | Lead qualificado | Valdece mencionar colega criminalista | Qualquer momento pós-satisfação |

**Argumento de abertura V2:** "Quando seu corpus chegar em 500 decisões, temos um upgrade com upload de documentos seus que você vai querer ver."
**Nunca pitch V2 antes de 2 semanas de uso real.**

---

## PRÓXIMA AÇÃO CRÍTICA

**DEMO 2026-05-20 — TEMAS CONFIRMADOS POR VALDECE (2026-05-19):**

> Valdece respondeu explicitamente os 3 temas que mais pesquisou esta semana:
> 1. **Crimes contra a vida** — cobertos: homicídio qualificado STF HC 188888 (sim 0.818), feminicídio, legítima defesa, tentativa
> 2. **Crimes contra o patrimônio** — cobertos: roubo + arma STJ AgRg HC 765432 (sim 0.792), furto, estelionato, extorsão, receptação
> 3. **Crimes contra a administração pública** — cobertos: AP 470 STF (sim 0.780), peculato, lavagem, organização criminosa

**QUERIES TESTADAS E APROVADAS para usar na demo (ctrl+C prontas):**
```
Tema 1 → "homicídio qualificado tribunal do júri excesso de linguagem pronúncia"
          → STF HC 188888 sim=0.818 (PRIMEIRO resultado = IMPACTO MÁXIMO)

Tema 2 → "roubo com arma de fogo dosimetria pena aumento proporcional"
          → STJ AgRg HC 765432 sim=0.792

Tema 3 → "corrupção peculato lavagem de dinheiro servidor público administração"
          → STF AP 470 sim=0.780
```

**checklist pré-demo:**

```
[SERVIDOR]  cd CLIENTES/VALDECE/frontend && python -m http.server 8080
            → abrir http://localhost:8080 no Chrome

[0–5 min]   ABERTURA: "Valdece, você mencionou os 3 temas — eu preparei o sistema
            especificamente em volta deles. Vamos ver o primeiro?"
            ↳ ELE NOMEOU OS TEMAS: não perguntar de novo. Já sabemos. Usar isso.
            
[5–10 min]  1ª busca: Crimes contra a vida — silêncio total, deixar o resultado aparecer
[10–20 min] 2ª busca: Crimes contra o patrimônio — mostrar o link "Ver íntegra ↗"
[20–30 min] 3ª busca: Administração pública — copiar citação ABNT com 1 clique
[30–40 min] Deixar ELE digitar a 4ª busca sem ajuda — MOMENTO DE VIRADA H-2
[40–55 min] SOVEREIGN PLAYBOOK: "se o sistema travar, você resolve em 3 passos"
[55–70 min] CONTRATO: não forçar — deixar o entusiasmo fechar
[70–90 min] FECHAMENTO + semente V2 plantada
```

**🚨 MOMENTO MAIS CRÍTICO DO PROJETO:** A primeira busca sobre crimes contra a vida.
HC 188888 vai aparecer primeiro com sim=0.818 — é o acórdão mais relevante do corpus para esse tema.
Se ele reconhecer o caso → contrato fecha sozinho.
Se não reconhecer → mostrar o link STF e ler a ementa em voz alta.

**Script para Sovereign Upload V2 (quando ele perguntar):**
> "Valdece, aquelas decisões que você guarda porque já te salvaram em mais de um caso — quando você tiver rodado o que está aqui por umas duas semanas e a gente entender o volume real, a próxima evolução é o seu acervo entrando junto. O sistema aprende o seu jeito de defender, não só o jeito dos tribunais."

**Linha de fechamento validada:** "O sistema é seu. Isso aqui só formaliza."
**Se perguntar sobre mensalidade:** "não tem — você paga R$1,20/mês direto ao Google." (confirmado)
**Se pedir desconto:** escalar ao Diretor. Não responder no momento. Mudar assunto.

**RISCO MONITORADO — sigilo:**
Se Valdece perguntar onde ficam os documentos dele (V2):
> "Ficam no seu Supabase — a mesma conta sua que está rodando agora. Nada sai do seu controle. Você sabe disso, viu hoje."

---

## GATILHO COMERCIAL

**Sinal que indica que chegou a hora do pitch V2:**
Valdece diz algo como "esse sistema me poupou 2 horas hoje" ou menciona colega com a mesma dor.

**Princípio candidato ao LEDGER:**
LegalTech para advogados criminalistas — o ROI é medido em precedentes encontrados antes do juiz,
não em horas economizadas. O argumento certo é "eu encontrei antes" — não "eu economizei tempo."

---

## HISTÓRICO DE ATUALIZAÇÕES

| Data | O que mudou | Quem atualizou |
|---|---|---|
| 2026-05-18 | Criação — véspera do presencial | Músculo |
| 2026-05-19 | Presencial realizado — credenciais obtidas — modelo confirmado (sem mensalidade) — demo pendente | Músculo (P-032) |
| 2026-05-19 | LOG_002 Embaixador processado: 3-temas question + script V2 + script sigilo + alerta H-5 janela 14 dias. Threshold demo ajustado para 0.45. 20 acórdãos testados — sistema verde. | Músculo (P-032) |
| 2026-05-20 | Valdece confirmou os 3 temas reais: crimes contra a vida + patrimônio + adm. pública. Gate CLI: vida 0.818, patrimônio 0.792, adm.pública 0.780. Frontend corrigido: credenciais reais + gemini-embedding-001. Sistema VERDE para demo. | Músculo (P-032) |
| 2026-05-19 (Loop 6) | 5 áudios de feedback processados. Entregas: ementa completa + badge UF + boost monocrático (commit 9709649). HC 512.290/RJ corrigido. V3 identificado (data_dje, repercussao_geral, recurso_repetitivo) — BLOQUEADO até contrato (P-023). Eduardo vai presencialmente assinar hoje. Temperatura: QUENTE. | Músculo (P-032) |

---

> **Protocolo de uso:** Cole este arquivo no início de cada sessão do Project.
> O Embaixador processa e opera com contexto real — não com suposições.
> Tempo de leitura: 30 segundos. Tempo de atualização: 2 minutos.
