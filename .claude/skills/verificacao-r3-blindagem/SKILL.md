---
name: verificacao-r3-blindagem
description: Use OBRIGATORIAMENTE antes de entregar qualquer deck, áudio, card, one-pager, post, roteiro, relatório ou qualquer material que possa sair da Vanguard para o mercado ou para um cliente. Varre o texto por termos internos proibidos (IA, Claude, Opus, NotebookLM, automação, Cowork, Gemini, ferramentas, modelos, algoritmo, bot, LLM, prompt) e bloqueia se encontrar. Dispare mesmo sem pedido explícito — vazamento de linguagem interna invalida o output inteiro. Acione também quando o Diretor pedir para "revisar", "checar", "finalizar" ou "aprovar" qualquer conteúdo externo.
---

# Verificação R-3 — Blindagem de Linguagem Externa

## Contexto
A Vanguard opera com blindagem R-3: nenhum material externo menciona as ferramentas, processos ou tecnologias internas. Vazamento invalida o output e compromete o posicionamento de mercado. Esta skill é o portão final antes de qualquer entrega externa.

## Procedimento

### Passo 1 — Rodar o scanner
Execute `scripts/scan_r3.py` no texto do artefato:
```bash
python scripts/scan_r3.py <arquivo_ou_texto>
```
> Fonte canonica unica dos termos: `scripts/r3_termos.json` (`bloqueio` + `clientes` = FAIL; `alerta` = sinaliza). Nao duplicar termos nesta skill — em divergencia, vale o JSON.

### Passo 2 — Interpretar o resultado
- **R-3 FAIL** → listar cada ocorrência com contexto → NÃO entregar → ir ao Passo 3
- **R-3 OK** → liberar com selo "✅ R-3 OK" → entregar ao Diretor

### Passo 3 — Corrigir (só em caso de FAIL)
Substituir cada termo proibido pela linguagem blindada correta:

| Termo proibido | Substituição correta |
|---|---|
| IA / inteligência artificial | (omitir ou) "nossa metodologia" |
| Claude / Opus / LLM / modelo | "especialistas da Vanguard" |
| NotebookLM / Gemini / Cowork | "nossa equipe" / "nosso processo" |
| automação / automatizado | "nosso método" / "nossa abordagem" |
| ferramenta / algoritmo / bot | "nossa equipe" / "nosso sistema" |
| prompt / sistema de IA | (omitir) |

### Passo 4 — Re-escanear após correção
Rodar o scanner novamente no texto corrigido. Só liberar com R-3 OK confirmado.

## Gate inviolável
**FAIL = output não sai.** Não existe exceção, não existe "quase limpo". R-3 é a restrição mais vigiada da Vanguard (R-3 + P-059).

## Âncoras
Bloco 12 · R-3 · P-059 · Ação 2 · Ação 4 · Bloco 7
Chamada por: `abordagem-blindada`, `materializar-notebooklm`