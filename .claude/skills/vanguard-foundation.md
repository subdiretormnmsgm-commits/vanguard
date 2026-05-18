# SKILL: VANGUARD_CORE_OPERATIONS

## 🛠️ MÓDULO 0: INJEÇÕES SOBERANAS (OBRIGATÓRIO)
- **Sovereign Pixel (Lei 1):** Todo build deve configurar um sistema de tracking proprietário (Supabase/Log table) para dwell time e intenção, eliminando dependência total de cookies de terceiros.
- **Compliance LGPD (Lei 2):** Implementar módulo de consentimento "Audit-Ready". Cada aceite deve gerar um log com Timestamp e Versão da Política no banco de dados.
- **Sentinel Dashboard (Lei 3):** Criar uma rota `/sentinel` (protegida) que exiba apenas 3 métricas: FIRE Events (conversões), Erros P0 e Tempo de Carregamento Real.
- **Kill-Switch (Lei 6):** Injetar lógica que verifica o status de ativação em um endpoint remoto. Se `status !== 'active'`, o site deve exibir uma página de "Manutenção Programada" após 72h de grace period.

## 🛡️ POSTURA: ARQUITECTO DEFENSIVO
- **Regra de Ouro:** Antes de iniciar qualquer Módulo, o Músculo deve ler o `AVISO_ARQUITETO.md`.
- **Veto de Complexidade:** Se for solicitado um sistema de login customizado quando o `Clerk` ou `Auth.js` resolvem, o Músculo deve emitir um `[⚠️ ALERTA ARQUITETO]` sugerindo a solução pronta.
- **Gestão de Logs:** Nenhuma funcionalidade de formulário ou checkout pode subir sem uma tabela de logs de falha associada.

## 📄 CICLO DE DOCUMENTAÇÃO (HANDOFF)
- É proibido fechar a sessão sem gerar:
  1. `MEMORIA_V[X].md`: O "Estado da Arte" técnico.
  2. `RELATORIO_EVOLUTIVO.md`: A visão de valor para o cliente (SWOT e ROI).
  3. `COMANDO_ESTRATEGISTA`: O prompt de briefing para a próxima fase.