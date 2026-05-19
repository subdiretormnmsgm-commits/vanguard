# MEMORIA_EMBAIXADOR — PROJ-001 VALDECE
> Documento vivo. Atualizar a cada gate ou marco de relacionamento.
> Leitura obrigatória de abertura de sessão — 30 segundos.
> Versão: Presencial · 2026-05-18 (criado na véspera da entrega)

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
| Gate atual | **Credenciais obtidas — configuração pendente** |
| commit ef3f1cd | Schema Supabase + ingest.py + kill_switch.js ✅ |
| commit 996b40d | Corpus pipeline Python + Mágico de Oz Gate ✅ |
| commit 18c617f | STJ por Tema + busca semântica threshold + UI Toga Digital ✅ |
| commit e9afb36 | Gate ABNT NBR6023 + busca precisa/ampla + redesign Navy/Ouro ✅ |
| Presencial 2026-05-19 | Realizado — credenciais do Valdece obtidas por Eduardo |
| Demo real | **NÃO REALIZADA** — Valdece ainda não testou o sistema |
| Contrato | **PENDENTE** — aguarda onboarding técnico + demo real |

**Pendente para a próxima sessão (com as credenciais em mãos):**
- Auth Supabase single-user (configurar com credenciais do Valdece)
- Edge Function cron blindado (auto-atualização do corpus na conta dele)
- Auto-Heal pg_net (reconexão automática em falhas)
- View last_activity (Valdece vê quando corpus foi atualizado)
- Sovereign Playbook (guia impresso)
- Migração infra → conta Supabase do Valdece (P-013 — soberania)
- **Demo real** — primeiro teste do Valdece no próprio sistema

---

## ESTADO DO RELACIONAMENTO

| Campo | Status |
|---|---|
| Último contato | **Presencial realizado — 2026-05-19** |
| Próximo contato | Próxima sessão — configuração + demo real (credenciais em mãos) |
| Canal principal | Presencial / WhatsApp |
| Tom que funciona | Direto, resultado concreto, sem jargão técnico |
| Tom que não funciona | Técnico, detalhado, longo, com termos de infraestrutura |

**O que Valdece imagina agora:** Eduardo tem as credenciais dele e está configurando o sistema.
Ainda não testou — aguarda a configuração na conta dele. A janela de encantamento está intacta.
A primeira impressão real ainda vai acontecer — é a sessão mais crítica do projeto.

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
| H-4 | Pode pedir feature não existente depois do encantamento | PENDENTE — demo ainda não realizada | Padrão de scope creep em clientes satisfeitos da área jurídica |
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

**CONFIGURAÇÃO + DEMO — próxima sessão (com credenciais em mãos):**

```
[ANTES]     Eduardo configura sistema com credenciais do Valdece (Auth Supabase + migração)
[0–5 min]   ABERTURA: demo no computador DELE — primeira busca com tema que ele usa
[5–20 min]  CONFIGURAÇÃO SILENCIOSA: "estou transferindo o controle para você"
[20–40 min] DEMONSTRAÇÃO GUIADA: 3 buscas reais + 1 busca DELE sem ajuda
[40–55 min] SOVEREIGN PLAYBOOK: "se o sistema travar, você resolve em 3 passos — sem me ligar"
[55–70 min] CONTRATO: não forçar — deixar o entusiasmo da demo fechar
[70–90 min] FECHAMENTO + semente do V2 plantada
```

**🚨 MOMENTO MAIS CRÍTICO DO PROJETO:** A primeira busca de Valdece no sistema dele.
Se ele encontrar o precedente que precisava → contrato fecha sozinho.
Se o sistema travar ou retornar resultado ruim → credibilidade perdida.
**Testar com as credenciais dele ANTES de qualquer demo.**

**Linha de fechamento validada:** "O sistema é seu. Isso aqui só formaliza."
**Se perguntar sobre mensalidade:** "não tem — você paga R$1,20/mês direto ao Google." (confirmado)
**Se pedir desconto:** escalar ao Diretor. Não responder no momento. Mudar assunto.

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

---

> **Protocolo de uso:** Cole este arquivo no início de cada sessão do Project.
> O Embaixador processa e opera com contexto real — não com suposições.
> Tempo de leitura: 30 segundos. Tempo de atualização: 2 minutos.
