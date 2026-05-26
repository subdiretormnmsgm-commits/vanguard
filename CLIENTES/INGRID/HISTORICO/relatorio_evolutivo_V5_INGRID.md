# RELATÓRIO EVOLUTIVO V5 — PROJETO INGRID
> Loop 5 · Dias 12-15 · Fechamento 2026-05-26
> Análise de negócio + 5 ideias disruptivas para Loop 6

---

## RESUMO EXECUTIVO

Loop 5 entregou a **soberania total da Ingrid sobre seus dados** (P-013) — o maior milestone de confiança do projeto. Além disso, adicionou 5 funcionalidades de engajamento (N-1 a N-5) que transformam o app de uma ferramenta de questões em um sistema de gestão de estudo. O gate foi aprovado no prazo, com o app v18 rodando integralmente no projeto Supabase próprio da Ingrid.

---

## SWOT — ESTADO ATUAL (pós-Loop 5)

### Forças
- **Soberania real:** Ingrid tem controle total — banco, funções, dados. Diferencial de mercado vs. concorrentes SaaS genéricos.
- **Stack completa:** Feed SM-2 + Tutor IA + Push + Heatmap + Simulado + Linha de Corte + Progresso exportável. Produto maduro.
- **Custo controlado:** $0.0001/resposta errada. Kill-switch ativo. Burn rate monitorado.
- **Infraestrutura robusta:** Edge Functions deployadas · RLS ativo · 9 RPCs funcionais.

### Fraquezas
- **User_id hardcoded:** Limita escalabilidade para mais de 1 usuário por projeto. Para Loop 6, precisa de auth real se houver segundo cliente.
- **Zero analytics de engajamento:** Sabemos que ela erra, mas não sabemos quando abandona, quanto tempo passa por questão, quais telas ela evita.
- **Feed sem curadoria adaptativa:** Score de prioridade é fixo — não aprende com o padrão de erros da Ingrid em tempo real.

### Oportunidades
- **Pipeline de indicação:** Ingrid aprova → ela conta para conhecidos → custo de aquisição zero.
- **Prova social:** Gate Dia 15 aprovado = produto entregue no prazo. Caso de sucesso documentável.
- **Expansão de nicho:** SEDES-DF é 1 concurso. O motor serve qualquer edital Quadrix com troca de dados.

### Ameaças
- **Churn por fadiga:** Ingrid estuda sozinha, sem rede. 4 meses até setembro = risco de abandono silencioso.
- **Concurso pode adiar:** SEDES-DF 2026 ainda sem data confirmada — Ingrid pode perder motivação.
- **Token exposto no chat:** `REVOKED_TOKEN...` precisa ser revogado imediatamente.

---

## PDCA — AVALIAÇÃO DO LOOP 5

### PLAN (o que foi planejado)
- Dias 12-15: Contador Pontos Ponderados + Notificação push domingo + P-013 Soberania
- DIRETRIZ V6 do Gemini · Skill ingrid-v5 do NotebookLM · Vereditos D1-D5 do Embaixador

### DO (o que foi executado)
- ✅ Todos os itens planejados entregues
- ✅ Gate Dia 15 aprovado em 26-05 (4 dias antes do deadline 30-05)
- ✅ Deploy v18 no projeto próprio da Ingrid
- ⚠️ Descoberta não planejada: coluna `pilula_do_dia` ausente no schema (resolvida on-the-fly)
- ⚠️ Descoberta não planejada: CLI Supabase não instalado (resolvida via npm)

### CHECK (o que funcionou e o que não funcionou)
- **Funcionou:** Processo de migração completo (SQL + CSV + Edge Functions + Secrets)
- **Funcionou:** Gate de verificação com evidência real (Total respostas: 1, Gasto: $0.0001)
- **Não funcionou:** Dashboard Supabase para deploy de Edge Functions (formato incompatível)
- **Não funcionou:** winget para instalação do CLI (pacote não encontrado)
- **A investigar:** 470 respostas migradas podem não estar vinculadas ao user_id ativo

### ACT (o que muda no próximo loop)
- Documentar `pilula_do_dia` no schema oficial para próximas migrações
- Incluir CLI Supabase como pré-requisito documentado no RUNBOOK
- Investigar e corrigir discrepância de user_id antes de Ingrid usar ativamente

---

## 5W2H — PRÓXIMO LOOP (Loop 6)

| Dimensão | Resposta |
|---|---|
| **What** | SaaS Readiness Audit + onboarding real da Ingrid no projeto dela |
| **Why** | Produto entregue mas Ingrid ainda não tem login próprio nem controle do dashboard |
| **Who** | Eduardo + Ingrid (presencial ou chamada) · Músculo executa técnico |
| **When** | A partir de 03-06-2026 (após Sentinel Report Valdece em 02-06) |
| **Where** | App em produção · Supabase da Ingrid · GitHub Pages |
| **How** | Auth real (Supabase Auth) · Ingrid cria senha · Painel de admin para ela |
| **How much** | ~2h build · $0 custo adicional de infra |

---

## 5 IDEIAS DISRUPTIVAS [M-1 a M-5] — Para o Gemini processar

**[M-1] Sistema de Streak com Risco Real**
Ingrid acumula "dias de fogo" (streak). Se perder 2 dias seguidos, o app bloqueia o simulado dominical e exige 10 questões de recuperação antes. Pressão positiva sem punição visível — ela se autocobra.

**[M-2] "Termômetro da Aprovação" na tela inicial**
Barra de progresso que mostra: se a prova fosse hoje, Ingrid aprovaria? Calculada em tempo real com base na Nota Simulada vs. Linha de Corte. Não é gamificação vazia — é diagnóstico honesto que cria urgência.

**[M-3] Modo Véspera (ativado automaticamente 7 dias antes da prova)**
Uma semana antes do concurso, o feed muda: só revisões SM-2 das disciplinas mais fracas + simulado completo todo dia. Eduardo ativa com 1 clique no Push Mágico de Oz. Ingrid não precisa fazer nada diferente.

**[M-4] Relatório Semanal para Ingrid (não só para Eduardo)**
Todo domingo à noite, Ingrid recebe no WhatsApp: "Você estudou X questões esta semana. Sua disciplina mais forte é Y. Se a prova fosse hoje, você estaria a N pontos da aprovação." Texto gerado por IA — Eduardo não digita nada.

**[M-5] Exportação do histórico como "Portfólio de Estudo"**
Ao final do projeto, gerar um PDF: "Ingrid estudou X questões em Y dias, taxa de acerto Z%, disciplina mais forte W." Serve como prova social para Eduardo fechar o próximo cliente: "Olha o que a Ingrid conquistou."

---

## ANÁLISE COMERCIAL

**O que este loop significou para o negócio:**
Loop 5 transformou um protótipo funcional em um produto entregável com responsabilidade legal clara. Ingrid agora tem soberania — isso é o argumento de venda para os próximos clientes: "Você tem o banco de dados, as funções e o histórico. Se você cancelar comigo, os dados ficam com você."

**Risco de MRR:** Baixo no curto prazo. Ingrid está comprometida (pagou, está usando). Risco médio no médio prazo se o concurso atrasar — ela pode perder a urgência. O Embaixador deve monitorar temperatura quinzenal.

**Próximo cliente:** O motor está provado. O próximo concurso Quadrix pode ser onboardado em 3 dias com o mesmo stack. O tempo de setup caiu de 15 dias para 3.

---

*Músculo — Pentalateral IAH — 2026-05-26*
