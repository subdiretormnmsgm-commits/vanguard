# PAINEL DE ATIVIDADES - DIRETOR EDUARDO
### Pentalateral IAH - Sexta-feira, 29-05-2026

---

## DECISOES E MANDATOS DA SESSAO — LER PRIMEIRO

> Estas decisões foram declaradas pelo Diretor nesta sessão e são permanentes.

### P-069 — DATA CALENDÁRIO REGE A ORDEM DE AÇÃO (declarado hoje)
- Todo item de projeto DEVE usar formato **"Dia X (DD-MM-YYYY dia-da-semana)"**
- Exemplo correto: "Dia 15 (29-05-2026 sexta-feira)"
- Exemplo incorreto: "Dia 15" ou apenas "29/05"
- Aplica-se a: PENDENTES.md, WIP_BOARD, PASSO files, e-mails, PAINEL
- Ferramenta: `scripts/mapa_diario_pendencias.ps1` — agora mostra data em TODAS as seções
- Eduardo: "Isso deve acontecer para sempre, as questões das datas"

### P-013 — GATE INGRID AUTORIZADO PELO DIRETOR (autorização desta sessão)
- Eduardo declarou: "PERGUNTA AO DIRETOR: Há 1 gate bloqueado aguardando sua deliberação. Desbloqueie"
- Decisão: **Opção B** — Ingrid cria o próprio projeto Supabase (soberania do cliente)
- Ação do Músculo: criar OFFBOARDING_RUNBOOK com passo a passo para Ingrid criar Supabase
- Ação do Músculo: criar `migrate_ingrid_supabase.sql` — script completo de migração
- Ação do Músculo: app atualizado com variáveis configuráveis (SUPABASE_URL / SUPABASE_ANON_KEY)
- Gate: Ingrid com acesso admin ao próprio Supabase — deadline 30-05-2026 sábado

### v17 INGRID — STATUS FINAL DESTA SESSÃO
- Deploy GitHub Pages: funcional ✅
- Nota Simulada de Prova: 7.6/100 · 2/13 disciplinas (correto — Ingrid precisa usar mais) ✅
- N-1 Última Sessão Dashboard: "Última sessão: 21:46 (segunda-feira, 25/05)" ✅
- Emojis no header: corrigidos (encoding PS5.1 fix com WriteAllText UTF8NoBOM) ✅
- sessoes_usuario migration: aplicada em Supabase ✅

---

## PROJETOS ATIVOS

```
Ingrid     [BUILD    ]  Loop 5 — Dia 15 (29-05-2026 sexta-feira) — P-013 Soberania  Deadline: 30-05-2026
Valdece    [HYPERCARE]  Loop 7 CONCLUIDO — toga-digital-valdece.netlify.app ativo     Hypercare: até 18/06
```

---

## PENDENTES CRITICOS

### PROJ-002 · Ingrid — Deadline: 30-05-2026 sábado (AMANHA)

🔴 **Dia 15 (29-05-2026 sexta-feira) — P-013 Soberania + gate admin Supabase**
   - Gate AUTORIZADO pelo Diretor nesta sessão
   - Músculo deve: criar OFFBOARDING_RUNBOOK + SQL de migração + app com variáveis configuráveis
   - Eduardo guia Ingrid pessoalmente na criação do Supabase dela

🟡 **D4:A (27-05-2026 terça-feira) — Plantar lead na próxima mensagem a Ingrid**
   - "Você conhece mais alguém prestando concurso esse ano?" — casual, sem pitch

### PROJ-001 · Valdece — Hypercare até 18/06

🟡 **Sentinel Report (02-06-2026 terça-feira) — Hypercare Valdece**
   - Gerar em 2026-06-02. Template: CLIENTES/VALDECE/CLAUDE_PROJECT/PASSO7_EMBAIXADOR.md
   - Hoje está com 1 dia de atraso na data de vencimento da PENDENTES (data era 2026-05-24)

---

## ALERTAS DO MUSCULO

🔴 **P-013 Opção B é bloqueante para entrega Ingrid**: Deadline é amanhã (30/05). Se Ingrid não
   criar o Supabase hoje, a entrega atrasa. Eduardo precisa contatar Ingrid TODAY.

🟡 **Wipe & Sync NotebookLM ao fechar Loop 5**: executar `preparar_notebooklm_projeto.ps1 -cliente INGRID`
   antes do próximo ciclo.

🟡 **MEMORIA_V5_INGRID ausente**: gerar ao fechar o Loop 5 (após gate dia15 APROVADO).

---

## PROXIMA ACAO DO DIRETOR

1. **HOJE** — Contatar Ingrid para criar conta Supabase (link: supabase.com → New Project)
   - Músculo vai gerar OFFBOARDING_RUNBOOK com passo a passo ilustrado nesta sessão
2. **HOJE** — Plantar pergunta de lead na mensagem a Ingrid: "Você conhece mais alguém prestando concurso esse ano?"
3. **02-06-2026** — Gerar Sentinel Report Valdece (template em PASSO7_EMBAIXADOR.md)

---

## DIAGNOSTICO DO DIA — 29-05-2026 sexta-feira

### Saúde dos projetos
```
PROJ-002 Ingrid   🟡 AGUARDANDO GATE   — Dia 15 em progresso. Eduardo contactou Ingrid (P-013).
                                          Falta: Ingrid criar Supabase + enviar URL/key.
PROJ-001 Valdece  🟢 SAUDÁVEL          — Hypercare ativo. Sem pendência hoje.
                                          Próxima ação: Sentinel Report em 02-06-2026.
```

### O que foi resolvido hoje
- ✅ P-069 operacionalizado: formato "Dia X (DD-MM-YYYY dia-da-semana)" em TODOS os documentos
- ✅ mapa_diario_pendencias.ps1 atualizado — exibe data completa em todas as seções
- ✅ WIP_BOARD Ingrid: campo `calendario` adicionado com mapeamento Dia 1-15
- ✅ OFFBOARDING_RUNBOOK.md criado — 6 passos para P-013
- ✅ migrate_ingrid_supabase_v1.sql criado — schema completo para projeto próprio da Ingrid
- ✅ D4:A fechado: Ingrid não conhece ninguém prestando concurso (pipeline de indicação = zero)
- ✅ MEMORIA_EMBAIXADOR atualizada: H-5 revisada, intel de pipeline registrada
- ✅ Mandato "não avanço com pendência no outro" gravado em LEDGER + memória permanente

### O que está bloqueado e por quê
- 🔴 **P-013** — aguarda Ingrid criar conta no Supabase (Eduardo já contactou)
- 🟡 **Commit da sessão** — aguarda veredito do Diretor

---

## PREVISAO PROXIMOS DIAS

### 30-05-2026 sábado — DEADLINE INGRID
**Cenário provável:** Ingrid envia URL + anon key do Supabase
- [ ] Músculo atualiza `app.js` linhas 16-17 com novas credenciais
- [ ] Eduardo roda `migrate_ingrid_supabase_v1.sql` no projeto da Ingrid
- [ ] Eduardo migra questões (export CSV do Vanguard → import na Ingrid)
- [ ] Eduardo deploya Edge Functions: `tutor-socratico`, `notificar-progresso`, `feed-diario`
- [ ] Músculo faz deploy v18 → Eduardo testa → gate dia15 APROVADO
- [ ] Ao fechar: gerar MEMORIA_V5_INGRID + relatorio_evolutivo_V5_INGRID
- [ ] Wipe & Sync NotebookLM: `preparar_notebooklm_projeto.ps1 -cliente INGRID`

**Cenário de risco:** Ingrid não cria o Supabase até sábado
- Músculo aciona Eduardo: "Deadline hoje. Ingrid confirmou?"
- Alternativa: Eduardo cria o projeto e convida Ingrid como admin depois

### 02-06-2026 terça-feira — SENTINEL REPORT VALDECE
- [ ] Músculo gera Sentinel Report com template `PASSO7_EMBAIXADOR.md`
- [ ] Eduardo leva ao Embaixador (Claude Projects — Valdece)
- [ ] Embaixador gera análise de Hypercare (30 dias de uso real)

### 03-06-2026 em diante
- Loop 6 Ingrid: iniciar com PASSO3_GEMINI + nova DIRETRIZ
- V2 Valdece: gatilho = corpus ≥ 500 docs ou 30 dias pós-entrega (18-06-2026)

---

## ANÁLISE GERENCIAL DO MÚSCULO — 29-05-2026

O projeto Ingrid está tecnicamente sólido: v17 funcional, 11 gates aprovados em 15 dias
previstos. O único risco real não é técnico — é a dependência de uma ação da Ingrid
(criar conta Supabase) para desbloquear o gate final. Eduardo já contatou. Se ela não
responder até amanhã, há alternativa clara: Eduardo cria o projeto e a convida como admin.

A intel D4:A revela isolamento: Ingrid estuda sozinha, sem rede, sem indicações. O referral
só ocorre pós-aprovação. Isso significa que os próximos 4 meses (até setembro) são de
retenção — não de aquisição. O risco não é churn técnico, é churn por fadiga de estudo.
O Embaixador deve responder: como manter a temperatura QUENTE sem visitas frequentes?

Valdece está saudável — Hypercare ativo, sem pendência imediata. O próximo ato é o
Sentinel Report em 02-06-2026: primeira leitura de 30 dias de uso real. Oportunidade
de coletar prova social antes de abrir pipeline V2.

---

## INSTRUCAO PARA O EMBAIXADOR

Com base neste PAINEL, gerar artefato publicável com os seguintes blocos:

1. **SEMÁFORO** — status visual de cada projeto (🔴 bloqueante / 🟡 atenção / 🟢 saudável)
2. **DIAGNÓSTICO DO DIA** — saúde de PROJ-002 Ingrid e PROJ-001 Valdece
3. **PREVISÃO DOS PRÓXIMOS DIAS** — data a data com checklist de ações do Diretor
4. **ANÁLISE GERENCIAL** — replicar e amplificar a análise do Músculo acima com perspectiva
   do Embaixador: o que o comportamento real da Ingrid confirma ou contradiz?
   O que o Embaixador vê que o Músculo não vê?
5. **PRÓXIMA AÇÃO DO DIRETOR** — máximo 3 itens, em ordem de prioridade

O artefato deve ser autossuficiente: o Diretor abre e sabe exatamente o que fazer.

Contexto crítico:
- P-013 autorizado, em execução. Deadline: 30-05-2026 sábado.
- Formato de data mandatório: "Dia X (DD-MM-YYYY dia-da-semana)" em todos os documentos.
- Mandato permanente: Músculo não avança em projeto algum com pendência aberta em outro.

---

Musculo - Pentalateral IAH - 2026-05-29
