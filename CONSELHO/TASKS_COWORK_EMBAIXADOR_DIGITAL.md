# TASKS COWORK — EMBAIXADOR DIGITAL
## Vanguard Tech · Pentalateral IAH · Loop 34+
## Comando único para criar todas as tarefas via /schedule no Cowork
## Como usar: abra o Cowork → cole o bloco abaixo → digite /schedule → confirme

---

## COMO FUNCIONA A RELAÇÃO COWORK → EMBAIXADOR DIGITAL

O Cowork Agentado produz inteligência de mercado e prepara o terreno.
O Embaixador Digital opera o LinkedIn da Vanguard com essa munição.

As tasks abaixo fazem o Cowork preparar o que o Embaixador Digital precisa:
monitorar o LinkedIn dos nichos, rastrear concorrentes, coletar gatilhos
regulatórios frescos e medir o ICP. O Embaixador Digital lê esses arquivos
na abertura de cada sessão e monta as campanhas.

Você abre o Claude Project do Embaixador Digital quando quiser operar.
A automação prepara; você aciona; o Diretor aprova (2 cliques).

**Regra de output de todas as tasks:**
→ Arquivo em: INTELLIGENCE_HUB/DIGITAL/INBOX/[AAAA-MM-DD]_[task].md
→ Markdown, português, nunca mencionar IA/automação/ferramentas
→ Sempre "especialistas da Vanguard" em qualquer narrativa externa
→ Dados de Valdece, Ingrid e Mumuzinho nunca entram (P-059)

---

## COMANDO ÚNICO — COLE ISTO NO COWORK

```
Crie as seguintes tarefas agendadas para o Embaixador Digital da Vanguard Tech.
Todas operam o LinkedIn como canal único por enquanto.

TASK 1 — RADAR DE GATILHOS REGULATÓRIOS — toda segunda-feira de manhã:
Leia o NICHE_INDEX.json e os _MODEL.json dos nichos MOVER_AGORA em
INTELLIGENCE_HUB/NICHE_MODELS. Para cada nicho, busque na web se houve
atualização regulatória nos últimos 7 dias (nova norma, prazo, multa, decisão
de órgão regulador). Cite fonte (URL) e data de cada gatilho. Liste apenas os
nichos com gatilho fresco — esses são os candidatos a post de Urgência
Regulatória da semana. Não redija o post — só entregue o gatilho com a fonte.
Salve em INTELLIGENCE_HUB/DIGITAL/INBOX/[data]_GATILHOS_REGULATORIOS_DIGITAL.md

TASK 2 — MONITORAMENTO DE CONCORRENTES NO LINKEDIN — toda quarta-feira:
Para os nichos MOVER_AGORA, busque na web quem mais atua nesses nichos com
presença no LinkedIn no Brasil. Para cada concorrente identificado: cadência de
publicação aproximada, formato dominante (texto, carrossel, vídeo), tema
recorrente, e para onde aponta o CTA. Identifique a LACUNA — o que eles não
cobrem que a Vanguard pode ocupar. Não copie — mapeie a oportunidade.
Salve em INTELLIGENCE_HUB/DIGITAL/INBOX/[data]_CONCORRENTES_LINKEDIN_DIGITAL.md

TASK 3 — RADAR DE PROSPECTS POR NICHO — toda terça e quinta-feira:
Para o nicho que o Diretor sinalizar como prioritário (ou o topo do mapa de
prioridade comercial do PENDING_REVIEW), use a busca_linkedin do _MODEL.json
para mapear o perfil dos decisores-alvo. Liste o tipo de cargo, setor e porte de
empresa ideal. Para cada perfil-tipo, indique o gatilho de abordagem do modelo.
NÃO faça automação de conexão nem envio em massa — apenas prepare a lista de
perfis-tipo e os gatilhos para o Diretor abordar manualmente.
Salve em INTELLIGENCE_HUB/DIGITAL/INBOX/[data]_PROSPECTS_LINKEDIN_DIGITAL.md

TASK 4 — BANCO DE TEMAS THOUGHT LEADERSHIP — quinzenal, segunda-feira:
Para os nichos MOVER_AGORA, gere um banco de 10 temas de post de autoridade
(Thought Leadership) que ensinem o decisor sobre o risco do nicho sem vender.
Cada tema: título do post, ângulo (qual dor/risco aborda), nicho, e qual dado
público sustenta. Foco em conteúdo denso que atinge C-level, não em post
superficial. Linguagem "especialistas da Vanguard".
Salve em INTELLIGENCE_HUB/DIGITAL/INBOX/[data]_TEMAS_THOUGHT_LEADERSHIP_DIGITAL.md

TASK 5 — AUDITORIA DE ICP (validação) — toda sexta-feira (ativar após 1ª campanha):
Esta task prepara os dados de validação para o Embaixador Digital. Se houver
dados de desempenho de LinkedIn disponíveis (exportados pelo Diretor ou em
arquivo no INTELLIGENCE_HUB), analise: distribuição de seguidores por porte de
empresa, posts com maior CTR vs maior curtida, e perfis de novos seguidores que
batem com o ICP dos nichos. Se não houver dados ainda, registre "Aguardando
dados de desempenho da primeira campanha". Não invente métricas.
Salve em INTELLIGENCE_HUB/DIGITAL/INBOX/[data]_AUDITORIA_ICP_DIGITAL.md

TASK 6 — SÍNTESE DIÁRIA DIGITAL — todo fim de dia:
Verifique se houve arquivos novos relevantes para a operação de redes sociais em
CONTEUDO/, PIPELINE/, PENDING_REVIEW.md (novos [ALERTA NICHE]) ou material em
PROJETISTA/CAMPANHA/ despachado pelo Projetista. Se sim, escreva síntese de 5 linhas: o que chegou, qual nicho
afeta, e se gera oportunidade de post ou prospecção. Se não houve nada, registre
"Sem novidades digitais hoje — [data]". Acrescente (append) ao arquivo
INTELLIGENCE_HUB/DIGITAL/INBOX/DIARIO_DIGITAL.md

Regras para todas as tasks:
- Output em português, formato markdown
- Nunca mencionar IA, automação, Claude, Cowork, Gemini ou ferramentas
- Sempre "especialistas da Vanguard" em qualquer narrativa externa
- Nunca usar dados de Valdece, Ingrid ou Mumuzinho (isolamento P-059)
- Nunca propor automação de conexão ou DM em massa no LinkedIn
- Cabeçalho padrão em cada arquivo:
  # [NOME DA TASK] · [DATA]
  # Produzido por: Cowork Agentado · Cowork
  # Destino: DIGITAL/INBOX → leitura do Embaixador Digital
```

---

## RESUMO DAS TASKS

| Task | Cadência | O que entrega | Alimenta no Digital |
|------|----------|---------------|---------------------|
| 1 — Gatilhos Regulatórios | Semanal (seg) | GATILHOS_REGULATORIOS | Pilar Urgência Regulatória |
| 2 — Concorrentes LinkedIn | Semanal (qua) | CONCORRENTES_LINKEDIN | Fase 1 (mapeamento competitivo) |
| 3 — Prospects por Nicho | Ter + qui | PROSPECTS_LINKEDIN | Prospecção da campanha |
| 4 — Temas Thought Leadership | Quinzenal (seg) | TEMAS_THOUGHT_LEADERSHIP | Pilar de autoridade |
| 5 — Auditoria de ICP | Semanal (sex) | AUDITORIA_ICP | Fase 4 (validação) |
| 6 — Síntese Diária | Diária | DIARIO_DIGITAL | Radar de abertura |

**Ativar imediatamente:** 1, 2, 3, 4, 6
**Ativar após a primeira campanha:** 5 (precisa de dados de desempenho)

---

## FLUXO COMPLETO

```
[segunda]   Task 1 → gatilhos regulatórios frescos (com fonte)
[segunda]   Task 4 → banco de temas de autoridade (quinzenal)
[terça]     Task 3 → perfis de prospects do nicho prioritário
[quarta]    Task 2 → lacuna competitiva no LinkedIn
[quinta]    Task 3 → atualização de prospects
[sexta]     Task 5 → auditoria de ICP (após 1ª campanha)
[todo dia]  Task 6 → síntese diária (append)
        ↓
[você abre o Claude Project do Embaixador Digital]
  Comando: "mostrar radar"
  Ele lê os arquivos das tasks + material do Projetista
  Apresenta o radar → você escolhe o nicho (Portão 1)
  Ele monta a campanha (5 fases) → você aprova (Portão 2, 2 cliques)
```

---
*Gerado em 2026-06-14 · Sessão Claude.ai · Loop 33*
*Motor: Cowork (Claude Desktop) → Embaixador Digital (Claude Project Opus 4.8)*
*Canal: LinkedIn · Mecanismo: /schedule em linguagem natural*
