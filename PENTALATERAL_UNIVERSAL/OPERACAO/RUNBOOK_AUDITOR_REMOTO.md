# RUNBOOK — ACESSO REMOTO AO AUDITOR (NOTEBOOKLM)
# Versão: 2.0 | Criado: 2026-06-09 | Atualizado: 2026-06-09
# Mandatório por instrução do Diretor — aplicável a TODO loop de todo cliente
#
# v2.0 — YT-ENRICHMENT (PASSO 2.5) + ARTEFATOS RICOS (PASSO 10)
# Objetivo: Auditor com banco de dados rico em fontes de qualidade
#           + saídas que vão além da Skill: relatório, mapa mental, podcast

---

## CONTEXTO

O Músculo acessa o Auditor (NotebookLM) remotamente via `notebooklm-py` CLI ou,
em caso de falha de autenticação, via Playwright (MCP plugin).

**Caderno VANGUARD:**
- ID: `d7dab0e1-8844-4697-bdec-d67a150d6502`
- Conta: `subdiretor.mnmsgm@gmail.com`
- Título: "Vanguard Tech — Conselho V29 🎼"

**Princípio fundador (instrução do Diretor 2026-06-09):**
> "Banco de dados grande e com qualidade facilita 4 LLMs para resultados inimagináveis."
> O Auditor deve ter o banco mais rico possível — fontes internas + fontes externas de qualidade.
> YT-SEARCH alimenta o banco com conteúdo de canais especializados via transcrição automática.
> Após a Skill, o Auditor não encerra — gera relatório, mapa mental e podcast do loop.

---

## PROBLEMA CONHECIDO

- CLI `notebooklm-py` usa cookie `SIDTS` que expira periodicamente
- Python 3.13+ não instala `rookiepy` (dependência de auto-refresh)
- Solução definitiva: `! notebooklm login` (interativo, requer Diretor no terminal)
- Solução imediata: Playwright fallback (skill `notebooklm-pentalateral-v2.md`)

---

## PASSO A PASSO OBRIGATÓRIO (executar nesta ordem)

---

### PASSO 1 — Verificar autenticação CLI

```powershell
notebooklm auth check --test --json
```
- Se `"token_fetch": true` → CLI funcionando → seguir fluxo CLI
- Se `"token_fetch": false` ou erro → ir para PASSO 2 (Playwright fallback)

---

### PASSO 2 (fallback) — Ativar Playwright

Usar MCP Playwright plugin. Navegar para:
```
https://notebooklm.google.com/notebook/d7dab0e1-8844-4697-bdec-d67a150d6502
```
Verificar conta logada: deve ser `subdiretor.mnmsgm@gmail.com`

---

### PASSO 2.5 — YT-ENRICHMENT [NOVO — OBRIGATÓRIO]

> Objetivo: alimentar o banco do Auditor com vídeos de canais especializados.
> O NotebookLM processa transcrições de vídeos — cada URL adicionada = conteúdo indexável.
> Músculo executa ANTES de preparar as fontes (PASSO 3).

**Executar as buscas YT-SEARCH pelo Músculo:**
```bash
# Busca 1: tecnologias centrais do loop (ex: MCP, Claude Code, Computer Use)
python ~/.claude/skills/yt-search/scripts/search.py "[TOPICO_1_DO_LOOP]" --count 8 --months 6

# Busca 2: nicho do cliente ativo (ex: LegalTech Brasil, EdTech concursos)
python ~/.claude/skills/yt-search/scripts/search.py "[TOPICO_2_NICHO]" --count 8 --months 6

# Busca 3: tendências de mercado relevantes para o loop
python ~/.claude/skills/yt-search/scripts/search.py "[TOPICO_3_TENDENCIA]" --count 5 --months 3
```

**Critério de seleção de vídeos — OBRIGATÓRIO:**
```
ACEITO (ao menos 1 critério):
  - Canal com > 10.000 inscritos
  - Views/Subs ratio > 0.3 (vídeo performou bem)
  - Canal oficial de empresa (Anthropic, Google, Microsoft, Gartner, etc.)
  - Canal de especialista técnico reconhecido (Nick Saraev, Matt Wolfe, AI Explained, etc.)
  - Vídeo com > 50.000 views (prova de relevância no nicho)

PROIBIDO:
  - Canal de "guru" com <1K subs e claim de resultado explosivo
  - Vídeo de compilação, "react", ou shorts sem conteúdo técnico
  - Canal sem histórico consistente no nicho
  - Vídeo > 18 meses (a menos que seja referência clássica)
```

**Canais de referência para loops de IA/Vanguard:**
| Canal | Nicho | Por que aceitar |
|-------|-------|-----------------|
| Anthropic (oficial) | Claude, MCP | Fonte primária |
| Google DeepMind | Gemini, Agentes | Fonte primária |
| Nick Saraev | Claude Code prático | 443K subs, alta relevância |
| Confluent Developer | MCP integrações | 58K subs, técnico |
| Two Minute Papers | Pesquisa LLM | Peer-reviewed |
| AI Explained | Tendências IA | Análise técnica |
| Matt Wolfe | Ferramentas IA | Mercado prático |

**Adicionar URLs selecionadas como fontes (via CLI):**
```bash
# Para cada URL selecionada (máx 5 por loop — não sobrecarregar):
notebooklm source add "https://youtube.com/watch?v=[VIDEO_ID]"

# Verificar processamento:
notebooklm source list
```

**Via Playwright (se CLI offline):**
Usar `browser_navigate` para abrir o caderno → botão "Adicionar fonte" → colar URL do YouTube.

**Saída esperada:** 3-5 fontes de vídeo adicionadas com status "Processada".

---

### PASSO 3 — Preparar fontes do projeto

```powershell
.\scripts\preparar_notebooklm_projeto.ps1 -cliente [NOME]
```
Confirmar que `CLIENTES/[NOME]/NOTEBOOKLM_FONTES/` tem os N arquivos esperados.
As fontes de vídeo do PASSO 2.5 são adicionadas SEPARADAMENTE via CLI (não pela pasta).

---

### PASSO 4 — WIPE (deletar todas as fontes antigas do loop anterior)

Verificar quantas fontes existem no painel. Se houver fontes antigas do loop anterior:
- Via CLI: `notebooklm source list` → `source delete` para cada uma
- Via Playwright: usar JavaScript para clicar em cada "Remover fonte"
- **AUTORIZAÇÃO OBRIGATÓRIA do Diretor antes de qualquer deleção em massa**

---

### PASSO 5 — SYNC (upload das novas fontes do projeto)

- Via CLI: `notebooklm source add [arquivo]` para cada arquivo da pasta NOTEBOOKLM_FONTES/
- Via Playwright: usar `browser_file_upload` via input[type=file]
- Aguardar todos os arquivos processados
- As fontes de vídeo do PASSO 2.5 já foram adicionadas — não duplicar

---

### PASSO 6 — Verificar persona do Auditor

Em "Configurar as conversas" do caderno, verificar que a persona referencia o loop correto.
Atualizar se necessário: "vanguard-v[N-1].md" → "vanguard-v[N].md"

---

### PASSO 7 — Enviar o PASSO5

Colar no chat do NotebookLM o prompt completo:
```
Leia o 13_PASSO5_NOTEBOOKLM.md completo e execute a missão do Auditor para o Loop [N].
Execute todas as PARTES na ordem: PARTE 1 (Auditoria de Coerência), PARTE 2 (Conexão Histórica),
PARTE 3 (Skill [cliente]-v[N].md com os 4 blocos exatos), PARTE 4 (N-1 a N-5) e PARTE 5
(AMPLIAR — pelo menos 3 ideias [A-1][A-2][A-3] novas, não presentes em M ou G).
Ao usar fontes de vídeo (YouTube), citar canal + título + minuto relevante.
Abra com MANIFESTO DE FONTES (incluindo fontes de vídeo). Idioma: português do Brasil.
```

---

### PASSO 8 — Aguardar resposta completa

Monitorar via snapshot até o indicador "Pensando..." desaparecer.
Verificar presença de PARTE 3 (Skill) e PARTE 5 (AMPLIAR) no output.
Se fontes de vídeo foram carregadas: verificar se foram citadas no MANIFESTO DE FONTES.

---

### PASSO 9 — Capturar e salvar resposta

Via JavaScript `browser_evaluate`:
```js
() => {
  // Extrair texto da última resposta do Auditor
  // (seletor varia; usar snapshot para identificar ref do elemento)
}
```
Salvar em:
- `CLIENTES/[NOME]/HISTORICO/AUDITOR_LOOP_V[N]_[NOME].md` — PARTES 1+2+4+5
- `.claude/skills/[cliente]-v[N].md` — PARTE 3 (Skill)

Rodar validação:
```powershell
.\scripts\skill_parser_gate.ps1 -skill ".claude\skills\[cliente]-v[N].md"
```

---

### PASSO 10 — ARTEFATOS RICOS [NOVO — DISRUPTIVO]

> Após a Skill gerada e validada, o Auditor não encerra.
> O banco agora tem fontes internas + fontes de vídeo especializadas — aproveitar ao máximo.
> Estes artefatos alimentam o Diretor, o Antigravity e o Embaixador no próximo ciclo.

**10.1 — RELATÓRIO (Briefing Document)**
```bash
notebooklm generate report --format briefing-doc
notebooklm artifact wait
notebooklm download report "CLIENTES/[NOME]/HISTORICO/BRIEFING_LOOP_V[N]_[NOME].md"
```
Conteúdo: síntese dos achados do loop com fontes citadas — ideal para o CONTEXTO_GEMINI do próximo PASSO3.

**10.2 — PODCAST (Áudio para o Diretor)**
```bash
notebooklm generate audio "Resumo executivo do Loop [N] para o Diretor da Vanguard: principais achados, alertas críticos, próximas decisões. Direto ao ponto, linguagem de negócios, máximo 10 minutos." --format brief
notebooklm artifact wait
notebooklm download audio "CLIENTES/[NOME]/HISTORICO/PODCAST_LOOP_V[N]_[NOME].mp3"
```
Uso: Diretor ouve no carro ou no celular — briefing do loop sem abrir documentos.

**10.3 — MAPA MENTAL (Estrutura visual das conexões)**
```bash
notebooklm download mind-map "CLIENTES/[NOME]/HISTORICO/MINDMAP_LOOP_V[N]_[NOME].json"
```
Uso: referência visual para o Diretor ver como as ideias do loop se conectam.

**10.4 — QUIZ (Verificação de coerência — opcional)**
```bash
notebooklm generate quiz
notebooklm artifact wait
notebooklm download quiz --format markdown "CLIENTES/[NOME]/HISTORICO/QUIZ_COERENCIA_V[N]_[NOME].md"
```
Uso: Músculo usa o quiz para verificar se os princípios do loop estão coerentes com o Ledger.

**Regra de prioridade de artefatos:**
```
OBRIGATÓRIO em todo loop:  RELATÓRIO (briefing-doc)
OBRIGATÓRIO se loop > 2h:  PODCAST (áudio brief)
OPCIONAL mas recomendado:  MAPA MENTAL + QUIZ
```

**Salvar metadados no histórico:**
```
CLIENTES/[NOME]/HISTORICO/ARTEFATOS_LOOP_V[N]_[NOME].md — lista de artefatos gerados
```

---

## RESULTADO ESPERADO (atualizado v2.0)

- Skill aprovada pelos 4 blocos obrigatórios
- AUDITOR_LOOP_VN salvo no HISTORICO/
- 3-5 fontes de vídeo YT-SEARCH adicionadas e processadas
- BRIEFING_LOOP_VN.md gerado (relatório)
- PODCAST_LOOP_VN.mp3 gerado (áudio brief para o Diretor)
- PASSO7_EMBAIXADOR.md atualizado com [N-1 a N-5] + [A-1 a A-3]
- Ciclo pronto para ir ao Embaixador

---

## HISTÓRICO DE EXECUÇÃO

| Data | Cliente | Loop | Método | Fontes | YT-SEARCH | Artefatos | Status |
|------|---------|------|--------|--------|-----------|-----------|--------|
| 2026-06-09 | VANGUARD | 30 | Playwright (CLI SIDTS expirado) | 18 | Não (pré-v2.0) | Não (pré-v2.0) | OK — Skill APROVADA |
