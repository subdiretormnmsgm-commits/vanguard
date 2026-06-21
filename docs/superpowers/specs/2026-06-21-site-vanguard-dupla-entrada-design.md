# Site Vanguard — Dupla Entrada + Vitrine Dinâmica de Nichos

> Spec de desenho · 2026-06-21 · Músculo → review do Diretor (P-124)
> Doutrina: VIRADA P-194 (modo inteligência de mercado). Não é Loop.
> Princípio-eixo do Diretor (2026-06-21): **"Ideia não ancorada em ação, controle e resultado não prospera."**

---

## 1. Objetivo

Adaptar o site da Vanguard para que a **inteligência de mercado** se torne **um canal de entrada de clientes**, **sem descartar** a ideia original de ancoragem por diagnóstico. O site passa a ter **dupla entrada** e a **respirar no ritmo mensal da inteligência** (nichos pontuados como fortes), sob **gate de data** — nunca cron cego, nunca calendário vazio.

Marca-larga preservada: o nicho é **ponta de lança**, não estreitamento. A Vanguard continua atendendo qualquer projeto; a campanha pinada troca sem rebranding.

## 2. Modelo de entrada (duas portas, segmentadas por origem)

Duas portas que **não competem na mesma tela** — a escolha vem da *origem* do visitante (parâmetro tipo `?nicho=<slug>`):

- **Porta orgânica (preservada — DNA Ingrid/Valdece):** visitante sem nicho conhecido → **quiz de descoberta genérico** (nicho · gargalo · WhatsApp) → descobre a dor do zero → ancora → Loop monta. Intacta.
- **Porta inteligência (nova):** visitante vindo de um canal de nicho → **mini-página do nicho** → **quiz robusto específico do gênero**, pré-carregado com as dores já mapeadas daquele nicho, que **direciona o cliente à sua dor REAL** entre os vetores conhecidos → ancora com precisão → Loop monta mirado.

Sem nicho na origem → porta orgânica. Com nicho → porta inteligência.

## 3. Quiz robusto por nicho (o coração da adaptação)

A inteligência de mercado **não substitui o quiz — torna-o preciso**. Para cada nicho com modelo maduro:

- O quiz do nicho é **gerado a partir do `dores[]`** do Niche Model correspondente (não inventado).
- Em vez de descobrir a dor do zero, ele **apresenta os vetores de dor conhecidos do gênero** e conduz o cliente a **identificar/confirmar a dor real dele** — diagnóstico de confirmação, não de descoberta cega.
- É **dinâmico**: conforme `dores[]` enriquece no ciclo mensal, o quiz do nicho fica mais robusto. O quiz evolui com a inteligência.
- Saída idêntica à da porta orgânica (lead ancorado + WhatsApp), mas com a dor **já qualificada** → discovery do Loop começa adiantado.

Honestidade (P-194): o quiz/mini-página mostra **dor mapeada e abordagem**, nunca case/produto pronto inexistente (Ingrid/Valdece dormentes).

## 4. Vitrine de Nichos (o que torna o site dinâmico)

Seção na home — **Vitrine de Nichos** — com cards dos nichos pontuados como **fortes** no mês (saída do NICHE_MODELER / `fit_score`). Cada card → mini-página do nicho → quiz robusto do nicho (§3). O nicho **nº 1** ocupa o **hero** (campanha pinada).

## 5. Cadência mensal — GATED pelo gate de data

A regeneração da Vitrine **não é cron cego**. É uma **ação datada** que só executa sob **gate de data** (mesmo mecanismo já em produção no `cowork_calendar.ps1`, integrado ao `session_start`):

- A ação `REGEN_VITRINE_SITE` entra como linha datada em `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/CALENDARIO_NICHE_INTELLIGENCE.md` — **logo após o enriquecimento mensal de dia 1** (NICHE_MODELER, que produz o score).
- O Músculo só regenera a Vitrine quando o gate cruza *hoje × calendário* e **libera** a data. Fora da data → não age. Sem score novo no mês → Vitrine permanece.
- O nome do arquivo do calendário **permanece** `CALENDARIO_NICHE_INTELLIGENCE.md` (decisão do Diretor 2026-06-21) — ele já é a autoridade de ações datadas; só ganha mais esta linha. Princípio: **nenhuma ação de calendário sem sincronização com esse calendário.**

## 6. Restrições inegociáveis (herança da operação)

- **Editorial:** mini-páginas, quiz de nicho e hero **nunca** mencionam IA/automação/Claude — vendem o *resultado* para a dor do nicho (regra do `INTENCAO_LINKEDIN.md`).
- **1 canal ativo por nicho + gate E-4:** a Vitrine pode *exibir* vários nichos, mas a *ativação de canal* por nicho exige ≥1 conversa real antes de abrir o próximo (`ESTRATEGIA_CANAIS_VANGUARD.md`).
- **Isolamento P-059:** o site é ativo da Vanguard (PROJ-000); nichos ≠ dados de cliente.

## 7. Ancoragem Ação–Controle–Resultado (eixo do Diretor)

| Peça | AÇÃO | CONTROLE | RESULTADO (mede-se) |
|---|---|---|---|
| Vitrine / regen | Entra/sai card por score; hero = nº 1 | Gate de data libera só pós-dia-1; sem score → não mexe | Nichos no ar == score do mês (auditável vs NICHE_MODELER) |
| Quiz de nicho | Conduzir cliente à dor real via `dores[]` | Dor vem do Niche Model + editorial sem IA | Dor qualificada na entrada → discovery adiantado |
| Mini-página | Publicar dor mapeada + abordagem + CTA | Editorial; sem case inexistente | **Conversas reais por nicho (métrica-mãe)** |
| Ativação de canal | Abrir 1 canal para o nicho-ponta | Gate E-4 | Canais ativos vs conversas — não escala no vazio |
| Quiz orgânico | Descobrir dor → ancorar | DNA intacto; segmentação por origem | Leads ancorados pela porta orgânica |
| Realimentação | Nicho que converteu volta ao scoring | Fecha ciclo no dia 1 | Prioridade do mês seguinte ajustada pelo que deu resultado |

**Métrica-mãe:** **conversas reais geradas por nicho**. Site que muda todo mês mas não gera conversa mudou cosmético, não prosperou. Esse número realimenta o score — o mercado vota, o site segue o voto.

## 8. Fora de escopo (YAGNI)

- Renomear/consolidar formalmente um "Calendário Vanguard" único — **não** se faz aqui (Diretor manteve o nome atual). Eventual unificação de todas as ações datadas é iniciativa irmã.
- Infra de deploy (onde o código mora, hospedagem, schema Supabase do lead por nicho, mecanismo concreto do regen) — **decisão de implementação**, definida no plano (writing-plans), não neste desenho.
- Novos canais além dos já governados por `ESTRATEGIA_CANAIS_VANGUARD.md`.

## 9. Decisões diferidas ao plano de implementação

1. **Localização do código do site** e como o regen mensal se pluga (estático regenerado vs. data-driven).
2. **Formato de armazenamento do quiz por nicho** (derivado de `dores[]` — gerado em build vs. lido em runtime).
3. **Instrumentação da métrica-mãe** (como contar "conversa real por nicho" — origem do lead/WhatsApp).

Essas três entram como perguntas a resolver no writing-plans, após o veredito deste spec.
