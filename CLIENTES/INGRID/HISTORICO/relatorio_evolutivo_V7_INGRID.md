# RELATÓRIO EVOLUTIVO V7 — PROJETO INGRID
> Loop 7 · SaaS Readiness + Pipeline Comercial · Fechamento 2026-05-30
> SWOT + PDCA + 5W2H + [M-1 a M-5] para Loop 8

---

## RESUMO EXECUTIVO

O Loop 7 foi um ciclo de deliberação, não de build. A barreira técnica (GitHub Security + deploy CLI) bloqueou a construção das features aprovadas, mas o ciclo produziu três ativos estratégicos de alto valor: (1) o Painel de Deliberação com 6 decisões formalizadas pelos 4 sócios, (2) ferramentas de processo que tornam o sistema mais robusto (Gate 0, Gate 9B, render_painel corrigido, P-091), e (3) inteligência do Embaixador que revelou um gap crítico de dados (24/05–30/05 sem registro de uso) antes que se tornasse churn silencioso.

---

## SWOT — ESTADO AO FECHAR LOOP 7

### Forças
- **Sistema autônomo em produção:** F-1, F-2, F-5, F-7, F-8 operam sem intervenção — "o app trabalha mesmo quando ninguém trabalha"
- **Soberania confirmada:** Ingrid admin do próprio Supabase (P-013 VERDE 2026-05-30)
- **Temperatura sustentada:** 7.5/10 sem intervenção ativa do Eduardo — H-8 confirmada (shift de player)
- **Processo mais robusto:** P-091 + Gate 0 + Gate 9B + render_painel bug fix — o sistema detecta suas próprias inconsistências
- **Inteligência do Embaixador consolidada:** 15 inputs deliberados individualmente — novo padrão estabelecido

### Fraquezas
- **Deploy CLI bloqueado:** F-4 (cron 19h45) e F-6 (relatório semanal) ainda manuais — risco real no primeiro domingo
- **GitHub Pages comprometido:** cada deploy exige workaround — velocidade de resposta a bugs reduzida
- **Telemetria ausente:** sem `evento_uso`, Eduardo voa às cegas sobre o que Ingrid efetivamente usa
- **Gap de dados 24/05–30/05:** 6 dias sem registro de uso confirmado — temperatura pode estar desatualizada

### Oportunidades
- **F-6 como argumento de pitch:** relatório semanal autônomo é o melhor argumento para R$97/mês — cada semana de operação autônoma é evidência do produto
- **Debrief 31/05 como gate informal de pitch:** resposta de Ingrid ao check-in define se pitch pode avançar
- **View SQL golden:** 102 registros = business case concreto — "X% em Direito Administrativo, SM-2 calibrado para você"
- **Motor replicável em 3 dias:** onboarding de segunda usuária depende só de RLS validado (Gate 7.2 → Loop 8)

### Ameaças
- **Apagão dominical:** se F-4/F-6 não deployados antes do próximo domingo, primeiro relatório semanal falha — pior momento para a percepção de sistema instável
- **Churn silencioso pós-entrega técnica:** Gate Dia 15 foi tarefa administrativa — Ingrid pode ter sentido abandono sem que Eduardo perceba
- **DATA-GAP:** 6 dias sem registro obrigam debrief antes de qualquer decisão comercial

---

## PDCA — AVALIAÇÃO DO LOOP 7

### PLAN (o que foi planejado)
- Resolver bloqueios técnicos: deploy CLI + GitHub Security
- SaaS Readiness Audit: RLS, telemetria, painel de uso
- Pipeline comercial: debrief casual + semente E-4
- 8 features (F-A a F-H) aprovadas na DELIBERAÇÃO P-037

### DO (o que foi executado)
- DELIBERAÇÃO P-037 completa com 25 inputs + filtro do Embaixador
- Vereditos formalizados via Painel HTML
- Gate 0 (P-091) + Gate 9B + render_painel corrigido
- test_tenant_isolation.ps1 criado (Gate 7.2 pronto para Loop 8)
- D3 mensagem no clipboard (debrief 31/05)
- D1/D2/D4/D6 registrados como pendências — Diretor saiu antes de executar

### CHECK (o que funcionou e o que não funcionou)
- **Funcionou:** Painel de deliberação — 6 decisões formalizadas em 1 fluxo
- **Funcionou:** Embaixador deliberou todos os 15 inputs individualmente — novo padrão validado
- **Funcionou:** render_painel bug fix — campos ausentes injetados automaticamente (problema detectado e resolvido na mesma sessão)
- **Funcionou:** P-091 detectou inconsistência WIP_BOARD vs disco antes de comprometer o processo
- **Não funcionou:** deploy CLI — supabase login interativo bloqueou execução autônoma
- **Não funcionou:** GitHub Security — requer presença física do Diretor no browser

### ACT (o que muda no próximo loop)
- Loop 8 começa com D4 (GitHub Security) → D1 (deploy) → build F-A a F-H
- `gerar_sintese_conselho.ps1` disponível para acelerar P-037
- Gate 0 e Gate 9B protegem o processo de inconsistências silenciosas

---

## 5W2H — LOOP 8

| Dimensão | Resposta |
|---|---|
| **What** | Deploy F-4+F-6 · GitHub Security · Telemetria · Painel Eduardo · Git Hook · View SQL golden |
| **Why** | F-4/F-6 manuais = risco de falha no domingo · Telemetria = decisão informada no pitch · Painel = Eduardo vê sem perguntar |
| **Who** | Eduardo (GitHub Security + debrief) · Músculo (deploy + build F-A a F-H) |
| **When** | Próxima sessão disponível — urgência: antes do próximo domingo |
| **Where** | Terminal (`supabase login`) · GitHub Security · app.js · Edge Functions |
| **How** | D4 → D1 → F-A → F-B → F-C → F-D → F-E → F-F → F-G → F-H → v21 |
| **How much** | ~4h build · $0 infra adicional · supabase login: 5 min Eduardo |

---

## 5 IDEIAS DISRUPTIVAS [M-1 a M-5] — Para o Gemini V8 processar

**[M-1] Dashboard de Ritmo de Aprovação — não de acerto**
Painel Eduardo mostra: "No ritmo atual, Ingrid chegará à prova com X questões estudadas e Y% de consistência semanal." Não é nota — é trajetória. Eduardo vê se Ingrid vai chegar ou não sem perguntar. Feature de 2h que transforma dados brutos em argumento de pitch concreto.

**[M-2] Certificado de Consistência Semanal (não de aprovação)**
Todo domingo: Ingrid recebe card visual PNG com "7/7 dias esta semana — você não parou." Diferente do Brasão já implementado (baseado em semanas desde início), este é semanal e binário — ou fez ou não fez. Mais urgente, mais visceral. Custo: extensão do F-6 existente.

**[M-3] Modo Silêncio — 3 dias sem sessão aciona série de mensagens progressivas**
Dia 3: "Boa noite, sentimos sua falta." Dia 5: "Faltam N dias — 10 questões agora?" Dia 7: "Eduardo enviou um recado." (aciona Pulse Check manual). Progressivo, não agressivo. Complementa M-5 do Loop 7 (alerta compound do Telegram) com ação do lado do app.

**[M-4] Benchmark de Candidatas Similares (anônimo)**
Quando a segunda usuária entrar: "Candidatas no seu ritmo acertam em média X% em Direito Administrativo na reta final." Ingrid compara com par invisível, não com nota genérica. Requer segunda usuária (Gate 7.2 desbloqueado). Custo: query simples quando multi-tenant ativo.

**[M-5] Página de Apresentação do Produto — SaaS Readiness Comercial**
Uma página pública (sem login) com: o que é o produto, como funciona, o que uma candidata recebe. Não exibe dados da Ingrid — é landing page para a próxima candidata. Eduardo envia o link em vez de explicar. Custo: 2h HTML estático, zero backend.

---

## ANÁLISE COMERCIAL

**O que este ciclo significou para o negócio:**
O Loop 7 não entregou features para Ingrid, mas entregou algo mais valioso: clareza sobre o que bloqueia o pitch e o que o desbloqueia. O debrief de 31/05 é o gate informal — se Ingrid confirmar uso nos últimos 6 dias e verbalizar progresso, a janela de R$97/mês está aberta. Se não confirmar, o sistema detecta silêncio antes do churn.

**O bloqueio técnico como revelação estratégica:**
D1 não pôde ser executado porque exige `supabase login` interativo. Isso revelou uma dependência oculta: todo deploy de Edge Function requer presença do Diretor no terminal. Para escala de 500 usuárias, este modelo não funciona. Loop 8 deve incluir automação de deploy via CI/CD ou service account — antes que a dependência trave o crescimento.

**Próxima janela comercial:**
- Pitch R$97/mês: debrief 31/05 → se temperatura confirmada → pitch na semana de 02/06
- Semente E-4: aguarda sessão com engajamento verbal mais alto (decisão soberana do Diretor)

---

*Músculo — Pentalateral IAH — 2026-05-30*
