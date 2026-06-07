# ANÁLISE DE ENCAIXE — OPORTUNIDADE MUMUZINHO
**Data:** 2026-06-07 | **Emitido por:** Músculo | **Status:** PROSPECTO — SEM CONTATO BILATERAL CONFIRMADO
**Briefing origem:** Formulário preenchido pelo Diretor + análise do Embaixador + validação técnica do Auditor
**GUT atual (provisório):** 60 | **GUT potencial pós-contato:** 100

> ⚠️ P-119: Lead não existe até contato bilateral real. Toda análise abaixo é provisória.
> Gate Zero obrigatório: contato confirmado com Dudu Félix (decisor presumido) antes de qualquer proposta.

---

## CONTEXTO DO PROSPECTO

**Nome:** Mumuzinho (cantor — pagode/samba)
**Negócio declarado:** Holding artística em formação — agenciamento, mentoria de artistas emergentes
**Infraestrutura física:** 3 salas no Rio de Janeiro (compradas)
**Decisor operacional provável:** Dudu Félix (ex-Universal Music, 12 anos de gestão de artistas)
**Decisor financeiro:** Mumuzinho (diretamente)
**Estado do build:** Já construindo sistema com outra equipe — janela de entrada existe mas é estreita

---

## DOR DECLARADA (fonte: vídeo público)

Falta de controle e transparência sobre:
- Comissão do empresário/gestor
- Carga tributária do show
- Custo logístico total
- Quantidade de público (bilheteria)

Acesso: mobile, em tempo real, para qualquer tamanho de artista (do R$30M/ano ao artista de barzinho).

---

## CENA DE SUCESSO P-041

O artista ou gestor pega o celular, abre interface com mapa geográfico da agenda de shows, clica em um evento específico e visualiza em tempo real: negociação, custo logístico, cachê bruto, comissão exata, carga tributária retida, quantidade de público. Materialização do Sovereign Ignition Cockpit aplicado à música.

---

## GUT SCORE COMPARATIVO

| Dimensão | Score | Raciocínio |
|---|---|---|
| **Gravidade** | 5 | R$30M/ano com zero transparência = vazamento financeiro em escala. Risco fiscal latente (ISS variável, ECAD, NFS-e). Dor existencial para holding em formalização. |
| **Urgência** | 3 | Declarada alta, mas não verificada para a Vanguard. Penalidade por ausência de contato bilateral. Se contato confirmado → urgência sobe para 5. |
| **Tendência** | 4 | Pagode/samba: mercado gigantesco, em consolidação profissional. Mumuzinho como hub de ecossistema = multiplicador estrutural. Music tech no Brasil é subdesenvolvido. |

**GUT atual (sem contato):** 5 × 3 × 4 = **60**
**GUT potencial (com contato confirmado):** 5 × 5 × 4 = **100**

| Projeto | GUT | Situação |
|---|---|---|
| PROJ-001 Valdece | 75 | Em produção, Hypercare até 18-06-2026 |
| PROJ-002 Ingrid | 75 | Loop 7 concluído, Loop 8 aguarda |
| Mumuzinho (atual) | 60 | Prospecto sem contato |
| Mumuzinho (pós-contato) | 100 | Superior a todos os projetos ativos |

---

## COMPLEXIDADE DO DFD (P-043)

**Respondidas com dados disponíveis (8 / ~17 — 47%):**

| # | Pergunta | Resposta disponível |
|---|---|---|
| 1 | Quem é o prospecto e contexto | Mumuzinho, holding artística em formação |
| 2 | Dor central | Transparência financeira nos shows via mobile |
| 3 | Cena de sucesso P-041 | Celular + mapa + show + dados financeiros em tempo real |
| 4 | Visão de longo prazo | Toda monetização artística: show + streaming + publicidade |
| 5 | Fluxo de informação básico | Entrada: negociação/custos/splits. Saída: dashboards mobile |
| 6 | Estado atual do prospecto | Equipe contratada, escritório físico, build em andamento |
| 7 | Escala de negócio | R$30M/ano (artista grande) → artista de barzinho |
| 8 | Urgência percebida | Alta — "já estou fazendo", janela estreita |

**Requerem contato bilateral (9 / ~17 — 53%):**

| # | Pergunta | Por que falta |
|---|---|---|
| 9 | Orçamento real disponível para tech | Gasto com imóvel/equipe ≠ budget para software |
| 10 | Decisor confirmado | Dudu Félix é presumido — não validado |
| 11 | Estado do build atual | "Já estou criando" pode ser MVP ou 80% pronto |
| 12 | Modelo comercial preferido | SaaS mensal? Enterprise? Revenue share? |
| 13 | Ontologia fiscal específica | ISS por município, ECAD integrado ou manual, tipos de NFS-e |
| 14 | Integração ECAD | Sistema atual ou 100% manual? |
| 15 | Carteira atual vs. meta | Quantos artistas hoje, meta em 12 meses |
| 16 | Adoção tecnológica dos artistas | Smartphone básico ou power user? |
| 17 | Por que trocar a equipe atual | O que falta no build que motivaria a troca |

**Diagnóstico:** DFD a 47%. Suficiente para GO na prospecção ativa. Insuficiente para qualquer proposta técnica.

---

## GAPS IDENTIFICADOS PELO EMBAIXADOR

**Gap 1 — Conflito de interesse interno ao produto:**
A dor de Mumuzinho é dar transparência ao artista. A dor do gestor pode ser manter controle da informação. Um SaaS que abre tudo ao artista ameaça o poder informacional do gestor. O DFD deve resolver: quem é o cliente real do produto? Isso define a arquitetura de permissões e o modelo de pricing — não é decisão técnica, é decisão de negócio.

**Gap 2 — Ontologia fonográfica é domínio específico:**
ISS tem alíquota variável por município. ECAD tem lógica própria de distribuição de royalties. O borderô de show é documento fiscal-jurídico específico. Split de cachê entre produtor/empresário/artista tem lógica contratual própria. Não é "dashboard financeiro com dados de música" — é domínio que exige P-043 específico. P-043 se aplica integralmente aqui (referência: Falácia da Homogeneidade dos Nichos).

**Gap 3 — Sem contato bilateral:**
A análise considera dois cenários:
- (A) Diretor tem canal direto → custo de chegada baixo → prospecção imediata possível
- (B) Diretor não tem canal → custo de prospecção relevante → calcular antes de priorizar

---

## STACK TÉCNICA CONFIRMADA (Auditor)

| Versão Vanguard | Componente | Aplicação Mumuzinho |
|---|---|---|
| V6 | Multi-Tenant RLS | Separação de visões artista × gestor |
| V12 | Living HUD financeiro | Dashboard de shows em tempo real |
| V23 | Partner Portal | Visões separadas por papel (artista/gestor/produtor) |

Sem precedente de build fonográfico no histórico — P-043 obrigatório antes de estimativa de escopo.

---

## AVALIAÇÃO DE CAPACIDADE ATUAL

**Datas críticas:**
- 2026-06-14: W-8 shadow mode expira — decisão do Diretor
- 2026-06-18: Valdece Hypercare encerra
- **2026-07-04: Captação 2ª candidata Ingrid — deadline de prospecção ativa do Diretor**

**Gargalo real:** tempo do Diretor, não capacidade técnica.
- Músculo pode pesquisar domínio fonográfico de forma assíncrona (zero custo para Eduardo)
- Prospecção ativa (encontrar contato de Dudu Félix + cold outreach) compete com 2ª candidata Ingrid

**Custo real de avançar agora:** 4–6h do Diretor que disputam com a prospecção de Ingrid.

---

## POSIÇÃO DO MÚSCULO

**ENCAIXA — com condicionante tripla. Prospecção ativa: pós 04-07-2026.**

### Condição 1 — Temporal (não opcional)
A captação da 2ª candidata de Ingrid tem deadline 04-07-2026. Prospecção ativa de Mumuzinho só começa após essa data. O Músculo usa o intervalo para mapear o domínio fonográfico — entrega pesquisa pronta quando o gate abrir.

### Condição 2 — Gate Zero absoluto (contato bilateral)
GUT atual = 60 (provisório). GUT pós-contato = 100 (potencial). Nenhuma estimativa de escopo, proposta ou alocação técnica antes de contato bilateral confirmado com Dudu Félix. Aplicação direta de P-119.

### Condição 3 — DFD fonográfico específico antes de qualquer proposta
O conflito de interesse (transparência para artista × controle do gestor) não é problema de features — é quem é o cliente real do produto. Isso define arquitetura, pricing e proposta de valor. Uma reunião de qualificação que não aborde isso vai gerar proposta para o produto errado.

### Por que encaixa apesar dos gaps
- Dor declarada é real, verificável e em escala relevante
- Stack técnica existe — não é build do zero
- Mumuzinho como hub de ecossistema = multiplicador: produto para 1 artista → produto para toda carteira gerida
- "Já está construindo com outra equipe" é sinal positivo: prova compromisso e orcamento; significa que os gaps técnicos da equipe atual são a oportunidade da Vanguard
- Music tech no Brasil é subdesenvolvido — vantagem de pioneiro real

---

## PRÓXIMAS AÇÕES (quando gate temporal liberar — pós 04-07-2026)

| Responsável | Ação | Prioridade |
|---|---|---|
| Músculo | Mapear ontologia fonográfica: ISS por município, ECAD, borderô, NFS-e artística, splits | Agora (assíncrono) |
| Músculo | Preparar roteiro de qualificação para reunião com Dudu Félix (10 perguntas do DFD pendente) | Antes do contato |
| Diretor | Encontrar canal de acesso a Dudu Félix (LinkedIn, indicação, evento) | Após 04-07-2026 |
| Diretor | Primeira abordagem — qualificação da dor e do decisor | Após contato estabelecido |
| Músculo | DFD completo com Embaixador + recalcular GUT real | Após reunião de qualificação |

---

## REFERÊNCIAS

- **P-043** — Falácia da Homogeneidade dos Nichos (LEDGER)
- **P-119** — Vídeo público de dor é dado de marketing, não de intenção de compra (LEDGER)
- **P-041** — Cena de sucesso como critério de design
- **PROJ-001 Valdece** — GUT 75, referência de qualificação
- **PROJ-002 Ingrid** — GUT 75, deadline 2ª candidata 04-07-2026 (gate temporal)
- **Embaixador** — Briefing com 3 gaps estruturais identificados (conflito interno, ontologia, contato)
