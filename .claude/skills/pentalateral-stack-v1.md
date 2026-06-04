
# SKILL: pentalateral-stack-v1.md

### PARTE 1 — ARQUITETURA DA FASE 1
*   **Stack Aprovado:** n8n operando como orquestrador neural autônomo (backend) e Notion operando exclusivamente como cockpit visual de telemetria (frontend gerencial).
*   **OpenClaw V2:** O gateway de IA multi-canal (OpenClaw) fica postergado condicionalmente para a V2. O desbloqueio exige que o n8n primeiro alcance e comprove 30 dias de estabilidade de produção, mitigando o risco de sobrecarga precoce do servidor.
*   **Data de Início:** O build da FASE 1 inicia em **19-06-2026**, condicionado ao encerramento e estabilização do período de Hypercare do PROJ-001 (Valdece).
*   **Restrição de RAM (EasyPanel):** A implementação exige vigilância estrita. O Músculo deve monitorar a alocação de RAM do EasyPanel antes e durante o deploy, limitando o n8n a no máximo ~512MB, garantindo que não ocorra degradação ou sufocamento de hardware nos containers dos clientes ativos (Valdece e Ingrid) que compartilham a máquina.

### PARTE 2 — RESPONSABILIDADES POR EVENTO
*   **Check-in 7h/13h/20h:** O **n8n** aciona o gatilho via *cron* temporal, extrai os dados do Notion e formata o briefing; o **Telegram Bot** responde entregando a mensagem na interface móvel do Diretor.
*   **Supabase alarme:** O **n8n** aciona via requisição HTTP horária de monitoramento para aferir o *uptime*; o **Telegram Bot** responde alertando imediatamente o Diretor se uma indisponibilidade for detectada nas instâncias dos clientes.
*   **GitHub push:** O **Webhook do GitHub** aciona interceptando os commits do Músculo; o **n8n** responde processando o *payload* do repositório e sincronizando/atualizando a tarefa correlata no banco de dados do Notion.
*   **Sessão fecha → MEMORIA atualiza:** O script local **`session_close.ps1`** aciona enviando um webhook isolado; o **n8n** responde recebendo o *payload* (incluindo novos princípios do LEDGER) e gravando a informação estruturada no Notion.
*   **WIP_BOARD muda → Notion atualiza:** O script local **`executar_vereditos.ps1`** aciona comunicando a mudança do arquivo JSON; o **n8n** responde atualizando as views espelhadas do estado visual no Notion.
*   **Diretor envia comando Telegram (/mem, /status, /alerta):** O **Diretor Eduardo** aciona enviando o prefixo no chat; o **n8n** (como orquestrador do bot) responde consultando os bancos de dados apropriados e devolvendo o texto para a tela de celular do operador.

### PARTE 3 — REGRAS DE BUILD
*   **O que NÃO fazer:**
    *   **PROIBIDO** construir qualquer interface de login proprietária ou habilitar espelhamento externo/público durante a FASE 1.
    *   **PROIBIDO** conceder permissão de edição manual no Notion para o Diretor. A base visual opera estritamente em "view only" (modo leitura) para o humano, liberando privilégios de escrita ("edit") exclusivamente para o Integration Token da API do n8n.
    *   **PROIBIDO** acoplar, codificar ou invocar o repositório OpenClaw antes do n8n bater a marca de 30 dias de *uptime* ininterrupto e estável.
    *   **PROIBIDO** refatorar os arquivos core `CLAUDE.md` e `session_close.ps1` na FASE 1. A modificação radical documental aguarda a entrada oficial da V2.
*   **Gates Bloqueantes:**
    *   **Gate de Prefixos:** A lista do protocolo de comandos do Telegram (ex: `/mem`, `/status`, `/alerta`) DEVE estar inteiramente definida, validada e documentada antes da criação do primeiro *workflow*.
    *   **Gate de Hardware:** É obrigatório executar a verificação da métrica de RAM livre no EasyPanel e assegurar a disponibilidade técnica do servidor ANTES de rodar qualquer comando de deploy em produção para a infraestrutura do n8n.

### PARTE 4 — ALERTAS DO AUDITOR [N-1 a N-5]
*   **[N-1] Risco de Colisão de Edição Concorrente no Notion (Quebra de P-073):** 
    *   *O QUE É:* Permitir que Eduardo faça pequenos cliques ou "arrastes" no quadro Kanban do Notion.
    *   *POR QUE IMPORTA:* Se o operador interagir manualmente com um card enquanto o Git/n8n processa um update concorrente, cria-se uma falha de sincronia assíncrona, quebrando a autoridade da fonte.
    *   *EVIDÊNCIA HISTÓRICA:* O princípio **[P-073]** dita de forma inexorável que "documento editado fora da fonte canônica é uma duplicata". O Notion deve funcionar sob *lock* manual severo.
*   **[N-2] Ponto Cego de Auto-Hospedagem no EasyPanel (Alucinação de Monitoramento):**
    *   *O QUE É:* Usar o n8n que está hospedado dentro do servidor EasyPanel para monitorar a saúde do próprio EasyPanel (G-4 propõe um "Watchdog do EasyPanel" na V2).
    *   *POR QUE IMPORTA:* Uma arquitetura onde o "vigia dorme na mesma casa que pega fogo" não emite alarme. Se o servidor travar fisicamente (CPU a 100% ou falta de RAM), o container do n8n cairá junto e nenhum alerta chegará ao Telegram.
    *   *EVIDÊNCIA HISTÓRICA:* A Vanguard já diagnosticou silenciosas quedas de instâncias passadas, resultando no **[P-025]** (7 panes Supabase). O alerta real de queda do servidor inteiro exige um *ping* externo secundário e independente (ex. UptimeRobot ou equivalente).
*   **[N-3] Atrito de Latência Assíncrona no Terminal (Fricção Operacional):**
    *   *O QUE É:* O atrelamento do script PowerShell local `session_close.ps1` ao webhook do n8n.
    *   *POR QUE IMPORTA:* Se o script `session_close.ps1` for configurado para aguardar uma resposta "200 OK" síncrona do servidor do n8n, qualquer latência de rota na internet do Diretor vai congelar o terminal PowerShell, atrasando o fechamento do seu dia e reativando a "Fadiga de Ritual". O POST para o n8n deve ser disparado em formato *fire-and-forget* (assíncrono isolado).
    *   *EVIDÊNCIA HISTÓRICA:* Os atritos em etapas de finalização documentados na [FALHA-PROCESSO-2026-05-18-D] atestam que lentidão induz o humano a pular os passos do Wipe & Sync.
*   **[N-4] Vazamento de Credenciais em Exportação de Backups (Violação do P-061):**
    *   *O QUE É:* O n8n armazenará chaves supercríticas (Telegram Bot Tokens, Supabase Service Keys, GitHub PATs). Quando o Músculo for fazer backup da infra (exportando os workflows em JSON para o repositório), ele poderá expor as senhas brutas.
    *   *POR QUE IMPORTA:* É um risco de violação letal do **[P-061]** (nenhuma key pertence ao frontend ou a repositórios desprotegidos).
    *   *EVIDÊNCIA HISTÓRICA:* A vulnerabilidade que bloqueou o GitHub Pages (onde credenciais da API do Google estavam expostas no HTML). O Git Hook *pre-push* deve ser calibrado urgentemente para caçar strings secretas dentro dos eventuais exports de workflows do n8n salvos pelo Músculo.
*   **[N-5] Diluição da Integridade do LEDGER.md (Ameaça ao P-005):**
    *   *O QUE É:* O uso da integração `Sessão fecha → MEMORIA atualiza` para jogar diretamente os novos princípios extraídos para o Notion.
    *   *POR QUE IMPORTA:* O Notion pode processar e exibir visualmente as fricções, mas o arquivo físico local `.md` do INTELLIGENCE_LEDGER precisa ser gravado fisicamente *primeiro*, localmente, antes do tráfego web, mantendo o arquivo *raw* em Markdown como depositário permanente de *backup*.
    *   *EVIDÊNCIA HISTÓRICA:* O princípio **[P-005]** consagra que a inteligência é "acumulada por sessão" em arquivo. Romper com o disco rígido local e confiar apenas no cloud do Notion arrisca perder a base neural estruturada de 74 princípios da holding de dados.