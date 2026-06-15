# Loop 34 Vanguard — Plano de Implementação

> **Para executores:** este plano segue o pós-veredito P-037 (D1:A Freeze + D2:A Régua de Risco). Passos usam checkbox (`- [ ]`). Gates Vanguard substituem testes unitários. **Tarefa 3 toca arquivo PROTEGIDO P-098 — não executar sem [VEREDITO-DIRETOR] ou `.musculo_autorizacao.flag`.**

**Goal:** Destravar a publicação do 1º post LinkedIn (nicho ECD, Régua de Risco) e formalizar o Conselho 6→9 (Projetista 7º, Embaixador Digital 8º em Freeze, Detector de Deriva coadjuvante), fechando o Loop 34 pelo gate mecânico E-1.

**Architecture:** Duas frentes. Frente A (PUBLICAR) = reescrita do POST 4 em arquivo, ato de publicação do Diretor — prioridade máxima do eixo "formalizar subordinado a publicar". Frente B (FORMALIZAR) = scaffolding subordinado: edição de CLAUDE.md, DEPENDENCY_MAP e sync universal. O loop só fecha quando o POST está publicado OU com data dura agendada (E-1).

**Stack:** Markdown/JSON Vanguard · PowerShell 5.1 (Write tool + validate_scripts) · gates: verify_gdrive_freshness, propagate_changes, sync_vanguard_docs, skill_parser_gate · WebSearch (verificação factual E-3).

---

## Estrutura de arquivos

| Arquivo | Frente | Responsabilidade | Protegido? |
|---|---|---|---|
| `CLIENTES/VANGUARD/INTENCAO_LINKEDIN.md` | A | POST 4 reescrito em Régua de Risco | Não |
| `CLIENTES/VANGUARD/CLAUDE_PROJECT/ARTEFATO_DE_PROVA_ECD.md` | A | Fontes verificáveis do post (E-3) | Não |
| `CLAUDE.md` | B | Conselho 6→9 + atores formalizados | **SIM (P-098)** |
| `PENTALATERAL_UNIVERSAL/OPERACAO/DEPENDENCY_MAP.json` | B | Registrar docs dos 3 atores | **SIM (P-098)** |
| `.claude/skills/embaixador-passo7-vanguard-v1.md` | B | Corrigir URL projeto 019e4c70→019eab2b (P-146) | **SIM (P-098)** |
| `CLIENTES/VANGUARD/CLAUDE_PROJECT/LOOP_STATE.json` | fechamento | objetivo_loop + estado fase | Não |

---

## FRENTE A — PUBLICAR (prioridade máxima)

### Tarefa 1: Verificar factualmente o registro I157 (E-3 ARTEFATO_DE_PROVA)

**Files:**
- Create: `CLIENTES/VANGUARD/CLAUDE_PROJECT/ARTEFATO_DE_PROVA_ECD.md`

- [ ] **Step 1: Pesquisar o registro I157 da ECD**

Usar WebSearch com query: `registro I157 ECD SPED transferência saldos plano de contas anterior cruzamento ECF`
Objetivo: confirmar (a) o que é o registro I157 na ECD, (b) como se relaciona ao cruzamento com a ECF, (c) o percentual/base de multa correto. NÃO escrever o post antes desta confirmação — o Embaixador já pegou o erro "leiaute 12" (era da ECF). Regra E-3: nenhum fato/número ao ar sem fonte rastreável.

- [ ] **Step 2: Registrar as fontes no ARTEFATO_DE_PROVA**

Escrever em `ARTEFATO_DE_PROVA_ECD.md`: cada afirmação factual do post (prazo 30/06, ano-calendário 2025, multa 0,02%/dia ou 5% s/ valor omitido, registro I157, cruzamento ECF) com a URL/fonte que a sustenta. Marcar qualquer afirmação sem fonte como ⚠️ REMOVER do post.

- [ ] **Step 3: Gate E-3**

Verificar: toda afirmação do rascunho do POST 4 tem entrada correspondente no ARTEFATO_DE_PROVA. Se alguma não tiver fonte → reescrever sem ela ou trocar por fato verificado.
Expected: zero afirmações órfãs.

### Tarefa 2: Reescrever o POST 4 em voz Régua de Risco (D2:A + E-5)

**Files:**
- Modify: `CLIENTES/VANGUARD/INTENCAO_LINKEDIN.md` (seção POST 4)

- [ ] **Step 1: Reescrever o corpo do post**

Substituir o POST 4 atual (corporate-speak: "precisão metodológica", "método analítico rigoroso") por voz de **autodiagnóstico** — o leitor se mede contra uma régua. Estrutura: (1) abertura com a dor datada (30/06, ano-calendário 2025); (2) **1 exemplo I157 concreto e verificado** (E-5) — divergência real no cruzamento ECD×ECF; (3) régua de 3-4 perguntas que o contador responde sozinho; (4) CTA R-3: "fale com nossa equipe técnica" (NUNCA IA/automação/ferramenta).
Restrição: escrever para publicação do **perfil pessoal do Eduardo** (1ª pessoa, People-First), não da Company Page.

- [ ] **Step 2: Atualizar o WhatsApp e a Reversão da seção POST 4**

Manter coerência factual com o ARTEFATO_DE_PROVA (já corrigido: I157, cruzamento ECF). Garantir tom de pessoa, não de corporação.

- [ ] **Step 3: Atualizar metadados da seção**

Mudar cabeçalho do POST 4 para refletir formato "Régua de Risco — perfil pessoal" e status "PRONTO PARA PUBLICAÇÃO (perfil pessoal, antes de 17/06)".

- [ ] **Step 4: Gate R-3 + E-5**

Verificar: (a) zero menção a IA/automação/Claude/ferramenta; (b) há 1 exemplo concreto (não adjetivo); (c) todas as afirmações batem com o ARTEFATO_DE_PROVA.
Expected: 3 verdes.

- [ ] **Step 5: Sync Drive (G2)**

Run: `.\scripts\verify_gdrive_freshness.ps1 -Perfil VANGUARD -AutoSync`
Expected: VERDE.

### Tarefa 3-A: Apresentar o post ao Diretor para publicação

- [ ] **Step 1: Mostrar o texto final no chat**

Colar o POST 4 reescrito completo no chat (não "está no arquivo"). O Diretor copia do chat e publica do perfil pessoal. Este é o ato humano que satisfaz o gate E-1.

---

## FRENTE B — FORMALIZAR (scaffolding subordinado — GATE P-098)

> ⛔ **As Tarefas 4-6 editam arquivos PROTEGIDOS (P-098). Não executar sem [VEREDITO-DIRETOR] explícito ou `.musculo_autorizacao.flag`.** Apresentar o diff ao Diretor antes (P-098 + feedback_p098_mostrar_texto_antes).

### Tarefa 4: Formalizar Conselho 6→9 no CLAUDE.md

**Files:**
- Modify: `CLAUDE.md` (cabeçalho SISTEMA + seção de atores)

- [ ] **Step 1: Mostrar o diff proposto ao Diretor**

Apresentar no chat o texto exato antes/depois: linha `SISTEMA: Pentalateral IAH...` → incluir Projetista (7º), Embaixador Digital (8º, Freeze D1:A), Detector de Deriva (coadjuvante). Aguardar "AUTORIZO SOBRESCREVER" ou [VEREDITO-DIRETOR].

- [ ] **Step 2: Editar CLAUDE.md (somente após veredito)**

Atualizar: (a) linha SISTEMA 6→9; (b) CURRENT_VERSION se aplicável; (c) ÚLTIMA_ATUALIZAÇÃO com P do Loop 34; (d) tabela de atores com os papéis novos e o Freeze do Embaixador Digital (D1:A).

- [ ] **Step 3: Gate — validar não-quebra**

Verificar: nenhuma seção existente removida acidentalmente; numeração de princípios intacta.
Expected: diff só adiciona/edita as linhas dos atores.

### Tarefa 5: Registrar docs dos 3 atores no DEPENDENCY_MAP

**Files:**
- Modify: `PENTALATERAL_UNIVERSAL/OPERACAO/DEPENDENCY_MAP.json`

- [ ] **Step 1: Adicionar entradas (após veredito)**

Registrar os documentos-fonte dos 3 atores com tipo (TIPO 1/2/3) e dependências de cascata.

- [ ] **Step 2: Propagar**

Run: `.\scripts\propagate_changes.ps1`
Expected: "Propagação concluída — N arquivos atualizados".

- [ ] **Step 3: Validar hash**

Verificar integridade VERDE (zero falhas de hash).

### Tarefa 6: Corrigir URL do projeto na skill embaixador-passo7 (P-146)

**Files:**
- Modify: `.claude/skills/embaixador-passo7-vanguard-v1.md`

- [ ] **Step 1: Trocar URL (após veredito)**

`019e4c70` → `019eab2b` (Vanguard Pentalateral IAH). Origem: feedback_drive_first_rclone_gatilhos.

- [ ] **Step 2: Gate**

Verificar: nenhuma outra ocorrência do ID antigo na skill.

---

## FECHAMENTO DO LOOP

### Tarefa 7: Atualizar LOOP_STATE + sync universal

**Files:**
- Modify: `CLIENTES/VANGUARD/CLAUDE_PROJECT/LOOP_STATE.json`

- [ ] **Step 1: Confirmar objetivo_loop registrado (P-160)**

Verificar `objetivo_loop` preenchido; atualizar `loop_fase_atual` → síntese OK, próximo = "publicar POST ECD".

- [ ] **Step 2: Sync universal (P-033) — se Frente B executada**

Run: `.\.claude\skills\files\sync_vanguard_docs.ps1`
Expected: INTEGRIDADE VERDE.

### Tarefa 8: Gate mecânico E-1 + commit

- [ ] **Step 1: Verificar gate E-1**

O Loop 34 só fecha se: POST ECD **publicado** (confirmado pelo Diretor) OU **data dura** agendada para publicação. Sem um dos dois → loop NÃO fecha; manter alerta PF-1.

- [ ] **Step 2: Commit (somente com [VEREDITO-DIRETOR])**

```
git add CLIENTES/VANGUARD/ CLAUDE.md PENTALATERAL_UNIVERSAL/ .claude/skills/ docs/
git commit -m "feat(loop34): Conselho 6->9 + presenca LinkedIn ECD -- D1:A Freeze + D2:A Regua de Risco [VEREDITO-DIRETOR] [RESOLVE: loop34]"
```

- [ ] **Step 3: Ritual de fechamento**

`session_close.ps1` no fim da sessão (somente com ordem explícita do Diretor — fechamento é prerrogativa dele).

---

## Self-Review

- **Cobertura do spec:** (1) reescrita POST ECD → Tarefas 1-2; (2) formalização 3 atores → Tarefas 4-6; gate P-098 explícito; gate E-1 → Tarefa 8. ✅
- **Placeholders:** o conteúdo factual do I157 é deliberadamente deixado para verificação na Tarefa 1 (E-3) — não é placeholder, é o guarda-rail anti-erro. ✅
- **Consistência:** nomes de scripts e gates batem com os usados na sessão (verify_gdrive_freshness, propagate_changes, sync_vanguard_docs). ✅
- **Ordem:** Frente A (reversível, autônoma) antes da Frente B (protegida, requer veredito). ✅
