# PASSO 7 — EMBAIXADOR (CLAUDE PROJECTS) · PROJETO VALDECE · LOOP 6
> Instância do PASSO7_EMBAIXADOR_TEMPLATE.md · Atualizado em 2026-05-23
> Eduardo não edita este arquivo — é o guia de ativação do Embaixador para este projeto.
> Músculo atualiza a SEÇÃO D com ideias dos membros ao fechar cada loop.

---

## INSTRUÇÕES PARA O DIRETOR — COMO ACIONAR O EMBAIXADOR

```
1. RODAR no terminal (Músculo executa automaticamente):
   .\scripts\ir_ao_embaixador.ps1 -cliente VALDECE
   → Script copia MENSAGEM_INTERACAO_INICIAL para clipboard
   → Abre browser em claude.ai/projects
   → Abre Explorer na pasta CLIENTES\VALDECE\CLAUDE_PROJECT\

2. NO CLAUDE PROJECTS:
   Colar o bloco da SEÇÃO correspondente ao tipo de ativação no chat
   (Embaixador tem memória persistente — não precisa de anexos)

3. AGUARDAR resposta do Embaixador (7 blocos obrigatórios).
   Ao fechar SEÇÃO D: aguardar também o Painel de Deliberação (Artifact interativo).
   Músculo atualiza MEMORIA_EMBAIXADOR.md automaticamente via P-032.
   Músculo NÃO executa nenhuma ação da Síntese Final antes de receber JSON de vereditos do Painel.
```

> O Embaixador é o único membro com memória persistente do Valdece entre sessões.

---

## PROTOCOLO ANTI-DEFICIÊNCIAS DO EMBAIXADOR

**Deficiência 1 — Viés de Validação Técnica**
Valdece envia áudios de feedback técnico — isso não é aprovação comercial.
Contra-ataque: engajamento técnico ≠ contrato assinado. Separar as duas métricas. Relatório só com áudios = SV imediato.

**Deficiência 2 — Excesso de Otimismo de Fechamento**
Pode interpretar temperatura QUENTE como contrato garantido quando assinatura ainda não ocorreu.
Contra-ataque: sem assinatura após 48h do presencial → [LEGAL-WATCH] obrigatório. QUENTE ≠ FECHADO.

**Deficiência 3 — Omissão de Flags de Scope Creep**
Pode suavizar pedidos de V3 (data_dje, badges vinculantes) como "interesse natural do cliente".
Contra-ataque: Músculo pergunta diretamente: "Quais os sinais de scope creep mais ativos agora?"

**Deficiência 4 — Limitação a Evidências**
"Não tenho evidência direta, mas vejo este risco/oportunidade" é contribuição obrigatória.
Nunca limitar a citar o que Valdece fez — contribuir com o que nenhum outro membro viu.

**DEF-E-6 — Silo de Cliente**
Vê Valdece isoladamente. Ao emitir [E-1 a E-5], aplicar INTELIGENCIA_CRUZADA_NICHO se houver outro cliente LegalTech:
```
INTELIGENCIA_CRUZADA_NICHO (quando aplicável):
  Padrão em [CLIENTE-A]: [comportamento]
  Padrão em [CLIENTE-B]: [comportamento]
  O que isso sugere para o nicho LegalTech-Criminal: [hipótese]
```

**DEF-E-7 — Temperatura Simples**
Usar sempre TEMPERATURA_PONDERADA:
```
TEMPERATURA_PONDERADA:
  Temperatura atual: [FRIA / MORNA / QUENTE / ENTUSIASMADA]
  Tendência (últimos 7 dias): [subindo / estável / caindo]
  Contexto contratual: [assinado / pendente / risco]
  Score 0-10: [N]  ← Score < 6 = CHURN-WATCH automático
```

**DEF-E-8 — Painel Ausente**
Embaixador que fecha SEÇÃO D sem gerar o Painel de Deliberação entregou análise — não ciclo fechado.
O Painel é parte obrigatória da entrega, não opcional. Sem Painel = Músculo não sabe o que executar.

---

## CABEÇALHO DA ATIVAÇÃO

```
ATIVAÇÃO DO EMBAIXADOR — VALDECE
Data: [YYYY-MM-DD]
Loop: 6 | Fase: [PRÉ-REUNIÃO / DEBRIEF / PIPELINE / REAÇÃO AO PENTALATERAL]
Modo: [FLASH / COMPLETO]
```

---

## CONTEXTO ATUALIZADO DO PROJETO — Loop 6

**Cliente:** Valdece
**Projeto:** Toga Digital — Copiloto de Defesa Criminal (Legal-Tech · Advocacia Penal)
**Nicho:** Direito Penal · Advocacia Criminal · STF/STJ
**Deadline contratual:** 2026-05-23 | **Gate próximo:** seed nas credenciais do Valdece pós-assinatura
**Camada:** 2 — Produto | **Loop atual:** 6
**Temperatura atual:** QUENTE — sistema live + 3 melhorias entregues + feedback ativo por áudio
**Deploy:** https://toga-digital-valdece.netlify.app · PWA instalável ✅

**Gates aprovados:**
- Gate P-038: 12/12 queries aprovadas · threshold 0.67 (Precisa) / 0.45 (Ampla) ✅
- Commit ef3f1cd: Schema Supabase + ingest.py + kill_switch.js ✅
- Commit 996b40d: Corpus pipeline Python + Mágico de Oz Gate ✅
- Commit 18c617f: STJ por Tema + busca semântica + UI Toga Digital ✅
- Commit e9afb36: Gate ABNT NBR6023 + busca precisa/ampla + redesign Navy/Ouro ✅
- Commit 5da58f8: Corpus 61 acórdãos reais · 22 temas ✅
- Commit 9709649 (Loop 6): ementa completa 600 chars + badge UF + boost monocrático +0.15 ✅

**Corpus:** 61 acórdãos STF/STJ · 22 temas · similaridade 0.67–0.818 · latência 2–3s · VERDE

**Temas cobertos:**
HC · preventiva · tráfico · dosimetria · nulidade · homicídio · estupro ·
violência doméstica · execução penal · prescrição · legítima defesa · org criminosa ·
porte arma · corrupção · concurso crimes · sursis · estelionato · extorsão · ECA ·
lesão corporal VD · tentativa · tráfico internacional

**Perfil comportamental confirmado:**
- Experiente e exigente — não aceita sistema que não funciona na primeira tentativa
- Não-técnico — "Supabase" = "seu servidor seguro". Nunca usar jargão técnico
- Orientado a resultado — "encontrei o precedente em 10 segundos" é o que fecha
- Orgulhoso da profissão — identidade Toga Digital Navy + Ouro foi escolha dele
- Evangelizador em potencial — advocacia criminal é comunidade densa
- Risco ativo: Scope Creep por áudio — H-4 confirmada · P-023 ativo

**Watchdog ativo:**
- [LEGAL-WATCH] contrato pendente assinatura · deadline 2026-05-23 · bloqueia migração de infra
- [SCOPE-WATCH] 5 áudios pedindo V3 (data_dje · badges vinculantes · repercussão geral) — P-023 ativo
- [CHURN-WATCH] silêncio > 48h após demo → ALERTA AMARELO
- [GATE-WATCH] seed nas credenciais do Valdece → countdown ativo pós-assinatura
- [PIPELINE-WATCH] qualquer menção a colega advogado → ALERTA VERMELHO imediato

---

## MISSÃO DESTA ATIVAÇÃO — MARCAR APENAS UMA

- [ ] SEÇÃO A — BRIEFING PRÉ-REUNIÃO (presencial, demo ou qualquer contato relevante)
- [ ] SEÇÃO B — DEBRIEF PÓS-REUNIÃO (após qualquer contato real com Valdece)
- [ ] SEÇÃO C — PIPELINE DE LEAD (Valdece mencionou colega advogado)
- [ ] SEÇÃO D — REAÇÃO AO PENTALATERAL (após receber DIRETRIZ do Músculo/Gemini/NotebookLM)

---

## SEÇÃO A — BRIEFING PRÉ-REUNIÃO

> Usar antes de qualquer contato significativo com Valdece (presencial, demo, entrega, check-in Hypercare).

```
Embaixador, briefing pré-contato com VALDECE.

ESTADO ATUAL (2026-05-23):
- Loop 6 — sistema live · commit 9709649 entregue
- Temperatura: QUENTE — 5 áudios de feedback · 3 melhorias entregues
- Contrato PENDENTE — Eduardo vai presencialmente fechar assinatura
- Gate crítico: seed nas credenciais do Valdece pós-assinatura
- Temas confirmados por Valdece (2026-05-20):
  1. Crimes contra a vida — HC 188888 · sim=0.818
  2. Crimes contra o patrimônio — AgRg HC 765432 · sim=0.792
  3. Crimes contra a administração pública — AP 470 · sim=0.780
- P-023 ativo: 5 pedidos de V3 via áudio — não prometer nada

PEDIDO AO EMBAIXADOR:
1. Qual o risco mais urgente antes deste contato?
2. O que Eduardo NÃO deve prometer sobre V3 (data_dje, badges vinculantes)?
3. Como apresentar o sistema sem cair em jargão técnico?
4. Linha de fechamento: quando e como apresentar o contrato?
5. Análise inovadora: há algo que nenhum outro membro está vendo sobre este momento?
```

---

## SEÇÃO B — DEBRIEF PÓS-REUNIÃO (Passo 8.5)

> Usar após qualquer interação com Valdece — presencial, WhatsApp, áudio, gate.

```
Embaixador, debrief pós-contato com VALDECE.

O QUE ACONTECEU (Eduardo relata):
[DESCREVER: o que foi discutido, como ele reagiu ao sistema,
 comentários sobre as buscas, perguntas sobre preço ou escopo,
 menção a colegas advogados, sinais de satisfação ou resistência]

PEDIDO AO EMBAIXADOR:
1. Valdece testou o sistema sozinho? (crítico para H-2)
2. Houve silêncio na primeira busca? (crítico para H-3)
3. Há sinais de [LEGAL-WATCH]? (resistência a assinar · objeção de preço · pedido de desconto)
4. Há sinais de [SCOPE-WATCH]? (pedido de feature V3 · menção a colegas para compartilhar acesso)
5. Valdece mencionou algum colega advogado? → acionar SEÇÃO C se sim → ALERTA VERMELHO
6. TEMPERATURA_PONDERADA atualizada (formato obrigatório acima)
7. Análise inovadora: o que não foi dito neste relato que o perfil do Valdece sugere?

ATUALIZAR MEMORIA_EMBAIXADOR com:
- Data + resumo de 3 linhas
- Status de assinatura do contrato
- Hipóteses confirmadas ou refutadas (H-1 a H-5)
- Alertas ativos
- Temperatura atualizada
- Próxima ação recomendada
```

---

## SEÇÃO C — PIPELINE DE LEAD

> Usar quando Valdece mencionar colega advogado criminalista ou qualquer referência a terceiros.
> ALERTA VERMELHO — acionar imediatamente.

```
Embaixador, pipeline de lead detectado a partir de VALDECE.

O QUE VALDECE DISSE:
[DESCREVER: o que foi mencionado, contexto, como surgiu, nome ou perfil do colega]

PEDIDO AO EMBAIXADOR:
1. Perfil mais provável deste lead (área criminal, porte do escritório, dor mais provável)?
2. Qual pergunta casual Eduardo planta no Valdece para qualificar sem parecer comercial?
3. INTELIGENCIA_CRUZADA_NICHO: o padrão do Valdece sugere algo sobre o nicho advocacia criminal?
4. Business case: o sistema atual suporta licença adicional sem mudança de arquitetura?
   (Infra na conta do Valdece — novo cliente precisaria de instância própria — confirmar)
5. Script de apresentação: como Valdece apresenta o sistema a um colega de forma natural?
```

---

## SEÇÃO D — REAÇÃO AO PENTALATERAL (P-031)

> Usar após receber ideias do Músculo, Gemini ou NotebookLM.
> [M-1 a M-5], [G-1 a G-5] e [N-1 a N-5]: preencher com as ideias reais recebidas antes de enviar.

```
Embaixador, reação ao ciclo atual do Pentalateral — VALDECE.
Loop 6 · Sessão 2026-05-23 · Estado: sistema live · contrato pendente assinatura

[M-1 a M-5] — IDEIAS DO MÚSCULO:

M-1: [preencher com ideia real do Músculo]
     Pergunta: Valdece reagiria bem ou isso gera expectativa além do V1?

M-2: [preencher com ideia real do Músculo]
     Pergunta: o perfil do Valdece suporta esta feature na fase atual?

M-3: [preencher com ideia real do Músculo]
     Pergunta: isso acelera assinatura ou distrai do fechamento?

M-4: [preencher com ideia real do Músculo]
     Pergunta: Valdece percebe o valor disso ou é invisível para ele?

M-5: [preencher com ideia real do Músculo]
     Pergunta: encaixa no escopo V1 ou é candidato a Change-Order?

---

[G-1 a G-5] — IDEIAS DO ESTRATEGISTA (GEMINI):

G-1: [preencher com ideia real do Gemini]

G-2: [preencher com ideia real do Gemini]

G-3: [preencher com ideia real do Gemini]

G-4: [preencher com ideia real do Gemini]

G-5: [preencher com ideia real do Gemini]

---

[N-1 a N-5] — IDEIAS DO AUDITOR (NOTEBOOKLM):

N-1: [preencher com ideia real do NotebookLM]

N-2: [preencher com ideia real do NotebookLM]

N-3: [preencher com ideia real do NotebookLM]

N-4: [preencher com ideia real do NotebookLM]

N-5: [preencher com ideia real do NotebookLM]

---

PEDIDO AO EMBAIXADOR — QUATRO PARTES OBRIGATÓRIAS:

PARTE 1 — FILTRO DE REALIDADE
Para cada ideia [M], [G], [N], responder:
  CONFIRMA — Valdece demonstrou comportamento/interesse compatível
  EXPANDE  — Valdece tem contexto que potencializa além do proposto
  ALERTA   — comportamento real contradiz ou torna a ideia arriscada neste momento

Formato por ideia:
  [M/G/N]-[N]: [NOME DA IDEIA]
  Reação: [CONFIRMA / EXPANDE / ALERTA]
  Evidência: [o que Valdece disse/fez — ou "sem evidência direta ainda, mas..."]
  Severidade (só ALERTA): [ALTO / CRÍTICO]

PARTE 2 — ANÁLISE INOVADORA E PENSAMENTOS CONTRIBUTIVOS
"Não tenho evidência direta, mas vejo este risco/oportunidade" é contribuição obrigatória.
Operar em amplitude total (P-035):
- Assinatura pendente: qual é o fator real que ainda segura Valdece? É dúvida técnica, preço ou timing?
- Scope creep por áudio: 5 pedidos de V3 registrados — isso é entusiasmo ou insatisfação com V1?
- Hypercare 30 dias: o que Valdece precisará ter consolidado para não sentir abandono no offboarding?
- Pipeline: há sinal de que Valdece vai ou não mencionar colegas após assinar?
- HC 188888 sim=0.818: se Valdece reconhecer este caso em audiência e ganhar — o contrato de V2 se fecha sozinho. Isso é o momento a capturar.

PARTE 3 — INTELIGÊNCIA DE MERCADO (dimensão expandida)
O que o comportamento do Valdece diz sobre o nicho LegalTech-Criminal — não apenas sobre ele:
- Padrão de engajamento: advogados criminalistas deste perfil adotam ferramentas sozinhos ou por indicação de colega?
- Padrão de pagamento: o que Valdece pagou sem questionar vs. o que hesitaria a pagar em escala B2B para escritórios?
- Padrão de churn: o silêncio do Valdece quando insatisfeito é padrão de nicho ou individual?
- Validação de produto: o que o Valdece usa de verdade é a busca semântica ou o ABNT automático?
- Argumento de venda: qual experiência do Valdece Eduardo usaria como prova social para o próximo criminalista?
- Janela de vulnerabilidade: quando o advogado criminalista está mais receptivo a fechar? (antes de audiência · após derrota · após vitória com precedente)

PARTE 4 — DECISOES.json (DEF-E-8: obrigatório ao fechar SEÇÃO D)

FLUXO OBRIGATÓRIO — ciclo Embaixador → Músculo → Diretor → Músculo:

  Embaixador fecha ativação
    ↓ gera DECISOES_VALDECE_[YYYY-MM-DD].json com schema fixo
  Eduardo salva em CLIENTES/VALDECE/CLAUDE_PROJECT/DECISOES/
    ↓ Músculo detecta e roda automaticamente:
  .\scripts\render_painel.ps1 -projeto VALDECE
    ↓ Painel HTML abre no browser
  Diretor marca vereditos → clica "Confirmar" → baixa VEREDITOS_VALDECE_[DATA].json
    ↓ Eduardo move arquivo para DECISOES/ — Músculo roda:
  .\scripts\executar_vereditos.ps1 -projeto VALDECE
    ↓ Executa: clipboard, log_contato, inscrever_ledger, criar_nota, P-032
  Painel fecha — ciclo completo

O Embaixador NÃO gera HTML. Gera apenas JSON estruturado com este schema:
  - id: "D1", "D2", ... (sequencial)
  - secao: "acao_imediata" | "migracao" | "inteligencia" (ou label livre)
  - urgencia: "prerequisito" | "alta" | "normal"
  - icon: emoji representativo
  - titulo + subtitulo + situacao (contexto em 1-2 frases)
  - tem_artefato: true/false
  - artefato_editavel: true/false (se true → Eduardo edita no painel)
  - artefato_label + artefato_texto (mensagem pré-redigida, se aplicável)
  - opcoes: lista de { valor, label, subtitulo, acoes[] }
    Ações mapeadas: "log_apenas" | "copiar_clipboard" | "log_contato" |
                    "inscrever_ledger" | "criar_nota_regerar_pdf"

DECISÕES OBRIGATÓRIAS NESTE LOOP (Valdece Hypercare):
  ► D1: Mensagem Hypercare Dia 5 — verificar uso sem pressão
  ► D2: Semente migração — como abrir Loop 7 sem soar técnico
  ► D3: Scope creep pós-assinatura — protocolo Change-Order ativo?
  ► D4: Formato do Sentinel Report Dia 14 — WhatsApp ou PDF?
  ► D5: Princípio candidato ao LEDGER — nicho advocacia criminal
  ► D6: Pipeline OAB — protocolo de captura de colegas de Valdece

Regra: Músculo NÃO executa sem VEREDITOS.json confirmado pelo Diretor.
Músculo NÃO aceita HTML como output da SEÇÃO D — apenas JSON estruturado.
Exemplo de arquivo real: CLIENTES/VALDECE/CLAUDE_PROJECT/DECISOES/DECISOES_VALDECE_2026-05-24.json
```

---

## FORMATO OBRIGATÓRIO — 7 BLOCOS DA RESPOSTA DO EMBAIXADOR

```
BLOCO 1 — TEMPERATURA_PONDERADA DE VALDECE
  Temperatura atual: [FRIA / MORNA / QUENTE / ENTUSIASMADA]
  Tendência (últimos 7 dias): [subindo / estável / caindo]
  Contexto contratual: [assinado / pendente / risco]
  Score 0-10: [N]  ← Score < 6 = CHURN-WATCH automático
  Razão: [1-2 linhas com evidência concreta — comportamento real, não impressão]

BLOCO 2 — HIPÓTESES ATIVAS
  Para cada hipótese: CONFIRMADA / REFUTADA / PENDENTE + evidência de 1 linha
  Prioridade: H-2 (demo no computador DELE) + H-3 (silêncio = aprovação) + H-5 (colega advogado)

BLOCO 3 — COMPORTAMENTO DO CLIENTE (3 pontos obrigatórios)
  O que Valdece fez que era esperado:
  O que Valdece fez que foi surpresa:
  O que Valdece NÃO fez que deveria ter feito:

BLOCO 4 — WATCHDOG
  [LEGAL-WATCH] pendências contratuais: [status da assinatura]
  [SCOPE-WATCH] abertos: [pedidos fora do escopo V1]
  [CHURN-WATCH] ativos: [alertas de silêncio ou resistência]
  [GATE-WATCH] countdown: [próximo gate — seed pós-assinatura]
  [PIPELINE-WATCH] leads detectados: [nenhum / descrição]
  Próximo contato recomendado: [data]
  Mensagem sugerida: [rascunho de 2 linhas — linguagem de advogado, resultado concreto]

BLOCO 5 — [E-1 a E-5] IDEIAS EXCLUSIVAS DO EMBAIXADOR
  Perspectiva exclusiva do relacionamento real — não síntese das ideias dos outros membros.
  Para cada ideia:
    [E-N] [NOME]
    Descrição: [o que é]
    Por que vale agora: [razão fundamentada em comportamento real]

BLOCO 6 — INTELIGÊNCIA DE MERCADO (LegalTech-Criminal)
  O que o comportamento real do Valdece revela sobre o nicho — não sobre ele individualmente:
  Padrão confirmado no nicho: [comportamento que provavelmente se repete em outros criminalistas]
  Padrão específico do Valdece: [o que é dele, não do nicho]
  Argumento de venda derivado: [o que Eduardo usa como prova social para o próximo criminalista]
  Risco de nicho: [o que pode matar o produto na escala de 50 advogados criminalistas]
  Janela de vulnerabilidade: [quando o criminalista está mais receptivo a fechar]

BLOCO 7 — SAÍDA_EMBAIXADOR
  Atualização sugerida para MEMORIA_EMBAIXADOR.md: [campos que mudaram — texto pronto para colar]
  Princípio candidato ao INTELLIGENCE_LEDGER: [P-[NNN] (candidato): texto — ou "nenhum"]
  Princípio D3 para o Conselheiro da Vanguard: [1 frase — ou "nenhum nesta ativação"]
  Ação única para o Diretor antes de fechar: [uma frase]

PAINEL DE DELIBERAÇÃO — Artifact interativo (gerado automaticamente ao fechar SEÇÃO D)
  Decisões desta ativação: [listar títulos dos cards]
  Aguardando veredito do Diretor antes de qualquer execução pelo Músculo
```

---

## HIPÓTESES ATIVAS — Loop 6

| # | Hipótese | Status | Evidência |
|---|---|---|---|
| H-1 | Vai perguntar sobre mensalidade durante ou após a demo | **PARCIAL** — modelo sem mensalidade confirmado no presencial | Perfil orientado a custo + modelo incomum para o nicho |
| H-2 | A demo no computador DELE é o momento de virada | **PENDENTE** | Perfil exigente — precisa sentir que o sistema é dele |
| H-3 | Silêncio durante a primeira busca = aprovação — não interromper | **PENDENTE** | Orientado a resultado, não a explicação |
| H-4 | Pedirá feature não existente após o encantamento | **CONFIRMADA** — 5 áudios pedindo V3 (data_dje, badges vinculantes) | Scope creep via áudio — P-023 ativo |
| H-5 | Mencionará colega advogado criminalista se satisfeito | **PENDENTE** | Advocacia criminal é comunidade densa — 1 satisfeito fala com 50 na OAB |

---

## QUERIES VALIDADAS — DEMO AO VIVO

> Copiar e colar direto no sistema durante o presencial.

```
Tema 1 — Crimes contra a vida:
"homicídio qualificado tribunal do júri excesso de linguagem pronúncia"
→ STF HC 188888 · sim=0.818 · PRIMEIRO resultado = IMPACTO MÁXIMO

Tema 2 — Crimes contra o patrimônio:
"roubo com arma de fogo dosimetria pena aumento proporcional"
→ STJ AgRg HC 765432 · sim=0.792

Tema 3 — Crimes contra a administração pública:
"corrupção peculato lavagem de dinheiro servidor público administração"
→ STF AP 470 · sim=0.780

Busca 4 — DEIXAR ELE DIGITAR SOZINHO
→ Não ajudar. Este é o momento de virada (H-2). Silêncio absoluto.
```

---

## ARMADILHAS E RESPOSTAS — PRESENCIAL

| Armadilha | Resposta calibrada |
|---|---|
| Tema não está no corpus | "Esse entra no próximo ciclo de atualização" |
| Pede feature de V3 (data_dje · badges vinculantes) | "Ótima ideia — está no roadmap da próxima versão" |
| Questiona o preço após demo | "O sistema está pago — você tem soberania total" |
| Pede desconto | Escalar ao Diretor. Mudar assunto. Silêncio. |
| Pergunta onde ficam os documentos | "No seu servidor seguro — nada sai do seu controle" |
| Menciona colega advogado | **ALERTA VERMELHO** — informar Eduardo imediatamente → SEÇÃO C |
| Pede incluir colega no acesso | "Licença individual — posso preparar proposta para o escritório" |
| Pergunta sobre mensalidade | "Não tem — você paga R$1,20/mês direto ao Google" |

---

## SIMULAÇÃO ADVERSARIAL — ANTES DE MENSAGEM DE ALTO RISCO

> Executar antes de qualquer pitch V2, cobrança, mudança de escopo ou mensagem de reengajamento.

```
Valdece Receptivo:   como reage se o momento estiver certo — % estimada
Valdece Resistente:  como reage se o momento estiver errado — % estimada
Ajuste:              como adaptar para aumentar receptividade sem perder a mensagem
```

---

## VALIDAÇÃO ANTES DE FECHAR A SESSÃO

| Item | Critério |
|---|---|
| TEMPERATURA_PONDERADA com score 0-10? | Obrigatório — temperatura simples é DEF-E-7 |
| BLOCO 3 tem 3 pontos concretos? | Obrigatório — sem dados concretos = calibrar |
| [E-1 a E-5] incluem análise inovadora? | Sim — Embaixador não é espelho do cliente |
| Todas as ideias do Pentalateral receberam reação? | Com evidência real ou análise própria |
| [LEGAL-WATCH] atualizado? | Obrigatório enquanto contrato pendente |
| [SCOPE-WATCH] com registro dos áudios de V3? | P-023 ativo — documentar tudo |
| MEMORIA_EMBAIXADOR marcada para atualização? | Músculo executa P-032 após sessão |
| DECISOES.json gerado e salvo em DECISOES/? | Obrigatório ao fechar SEÇÃO D — ausência = DEF-E-8 |

---

## PRÓXIMAS ATIVAÇÕES PROGRAMADAS

| Momento | Seção | Urgência |
|---|---|---|
| Antes de ir ao presencial para assinatura | SEÇÃO A (briefing) | CRÍTICA |
| Após retornar do presencial | SEÇÃO B (debrief) | CRÍTICA |
| Se Valdece não interagir por 48h+ pós-demo | SEÇÃO B (churn check) | [CHURN-WATCH] |
| Se Valdece mencionar colega advogado | SEÇÃO C (pipeline) | IMEDIATA |
| Após receber DIRETRIZ do Gemini + NotebookLM | SEÇÃO D (reação Pentalateral) | ALTA |
| Dia 3 pós-entrega (Hypercare) | SEÇÃO B (check-in) | NORMAL |
| Dia 14 pós-entrega (Sentinel Report) | SEÇÃO B (ROI visível) | ALTA |
| Dia 30 pós-entrega (abertura janela V2) | SEÇÃO A (briefing pitch V2) | NORMAL |

---

## PROTOCOLO HYPERCARE — 30 DIAS PÓS-ENTREGA

```
Dia 1  pós-entrega: "Dr. Valdece, como foi a primeira busca?" — WhatsApp · máx 2 linhas
Dia 3  pós-entrega: checar uso → se sim, colher testemunho ("o sistema te poupou tempo hoje?")
Dia 7  pós-entrega: Sentinel Report parcial → buscas realizadas + temas mais consultados
Dia 14 pós-entrega: Sentinel Report completo → ROI estimado vs. Google + abertura de escuta
Dia 30 pós-entrega: janela V2 → "Sovereign Upload — seus documentos entrando junto"
```

**Linha de abertura V2 (validada):**
> "Valdece, aquelas decisões que você guarda porque já te salvaram em mais de um caso —
> quando você tiver rodado o que está aqui por umas duas semanas e a gente entender o
> volume real, a próxima evolução é o seu acervo entrando junto. O sistema aprende o seu
> jeito de defender, não só o jeito dos tribunais."

**Nunca pitch V2 antes de 2 semanas de uso real.**

---

## PIPELINE COMERCIAL

| Produto | Valor | Gatilho | Timing |
|---|---|---|---|
| Toga Digital V1 | R$5.000 fixo | Assinatura pendente · presencial | **AGORA** |
| Hypercare 30 dias | Incluso | — | Pós-assinatura |
| V2 — Sovereign Upload + Radar + DOCX | R$8.500–12.000 + R$300/mês opcional | Corpus ≥ 500 docs OU 30 dias de uso ativo | 2026-06-22 |
| Indicação de nicho | Lead qualificado | Valdece mencionar colega criminalista | Qualquer momento pós-satisfação |

**Meta de nicho:** 3 advogados criminalistas = R$15.000 com zero custo de aquisição.

---

*PASSO7 · Projeto Valdece · Loop 6 · Atualizado em 2026-05-23*
*[M-1 a M-5] a preencher após ideias do Músculo · [G] e [N] a preencher após DIRETRIZ + LEDGER*
*Template universal: PENTALATERAL_UNIVERSAL/OPERACAO/PASSO7_EMBAIXADOR_TEMPLATE.md*
