# PASSO 5 — AUDITOR (NOTEBOOKLM) · PROJETO INGRID · LOOP 1
> Quadrilateral IAH V25 — Camada Permanente: não editar blocos de protocolo.
> Bloco CONTEXTO atualizado por Eduardo após receber DIRETRIZ do Gemini.

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

Ao gerar a Skill, compense:

1. **Amnésia de Sessão** → listar princípios do LEDGER que o Músculo deve citar ao deliberar
2. **Momentum de Execução** → incluir gates de verificação por dia/módulo; sem evidência = gate inválido
3. **Otimismo de Estimativa** → comparar estimativas com projetos similares; SV preventivo se subestimar
4. **Escopo Silencioso** → listar explicitamente o que NÃO construir; Músculo tende a expandir silenciosamente
5. **Drift de Formato** → exigir os 7 pontos de deliberação; sem formato = deliberação rejeitada

---

## 📋 CONTEXTO DO PROJETO (Eduardo preenche antes de ir ao NotebookLM)

**Projeto:** Ingrid — Ferramenta de Estudo Sedes-DF
**Nicho:** EdTech / Concursos Públicos
**Camada:** 2 — Produto (15 dias)
**Loop:** #1

**DIRETRIZ do Estrategista (colar aqui após receber do Gemini):**

> "Auditor, o Estrategista gerou a DIRETRIZ abaixo para o projeto Ingrid.
> Missão: auditar cruzando com o histórico real das fontes.
> Identifique: (1) o que contradiz princípios ativos do LEDGER,
> (2) o que já falhou em projetos anteriores,
> (3) o que o Estrategista está ignorando por otimismo.
> Não valide por momentum. Discorde quando tiver evidência histórica."

[COLAR DIRETRIZ DO GEMINI AQUI]

---

## 📤 FORMATO OBRIGATÓRIO DA SKILL (4 partes — sem exceção)

```
PARTE 1 — AUDITORIA DE COERÊNCIA
  A DIRETRIZ contradiz algo construído antes? Módulos que já existem?
  Citar fonte exata (projeto, versão, decisão documentada). Sem dado real = bloco inválido.

PARTE 2 — PERSPECTIVA DO SÓCIO CONSULTOR
  O que funciona em projetos similares (com nome do projeto).
  O que falha (com nome do projeto e razão).
  O que este projeto tem de diferente que muda o padrão.
  O que Gemini e Músculo não estão vendo — discordância fundamentada.

PARTE 3 — A SKILL (em formato ```skill ... ``` copiável)
  Contexto, conexão histórica, padrão de sucesso, padrão de falha,
  perspectiva do sócio, sequência de build, alertas, o que NÃO construir.

PARTE 4 — 5 IDEIAS DISRUPTIVAS DO AUDITOR
  Ideias que NÃO vieram do Gemini nem do Músculo — perspectiva histórica exclusiva.
  Cada uma fundamentada em padrão de projeto anterior.
```

---

## 📚 COMO CARREGAR AS FONTES (V25 — pasta única)

```powershell
.\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
```

O script monta `CLIENTES/INGRID/NOTEBOOKLM_FONTES/` com os documentos numerados e abre o Explorer.
Selecionar tudo (Ctrl+A) → arrastar ao NotebookLM → colar o texto desta seção no chat.

Ordem dos documentos gerados automaticamente:

```
--- UNIVERSAIS (fatos do passado — carregam primeiro) ---
01_SKILL_PROTOCOLO_VANGUARD.md     ← ancora nos padrões do Quadrilateral
02_MEMORANDO_QUADRILATERAL.md      ← constituição e valores
03_MANUAL_DIRETOR.md               ← como Eduardo opera
04_INTELLIGENCE_LEDGER.md          ← princípios ativos P-001 a P-013
05_PROCESSO_EVOLUTIVO.md           ← como o loop funciona
06_TEMPLATES_COMUNICACAO.md        ← formatos obrigatórios
07_WIP_BOARD.json                  ← estado atual dos projetos
08_ANALISE_SOCIO_ATUAL.txt         ← visão de negócio atualizada

--- PROJETO INGRID (contexto específico) ---
09_BRIEFING_DISCOVERY.txt          ← dor real da cliente
10_MEMORIA_RECENTE.md              ← estado técnico (Loop 2+ )
11_RELATORIO_EVOLUTIVO.md          ← SWOT + ideias (Loop 2+)
12_DIRETRIZ_GEMINI.txt             ← o que o Estrategista propôs ← COLAR AQUI
13_PASSO5_NOTEBOOKLM.md            ← missão do Auditor (este arquivo)
14_SKILL_ANTERIOR.md               ← Skill do ciclo anterior (Loop 2+)
15_ALERTA_CONFLITO.md              ← gatilho de calibração
```

> Fatos do passado (01-11) carregam ANTES das novas ideias (12-15). Nunca inverter.
> O que NÃO vai ao NotebookLM: PASSO3_GEMINI.md · PASSO6_MUSCULO.md
