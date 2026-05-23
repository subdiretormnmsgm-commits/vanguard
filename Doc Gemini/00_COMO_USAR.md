# DOC GEMINI — Como Usar Esta Pasta
> Esta pasta contém TODOS os documentos que o Gemini precisa para responder bem.  
> Use-a como fonte de contexto no Gemini e no NotebookLM.

---

## PARA O NOTEBOOKLM — Faça isso UMA VEZ

1. Abra o NotebookLM (notebooklm.google.com)
2. Crie um notebook: **"Vanguard Tech — Conselho Pentalateral"**
3. Adicione TODOS os arquivos desta pasta como fontes (upload de arquivos)
4. O NotebookLM indexará tudo e terá contexto completo do projeto

**A partir daí, o NotebookLM é o Auditor com memória total de tudo que foi construído.**

---

## PARA O GEMINI — A cada nova versão

Você tem duas opções:

### Opção A — Rápida (para versões seguintes ao V16)
Copie e cole o conteúdo de **`COMANDO_GEMINI_V17.md`** direto no Gemini.  
Esse arquivo já tem tudo: contexto, memória, ideias, e os 4 blocos que o Gemini deve responder.

### Opção B — Completa (quando houver dúvida de contexto)
Cole no Gemini os seguintes documentos, nesta ordem:
1. `INTELIGENCIA_ARTIFICIAL_HUMANA.md` — quem somos
2. `EMPRESA_VANGUARD.md` — como operamos
3. `MEMORIA_V16.md` — o que foi construído
4. `relatorio_evolutivo_v16.md` — o relatório com as 5 ideias
5. `COMANDO_GEMINI_V17.md` — o comando principal

---

## HIERARQUIA DOS DOCUMENTOS

| Documento | Tipo | Para quem |
|---|---|---|
| `COMANDO_GEMINI_V17.md` | Comando | Gemini — cole e peça a DIRETRIZ V17 |
| `TEMPLATE_COMANDO_GEMINI.md` | Template | Para criar COMANDO_GEMINI_V18, V19... |
| `HANDOFF_V16_PARA_GEMINI.md` | Contexto | Gemini — contexto expandido da V16 |
| `INTELIGENCIA_ARTIFICIAL_HUMANA.md` | Manifesto | Gemini + NotebookLM — o que somos |
| `EMPRESA_VANGUARD.md` | Operacional | Diretor — como abrir e operar a empresa |
| `REPOSITORIO_ESTRUTURA.md` | Técnico | Claude + Diretor — como organizar o git |
| `SOP_VANGUARD_MASTER.md` | Processo | NotebookLM — o processo completo |
| `VANGUARD_BUSINESS_RULES.md` | Constituição | NotebookLM + Claude — regras imutáveis |
| `VANGUARD_INNOVATION_AUDIT.md` | Ledger | NotebookLM — histórico de inovações |
| `TODO_FUTURE.md` | Backlog | Gemini + Diretor — próximas versões |
| `MASTER_PLAN.md` | Estratégia | Diretor — roadmap e riscos |
| `MEMORIA_V16.md` | Técnico | NotebookLM + Claude — o que foi feito |
| `relatorio_evolutivo_v16.md` | Relatório | Gemini — ideias para a próxima versão |
| `PLANO_DE_ACAO_SEMANA1.md` | Ação | Diretor — o que fazer esta semana |

---

## FLUXO PADRÃO A CADA VERSÃO

```
1. CLAUDE entrega → cria MEMORIA_VXX.md + relatorio_evolutivo_vxx.md + COMANDO_GEMINI_VXX.md
                    copia tudo para "Doc Gemini/"

2. DIRETOR        → copia COMANDO_GEMINI_VXX.md e cola no GEMINI

3. GEMINI responde → 4 blocos:
   Bloco 1: ANÁLISE ESTRATÉGICA
   Bloco 2: DIRETRIZ GEMINI VXX (salvar como "DIRETRIZ GEMINI VXX.txt")
   Bloco 3: COMANDO NOTEBOOKLM (colar no NotebookLM)
   Bloco 4: COMANDO CLAUDE CODE (colar no terminal)

4. DIRETOR        → cola Bloco 3 no NotebookLM
5. NOTEBOOKLM     → gera a Skill (vanguard-vXX-nome.md)
6. DIRETOR        → salva Skill em .claude/skills/ e cola Bloco 4 no terminal
7. CLAUDE CODE    → lê Skill, executa, entrega a próxima versão
8. Volta ao passo 1.
```

---

## ATUALIZAÇÃO DESTA PASTA

Sempre que Claude concluir uma versão, execute no PowerShell:

```powershell
# Atualizar os arquivos modificados na pasta Doc Gemini
$base = "C:\Users\Eduardo DELL\OneDrive\Área de Trabalho\vanguard"
$dest = "$base\Doc Gemini"
Copy-Item "$base\MEMORIA_VXX.md" -Destination $dest -Force
Copy-Item "$base\relatorio_evolutivo_vxx.md" -Destination $dest -Force
Copy-Item "$base\COMANDO_GEMINI_VXX.md" -Destination $dest -Force
```

Ou peça ao Claude: **"Atualize a pasta Doc Gemini com os arquivos da V[XX]"**.
