# CAMADA_DECISAO — PROJ-002 INGRID
> **Regra absoluta:** o que o Conselho deliberou formalmente, o que ficou decidido, marcos cronológicos.
> Sem interpretação ("por que decidiu assim" vai para CAMADA_INFERENCIA).
> Sem captura de fala verbatim (essas vão para CAMADA_FATOS).
>
> **Quem mantém:** Embaixador registra; Conselho confirma na próxima ativação.
> **Quem lê:** Auditor (para reconstruir cronologia), Diretor (para visão geral), Estrategista e Músculo (para alinhar próxima rodada).
> **Como ler:** linha do tempo de decisões + protocolos vigentes + estado oficial do projeto.
>
> **Versão:** v1 (refatoração inicial — 2026-05-18) | **Última atualização:** 2026-05-18

---

## ESTADO OFICIAL DO PROJETO

| Campo | Valor oficial |
|---|---|
| Projeto | PROJ-002 — Ferramenta de Estudo Sedes-DF |
| Cliente | Ingrid |
| Loop atual | Loop 3 — Build (Dias 6-8) |
| Camada | 2 — Produto |
| Deadline de entrega | 2026-05-30 |
| Data da prova da cliente | 2026-09-06 |
| Termo de Uso — situação oficial | ASSINADO em 2026-05-18 (PDF com inconsistência de data — pendência de regeração) |
| Gate Dia 2 | APROVADO |
| Gate Dia 5 | APROVADO (2026-05-17) |
| Gate Dia 8 — primeira sessão real da Ingrid | OCORRIDO em 2026-05-18 — feedback positivo + 1 bug reportado |
| Gate Dia 11 | PENDENTE |
| Gate Dia 15 (handoff admin Supabase) | PENDENTE |

---

## DELIBERAÇÕES FORMAIS DO CONSELHO

### 2026-05-15 — Veredito de Aprovação do Build
Diretor aprovou o início do build do PROJ-002 com base no edital_sedes.json e na Skill v1 do NotebookLM. Loop 1 (Kickoff) concluído.

### 2026-05-17 — Aprovação do Gate Dia 5
Feed exibe 7 dias × 20 questões com proporção 70/30 confirmada e 0 erros no `gate_cli_dia5.js`. Loop 2 fechado.

### 2026-05-18 — Síntese Final do Loop 3 (P-037)
Conselho deliberou em síntese final do Loop 3:
- **Número visível na UI:** Pontos Ponderados. Score de Sobrevivência removido (contradiz cláusula 2 do contrato).
- **E-2 (frase de abertura):** dois estados aprovados — cold start de edital e erro recente.
- **E-5 (frase de encerramento):** só exibir se `total_respostas >= 10`.
- **Beacon de abandono:** padrão de 3+ ocorrências por semana, não evento único.
- **TTI de acerto:** marcar `acerto_provavel_chute: true` quando TTI < 10s + acerto.
- **Debug Mode:** ativação por 5 toques no logo (nunca query string, porque Ingrid não é técnica).

### 2026-05-18 — Promoção Formal de Embaixador
Especialista em Formalização (passivo) promovido a Embaixador (mandato ativo, 11 mandatos). Memória persistente entre sessões formalizada como mecanismo do Conselho.

### 2026-05-18 — Ingrid Designada como Piloto do Multiplicador Comportamental do GUT Score
A partir do Loop 3, o Embaixador fornece a TEMPERATURA_CLIENTE ao Músculo antes de qualquer priorização de dívidas técnicas. Urgência técnica é rebaixada se TEMPERATURA contradisser.

### 2026-05-18 — Aprovação de Refatoração da MEMORIA em 3 Camadas
Diretor aprovou em 2026-05-18 a refatoração da MEMORIA_EMBAIXADOR em três camadas separadas: CAMADA_FATOS, CAMADA_INFERENCIA, CAMADA_DECISAO. Esta refatoração é a primeira aplicação do princípio P-039 proposto. Embaixador mantém as três camadas; Conselho lê a camada apropriada para cada propósito.

---

## PROTOCOLOS VIGENTES

### Protocolo Gate Dia 8 (executado em 2026-05-18 — adaptado pelo curso natural da conversa)
- Ingrid recebe link do app via WhatsApp.
- Ingrid responde questões reais no PWA.
- Diretor colhe feedback espontâneo.
- Pergunta de lead E-2 será replantada em contato natural posterior — não foi feita na primeira sessão para preservar o sinal emocional positivo.
- Embaixador debriefa após o contato e atualiza as camadas correspondentes.

### Protocolo de bloqueio pré-entrega
Nenhum link de acesso é entregue antes da assinatura do Termo. Cumprido em 2026-05-18.

### Protocolo SHIELD_DE_ESCOPO
A cada pedido ou mensagem da Ingrid, confrontar internamente com o Termo de Uso antes de responder:
- Pedido dentro da Cláusula 1 (escopo) → responder normalmente.
- Pedido fora do escopo → gerar Change-Order + registrar no LOG_CLIENTE.

### Protocolo de Auditoria Contratual (P-026)
Todo documento contratual gerado pelo Embaixador deve ser auditado pelo Auditor (NotebookLM) antes do envio à cliente. Subir o documento como fonte extra no NotebookLM antes do envio.

### Protocolo de 5 Ideias Disruptivas do Embaixador (P-031)
Ao fechar qualquer loop significativo, gerar 5 ideias [E-1 a E-5] para o COMANDO_ESTRATEGISTA.

### Protocolo CONTRATO_STATUS.txt (P-026)
Arquivo `CLIENTES/INGRID/CONTRATO_STATUS.txt` mantido com:
- `[PENDENTE]` enquanto o Termo não estiver assinado.
- `[ASSINADO]` após confirmação de assinatura.

**Status atual:** deve estar `[ASSINADO]` desde 2026-05-18. Verificar com Músculo.

---

## PENDÊNCIAS FORMAIS ABERTAS

| Pendência | Descrição | Responsável | Prazo |
|---|---|---|---|
| **Regeração do PDF do Termo** | PDF original `Termo_Uso_Ingrid_PROJ002_30052026.pdf` tem data 30/05 no corpo; assinatura real foi 18/05. Embaixador aguarda autorização do Diretor para gerar nova versão `Termo_Uso_Ingrid_PROJ002_18052026.pdf`. | Embaixador (geração) + Diretor (autorização e envio) | Aberto desde 2026-05-18 |
| **Correção do bug da questão 18** | ~~Bug de formatação de negrito.~~ **RESOLVIDO** — commit da9887a, deployado em 2026-05-19. | Músculo | **FECHADO 2026-05-19** |
| **Sincronização WIP_BOARD.json** | ~~Campo formalizador.status ainda diz "minuta".~~ **RESOLVIDO** — atualizado para "ASSINADO 2026-05-18" em 2026-05-19. | Músculo | **FECHADO 2026-05-19** |
| **Pergunta E-2 a plantar** | "Você conhece mais alguém prestando concurso esse ano?" não foi feita no primeiro contato. | Diretor | Próximo contato natural |
| **Mensagem de retorno à Ingrid** | Após fix da questão 18, enviar mensagem preparada (Bloco 7 do debrief de 2026-05-18). | Diretor | Após fix |

---

## HISTÓRICO DE ATUALIZAÇÕES DA MEMORIA

| Data | Evento | Quem registrou |
|---|---|---|
| 2026-05-18 | Criação da MEMORIA_EMBAIXADOR — Loop 3 | Embaixador |
| 2026-05-18 | Síntese Final P-037: [E-1 a E-5] + H-1 confirmada + H-2 refutada + H-6 adicionada + Pipeline R$150 + Ativo de dados + temperatura com alerta 2026-05-23 + protocolo Gate Dia 8 + decisões da Síntese | Músculo (P-032) |
| 2026-05-18 | Termo assinado — temperatura AMARELA → VERDE — P-023 resolvido | Músculo (P-032) |
| 2026-05-18 | URL pública ativa: https://subdiretormnmsgm-commits.github.io/vanguard/ | Músculo (P-032) |
| 2026-05-18 | Primeira sessão real da Ingrid — feedback verbatim capturado, H-3 e H-4 refutadas, H-7 nova proposta, temperatura QUENTE | Embaixador |
| 2026-05-18 | Confirmação verbatim do Diretor: Termo assinado em 18/05/2026; inconsistência de data no PDF aberta como pendência formal | Embaixador |
| 2026-05-18 | **Refatoração da MEMORIA em 3 camadas** aprovada pelo Diretor; CAMADA_FATOS, CAMADA_INFERENCIA, CAMADA_DECISAO criadas | Embaixador |

---

## PROTOCOLO DE USO DESTA CAMADA

**Quando registrar aqui:**
- Conselho deliberou formalmente sobre algo (gate aprovado, princípio extraído, decisão de design).
- Marco cronológico relevante ocorreu (assinatura, aprovação, mudança de status).
- Pendência formal foi aberta ou fechada.
- Protocolo entrou em vigor ou foi alterado.

**Quando NÃO registrar aqui:**
- Falas e eventos verbatim → vão para CAMADA_FATOS.
- Análise do impacto de uma decisão → vai para CAMADA_INFERENCIA.
- Hipóteses, padrões inferidos, leituras estratégicas → vão para CAMADA_INFERENCIA.

---

> **Princípio que governa esta camada:**
> Decisão registrada sem análise. Análise vai para a camada de inferência.
> Esta camada é o esqueleto cronológico do projeto — quem audita o processo lê aqui.
