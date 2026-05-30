SKILL: ingrid-v7.md
**Camada:** 3 (SaaS Readiness) | **Loop:** #7 | **Stack:** PWA Vanilla JS + Supabase + CLI GitHub/Deploy

## [AUDITORIA DE COERENCIA]
A transição para o estado de "SaaS Readiness" (Camada 3) é integralmente suportada pelo *DADOS-WATCH* em estado VERDE SUSTENTADO (102 respostas e telemetria isolada para 1 `user_id`) [4, 5]. No entanto, a execução manual das *Edge Functions* F-4 e F-6 viola a premissa de um sistema autônomo e de baixa fricção para o operador. A DIRETRIZ V7 exige o deploy imediato via CLI para sanar este débito [6-8]. O *dry-run* de isolamento de *tenant* (ideia G-2) garante a obediência cega ao princípio **[P-059]** (Isolamento de Contexto) antes de darmos o *GO* para novos usuários [9-11].

## [CONEXAO HISTORICA]
O histórico do PROJ-001 (Valdece) documentou no princípio **[P-046]** que a formalização e a escala comercial não podem preceder a validação técnica impecável no ambiente real [12, 13]. Ao exigir o "SaaS Readiness Audit" agora [7, 8], o sistema previne o erro agudo de tentar embarcar um segundo cliente B2C sem comprovar o bloqueio de RLS. A estratégia inicial de operar com "Mágico de Oz" para notificações dominicais replicou o sucesso do *Mágico de Oz Gate CLI* validado nos primeiros dias da Vanguard [14], mas precisa ser superada técnica e definitivamente neste loop [7, 8].

## [PADRAO DE SUCESSO/FALHA]
*   **Sucesso:** A manutenção da restrição **[P-045]**, proibindo a implementação de telas de login multifator no MVP, manteve a fricção da cliente próxima a zero, resultando no engajamento necessário para consolidar 102 registros limpos de progresso [4, 15, 16].
*   **Falha:** O bloqueio da branch `gh-pages` por vazamento de token no histórico e a ausência de autenticação do Supabase via CLI evidenciaram uma negligência com a governança de credenciais, o que fere a autonomia de deploy do Músculo e cria vulnerabilidade processual [6, 7, 17].

## [PERSPECTIVA DO SOCIO]
Como Sócio-Consultor e Advogado, alerto: o painel interno de telemetria e o gatilho de reativação de 5 dias são apenas meios, não fins [7, 8, 18]. A Vanguard Tech possui, neste exato momento, um MRR (Receita Recorrente Mensal) projetado, mas de saldo faturado igual a R$ 0 [19, 20]. O objetivo final deste ciclo não é admirar um painel local brilhante; é pavimentar a execução do *pitch* comercial "Sovereign Study SaaS" de R$ 97/mês, disparando a isca E-4 ("quando você passar...") exatamente nesta janela temporal onde a "temperatura" da cliente está aferida como VERDE SUSTENTADO [21-24].

## ⚙️ SEQUÊNCIA DE BUILD E RESTRIÇÕES (Dias 14-15)
*   **Desbloqueio de Infra (P0):** Executar login via `supabase login` e despachar deploy em `yjqvjhezwhepwomukudt` [7, 8]. Liberar acesso de push no GitHub contornando a trava de segurança de vazamento [7, 8].
*   **RLS e Isolamento:** Auditar as tabelas `progresso_usuario` e `evento_uso` contra injeção maliciosa via `test_tenant_isolation.ps1` [7, 8, 10].
*   **Monitoramento e Vendas:** Criar painel interno restrito a Eduardo. Parametrizar alarme no Telegram: `(Inatividade > 3 dias) && (Falha no Cron) && (Relatório não enviado)` [7, 8, 10].
*   **O que NÃO construir:** Algoritmo Safe-Horizon para 2027 (foco inegociável na prova em 2026-09-06) [10, 15, 16]. UI analíticas extensas no painel interno de uso; foque puramente na leitura de texto limpo para o Diretor [7, 8].