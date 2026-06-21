---
name: protocolo-leitura
description: Use SEMPRE antes de qualquer projeção, materialização ou resposta sobre nicho, mercado ou plano de execução. Executa os 4 passos obrigatórios de leitura de estado (WIP_BOARD, PENDING_REVIEW + M-STATS, NICHE_INDEX, INBOX, MEMORIA_PROJETISTA) antes de qualquer análise. Bloqueante — sem ela a projeção é no escuro. Dispare automaticamente quando o Diretor mencionar nicho, oportunidade, plano, projeção, campanha, prioridade ou qualquer pedido operacional da Vanguard.
---

# Protocolo de Leitura Obrigatório

## Contexto
O Projetista nunca trata uma sessão como Dia 1. Toda projeção nasce do cruzamento do acervo histórico (VANGUARD_HISTORICO) com o estado presente (INTELLIGENCE_HUB). Sem a leitura, o Projetista projeta no escuro — reinventa o que já existe ou ignora o mercado.

## Os 4 Passos (bloqueantes — nenhum é pulável)

### Passo 1 — Estado do sistema
Ler via Google Drive:
- `WIP_BOARD.json` → ritmo de loops, projetos ativos, Loop atual
- `PENDING_REVIEW.md` → alertas, mapa de prioridade comercial, fila ativa **e o PARECER M-STATS do nicho** (TAM/SAM/SOM ±15% + IC — camada fria que ancora a projeção)

IDs canônicos:
- WIP_BOARD: `1FWSZj4nCxqad4MUUjwADmV8Ar71HwET_`
- PENDING_REVIEW: `1_ch563cTFexl3xlj0t1VxsWsBw7Du-cM`

### Passo 2 — Inteligência de mercado
Ler via Google Drive:
- `NICHE_INDEX.json` → status DELTA, fit_score de cada nicho (`1TDjq465FbPrDsJ8OO-1x1Pw0-756gPxl`)
- Arquivos novos em `INBOX_COWORK/` e `PROJETISTA/INBOX/` (ordenados por data — F1, F3, F8, F10, F16–F22)
- `Biblioteca_Nichos/` vigente

⚠️ Se houver parecer M-STATS para o nicho em pauta → é input obrigatório da FASE 1 do plano. Projeção sem camada fria, quando ela existe, é projeção no escuro.

### Passo 3 — Acervo histórico
Consultar **VANGUARD_HISTORICO** (Drive: `vanguard/PENTALATERAL_UNIVERSAL/VANGUARD_HISTORICO`) ou via caderno PROJETISTA-ACERVO no NotebookLM (Claude in Chrome, P-126).

Perguntas obrigatórias:
- Que skill a Vanguard já construiu que se aplica ao nicho em pauta?
- Qual versão tentou algo semelhante e com que resultado?
- Que princípios do LEDGER se aplicam?

Falha no Claude in Chrome → fallback manual (P-110): buscar `search_files` no Drive com `title contains 'VANGUARD_HISTORICO'`.

Complementar: `INTELLIGENCE_LEDGER.md` — régua de princípios P-001 a P-151+.

### Passo 4 — Memória do Projetista
- `MEMORIA_PROJETISTA.md` colada no início da sessão (`1uwMN5MNA61wWZECjeaNWhTU06oTjRMO3`)
- **Ausente** → SINALIZAR antes de prosseguir: *"MEMORIA_PROJETISTA não colada — reconstruindo do Drive."* Ler do Drive pelo ID canônico antes de avançar.

## Gate
**Nenhuma projeção antes dos 4 passos.** Ao final, declarar:
```
LEITURA CONCLUÍDA:
✅ Passo 1 — WIP_BOARD + PENDING_REVIEW [M-STATS: presente/ausente]
✅ Passo 2 — NICHE_INDEX + INBOX [N arquivos novos]
✅ Passo 3 — VANGUARD_HISTORICO [skill aplicável: X / versão: Y]
✅ Passo 4 — MEMORIA_PROJETISTA [Loop atual: N]
```
Passo incompleto → declarar motivo e o que ficou pendente antes de prosseguir.

## Padrão de acesso ao Drive
```
search_files → title contains '[nome]' → excludeContentSnippets: True → read_file_content por ID
```
IDs canônicos estáveis — usar diretamente sem path-browsing.

## Âncoras
Bloco 3 · P-110 · P-126 · M-STATS (Mandato 23) · Gate de Fato
Precede: toda sessão de projeção, materialização ou agendamento