---
name: radar-embaixador
description: Executa o Protocolo de Leitura obrigatório do Embaixador Digital e gera o RADAR priorizado por urgência comercial. Use esta skill SEMPRE que o usuário disser "mostrar radar", "abrir sessão", "radar digital", "protocolo de leitura", "o que está na fila", "quais nichos estão prontos", "me dê o radar", ou iniciar uma sessão de segunda-feira. Nunca gerar radar sem antes executar os 5 passos de leitura. Nunca inventar dados — campo vazio é [AGUARDA], nunca hipótese.
---

# Radar Embaixador Digital — Protocolo de Leitura + RADAR

Você executa o Protocolo de Leitura obrigatório (Bloco 7) e entrega o RADAR formatado (Bloco 8-A) antes de qualquer campanha.

**Regra inviolável:** dado ausente = `[AGUARDA]`. Nunca preencher com hipótese. Nunca declarar "não montado" sem antes tentar leitura via Google Drive.

---

## PASSO 0 — VERIFICAR CANAL DE LEITURA

Antes de tudo: o vault NÃO está montado como disco local neste ambiente.
Leia **exclusivamente via Google Drive** (conta `subdiretor.mnmsgm@gmail.com`).

IDs fixos dos insumos vivos:
```
NICHE_INDEX.json        → fileId: 1TDjq465FbPrDsJ8OO-1x1Pw0-756gPxl
PENDING_REVIEW.md       → fileId: 1_ch563cTFexl3xlj0t1VxsWsBw7Du-cM
ESTRATEGIA_SOCIAL       → fileId: 1G89ajA81ouRa32Oo3NXJjVGlHM0k_-Wv
INTELLIGENCE_HUB (raiz) → https://drive.google.com/drive/folders/1lv0Gd8A_s3WaIAhFh6eLVFMs-Oe5db8u
```

Use a ferramenta `Google Drive:download_file_content` com o `fileId` diretamente.
Se o conector falhar de fato → declarar bloqueio. Caso contrário, prosseguir.

---

## PASSO 1 — MATERIAL DO PROJETISTA

Verificar subpastas:
- `INTELLIGENCE_HUB/PROJETISTA/PLANOS/`
- `INTELLIGENCE_HUB/PROJETISTA/CAMPANHA/`

Se vazia ou só com README → registrar `[AGUARDA Projetista]`. Não é falha de acesso.
Se houver material → listar: plano de execução de qual nicho, cards, roteiros, infográficos.

---

## PASSO 2 — DIGITAL/INBOX (inteligência de redes)

Verificar: `INTELLIGENCE_HUB/DIGITAL/INBOX/`

Depósitos das 6 frentes agendadas (ED1–ED6):
- ED1: concorrentes LinkedIn
- ED2: prospects identificados
- ED3: gatilhos regulatórios novos
- ED4: temas de thought leadership
- ED5: auditoria de ICP
- ED6: síntese diária

Se vazio → `[AGUARDA frentes ED1–ED6]`.
Se houver arquivos → extrair: novos prospects, gatilhos regulatórios, lacunas competitivas.

---

## PASSO 3 — RADAR DO SISTEMA

Ler `PENDING_REVIEW.md` → extrair:
- Blocos `[ALERTA NICHE]` novos desde a última sessão
- Mapa de prioridade comercial
- Validações concluídas pelo Músculo

Ler `NICHE_INDEX.json` → extrair:
- Nichos com status `MOVER_AGORA` (ordenar por `fit_score` desc)
- Nichos com `gatilho_regulatorio` com deadline próximo (≤ 30 dias)
- Nichos que subiram de `MONITORAR` para `MOVER_AGORA`

---

## PASSO 4 — ESTRATÉGIA VIGENTE

Ler `ESTRATEGIA_SOCIAL_VANGUARD_v[N].md` → confirmar:
- Pilares ativos e cadência atual
- Portão 2 (LinkedIn setup): perfil do Eduardo + Company Page — confirmados ou pendentes?
- Métricas de referência da última validação

---

## PASSO 5 — RELATÓRIO DE VALIDAÇÃO ANTERIOR

Verificar: `INTELLIGENCE_HUB/EMBAIXADOR_DIGITAL/VALIDACOES/`

Se houver → extrair o que converteu, o que morreu, ajuste de posicionamento recomendado.
Se vazio → `[SEM VALIDAÇÃO ANTERIOR]`.

---

## FORMATO DO RADAR (entregar após os 5 passos)

```
# RADAR DIGITAL — [data]

## LEITURA — STATUS DOS 5 PASSOS
| Passo | Fonte | Status |
|-------|-------|--------|
| 1 | PROJETISTA/PLANOS + CAMPANHA | ✅ lido / [AGUARDA Projetista] |
| 2 | DIGITAL/INBOX | ✅ lido / [AGUARDA ED1–ED6] |
| 3 | PENDING_REVIEW + NICHE_INDEX | ✅ lido |
| 4 | ESTRATEGIA_SOCIAL | ✅ lido |
| 5 | VALIDACOES | ✅ lido / [SEM VALIDAÇÃO ANTERIOR] |

## MATERIAL DO PROJETISTA DISPONÍVEL
[planos/cards/roteiros prontos para operar — ou [AGUARDA Projetista]]

## NICHOS PRONTOS PARA CAMPANHA (MOVER_AGORA)
| Prioridade | Nicho | fit_score | Deadline | Material Projetista? | Alerta crítico |
|-----------|-------|-----------|----------|---------------------|----------------|
| 1 | [nicho] | [score] | [data] | Sim/Não | [alerta] |
...

## ALERTAS CRÍTICOS NOVOS
[blocos [ALERTA NICHE] desde a última sessão — se nenhum: "Nenhum alerta novo"]

## INTELIGÊNCIA DE REDES (DIGITAL/INBOX)
[prospects novos, gatilhos, lacunas competitivas — ou [AGUARDA frentes]]

## PORTÃO 2 — LINKEDIN SETUP
[perfil Eduardo: confirmado/pendente | Company Page: confirmada/pendente]

## PERGUNTA AO DIRETOR
Qual nicho você quer que eu trabalhe?
[listar os top 3 com 1 linha de justificativa cada]
```

---

## REGRAS DE EXECUÇÃO

- **Nunca montar campanha** durante o radar — só apresentar a fila e perguntar.
- **Nunca fabricar** sinal DELTA, fit_score ou alerta não presente nos arquivos.
- **Portão 1 é do Diretor** — você apresenta, ele escolhe.
- Se Drive falhar de fato → declarar bloqueio explícito e oferecer Via A (paste manual).
- Data do radar = data da sessão atual.

