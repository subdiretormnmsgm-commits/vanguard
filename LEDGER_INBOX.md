# LEDGER_INBOX — Buffer de Princípios e Falhas Pendentes
> Arquivo: `LEDGER_INBOX.md` · Raiz do projeto
> Função: buffer oficial para princípios e erros que aguardam autorização P-098 para entrar no INTELLIGENCE_LEDGER.md
> Regra: ao detectar falha ou princípio na sessão → registrar aqui IMEDIATAMENTE, mesmo sem flag P-098.
> Quando autorizado: Músculo move para INTELLIGENCE_LEDGER.md com `[RESOLVE: LEDGER_INBOX-XXX]`.
> Criado: 2026-06-10 · Loop 32 · ATO 6

---

## STATUS: 0 ENTRADAS — P-154/P-155/P-156 movidos para INTELLIGENCE_LEDGER.md · 2026-06-13

---

## [MOVIDOS PARA INTELLIGENCE_LEDGER.md — 2026-06-13]

- **P-154** → adicionado após P-153 · Loop 33 · [RESOLVE: LEDGER-INBOX-P154]
- **P-155** → adicionado após P-154 · Loop 33 · [RESOLVE: LEDGER-INBOX-P155]
- **P-156** → adicionado após P-155 · Loop 33 · [RESOLVE: LEDGER-INBOX-P156]

---

## [ARQUIVO — princípios anteriores que foram movidos em 2026-06-13]

### P-155 — GATE E-4: PROXIMO CANAL SO ABRE APOS ≥1 CONVERSA REAL NO CANAL ATUAL (2026-06-13)

**Regra:** Em estratégia de outreach multi-canal, o próximo canal não abre por calendário — abre por condição: ≥1 conversa real (resposta, reunião, proposta) no canal em curso. Gate estrutural, não meta de tempo.

**Por que:** Sem o gate, o plano de canais vira cronograma: 3 canais abertos com 0 conversas = dispersão de energia do Diretor. Evidência Loop 33: Embaixador identificou que "inbound system para fundador em modo outbound" dispersa. E-4 foi aprovado como lei estrutural e embutido na ESTRATEGIA_CANAIS_VANGUARD.md com campo `gate_e4_status`.

**Como aplicar:** Ao criar ou revisar estratégia de canais → verificar se `gate_e4_status` está preenchido. Próximo canal só entra em ação quando canal atual tem ≥1 log real em `conversas_ativas`. Template: ESTRATEGIA_CANAIS_VANGUARD.md.

---

### P-156 — SESSAO BEM EXECUTADA VIRA RUNBOOK + SKILL COM GATILHO AUTOMATICO (2026-06-13)

**Regra:** Quando o Diretor declara que uma atividade "foi muito bem executada, quero que sempre seja assim", o Músculo cria na mesma sessão: (a) RUNBOOK permanente em `PENTALATERAL_UNIVERSAL/OPERACAO/RUNBOOK_[NOME].md` com todas as fases documentadas, (b) skill em `.claude/skills/[nome].md` com gatilho automático por palavras-chave.

**Por que:** Sem documentação imediata, a excelência fica presa na memória da sessão e se perde. O RUNBOOK garante que o processo possa ser reproduzido por qualquer membro do Conselho em qualquer sessão futura. Evidência Loop 33: RUNBOOK_NICHE_MODELER.md criado com 7 fases + niche-modeler.md com gatilho — processo NICHE_MODELER agora é reproduzível.

**Como aplicar:** Ao detectar "foi muito bem executada" ou "quero que sempre seja assim" → criar RUNBOOK + skill antes de fechar a sessão. O commit de fechamento inclui os dois arquivos.

---

### P-154 — COMUNICACAO DIRETA DO DIRETOR ENTRE SOCIOS NAO REQUER GATE DE DIRETRIZ (2026-06-13)

**Regra:** Quando o Diretor ordena comunicação direta com o Embaixador (ou qualquer sócio) fora do fluxo padrão do loop, o gate de DIRETRIZ no `ir_ao_embaixador.ps1` deve ser contornável via flag `-OrdemDiretor`.

**Por que:** O gate de DIRETRIZ existe para proteger o fluxo padrão Gemini→NotebookLM→Embaixador→Músculo. Ele não se aplica quando o Diretor exerce prerrogativa direta de comunicação entre sócios (ex: consultar o Embaixador sobre estratégia de canal antes de uma decisão). Bloquear este caso é falha arquitetural — a restrição foi aplicada ao contexto errado.

**Diferença crítica:** Loop padrão (gate obrigatório) × Comunicação direta do Diretor (gate ignorado com `-OrdemDiretor`). O Embaixador registra o motivo no LOG.

**Ferramenta construída:** flag `-OrdemDiretor` adicionado ao `ir_ao_embaixador.ps1` (sessão 2026-06-13).

**Evidência:** `ir_ao_embaixador.ps1` bloqueou com "DIRETRIZ_GEMINI_V33.txt não encontrada" quando o Diretor ordenou consulta ao Embaixador sobre estratégia 3 canais NICHE_MODELER — contexto correto, gate errado.

---

---

## [MOVIDOS PARA INTELLIGENCE_LEDGER.md — 2026-06-12]

- **P-149** → adicionado após FALHA-K · [RESOLVE: LEDGER-INBOX-P149]
- **P-150** → adicionado após P-149 · [RESOLVE: LEDGER-INBOX-P150]

Todos os itens do lote Loop 31+32 foram movidos para INTELLIGENCE_LEDGER.md:
- **P-148** → adicionado após P-141
- **P-130-ADDENDUM** → inserido no P-130 existente
- **FALHA-H** (deliberação sem citar texto) → adicionada
- **FALHA-I** (sed sem container) → adicionada
- **FALHA-J** (Cron W-1 1x/dia) → adicionada
- **FALHA-K** (meta-falha: falhas não entraram no LEDGER) → adicionada
- **FALHA-A..G** (Loop 31) → já estavam no LEDGER — sem duplicação

Commit: [RESOLVE: ATO 5] [RESOLVE: LEDGER-INBOX-FALHAS]

---

## COMO USAR ESTE ARQUIVO

1. **Adicionar:** ao detectar falha ou novo princípio → adicionar seção aqui imediatamente
2. **Autorizar:** quando Diretor disser "AUTORIZO SOBRESCREVER INTELLIGENCE_LEDGER.md" → Músculo move os itens
3. **Commit:** `[RESOLVE: LEDGER-INBOX-FALHAS]` fecha o lote
4. **Limpar:** após mover para LEDGER, remover a seção do INBOX
5. **Nunca:** deixar item no INBOX por mais de 3 loops sem mover

---

*LEDGER_INBOX v1.1 · Atualizado 2026-06-11 · Loop 33 · ATO 5 concluído*