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
`C:\Users\Eduardo DELL\Claude\Scheduled\[task-id]\SKILL.md`) — o roteiro que o **Embaixador
Agentado** executa para fazer a pesquisa daquela frente. O Músculo lê essas skills, nunca edita
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
