# SKILL: skill_ingrid_v2.2.md
**Camada:** 2 (Produto - Dias 6 a 8) | **Loop:** #3 | **Stack:** PWA Vanilla JS + Supabase + Claude API (Haiku)
**Consolidada em:** 2026-05-18 | **Atualizada após Síntese Final:** 2026-05-18

---

## 📋 CONTEXTO DO PROJETO

PROJ-002 (Ingrid). Banco Supabase: 460 questões validadas, Cargo 202 (Técnico Administrativo — Sedes-DF/Quadrix). Disciplinas Peso 2: Dir. Administrativo, Constitucional, Arquivologia, Rec. Materiais. Feed 70/30 (Específicas/Gerais) validado no Gate Dia 5. A usuária é não-técnica, ansiosa, com ~111 dias até a prova. Temperatura da cliente: AMARELA. Prazo do projeto: 2026-05-30.

**Decisões fixadas (nunca reverter):**
- Arquitetura: 1 Claude call por invocação de Edge Function — nunca monólito (M-11)
- Auth: hardcoded via `user_id` — sem login (M-14)
- SM-2: fórmula original preservada — apenas coletar dados de latência (M-13)
- Stack: PWA Vanilla JS — sem React, Vue ou frameworks pesados
- Fluxo: Mock → Supabase → Tutor (M-15)
- Número visível: Pontos Ponderados — não Score de Sobrevivência (obrigação contratual cláusula 2)

---

## 🛡️ ALERTAS ATIVOS (INTELLIGENCE LEDGER)

| Princípio | Regra |
|---|---|
| **[P-003] Zero Scraping** | Dados exclusivamente do Supabase populado via API Claude. Proibido buscar dados externos no frontend. |
| **[P-006] Burn Rate Shield** | Limite $5,00/dia. Kill-switch obrigatório aos 70% da cota. |
| **[P-010] Gate Verificável** | Nenhum dia avança sem output real aprovado pelo Diretor. |
| **[P-023] BLOQUEIO COMERCIAL** | PWA NÃO é entregue à Ingrid até aceite do Termo de Uso. Clickwrap resolve em código no Dia 6. |
| **[P-024] Cargo 202** | Todo conteúdo retornado pela UI reflete estritamente Cargo 202. Não TDAS área social. |
| **[P-025] 7 Panes Supabase** | Ver troubleshooting documentado antes de escalar qualquer erro de Edge Function. |
| **[P-031] Filtro de Realidade** | Ingrid repele jargão técnico e UI complexa. 1 clique para estudar. Frases E-2/E-5 são retenção, não UX secundária. |

---

## ⚙️ SEQUÊNCIA DE BUILD (DIAS 6–8)

### DIA 6 — UI Mockada + Clickwrap + Âncoras Emocionais
**PRIMEIRA TAREFA:** Clickwrap de Termo de Uso (resolve P-023)
- Primeira tela do PWA: "Ao clicar em Iniciar, declaro que li e concordo com os Termos de Uso"
- Clique grava `user_id + timestamp + versao_termo + hash_sha256` na tabela `termos_aceitos`
- Skip automático se já aceitou (verifica tabela ao iniciar)

**Frase de Abertura E-2 — lógica de dois estados:**
- `if total_respostas == 0` → cold start: *"Hoje começamos pelo Peso 2 — Direito Administrativo cai mais que qualquer outra."*
- `if total_respostas > 0` → *"Hoje atacamos o que travou você ontem: [matéria do último erro]."*

**Frase de Encerramento E-5 — com threshold:**
- Exibir somente se `total_respostas >= 10`
- Formato: *"15 questões hoje. 87 esta semana. Continua."* — fato + fato + imperativo. Sem confete, sem "parabéns".
- Número vem de RPC `get_total_respostas_ingrid` — não contagem no frontend

**Número principal da tela:** Pontos Ponderados (cláusula 2 do contrato). Não Score de Sobrevivência.

**Restante do Dia 6:**
- Esqueleto HTML/CSS/JS Vanilla, mobile-first
- Barra de progresso por disciplina Peso 2
- Auth hardcoded via `user_id`
- Debug Mode: 5 toques no logo → painel colapsável (questão ID, disciplina, peso SM-2, cache hit/miss, custo estimado). Ingrid nunca digita query string.

**GATE Dia 6:** Diretor testa layout estático no celular. Aprovação visual obrigatória antes do Dia 7.

---

### DIA 7 — Supabase + Tutor Socrático + Telemetria
**Conexão Supabase:**
- Conectar à view `questoes_nao_respondidas` (feed 70/30 já validado)
- Capturar `started_at = Date.now()` ao renderizar cada questão
- POST de resposta inclui `tempo_resposta_ms` (TTI)
  - TTI < 30s + erro = desatenção → Tutor usa tom direto
  - TTI > 2min + erro = lacuna de teoria → Tutor aprofunda conceito
  - TTI < 10s + acerto = possível chute → registrar como `acerto_provavel_chute: true` (não confia no SM-2 para espaçar muito)

**Campo obrigatório no banco (business case P-035/E-4):**
- Registrar em cada resposta: `distrator_escolhido`, `nivel_tutor_disparado` (1, 2 ou 3)
- Isso gera a curva de erro/distrator nas primeiras 3 sessões = dado de pitch para 500 candidatos Quadrix

**Tutor Socrático em 3 Níveis (cache-first):**
1. Tutor checa `explicacao_tutor` no Supabase — se hit, retorna sem chamar API
2. Se miss → chama Claude Haiku com contexto do erro
   - **1º erro na questão:** explica o conceito da alternativa correta
   - **2º erro na mesma questão:** ataca o distrator específico que a Ingrid escolheu
   - **3º erro:** analogia — conecta o conceito a algo da vida cotidiana
3. Grava resultado no cache `explicacao_tutor` (P-006)
4. Tom: `tone: "austere"` — professor exigente que acredita no aluno. Se soar AI-frio ("Vamos analisar...") → reformular como "servidor concursado experiente, sem rodeios".

**Proteções de API:**
- Debounce no botão "Responder": `disabled = true` no primeiro toque, reativa após resposta (N-3)
- Override Admin: URL `?admin=<token_secreto>` aceita JSON de peso por disciplina, força cache reset (G-1)

**RPC get_total_respostas_ingrid:** Stored Procedure — retorna inteiro total. Alimenta E-5 sem baixar histórico.

**GATE Dia 7:** Log do Supabase confirma cache hit no Tutor (zero chamada duplicada). Diretor valida via debug (5 toques no logo).

---

### DIA 8 — Fallback + Proteções Finais + Gate Comercial
**Fallback de Fadiga (P-006):**
- Monitor de cota: ao bater 70% de $5,00/dia → kill-switch da API
- Simular antes de deploar: quantas questões até o fallback disparar? Se < 15 → ajustar threshold.
- Modo passivo: exibe `explicacao_base` já nas questões do banco
- Graceful Degradation: Edge Function falha → cache → `explicacao_base` → nunca tela branca.

**Sanitização de Sessão Stale (N-4):**
- `document.hidden` listener: se aba ficar inativa > 4h → `window.location.reload()` silencioso

**Log de Abandono (N-5):**
- Se Ingrid abrir, visualizar questão e fechar sem responder em 2 min → `navigator.sendBeacon` grava em `abandonment_log`
- **Padrão, não evento único:** acionar alerta ao Embaixador somente após 3+ abandonos na mesma semana. Único abandono pode ser gestão de contexto (ônibus, reunião).

**GATE Dia 8 — Comercial (P-023):**
- Ingrid responde 10 questões reais, progresso salvo, fallback testado
- Gate só é válido se `termos_aceitos` tiver registro da Ingrid
- **Componente de captura de voz:** Eduardo pede 3 frases via WhatsApp após a sessão — "como foi?" — sem mencionar tecnologia. Sem isso, Loop 4 continua operando com dados [INFERIDO].
- **Eduardo planta no Gate Dia 8:** *"Você conhece mais alguém prestando concurso esse ano?"* (protocolo Embaixador [E-2])
- Embaixador reporta temperatura da cliente após o Gate

---

## 🚫 O QUE NÃO CONSTRUIR NESTE LOOP

| Item | Razão |
|---|---|
| Score de Sobrevivência | Depende de modelo de corte inexistente; contradiz cláusula 2 do contrato |
| IndexedDB / sincronização offline | Dívida técnica desnecessária no prazo |
| Web Speech API / áudio | Veto P-016 + P-031 |
| Modo Revisão Express (5 min) | Vetado — bifurcar modos antes de validar feed principal |
| Distrator Vingativo em Loop | V2 — 4h+, registrado como P-034 |
| Dashboards analíticos | Dispersa foco. 1 clique para estudar (P-031) |
| Modais de antievasão | Vetado — incompatível com perfil da Ingrid |
| Edge Function monolítica | Vetado M-11 |
| Alterar fórmula SM-2 | Vetado M-13 |

---

## 🔗 CONEXÃO HISTÓRICA

**Loop 1 provou:** banco de questões via API Claude é viável (Gate Dia 2 aprovado).
**Loop 2 provou:** Edge Functions + feed 70/30 + SM-2 operacional (Gate Dia 5 aprovado).
**Loop 3 constrói:** interface que conecta o backend à mão da Ingrid + Tutor Socrático + proteções.

---

## 💡 PERSPECTIVA DO SÓCIO (AUDITOR — PARTE 2)

A Janela de Adesão Emocional é o risco real do Dia 8. As frases E-2 e E-5 não são decoração — são o mecanismo de retenção para este perfil. O cold start da E-2 (primeiro dia sem "ontem") é crítico: se a frase falhar na primeira sessão, Ingrid não experimenta o app que "te conhece" — experimenta um app genérico. O TTI com registro de chute vs. conhecimento cria o ativo de dados que prova o ROI do Sovereign Study Engine para os próximos 50.000 candidatos Quadrix.

---

## 🔬 ANÁLISE CIRÚRGICA [G+N] QUALIFICADOS

### Estrategista [G-1 a G-5]

| Ideia | Veredito | Onde |
|---|---|---|
| G-1 Inject Focus Override | ENTRA modificado — URL `?admin=<token>` | Dia 7 |
| G-2 Telemetria TTI | ENTRA + TTI de acertos < 10s | Dia 7 |
| G-3 Distrator Vingativo | V2 — 4h+, inviável | — |
| G-4 Clickwrap Termo | ENTRA PRIORIDADE MÁXIMA | Dia 6 |
| G-5 Cínico Socrático | ENTRA — `tone: "austere"` | Dia 7 |

### Auditor [N-1 a N-5]

| Ideia | Veredito | Onde |
|---|---|---|
| N-1 Clickwrap Front-end | ENTRA — convergência com G-4 | Dia 6 |
| N-2 RPC get_total_respostas | ENTRA | Dia 7/8 |
| N-3 Debounce Anti-Duplicação | ENTRA OBRIGATÓRIO | Dia 7 |
| N-4 Sanitização Sessão Stale | ENTRA | Dia 8 |
| N-5 Beacon Abandono | ENTRA modificado — padrão 3+/semana | Dia 8 |

---

## 💥 [M'-1 a M'-5] — NOVAS IDEIAS DO MÚSCULO (análise cruzada G+N)

1. **M'-1 — Frase de Abertura com Cold Start:** E-2 tem dois estados — primeira sessão puxa do edital; sessões 2+ puxam do último erro. Nunca genérica.

2. **M'-2 — Pontos Ponderados como único número:** Única métrica visível. Honesto e contratual. Score de Sobrevivência é V2 após 3+ provas com corte real.

3. **M'-3 — Debug Mode por Gesto:** 5 toques no logo → painel colapsável. Ingrid nunca digita query string.

4. **M'-4 — Curva Erro/Distrator/Nível Tutor:** Campo explícito no banco desde a sessão 1. Gera o ativo de dados para o pitch de escala.

5. **M'-5 — Gate Dia 8 com Captura de Voz:** Eduardo pede 3 frases WhatsApp após as 10 questões. Sem isso, Loop 4 opera com inferência, não com evidência.

---

## 🧭 [E-1 a E-5] DO EMBAIXADOR (filtro de realidade — 2026-05-18)

| # | Contribuição | Ação para o build |
|---|---|---|
| [E-1] | Vanguard como investidor de relacionamento — gerar "Resumo da Entrega" no Gate Dia 15 | Protocolo operacional — não código |
| [E-2] | Plantar pergunta sobre rede de concurseiras no Gate Dia 8 | Protocolo Eduardo |
| [E-3] | R$97/mês é teto receptivo; real pode ser R$150 | Monitorar reação dela ao ouvir o número |
| [E-4] | Curva de erro/distrator nas 3 primeiras sessões = pitch gold | Campo `distrator_escolhido` obrigatório no banco |
| [E-5] | Clickwrap em D1 vira regra Vanguard | P-XXX candidato ao LEDGER |
