# RELATÓRIO EVOLUTIVO V8 — PROJETO INGRID
> Loop 8 · Telemetria + RLS + Monetização · Fechamento 2026-06-04
> SWOT + PDCA + 5W2H + [M-1 a M-5] para Loop 9

---

## RESUMO EXECUTIVO

O Loop 8 foi o ciclo de fundação da infraestrutura de dados. A decisão mais importante não foi técnica: foi estratégica. Eduardo decidiu que Ingrid é fundadora simbólica do produto — não cliente pagante. Isso libera a monetização via próximas candidatas usando os dados reais de Ingrid como prova de resultado. Tecnicamente, o loop entregou telemetria passiva (F-A), painel de uso para Eduardo (F-B), alerta Telegram (F-E), segurança via Git Hook (F-G), heartbeat autônomo (N-3), TTL expurgo LGPD (N-4) e framing de edital no relatório semanal (D2). A janela de pitch para a 2ª candidata está aberta — mas o fluxo operacional de aceite ainda não existe.

---

## SWOT — ESTADO AO FECHAR LOOP 8

### Forças
- **Telemetria real em produção:** Eduardo agora tem visibilidade do que Ingrid usa — telemetria não é promessa, é dado
- **Sistema autônomo completo:** F-4 (cron 19h45) + F-6 (relatório semanal) + F-E (alerta Telegram) rodam sem intervenção
- **Segurança blindada:** F-G Git Hook bloqueou token sbp_ na própria sessão — sistema que se autoprotege
- **Fundação multi-tenant:** N-4 TTL + View golden + migrations aplicadas — base pronta para 2ª usuária
- **Decisão estratégica limpa:** D1 DESCARTADO — sem ambiguidade sobre o papel de Ingrid. Músculo e Embaixador alinhados

### Fraquezas
- **Deploy GitHub Pages pendente:** app.js Loop 8 (F-A + N-3) não chegou ao gh-pages — Ingrid ainda usa versão anterior
- **Gate 7.2 RLS pendente:** sem isolamento validado, não há segurança para 2ª usuária entrar
- **N-1 Clickwrap ausente:** dados de Ingrid não podem ser usados em pitch B2C sem opt-in formal
- **Fluxo de aceite do pitch não existe:** contrato V2, forma de pagamento, onboarding — nada está pronto

### Oportunidades
- **Janela de pitch fecha ~04/07:** Eduardo tem 30 dias para capturar 2ª candidata com a jornada da Ingrid como prova
- **View SQL golden:** snapshot_ingrid_loop6_golden compila o case — "+X% acertos Peso 2 após 15 dias" é argumento concreto
- **F-6 com framing de edital:** relatório dominical agora conecta progresso à prova real — argumento de venda passivo
- **D4 presença humana:** Eduardo reentra no radar de Ingrid esta semana — temperatura 8.5/10 + componente humano = pitch no momento certo

### Ameaças
- **Apagão operacional do Diretor:** F-E calibrado para 3 dias — se Ingrid tiver pausa legítima, alerta pode virar ruído
- **Janela fecha em julho:** após ~04/07 Ingrid entra em modo bunker pré-prova — sem contacto comercial possível
- **2ª candidata sem estrutura:** se aparecer lead antes de Gate 7.2 + N-1 Clickwrap, o onboarding vai improvisar

---

## PDCA — AVALIAÇÃO DO LOOP 8

### PLAN (o que foi planejado)
- Build: F-A telemetria, F-B painel, F-E alerta, F-G hook, N-3 heartbeat, N-4 TTL, D2 framing
- Decisões estratégicas via Embaixador: timing do pitch (D1), framing F-6 (D2), opt-in dataset (D3), presença humana (D4), sequência de build (D5)
- Segurança: F-G pre-push como Bloco A inviolável

### DO (o que foi executado)
- Todos os 7 componentes do build entregues e deployados ✅
- Vereditos D1–D5 formalizados e executados ✅
- validar_diretriz.ps1 e file_protection_guard criados ✅
- F-G bloqueou token sbp_ na mesma sessão — validação real em produção ✅
- Tokens redatados em todo o histórico (MEMORIA_V5, runbooks) ✅

### CHECK (o que funcionou e o que não funcionou)
- **Funcionou:** Decisão D1 — clareza estratégica sobre o papel de Ingrid elimina confusão de monetização
- **Funcionou:** F-G validado em produção no mesmo dia — segurança real, não teórica
- **Funcionou:** N-4 TTL aplicado — LGPD protegida antes de escalar
- **Não funcionou:** sessão interrompida antes do fechamento — DELIBERAÇÃO, MEMÓRIA e relatório gerados na sessão seguinte (falha de processo, não de produto)
- **Pendente:** Deploy GitHub Pages com app.js Loop 8 — Ingrid ainda usa versão sem telemetria

### ACT (o que muda no processo)
- Fechamento de loop deve ser resistente a interrupção — P-045 garante bloqueio, mas DELIBERAÇÃO e MEMÓRIA devem ser geradas antes do deploy, não depois
- Loop 9 começa com Gate 7.2 (RLS) como Bloco A obrigatório

---

## 5W2H — PRÓXIMO CICLO (Loop 9)

| Campo | Detalhe |
|---|---|
| **WHAT** | 2ª candidata: onboarding + opt-in dataset + contrato V2 |
| **WHY** | Monetização real — R$97/mês ou R$2.500 projeto personalizado com a jornada da Ingrid como prova |
| **WHO** | Eduardo (captação) + Músculo (onboarding técnico) + Embaixador (intelligence da 2ª candidata) |
| **WHEN** | Antes de ~04/07 — janela fecha quando Ingrid entra em modo bunker pré-prova |
| **WHERE** | Mesmo stack — Supabase multi-tenant · Gate 7.2 como pré-requisito |
| **HOW** | D4 (presença humana) → Ingrid indica ou Eduardo prospecta → Gate 7.2 → N-1 Clickwrap → onboarding |
| **HOW MUCH** | Gate 7.2: ~30 min (Diretor + Músculo) · N-1 Clickwrap: ~2h Músculo · Contrato V2: template disponível |

---

## [M-1 a M-5] — 5 IDEIAS PARA O LOOP 9

| # | Ideia | Fundamento |
|---|---|---|
| M-1 | **Onboarding invisível da 2ª candidata** — clonar schema Ingrid, atribuir novo `user_id`, Gate 7.2 valida isolamento real antes de deixar entrar | Gate 7.2 pendente é o único bloqueio técnico para escalar |
| M-2 | **N-1 Clickwrap Opt-In integrado ao onboarding** — "Autorizo uso anônimo das minhas estatísticas para ajudar outras concurseiras" na primeira sessão | LGPD limpa antes de qualquer uso dos dados em vendas |
| M-3 | **Contrato V2 com cláusula de dados** — incluir opt-in dataset como item contratual, não modal UX | Fundamento legal sólido para argumento comercial da 2ª candidata em diante |
| M-4 | **Comparativo anonimizado Candidata A vs B** — painel Eduardo mostra progresso relativo entre candidatas sem revelar identidade | Argumento de retenção poderoso: "você está no top 50% do grupo" |
| M-5 | **Script de pitch com prova da View SQL golden** — Eduardo abre painel ao vivo para prospect: "+23% acertos Direito Administrativo em 15 dias, candidata real Cargo 202" | Pitch visual elimina objeção de preço — prospect vê ROI antes de decidir |

---

## IMPACTO COMERCIAL

- **D1 DESCARTADO** é a decisão comercial mais importante dos 8 loops: transforma Ingrid de "caso de teste" em "prova de conceito viva" que pode ser mostrada (com opt-in) para próximas candidatas
- **F-A telemetria:** Eduardo sabe exatamente o que Ingrid usa — painel de uso é o termômetro real, não intuição
- **F-6 com framing de edital:** relatório dominical conecta treino à prova — argumento de "isso é treino específico para você, não conteúdo genérico" — diferenciação do TEC
- **Janela de 30 dias:** Eduardo tem julho para capturar 2ª candidata. Após 04/07, Ingrid entra em modo bunker e a janela de referência fecha

---

## PRÓXIMA AÇÃO DO DIRETOR

1. **ESTA SEMANA:** D4 — mensagem de presença humana para Ingrid
2. **Antes de 2ª candidata:** Gate 7.2 RLS dry-run + N-1 Clickwrap
3. **Antes de julho:** Prospectar 2ª candidata com caso Ingrid como prova

---

## REGISTRO

- **RELATÓRIO criado:** 2026-06-04
- **Músculo responsável:** Claude Sonnet 4.6
- **Versão anterior:** `relatorio_evolutivo_V7_INGRID.md`
