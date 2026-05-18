# WIP BOARD — QUADRILATERAL IAH
**Atualizado em:** 2026-05-18
**Fonte:** WIP_BOARD.json (versão legível para NotebookLM)

---

## PROJETOS ATIVOS EM BUILD

### PROJ-001 — VALDECE
**Projeto:** Ferramenta de Busca Jurisprudência STF/STJ  
**Área:** Legal Tech · Direito Penal  
**Camada:** 1 (MVP Alto Impacto)  
**Valor fechado:** R$ 5.000  
**Deadline:** 2026-05-23 (anterior: 2026-05-17 — slip por dificuldades técnicas do cliente)  
**Status:** Build concluído (Dia 4/5) — Eduardo vai presencialmente 2026-05-19 para onboarding técnico  
**Modelo de entrega:** Opção A — infra Valdece, sem MRR, R$ 1,20/mês no API dele  
**Loop atual:** Loop 2 concluído — DIRETRIZ V3 + Quick Audit NotebookLM executados | Loop 3 no Dia 5  

**Dias completos:** Dia 1 (infraestrutura) · Dia 2 (corpus + pipeline) · Dia 3 (STJ tema + UI) · Dia 4 (gate ABNT threshold toga)  

**Commits:** dia1=ef3f1cd · dia2=996b40d · dia3=18c617f · dia4=e9afb36  

**Próximo passo:** Dia 5 — Eduardo vai presencialmente: Auth Supabase (single-user) + Edge Function cron blindado + Auto-Heal pg_net + view last_activity + Sovereign Playbook + migração infra Valdece  

**Formalização:** Contrato_Toga_Digital_Valdece_19052026.pdf — minuta aguardando assinatura  

**V2 pipeline (gatilho: corpus ≥ 500 docs ou 30 dias pós-entrega):**  
- Sovereign Upload · Radar de Divergência · Citação DOCX  
- Pricing: R$ 8.500–12.000 projeto único + R$ 300/mês manutenção opcional  

---

### PROJ-002 — INGRID
**Projeto:** Ferramenta de Estudo — Concurso Sedes-DF  
**Área:** EdTech · Concursos Públicos  
**Camada:** 2 (Produto — 15 dias)  
**Cargo:** TDAS – Técnico em Desenvolvimento e Assistência Social – Especialidade: Técnico Administrativo (Cargo 202)  
**Banca:** Instituto Quadrix  
**Stack:** PWA + Supabase + Claude API  
**Valor fechado:** R$ 0 (Projeto Piloto Interno — Validação V25)  
**Deadline:** 2026-05-30 | Prova do cliente: 2026-09-06  
**Status:** Loop #2 concluído — iniciando Loop #3 (Dias 6-8)  

**Dias completos:** Dia 1 (Schema multi-tenant + Edge Function) · Dia 2 (Mágico de Oz Gate questões) · Dias 3-5 (Feed SM-2 + PWA)  

**Gates bloqueantes:**
- Dia 2: 10 questões avaliadas por Eduardo — rubrica média ≥ 4/5 ✅
- Dia 5: Feed exibe plano correto 7 dias com proporção correta ✅
- Dia 8: Ingrid responde 10 questões — progresso salvo — fallback testado (PENDENTE)
- Dia 11: Heatmap correto + simulado domingo completo (PENDENTE)
- Dia 15: Ingrid com acesso admin próprio Supabase (PENDENTE)

**Decisões fixadas:**
- Fonte questões: Claude API — sem scraping (P-003)
- Auth: single-user — sem login complexo
- Cache: gerar lote 50 quando < 30 questões disponíveis
- Proporção feed: 70% Peso 2 / 30% Peso 1
- Modelos API: Haiku (gerais + dicas socráticas) / Sonnet (específicos)
- Burn rate: BURN_RATE_DAILY_LIMIT_USD=5.00
- Fallback: trigger 70% da cota diária
- Spaced repetition: SM-2 intervalo variável

**Loops programados:**
- Loop 1 — Kickoff (gate dia2_questoes): CONCLUÍDO
- Loop 2 — Gate Dia 5 (dia5_feed_proporcao): CONCLUÍDO em 2026-05-17 — evidência: 7 dias x 20 questões | 70.0% Peso2 | 0 erros | gate_cli_dia5.js APROVADO
- Loop 3 — Gate Dia 11 (dia11_heatmap_simulado): PENDENTE
- Loop 4 — Handoff Dia 15 (dia15_admin_supabase): PENDENTE

**Precificação:**
- Valor gerado ao candidato: R$ 9.750 (tempo + probabilidade aprovação)
- Serviço personalizado externo: R$ 2.500 por candidato
- Licença SaaS: R$ 197 por ciclo do concurso
- SaaS B2C MRR: R$ 97/mês x 4 meses = R$ 388 por usuário
- Meta SaaS: 500 usuários = R$ 194.000 no ciclo Sedes-DF 2026

**Formalização:** Termo_Uso_Ingrid_PROJ002_30052026.pdf — minuta aguardando assinatura (STATUS AMARELO — 2 dias sem contato)

**Próximo passo:** DIRETRIZ V2 recebida. NotebookLM gerando Skill ingrid-v2.md. Amanhã: Músculo delibera + Build Dias 6-8

**Decisões aprovadas Loop 3 (Embaixador 2026-05-18):**
- E-1: Frase âncora dinâmica de abertura — ativar junto com Tutor Socrático (Dias 6-8)
- E-2: Encerramento com número concreto — ativar no Gate Dia 8
- E-3: Relatório semanal WhatsApp — **GATE FORMAL** toda segunda-feira — Eduardo não pode pular
- E-4: Check-in pós-sessão 1 clique → TEMPERATURA_CLIENTE real — ativar Gate Dia 8
- E-5: Modo Silêncio Ativo — limiar 2 dias sem abertura → Eduardo recebe alerta do Embaixador

**Pendente do Diretor:** 5 questões reais Quadrix para playbook distratores (bloqueante Dia 2)

---

## POLÍTICA DO WIP BOARD

| Regra | Descrição |
|---|---|
| Regra 1 | Nada entra em BUILD sem Briefing aprovado pelo Diretor |
| Regra 2 | Nada sai de BUILD sem check_leis.ps1 aprovado |
| Regra 3 | Nada vai para ENTREGUE sem Sovereign Playbook gerado |
| Regra 4 | Sentinel do cliente atual validado antes de novo projeto entrar em BUILD |
| Regra 5 | Retainer só após 30 dias de dados reais do Sentinel |

**WIP Limits:** Build = 2 simultâneos · Check = 1 simultâneo
