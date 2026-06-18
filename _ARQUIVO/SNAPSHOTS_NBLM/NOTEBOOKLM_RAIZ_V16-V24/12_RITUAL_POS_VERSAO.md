# RITUAL PÓS-VERSÃO — Vanguard Tech
> Guia cronológico obrigatório ao fechar cada versão.  
> Cada passo depende do anterior — siga a ordem exacta.

---

## MAPA DE DEPENDÊNCIAS

```
fechar_versao.ps1
        │
        ├── gera ──► COMANDO_GEMINI_VXX.md
        │                    │
        ├── gera ──► NotebookLM/ (ficheiros actualizados)
        │                    │
        └── gera ──► Doc Gemini/ (ficheiros actualizados)
                             │
                    ┌────────▼─────────┐
                    │  NOTEBOOKLM      │  ← PASSO 2: upload dos novos ficheiros
                    │  (actualizar)    │     (antes do Gemini, para ter contexto)
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
                    │    GEMINI        │  ← PASSO 3: colar COMANDO_GEMINI
                    │  (4 blocos)      │
                    └────┬───┬───┬───┬─┘
                         │   │   │   │
                  Bloco1  │   │   │   │ Bloco4
                  (ler)   │   │   │   └──────────────────────┐
                          │   │   │                          │
                  Bloco2  │   │   │ Bloco3                   │
                  (salvar)│   │   └──────────┐               │
                          │   │              │               │
                    ┌─────▼───┴──┐  ┌────────▼────────┐  ┌──▼──────────────┐
                    │ DIRETRIZ   │  │   NOTEBOOKLM    │  │  CLAUDE CODE    │
                    │ GEMINI     │  │  (Bloco 3 +     │  │  (Bloco 4 →     │
                    │ V(XX+1)    │  │   gera Skill)   │  │   inicia VXX+1) │
                    │ .txt       │  └────────┬─────────┘  └─────────────────┘
                    └────────────┘           │
                                    ┌────────▼──────────┐
                                    │  Skill salva em   │
                                    │ .claude/skills/   │
                                    └───────────────────┘
```

---

## SEQUÊNCIA CRONOLÓGICA COMPLETA

### PASSO 1 — TERMINAL: Fechar a versão
```powershell
.\scripts\fechar_versao.ps1 -versao XX
```
**Produz:**
- `MEMORIA_VXX.md` (deve existir antes)
- `relatorio_evolutivo_vXX.md` (deve existir antes)
- `COMANDO_GEMINI_VXX.md` ← gerado pelo script
- Pasta `NotebookLM/` actualizada com todos os ficheiros
- Pasta `Doc Gemini/` actualizada com contexto completo
- Commit automático no git

---

### PASSO 2 — NOTEBOOKLM: Upload dos ficheiros novos
> Fazer ANTES do Gemini — para que o NotebookLM já tenha o contexto da versão
> quando receber o Bloco 3.

**O que fazer:**
1. Abrir o NotebookLM do projecto Vanguard
2. Apagar os ficheiros antigos das posições 07 e 08 (se necessário)
3. Fazer upload dos novos:
   - `NotebookLM\07_MEMORIA_VXX.md`
   - `NotebookLM\08_relatorio_evolutivo_vXX.md`
4. Se a DIRETRIZ da versão recém-fechada ainda não estiver lá, adicionar também:
   - `NotebookLM\18_DIRETRIZ GEMINI VXX.txt`

**Resultado:** NotebookLM tem o contexto completo e está pronto para receber o Bloco 3.

---

### PASSO 3 — GEMINI: Colar o COMANDO e receber os 4 blocos
> Só fazer depois do Passo 2.

**O que fazer:**
1. Abrir o Gemini (gemini.google.com)
2. Colar o conteúdo de:
   ```
   Doc Gemini\COMANDO_GEMINI_VXX.md
   ```
3. Aguardar os **4 blocos** de resposta

---

### PASSO 4 — SALVAR: Bloco 2 → DIRETRIZ da próxima versão
> Imediatamente após receber os 4 blocos.

**O que fazer:**
1. Copiar o **Bloco 2** completo da resposta do Gemini
2. Criar o ficheiro:
   ```
   DIRETRIZ GEMINI V(XX+1).txt
   ```
3. Colar e guardar na raiz do projecto
4. Este ficheiro vai para o NotebookLM na próxima versão

---

### PASSO 5 — NOTEBOOKLM: Colar o Bloco 3 e receber a Skill
> Depende do Passo 3 (Bloco 3 do Gemini) e do Passo 2 (contexto já carregado).

**O que fazer:**
1. No NotebookLM, colar o **Bloco 3** da resposta do Gemini
2. O NotebookLM vai:
   - Assumir o papel de Arquivista
   - Conectar a DIRETRIZ ao histórico V1–VXX
   - Gerar a Skill `vanguard-v(XX+1)-[nome].md`
3. Copiar o conteúdo completo da Skill gerada

---

### PASSO 6 — FICHEIRO: Salvar a Skill
> Depende do Passo 5.

**O que fazer:**
1. No Claude Code, criar o ficheiro:
   ```
   .claude\skills\vanguard-v(XX+1)-[nome].md
   ```
2. Colar o conteúdo recebido do NotebookLM
3. A Skill já contém:
   - A visão estratégica do Gemini
   - O contexto histórico do NotebookLM
   - O AUTO-LOG para o VANGUARD_INNOVATION_AUDIT.md
   - A CONEXÃO HISTÓRICA para o Claude

---

### PASSO 7 — CLAUDE CODE: Colar o Bloco 4 e iniciar a próxima versão
> Depende do Passo 6 (Skill salva) + Passo 3 (Bloco 4 do Gemini).

**O que fazer:**
1. No terminal do Claude Code, colar o **Bloco 4** da resposta do Gemini
2. Claude vai:
   - Ler a Skill (`.claude/skills/vanguard-v(XX+1)-[nome].md`)
   - Processar o AUTO-LOG → actualizar `VANGUARD_INNOVATION_AUDIT.md`
   - Executar a infraestrutura com contexto completo de Gemini + NotebookLM
   - Ao concluir, propor 5 ideias disruptivas para V(XX+2)

---

### PASSO 8 — COMERCIAL: Activação de vendas (em paralelo com 3–7)
> Pode começar logo após o Passo 1.

**O que fazer:**
```powershell
.\scripts\prospectar.ps1 -add      # adicionar prospecto + gerar mensagem WhatsApp
.\scripts\prospectar.ps1 -followup # ver quem precisa de follow-up
.\scripts\prospectar.ps1 -stats    # ver métricas do pipeline
```

**Identificar a nova arma desta versão:**

| Pergunta | Resposta |
|---|---|
| O que foi construído? | |
| Qual problema do cliente resolve? | |
| Como demonstro em 30 segundos? | |
| Qual o preço / produto disponível? | |
| Qual a prova de valor (número)? | |

---

## CHECKLIST RÁPIDO (para usar no dia)

```
[ ] PASSO 1  — fechar_versao.ps1 executado → commit feito
[ ] PASSO 2  — NotebookLM actualizado com 07 + 08 + 18
[ ] PASSO 3  — COMANDO_GEMINI colado → 4 blocos recebidos
[ ] PASSO 4  — Bloco 2 salvo como "DIRETRIZ GEMINI V(XX+1).txt"
[ ] PASSO 5  — Bloco 3 colado no NotebookLM → Skill recebida
[ ] PASSO 6  — Skill salva em .claude/skills/
[ ] PASSO 7  — Bloco 4 colado no terminal → V(XX+1) iniciada
[ ] PASSO 8  — prospectar.ps1 rodado → 20 contatos enviados
```

---

## PDCA SEMANAL — Toda sexta, 30 minutos

```powershell
.\scripts\prospectar.ps1 -stats
```

| Métrica | Meta Semana 1 | Meta Semana 4 |
|---|---|---|
| Contatos enviados | 40 | 160 |
| Taxa de resposta | >15% | >25% |
| Reuniões agendadas | 2 | 10 |
| Clientes fechados | 0-1 | 3-5 |
| MRR gerado | R$0 | R$1.350 |

**Se taxa de resposta < 15%:** mudar o texto da mensagem.
**Se reuniões não convertem:** mudar o script da demo.
**Se preço é objecção:** oferecer 30 dias grátis.
**Se nicho não responde:** mudar nicho, manter produto.

---

## REGRA FINAL

> Cada versão que fecha sem pelo menos **1 conversa de venda activa** é incompleta.
> O código sem cliente é só tecnologia. O cliente transforma tecnologia em negócio.

---

## HISTÓRICO DE ACTIVAÇÕES

| Versão | Nova arma comercial | Clientes gerados | MRR adicionado |
|---|---|---|---|
| V16 | Badge SVG + Stripe Connect | 0 | R$0 |
| V17 | Neural Audit Trail + Sovereign Pixel | — | — |
| V18 | (a definir pelo Gemini) | — | — |
