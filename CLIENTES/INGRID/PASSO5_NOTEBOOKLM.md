# PASSO 5 — AUDITOR (NOTEBOOKLM) · PROJETO INGRID · LOOP 3
> Pentalateral IAH — Camada Permanente: não editar blocos de protocolo.
> Atualizado pelo Músculo em 2026-05-18 (Loop 3 / Gate Dia 8)

---

## 📌 ANTES DE IR AO NOTEBOOKLM — checklist obrigatório

```
[x] 1. DIRETRIZ_GEMINI_V4.txt recebida e salva em CLIENTES\INGRID\
[x] 2. Rodar: .\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
[x] 3. Explorer abre automaticamente — Ctrl+A → arrastar TUDO ao NotebookLM
[x] 4. Fazer Wipe & Sync das fontes (apagar antigas antes de subir as novas)
[x] 5. Colar o COMANDO CURTO no chat (não o arquivo inteiro — ele já está nas fontes)
```

> Sem o Wipe & Sync, o Auditor mistura contexto do Loop anterior com o atual.
> Auditor com fontes velhas = Skill que contradiz o que já foi construído.

### 💬 COMANDO CURTO — colar no chat do NotebookLM (Ctrl+V)

```
Auditor, leia o arquivo 13_PASSO5_NOTEBOOKLM.md das fontes carregadas e execute todas as instruções contidas nele.
```

> O arquivo já está nas fontes — não colar o conteúdo inteiro no chat.

---

## 🔍 PROTOCOLO ANTI-ALUCINAÇÃO (ler antes de processar)

Auditor, você opera com 4 deficiências nativas:

| Deficiência | Gatilho de Alerta |
|---|---|
| Amnésia de Contexto | Tratar o projeto como Dia 1 sem MEMORIA |
| Alucinação Estrutural (P-007) | Skill com blocos genéricos sem dados reais do projeto |
| Síndrome do Yes-Man | Validar a DIRETRIZ do Gemini sem questionar |
| Lost-in-the-Middle | Ignorar OVERRIDE recente e aplicar regra V1 |

**Remédio:** "🚨 ALERTA: Auditor alucinou. Gatilho de Calibração ativado."

---

## ⚙️ COMPENSAÇÃO DAS DEFICIÊNCIAS DO MÚSCULO

Ao gerar a Skill, compense ativamente:

1. **Amnésia de Sessão** → listar princípios do LEDGER (P-001 a P-032) que o Músculo deve citar ao deliberar
2. **Momentum de Execução** → gates verificáveis por dia — sem output real = gate inválido
3. **Otimismo de Estimativa** → comparar estimativas com projetos similares; SV preventivo se subestimar
4. **Escopo Silencioso** → listar explicitamente o que NÃO construir neste loop
5. **Drift de Formato** → exigir os 7 pontos de deliberação; sem formato = deliberação rejeitada

---

## 📋 CONTEXTO DO PROJETO

**Projeto:** Ingrid — Ferramenta de Estudo Sedes-DF
**Nicho:** EdTech / Concursos Públicos
**Camada:** 2 — Produto (15 dias)
**Loop:** #3 — Dias 6–8 (Interface + Tutor Socrático + Fallback Fadiga)
**Gates aprovados:** Dia 2 (qualidade das questões) + Dia 5 (feed 70/30, 7 dias, 0 erros)
**Banco de questões:** 460 questões no Supabase — 13 disciplinas Cargo 202
**Próximo gate:** Dia 8 — Ingrid responde 10 questões reais, progresso salvo, fallback testado

**Estado técnico atual (MEMORIA_V2_INGRID.md):**
- Edge Functions gerar-questoes + feed-diario deployadas e validadas
- Arquitetura: 1 Claude call por Edge Function invocação (nunca reverter)
- Recalibração de cargo executada (P-024): Cargo 202, não TDAS área social

**Missão do Auditor neste loop:**
> "Auditor, você recebeu a DIRETRIZ_GEMINI_V4 para o Loop 3 do Projeto Ingrid.
> O Músculo vai deliberar e construir a interface mobile, o Tutor Socrático e o fallback de fadiga.
> Sua missão: auditar a DIRETRIZ cruzando com o histórico real das fontes.
> Identifique: (1) o que contradiz princípios ativos do LEDGER ou decisões já tomadas,
> (2) o que já falhou em projetos anteriores,
> (3) o que o Estrategista está ignorando por otimismo de prazo.
> Não valide por momentum. Discorde quando tiver evidência histórica."

---

## 🎯 MISSÃO CRÍTICA — GERAR A SKILL ingrid-v2.md

**Após processar as fontes e a missão acima, gere a Skill completa em 4 partes obrigatórias.**

O nome exato da Skill: **`ingrid-v2.md`**

O Músculo vai executar `/ingrid-v2` antes de qualquer deliberação do Loop 3.
Skill sem os 4 blocos com dados reais = Skill rejeitada. Músculo não inicia o build sem Skill válida.

---

## 📤 FORMATO OBRIGATÓRIO DA SKILL (4 partes — sem exceção)

```
PARTE 1 — AUDITORIA DE COERÊNCIA
  A DIRETRIZ V4 contradiz algo já construído ou decidido nos Loops 1, 2 ou 3?
  Citar: fonte exata (arquivo, princípio, versão). Sem dado real = bloco inválido.
  Verificar especificamente:
    - Arquitetura de batch (1 Claude call/invocação — nunca reverter)
    - Cargo 202 vs TDAS (P-024 — recalibração obrigatória)
    - Deadline 2026-05-30 (12 dias restantes)
    - Budget $5,00/dia (P-006 — Burn Rate Shield)

PARTE 2 — PERSPECTIVA DO SÓCIO CONSULTOR
  O que funciona em projetos similares (citar projeto + resultado).
  O que falha (citar projeto + razão documentada).
  O que este projeto tem de diferente que muda o padrão.
  O que Gemini e Músculo não estão vendo — discordância fundamentada.

PARTE 3 — A SKILL (em formato ```skill ... ``` copiável para .claude/skills/ingrid-v2.md)
  Incluir obrigatoriamente:
    - Contexto do projeto (cargo, banco, stack, decisões fixadas)
    - Conexão histórica (o que os Loops 1 e 2 provaram)
    - Padrão de sucesso validado (o que funcionou)
    - Padrão de falha documentado (7 panes — ver TROUBLESHOOTING)
    - Perspectiva do Sócio (o que o Auditor vê que os outros não veem)
    - Sequência de build Dias 6-8 com gates verificáveis
    - O que NÃO construir neste loop (com razão objetiva)
    - Alertas ativos (P-006, P-010, P-024, P-025)

PARTE 4 — 5 IDEIAS DISRUPTIVAS DO AUDITOR
  Ideias que NÃO vieram do Gemini nem do Músculo — perspectiva histórica exclusiva.
  Cada uma fundamentada em padrão de projeto anterior ou princípio do LEDGER.
  Formato: o que é + impacto + por que o Músculo não propôs isso.
```

**Validação antes de entregar:**
- [ ] Skill tem nome exato `ingrid-v2.md` declarado na PARTE 3
- [ ] PARTE 1 cita fontes reais (não genéricas)
- [ ] PARTE 4 tem 5 ideias exclusivas do Auditor
- [ ] Skill é copiável diretamente para `.claude/skills/`

---

## 📚 COMO CARREGAR AS FONTES (V25 — pasta única)

```powershell
.\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
```

O script monta `CLIENTES/INGRID/NOTEBOOKLM_FONTES/` e abre o Explorer automaticamente.
Selecionar tudo (Ctrl+A) → arrastar ao NotebookLM → colar o texto deste PASSO5 no chat.

Ordem dos documentos (fatos do passado primeiro — nunca inverter):

```
--- UNIVERSAIS ---
01_SKILL_PROTOCOLO_VANGUARD.md     ← ancora nos padrões do Quadrilateral
02_MEMORANDO_QUADRILATERAL.md      ← constituição e valores
03_MANUAL_DIRETOR.md               ← como Eduardo opera
04_INTELLIGENCE_LEDGER.md          ← princípios ativos P-001 a P-032
05_PROCESSO_EVOLUTIVO.md           ← como o loop funciona
06_TEMPLATES_COMUNICACAO.md        ← formatos obrigatórios
07_WIP_BOARD.txt                   ← estado atual dos projetos (TXT — NotebookLM lê)
08_ANALISE_SOCIO_ATUAL.txt         ← visão de negócio atualizada

--- PROJETO INGRID ---
09_BRIEFING_DISCOVERY.txt          ← dor real da cliente
10_MEMORIA_RECENTE.md              ← MEMORIA_V2_INGRID.md (Loop 2)
11_RELATORIO_EVOLUTIVO.md          ← relatorio_evolutivo_V2_INGRID.md (Loop 2)
12_DIRETRIZ_GEMINI.txt             ← DIRETRIZ_GEMINI_V4 do Gemini ← OBRIGATÓRIO
13_PASSO5_NOTEBOOKLM.md            ← este arquivo (missão do Auditor)
14_SKILL_ANTERIOR.md               ← Skill ingrid-v1.md do Loop 1 (se existir)
15_ALERTA_CONFLITO.md              ← gatilho de calibração
```

> **07_WIP_BOARD.txt** — extensão `.txt` obrigatória. NotebookLM não lê `.json`.
> O script converte automaticamente. Se aparecer `.json`, rodar `atualizar_notebooklm_base.ps1` antes.

