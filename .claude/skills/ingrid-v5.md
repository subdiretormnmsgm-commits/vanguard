# SKILL: ingrid-v5.md
**Camada:** 2 (Produto) | **Loop:** #4 | **Stack:** PWA Vanilla JS + Supabase + Claude API

### PARTE 1 — Auditoria de Coerência
A intenção de expandir o banco de questões para 1.000+ no Loop 4 contradiz a prudência operacional se executada antes de aplicar o **[P-038] (Perfil de Candidato obrigatório)** e sem monitoramento de caixa. O histórico recente documenta a `[FALHA-PROCESSO-2026-05-18-F]`, onde a expansão silenciosa esgotou os créditos da Anthropic e travou o sistema sem aviso [10]. Expandir o banco agora sem um script que valide o saldo da API antes do loop viola o **[P-006] (Burn Rate Shield)**. Além disso, o Músculo falhou seguidamente em seus gates por não testar no ambiente real do usuário (browser), violando o **[P-010]**, o que exige a adoção estrita do recém-criado **[P-039] (Modelo de testes em 3 camadas)** antes de qualquer nova feature ser codificada [7].

### PARTE 2 — Perspectiva do Sócio Consultor
O Músculo está acelerando a produção técnica ("Momentum de Execução"), mas transferiu o custo de QA (Garantia de Qualidade) e orquestração para o Diretor. Eduardo está exausto de ser o lembrete humano de processos que deveriam ser imutáveis. O que os outros membros não estão vendo é que o PROJ-002 atingiu a fase de "Temperatura Verde" e o Termo está assinado. O foco agora não deve ser criar dezenas de novas lógicas de UI, mas sim transformar o app num ativo documentado. O Perfil de Nicho EdTech-Concurso recém-criado (**[P-040]**) é o verdadeiro produto que será vendido a seguir. A expansão do banco de questões e a estabilização final devem servir puramente para gerar os 3 documentos de entrega (Relatório, Manual, Metodologia) que justificam o valor comercial do sistema.

### PARTE 3 — A Skill copiável para .claude/skills/

## 📋 CONTEXTO DO PROJETO
O App está no ar (GitHub Pages), o Termo foi assinado e a Temperatura da Cliente é VERDE. O Gate Dia 8 está ativo com 460 questões. O objetivo deste loop é expandir a inteligência do banco para 1.000+ questões (aguardando créditos), implementar os micro-simulados e heatmaps (Dias 9-11), e gerar a documentação de entrega em alto valor percebido.

## 🛡️ PADRÕES E ALERTAS DE VETO (INTELLIGENCE LEDGER)
*   **[P-038] Dimensionamento por Perfil:** Proibido gerar questões em massa sem validar o volume diário típico e o gatilho de abandono do Perfil de Candidato.
*   **[P-039] Testes em 3 Camadas:** Proibido solicitar "Veredito" do Diretor sem antes testar a funcionalidade em um browser real (mitigação do erro de CORS).
*   **[P-041] Checklist de Setup:** O Músculo deve sempre validar se todos os arquivos PASSO estão instanciados.
*   **[ALERTA DE CRÉDITO]:** O script de seed DEVE conter uma rotina de checagem do saldo da API da Anthropic. Se o saldo for insuficiente, bloqueie a execução com mensagem clara, em vez de gerar erros 500 silenciosos.

## ⚙️ SEQUÊNCIA DE BUILD (DIAS 9-11)
1.  **Expansão Inteligente e Segura:** Modificar o `seed_questoes.ps1` para interceptar erros de saldo da API (Anthropic). Popule as 540 questões faltantes priorizando estritamente o Score de Incidência (**[P-014]**).
2.  **Heatmap e Micro-Simulado:** Construir o Heatmap de urgência por matéria na UI e programar o Modo Sedes-DF (Micro-Simulado) focado nos finais de semana, alinhado com as respostas do Embaixador.
3.  **Geração de Ativos de Entrega:** Estruturar via scripts a compilação automática do Relatório de Entrega, Manual de Instruções (Sovereign Playbook) e Metodologia Vanguard, utilizando os dados acumulados do projeto.

## 🚫 O QUE NÃO CONSTRUIR
*   **NÃO** construa a expansão de 1.000+ questões sem implementar a trava de verificação de créditos no script.
*   **NÃO** delegue a verificação de CORS ou erros de integração de frontend para o Diretor.
*   **NÃO** crie novas dinâmicas gamificadas que não estejam previstas no `PERFIL_CANDIDATO_SEDES_DF.md`.

### PARTE 4 — 5 Ideias Disruptivas do Auditor
1.  **wip_guard_soberano.ps1 (O Cão de Guarda do Diretor):** Um script que roda antes do Músculo fechar a sessão. Ele faz um ping simulado na URL pública para checar o CORS, verifica se os arquivos `.env.local` e `PASSO7` existem, e checa se o JSON do banco tem as variáveis do P-038. Se falhar, o Músculo é impedido de chamar o Diretor.
2.  **API Wallet Ping no Seed:** Adicionar uma função levíssima no início do `seed_questoes.ps1` que dispara uma requisição de custo zero (ou mínimo) para checar o status da conta Anthropic e confirmar créditos antes de iniciar o loop de milhares de tokens.
3.  **Auditoria Automatizada de Nicho (Auto-Niche Profiler):** Ao fechar o projeto, em vez do Diretor redigir o Perfil de Nicho EdTech, um script compila a `MEMORIA_EMBAIXADOR.md` e o `LOG_CLIENTE.md` e usa o Claude API para atualizar o arquivo `QUADRILATERAL_UNIVERSAL/PERFIS_NICHO/edtech.md` de forma autônoma.
4.  **Handoff as Code (Entrega como Código):** Os 3 documentos exigidos hoje (Relatório, Manual, Metodologia) não devem ser digitados. O Músculo cria um script `gerar_handoff_docs.ps1` que lê as views de progresso do Supabase e o LEDGER, cuspindo os Markdowns formatados já com as métricas reais da Ingrid.
5.  **Telemetria Anti-Abandono Baseada no P-038:** O Perfil do Candidato dita que um usuário sério faz 50-100 questões/dia. O app deve ter um gatilho de banco de dados: se a média móvel de 3 dias da Ingrid cair para menos de 20 questões/dia, o Embaixador gera um alerta de "Risco de Quebra de Hábito" antes que ela abandone o aplicativo definitivamente.