# RUNBOOK — COWORK NICHO DE MERCADO (NICHE_MODELER)
> Tipo: UNIVERSAL_PURO (TIPO 1) — nunca editar fora de PENTALATERAL_UNIVERSAL/
> Criado: 2026-06-13 · Originado em: Loop 33 NICHE_MODELER Vanguard
> Parabéns registrados pelo Diretor: "foi muito bem executada. Quero que sempre seja assim"
> Aplicável a: todo loop que inclua modelagem ou atualização de nichos de mercado

---

## VISÃO GERAL DO FLUXO

```
[MÚSCULO]          [GEMINI ADVANCED]     [NOTEBOOKLM]      [EMBAIXADOR]
Cowork Setup   →   Skill gemini-penta  →  Auditor          →  Consulta
PASSO3 escrito     Acesso remoto          Skill validada       CONFIRMA/
no disco           Gemini responde        Skill instalada      EXPANDE/
                   Resposta processada                         ALERTA
                   MODEL JSONs atualizados
                   NICHE_INDEX atualizado
                                    ↓
                   [MÚSCULO] Síntese P-037 → ESTRATEGIA_CANAIS → MEMORIA + RELATORIO
```

**Princípio de separação (P-124):** Gemini Advanced = motor diferente do Antigravity/Claude.
Toda saída do Gemini vai para PENDING_REVIEW antes de qualquer ação. Câmara de eco proibida.

---

## FASE 1 — COWORK SETUP (Músculo executa)

**Objetivo:** Preparar todos os artefatos que o Gemini precisará para a sessão de NICHE_MODELER.

### 1.1 Verificar pré-condições
```powershell
# Confirmar que o loop atual está na fase correta
# WIP_BOARD.json → loop_fase_atual.gemini deve ser "PENDENTE"
# NICHE_INDEX.json → verificar última versão e itens marcados para revisão
```

### 1.2 Atualizar CONTEXTO_GEMINI.md
```powershell
.\scripts\gemini_anchor_generator.ps1
# Gera CLIENTES\[CLIENTE]\CONTEXTO_GEMINI.md com:
# - INTELLIGENCE_LEDGER tail (últimos princípios)
# - WIP_BOARD estado atual
# - MEMORIA do loop anterior
# - Princípios P-124 / P-033 ativos
```

### 1.3 Escrever PASSO3_GEMINI.md no disco (P-090 — OBRIGATÓRIO)
O conteúdo NUNCA é escrito apenas no chat. Usar Write tool para gravar em:
`CLIENTES\[CLIENTE]\PASSO3_GEMINI.md`

**Estrutura obrigatória do PASSO3 para NICHE_MODELER:**
```markdown
## MISSÃO: NICHE_MODELER
Analisar e atualizar os nichos em NICHE_INDEX.json com base em:
- Dados regulatórios mais recentes (F1, F3, F11 do Cowork)
- Critérios: dor_clara / solucao_diferenciada / concorrencia_baixa / ticket_viavel / recorrencia
- Identificar novos nichos não mapeados com urgência regulatória

## NICHOS ATUAIS (para análise)
[colar tabela resumida do NICHE_INDEX.json]

## O QUE ENTREGAR
- Para cada nicho: confirmar/atualizar fit_score + urgencia_regulatoria + alerta_timing
- Identificar nichos novos: id, nome, vertical, keywords, fit_score justificado
- [G-1 a G-5]: 5 ideias disruptivas para o loop

## CONTEXTO DO SISTEMA
[colar trecho do CONTEXTO_GEMINI.md]
```

**Gate de proteção:** `gemini_anchor_generator.ps1` bloqueia (exit 1) se detectar `[MUSCULO:` no arquivo.

### 1.4 Verificar que os 3 arquivos de leitura estão prontos para o Gemini
O Gemini recebe (na ordem):
1. `MEMORIA_V[N-1]_[cliente].md` — contexto técnico do loop anterior
2. `relatorio_evolutivo_V[N-1]_[cliente].md` — análise de negócio + M-1..M-5
3. `PASSO3_GEMINI.md` — missão do loop atual (já escrita no disco)

---

## FASE 2 — INVOCAÇÃO DA SKILL gemini-pentalateral

**Objetivo:** Abrir o Gemini Advanced via browser automation (acesso remoto) e posicionar os artefatos.

### 2.1 Invocar a skill
```
/gemini-pentalateral
```
A skill `gemini-pentalateral` (`.claude/skills/gemini-pentalateral.md`) faz:
- Abre browser via Playwright
- Navega para Gemini Advanced (conta correta)
- Prepara o contexto para o Diretor colar os artefatos

**Atenção P-124:** o Gemini Advanced é um motor DIFERENTE do Antigravity/Claude.
Essa diferença é o valor — triangulação cega. Nunca usar Claude para gerar a DIRETRIZ do Gemini.

### 2.2 O que a skill verifica antes de abrir
- [ ] `PASSO3_GEMINI.md` existe e não contém `[MUSCULO:` (placeholder detectado)
- [ ] `CONTEXTO_GEMINI.md` foi gerado nesta sessão (timestamp < 2h)
- [ ] Loop anterior tem MEMORIA + RELATORIO em disco (P-045)

---

## FASE 3 — AÇÕES NO ACESSO REMOTO (Playwright)

**Objetivo:** O Músculo opera o browser para levar os artefatos ao Gemini sem intervenção manual do Diretor.

### 3.1 Sequência de ações no browser
```
1. browser_navigate → gemini.google.com/app (conta correta verificada)
2. browser_snapshot → confirmar que está na sessão certa / sem conversa residual
3. browser_new_conversation → limpar contexto anterior
4. browser_file_upload ou browser_fill_form → anexar MEMORIA + RELATORIO como arquivos
5. browser_type → colar conteúdo do PASSO3_GEMINI.md
6. browser_click → enviar
7. browser_wait_for → aguardar resposta completa (pode levar 30-120s em NICHE_MODELER)
8. browser_snapshot → capturar resposta completa
```

### 3.2 Regras do acesso remoto
- **Nunca fechar o browser antes de capturar a resposta completa**
- Se resposta vier truncada → `browser_scroll_down` + novo snapshot
- Se Gemini pedir confirmação → `browser_click` no botão correspondente
- **Nunca colar output parcial no disco** — aguardar resposta completa antes de processar

### 3.3 Extrair a resposta
Após snapshot completo:
- Identificar blocos: [G-1 a G-5] (ideias) + NICHE_INDEX updates + MODEL JSON updates
- Copiar para `PENDING_REVIEW.md` (P-124 — obrigatório antes de qualquer ação)
- Formato: `## GEMINI_RAW_[DATA] — NICHE_MODELER Loop N`

---

## FASE 4 — IDA AO GEMINI E O CAMINHO DAS RESPOSTAS

**Objetivo:** Processar a resposta bruta do Gemini com integridade e P-124.

### 4.1 Processar PENDING_REVIEW.md
```
1. Ler PENDING_REVIEW.md completo
2. Para cada item:
   a. É update de MODEL JSON? → aplicar ao arquivo correspondente
   b. É nicho novo? → criar MODEL JSON novo em NICHE_MODELS/
   c. É update de fit_score? → atualizar NICHE_INDEX.json
   d. É [G-X] ideia disruptiva? → registrar para síntese P-037
   e. É ALERTA de urgência? → adicionar ao PENDENTES.md se prazo < 30 dias
3. Limpar PENDING_REVIEW.md após processamento completo
```

### 4.2 Atualizar NICHE_INDEX.json
```powershell
# Regras de atualização:
# - Nunca rebaixar fit_score sem evidência do Gemini
# - status MOVER_AGORA: só para nichos com urgência_regulatoria CRITICA ou ALTA + prazo < 60 dias
# - status MONITORAR: fit alto mas sem pipeline ativo ou prazo distante
# - Atualizar _meta.versao (ex: 1.1 → 1.2) e ultima_atualizacao
# - Atualizar resumo: MOVER_AGORA + MONITORAR + lista_monitorar
```

### 4.3 Atualizar MODEL JSONs
Para cada nicho com update do Gemini:
```
NICHE_MODELS/[id]_MODEL.json → campos a verificar:
- urgencia_regulatoria (CRITICA / ALTA / MEDIA / BAIXA / ESTRUTURAL)
- alerta_timing (prazo específico se houver)
- fit_score_criterios (revisar cada sub-critério)
- niche_modeler_l[N]: adicionar nota da sessão atual
```

### 4.4 Validar scripts associados
```powershell
.\scripts\validate_scripts.ps1 -target scripts\niche_alert_router.ps1
# Verificar: encoding, aspas, regex headers, duplicação de lógica
# NUNCA comprometer com script quebrado
```

### 4.5 Atualizar WIP_BOARD.json
```powershell
# loop_fase_atual.gemini → "OK"
# loop_fase_atual.proximo → "NotebookLM — Skill [cliente]-v[N].md"
# Imediatamente após confirmar output processado (P-027)
```

---

## FASE 5 — CONSOLIDAÇÃO (NotebookLM + Embaixador)

**Objetivo:** Validar o output do Gemini com os outros dois sócios antes da síntese.

### 5.1 NotebookLM — Skill do Auditor
```powershell
.\scripts\preparar_notebooklm_projeto.ps1 -cliente [NOME]
# Monta CLIENTES/[NOME]/NOTEBOOKLM_FONTES/ com fontes atualizadas
# Incluir: NICHE_INDEX.json atualizado + MODEL JSONs novos como fontes adicionais
```

Colar PASSO5_NOTEBOOKLM.md ao Auditor. Aguardar Skill com 4 partes obrigatórias.

```powershell
.\scripts\skill_parser_gate.ps1 -skill ".claude\skills\[cliente]-v[N].md"
# APROVADO → instalar
# REJEITADO → solicitar Auditor completar as partes faltantes
```

### 5.2 Embaixador — Validação comportamental
```powershell
.\scripts\ir_ao_embaixador.ps1 -cliente [NOME]
# Se comunicação direta (não loop padrão):
.\scripts\ir_ao_embaixador.ps1 -cliente [NOME] -OrdemDiretor  # P-154
```

PASSO7 deve incluir:
- Os nichos identificados pelo Gemini (quais o Embaixador CONFIRMA / EXPANDE / ALERTA)
- Pergunta específica: "Este nicho é compatível com o perfil do Diretor como vendedor?"
- Alertas de churn de clientes ativos (sempre verificar antes de focar em novos nichos)

---

## FASE 6 — TRABALHO DA RESPOSTA EMANADA (Músculo síntese)

**Objetivo:** Transformar 25 inputs (M+G+N+E) em 1 plano executável.

### 6.1 Síntese P-037
Deliberar cada ideia de cada sócio com 7 pontos:
1. O que está certo
2. Onde diverge
3. DECISÃO (ENTRA AGORA / V2 / BACKLOG / DESCARTADO)
4. Enhancement
5. Custo real
6. Impacto comercial
7. Próxima ação

**Nunca pular para plano consolidado sem mostrar cada ideia.**

```
Criar: CLIENTES/[CLIENTE]/HISTORICO/DELIBERACAO_LOOP_V[N]_[cliente].md
```

### 6.2 Atualizar NICHE_INDEX pós-deliberação (se Embaixador alertar)
Exemplo Loop 33: Embaixador recomendou rebaixar 8/11 nichos para MONITORAR.
Aplicar após deliberação — nunca antes.

```powershell
# Gate E-4 embutido na estratégia:
# status MONITORAR: "aguarda pipeline ativo (Gate E-4 confirmado)"
# Próximo nicho só ativa após 1 conversa real no nicho âncora
```

### 6.3 Criar documento estratégico de saída
Para sessões NICHE_MODELER, o artefato de saída é:
`CLIENTES/[CLIENTE]/ESTRATEGIA_CANAIS_[CLIENTE].md` (ou equivalente)

Estrutura mínima (7 campos por nicho âncora):
| Campo | Descrição |
|-------|-----------|
| NICHO | id + nome do nicho |
| CANAL_ATIVO | canal em operação agora |
| COPY_DISPONIVEL | sim/não + path para as mensagens |
| CONVERSAS_REAIS | contador Gate E-4 |
| CANAL_PENDENTE | próximo canal (bloqueado por E-4) |
| DEADLINE | prazo regulatório crítico |
| PROXIMO_CHECK | data da próxima revisão |

### 6.4 Atualizar todos os metadados
```powershell
# WIP_BOARD.json:
# - loop_fase_atual.musculo → "OK"
# - loop_fase_atual.proximo → próximo passo real
# - atualizado_em → hoje

# MEMORIA_EMBAIXADOR:
# - Adicionar entrada no LOG com resumo da sessão (P-032)

# LOOP_STATE.json (se cliente tiver):
# - Adicionar entrada niche_modeler_l[N] com status + commit + entregues
```

### 6.5 P-033 Sync obrigatório
```powershell
.\.claude\skills\files\sync_vanguard_docs.ps1
# INTEGRIDADE VERDE = zero falhas. AMARELO = verificar órfãos.
```

---

## FASE 7 — FECHAMENTO DO LOOP (P-045)

### 7.1 Criar artefatos obrigatórios
```
CLIENTES/[CLIENTE]/HISTORICO/MEMORIA_V[N]_[cliente].md
CLIENTES/[CLIENTE]/HISTORICO/relatorio_evolutivo_V[N]_[cliente].md
```

**MEMORIA:** contexto técnico completo — o que foi construído, decisões, estado do sistema, pendentes.
**RELATORIO:** SWOT + PDCA + 5W2H + impacto comercial + [M-1 a M-5] para o loop seguinte.

### 7.2 Commit com mensagem estruturada
```bash
git commit -m "docs(l[N]): MEMORIA_V[N] + relatorio_V[N] -- loop [N] fechado (P-045)

[resumo dos artefatos + ideias M-1..M-5 + quem abre o próximo loop]

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

### 7.3 Instrução de Wipe & Sync para o Diretor
```
"Loop [N] encerrado. Execute preparar_notebooklm_projeto.ps1 -cliente [NOME]
e faça Wipe & Sync das fontes antes do próximo ciclo."
```

---

## CHECKLIST RÁPIDO — NICHE_MODELER

```
[ ] FASE 1: CONTEXTO_GEMINI atualizado + PASSO3 escrito no disco
[ ] FASE 2: gemini-pentalateral skill invocada
[ ] FASE 3: browser automation — artefatos entregues ao Gemini
[ ] FASE 4: resposta em PENDING_REVIEW → MODEL JSONs + NICHE_INDEX atualizados
[ ] FASE 5a: NotebookLM — Skill validada e instalada
[ ] FASE 5b: Embaixador — CONFIRMA/EXPANDE/ALERTA recebidos
[ ] FASE 6: Síntese P-037 — 7 pontos por ideia + DELIBERACAO_LOOP criada
[ ] FASE 6: Documento estratégico de saída criado (ESTRATEGIA_CANAIS ou equivalente)
[ ] FASE 6: WIP_BOARD + MEMORIA_EMBAIXADOR + LOOP_STATE atualizados
[ ] FASE 6: P-033 sync rodado
[ ] FASE 7: MEMORIA_V[N] + relatorio_V[N] criados e commitados (P-045)
[ ] FASE 7: Instrução Wipe & Sync passada ao Diretor
```

---

## LIÇÕES DO LOOP 33 (primeira execução deste RUNBOOK)

1. **M-1..M-5 sendo eco do sistema = câmara de eco** (P-149): verificar antes de entregar ao Gemini se as ideias são genuinamente disruptivas ou apenas reorganização do que já existe.

2. **Embaixador detecta o que os outros sócios não veem**: no Loop 33, o Embaixador identificou o padrão builder>vendedor do Diretor ANTES de qualquer sócio técnico — valor diferencial que justifica o protocolo de 3 sócios.

3. **Gate E-4 antes de estratégia de canais**: qualquer sessão que produza NICHE_INDEX deve terminar com um gate claro: qual o critério para o próximo canal. Sem gate, o sistema produz estratégia sem execução.

4. **P-124 é lei no NICHE_MODELER**: usar Gemini Advanced (motor diferente do Antigravity) é o que garante triangulação real. Nunca usar Claude/Antigravity para gerar a DIRETRIZ de nicho.

5. **Acesso remoto via Playwright elimina o transporte manual do Diretor**: o Músculo opera o browser — o Diretor só delibera o resultado. "O Diretor delibera — não transporta" (P-075).

---

*Criado em 2026-06-13 · Músculo · Referência: Loop 33 NICHE_MODELER Vanguard*
*"foi muito bem executada. Quero que sempre seja assim em todas as sessões" — Diretor, 2026-06-13*
