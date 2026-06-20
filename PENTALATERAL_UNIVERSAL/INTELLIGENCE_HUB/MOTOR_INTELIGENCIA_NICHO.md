# MOTOR DE INTELIGÊNCIA DE NICHO — VANGUARD

> Arquitetura confirmada pelo Diretor em 2026-06-16.
> Este é o organograma vivo da cadeia de prospecção da Vanguard: das engrenagens (tarefas
> agendadas do Cowork) até o fechamento do negócio pelo Diretor.

---

## CONCEITO

As **tarefas agendadas do Cowork são as engrenagens** do motor. Elas rodam por calendário
(M1–M7, F-series, P-series) — por isso o motor nunca para e **sempre gera produto Vanguard**.
O produto que sai é a **nossa inteligência de nicho de mercado**.

Princípio fundador em forma de arquitetura: **o sistema gera, o Diretor delibera.**

---

## ORGANOGRAMA

```
   ENGRENAGENS — TAREFAS AGENDADAS DO COWORK
      (rodam por CALENDÁRIO — M1–M7 / F-series / P-series)
      motor perpétuo · nunca para · sempre gera produto
                          |
                          v
                    INBOX_COWORK
                          |
                          v   <- MÚSCULO se alimenta (início do processo)
                  ANÁLISE DO MÚSCULO  (base)
                          |
                          v
   EXECUTOR COWORK --robustece-->  ENTREGA DO COWORK = PRODUTO VANGUARD
                                    ( = INTELIGÊNCIA DE NICHO DE MERCADO )
                                              |
                          M-STATS (skill market-stats-analysis)
                       camada analítica fria: TAM/SAM/SOM ±15% + IC
                       (mensal dia 1 + sob demanda · -> PENDING_REVIEW)
                                              |
                      +-----------------------+---------------+
                      v                                       v
                 PROJETISTA                          EMBAIXADOR DIGITAL
            (PLANOS + CAMPANHA)              consome a ENTREGA DO COWORK
                      |                          + os PRODUTOS do Projetista
                      +--------------->---------------+
                                              |
                                              v
                                   PROSPECÇÃO DA VANGUARD
                                              |
        +------------------------ DIRETOR (Eduardo) ------------------------+
        |  ÚNICO nó humano — tudo converge para ele e parte dele:           |
        |   - ORIGINA a estratégia / o objetivo do ciclo (P-160)           |
        |   - dá o VEREDITO sobre cada produto (via PENDING_REVIEW · P-124) |
        |   - recebe o BRIEFING de abordagem (futuro "Diretor Vanguard")   |
        |   - EXECUTA a abordagem final ao cliente, munido pelo Digital     |
        +-------------------------------------------------------------------+
                                              |
                                              v   resultado real da prospecção
                        CALIBRAÇÃO  (CALIBRACAO.md / Biblioteca de Nichos)
                                              |
                                              +--> realimenta as ENGRENAGENS

   (MÚSCULO = portão de governança em todo caminho de escrita · P-124)
```

---

## OS NÓS

### Engrenagens — tarefas agendadas do Cowork
Rodam por calendário. São a fonte perpétua. Cada task tem sua `SKILL.md` (em
`C:\Users\Eduardo DELL\Claude\Scheduled\[task-id]\SKILL.md`) — o roteiro que o **Cowork Agentado**
(renomeado de "Embaixador Agentado" em 2026-06-20 — para não confundir com o Embaixador Digital)
executa para fazer a pesquisa daquela frente. O Músculo lê essas skills, nunca edita
(igual à `cowork-engine-v1`).

### Músculo
Se alimenta do INBOX_COWORK no início do processo. Sua análise é a **base** que o Executor Cowork
robustece. No caminho do produto, o Músculo é **portão de governança**, não autor: revisa via
PENDING_REVIEW, e grava no acervo **somente após o veredito do Diretor** (P-124 — escrita única).

### Executor Cowork
Robustece a análise do Músculo. O que sai dele — a **entrega do Cowork** — é o **PRODUTO VANGUARD**.
Não é "sinal bruto": é o entregável de inteligência de nicho.

### M-STATS — camada analítica fria (engrenagem transversal)
Órgão de rigor quantitativo do motor, encarnado na skill **`market-stats-analysis`** (`.claude/skills/`).
Não é nicho-específico — é transversal. Roda **mensal (dia 1, junto do NICHE_MODELER) + sob demanda**.
Pega o produto Vanguard (Cartão de Nicho) e devolve **número defensável**: market sizing TAM/SAM/SOM
por dupla-via (±15%), tendência com intervalo de confiança, atributos priorizados (MaxDiff→Conjoint).
Quem usa: **Músculo** (análise base) + **Executor Cowork** (robustece). Saída → `PENDING_REVIEW`
(P-124). Produz só a camada fria (número + incerteza + fonte); **não** escreve discurso de venda —
isso é handoff ao Projetista (R-3). Gate de honestidade: N insuficiente → "INCONCLUSIVO", nunca fabrica.

### Projetista
Consome o produto Vanguard **+ a camada M-STATS** e gera **PLANOS + CAMPANHA** (entrega no chat ao
Diretor; o Músculo grava em `PROJETISTA/PLANOS` e `/CAMPANHA` após veredito). É quem traduz o número
frio do M-STATS em linguagem de prospecção blindada (R-3).

### Embaixador Digital
Alimentação **dupla**: consome a **entrega do Cowork** E os **produtos do Projetista**. Com isso,
**prospecta a Vanguard** nos canais externos (LinkedIn / Instagram / WhatsApp), sempre com
linguagem blindada (R-3 — "especialistas da Vanguard", nunca IA/ferramentas).

### Diretor (Eduardo) — único nó humano
Tudo converge para ele e parte dele:
1. **Originador** — define o objetivo do ciclo (P-160). Sem ele, o motor roda sem direção.
2. **Veredito** — nenhum produto vira ativo sem sua aprovação (P-124).
3. **Destinatário do briefing** — o futuro "Diretor Vanguard" existe para prepará-lo.
4. **Executor final** — quem fecha negócio é o Diretor, munido pelo Embaixador Digital.

Síntese: **a máquina prospecta; o Diretor converte.**

---

## PROTOCOLO DE EXECUÇÃO M-STATS — DOIS PASSOS + CALIBRAÇÃO

> Confirmado pelo Diretor em 2026-06-17. A skill `market-stats-analysis` tem **dois usuários em
> momentos distintos** (skill linha 14). Aqui cada um vira um **passo operacional separado**, com
> gatilho, ação e output próprios — para o motor saber QUANDO e COMO cada um roda, em vez de fundir
> os dois numa frase. O 3º elemento (CALIBRAÇÃO) é a seta que fecha o ciclo.

### PASSO M-STATS-1 — MÚSCULO (análise BASE)
- **Quem:** o Músculo (Claude Code), via skill `market-stats-analysis`.
- **Gatilho:** ao processar o `INBOX_COWORK` (gate 0B de colheita) com um produto de nicho / Cartão
  novo ou atualizado que assere um número de mercado. É reflexo por ação (P-180), não agenda fixa.
- **Ação:** declara o regime de dados (A estruturado / B esparso — gate de entrada da skill); roda o
  **market sizing base** (TAM/SAM/SOM pela(s) via(s) que o dado permite); aplica o **gate de honestidade
  N pequeno** (N insuficiente → "INCONCLUSIVO — N=x", nunca fabrica). Linguagem fria; fonte + data + N
  sempre (P-132).
- **Output:** parecer **M-STATS BASE** anexado ao Cartão → `PENDING_REVIEW.md` (AGUARDANDO_VEREDITO, P-124).
- **Propagação:** G2 (rclone) após gravar — o parecer precisa existir no Drive para o Executor e o Projetista.

### PASSO M-STATS-2 — EXECUTOR COWORK (ROBUSTECE)
- **Quem:** o **Antigravity no papel EXECUTOR** (P-163: "executa o que foi definido, lê do disco/Drive").
  É o EXECUTOR que **roda a skill `market-stats-analysis`** sobre a BASE. **NÃO** é uma task agendada do
  Cowork Agentado (confirmado pelo Diretor 2026-06-17): o "agendado" do calendário é só **disparo/lembrete**
  mensal — a execução real é o EXECUTOR lendo a BASE do `PENDING_REVIEW`/Drive, robustecendo e gravando de volta.
- **Gatilho:** **disparo mensal** (dia 1, junto do NICHE_MODELER — apenas lembra que é hora de robustecer)
  **OU sob demanda** — quem aciona é o **Projetista** (Ação 3 do template Projetista v5.1); ao receber a
  encomenda, o **Músculo prepara o COMANDO EXECUTOR** (`ir_ao_antigravity.ps1 -papel EXECUTOR`). Respeita o
  GATE DE DATA do calendário só no disparo mensal; sob demanda é estado-dependente, não data-dependente.
- **Ação:** pega o parecer **BASE** do Passo 1 e o **robustece** — fecha a convergência **±15%**
  (top-down × bottom-up), completa os métodos que o N agora permite (MaxDiff → Conjoint, regressão/ARIMA
  com diagnóstico de resíduos), e **alarga o IC pelo horizonte** (previsão distante nunca como ponto firme).
- **Output:** parecer **M-STATS ROBUSTECIDO** → `PENDING_REVIEW.md` (atualiza o BASE, P-124) → **handoff
  ao Projetista** (R-3 — camada fria recebida, traduzida em PLANOS/CAMPANHA com linguagem blindada).
- **Propagação:** G2 (rclone) obrigatório — sem isso o Projetista (Claude Project no Drive) lê a versão velha.
- **⚠️ DIFERENTE DAS ATIVIDADES COWORK USUAIS (Diretor 2026-06-17):** as tarefas Cowork normais (M1–M7,
  F-series) são **pesquisa de mercado upstream** — geram sinal bruto que cai no `INBOX_COWORK`, e o Músculo
  **colhe** (gate 0B). O M-STATS-2 **não é pesquisa nova e não escreve no `INBOX_COWORK`**: ele é **downstream**,
  opera sobre o parecer **BASE** que o Músculo já depositou no `PENDING_REVIEW`, robustece com método estatístico
  e devolve ao **próprio `PENDING_REVIEW`** (não há "colheita" pelo Músculo). Por isso **não segue o mapa de
  colheita do calendário** nem é colhido como M1–M7 — é uma engrenagem **analítica transversal**, não uma frente
  de coleta. O que o calendário agenda é apenas o **disparo mensal** (dia 1); o resto é sob demanda do Projetista.

### 3º ELEMENTO — CALIBRAÇÃO (fecha o ciclo)
- **Onde:** `CALIBRACAO.md` (Biblioteca de Nichos).
- **O que:** o **resultado real da prospecção** (respondeu? marcou reunião? virou cliente?) volta ao
  `CALIBRACAO.md` e reajusta o score/parâmetros dos nichos. Efeito: na próxima rodada, os Passos 1 e 2
  partem de parâmetros calibrados e as engrenagens priorizam os nichos que de fato convertem.
- **Hoje:** em `[AGUARDA-CAMPO]` (0 clientes) — a fonte da calibração é exatamente esse retorno de campo.

> **Fronteira de papéis (não confundir):** o Músculo produz a BASE e é **portão de governança** (P-124);
> o Executor **robustece** e gera o PRODUTO; nenhum dos dois escreve discurso de venda — isso é do
> Projetista (R-3). M-STATS é **execução interna do motor**, NÃO ativação manual do Diretor → **não entra
> no W-11** (confirmado 2026-06-16).

### ALERTA NO TERMINAL — duas vias (Diretor 2026-06-17: "é sempre bom conferir")
Toda atividade Cowork já é alertada no terminal na abertura (gate 0C, `cowork_calendar.ps1` no session_start).
O M-STATS, por ser **diferente do Cowork usual** (transversal, não colhido por data), precisa de **duas vias**:
1. **Alerta por DATA (disparo):** `cowork_calendar.ps1` já lista o M-STATS no bloco **Mensal** quando é dia 1
   — cobre o disparo/lembrete mensal. Confirmado em código (linha do `fMensal`).
2. **Alerta por ESTADO (conferir):** check de pé que varre o `PENDING_REVIEW.md` por parecer **M-STATS BASE**
   com a keyword `AGUARDANDO_ROBUSTECER` e o lista no terminal **toda sessão, independente da data**. É o que
   garante que um Passo 1 (BASE) não fique esquecido sem o Passo 2 (robustecer) — fecha o P-146 da via de estado.
   O Passo 1 marca a entrada com a tag `[M-STATS-BASE AGUARDANDO_ROBUSTECER]`; quando o EXECUTOR robustece,
   troca para `ROBUSTECIDO`, e o alerta some sozinho.

---

## LOOP DE CALIBRAÇÃO (a seta que fecha o ciclo)

Hoje o motor *gera*, mas ainda não *aprende*. O resultado real de cada prospecção (respondeu?
marcou reunião? virou cliente?) deve voltar ao `CALIBRACAO.md` e reajustar o score dos nichos.
Efeito: as engrenagens passam a **priorizar os nichos que de fato convertem** — o motor fica mais
inteligente a cada giro do calendário, não só mais produtivo.

Isso dá fonte à task de retroalimentação do Projetista (P-T5), hoje em `[AGUARDA-CAMPO]` por
termos 0 clientes: a fonte dela é exatamente esse retorno de prospecção.

**Heartbeat do motor:** como as engrenagens rodam por calendário, mede-se "produtos Vanguard
gerados por semana". Cair a zero = engrenagem travada.

---

## CAMADA DE SINCRONIZAÇÃO — rclone / DRIVE-FIRST (crítica)

Os atores que consomem os produtos — **Embaixador Digital, Projetista e o futuro Diretor Vanguard**
— vivem no Claude Projects e **leem do Google Drive**, não do OneDrive. O OneDrive é a fonte
canônica (onde o Músculo grava); o Drive é o espelho que os atores enxergam.

Consequência: **o rclone é engrenagem crítica do motor**. Um produto gravado no OneDrive que não
foi propagado ao Drive **não existe para os atores** — eles leem a versão velha, e a prospecção
sai desatualizada.

Regra operacional (gatilhos rclone — P-169):
- **G2 obrigatório:** após gravar/editar qualquer arquivo que um ator remoto lê
  (MOTOR, PROJETISTA/PLANOS, PROJETISTA/CAMPANHA, EMBAIXADOR_DIGITAL/*, Biblioteca de Nichos,
  Cartões), **propagar imediatamente ao Drive via rclone**.
- O rclone preserva mtime — a verificação de frescura é sempre por **data+hora/hash** (P-168).
- Comando de propagação:
  `rclone copy "PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/<sub>" "gdrive:vanguard/PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/<sub>" --create-empty-src-dirs`

Sem essa camada, o organograma acima quebra no momento exato em que o produto deixa o Músculo e
deveria chegar ao ator. O rclone é o que mantém "sempre gera produto" valendo também como
"sempre entrega produto atualizado".

---

## CAMINHO MAPEADO — "DIRETOR VANGUARD" (intenção futura, não implementado)

Camada de **briefing de abordagem** entre os produtos do motor e o Diretor. Ancorado no Claude
Projects + NotebookLM do nicho. Instrui o Diretor sobre como abordar o cliente e dominar o assunto
antes da prospecção.

ENTRADAS: Cartões de Nicho · Produtos do Projetista · NotebookLM do nicho · Entregas do Embaixador
Digital · CALIBRACAO/histórico.
SAÍDAS: briefing de abordagem · dossiê do assunto · roteiro de reunião · antecipação de objeções.
Posição: antessala entre PRODUTOS do motor e o DIRETOR.
Síntese: o Embaixador Digital prospecta/atrai; o Diretor Vanguard instrui o Diretor; o Diretor fecha.

> Registrado para retomada quando o Diretor reabrir o tema. Nada criado nesta data.
