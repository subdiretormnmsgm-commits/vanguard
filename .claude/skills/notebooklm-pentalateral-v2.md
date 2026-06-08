# SKILL: notebooklm-pentalateral-v2.md
Camada: Sistema Interno | Loop: Universal | Stack: Claude Chrome Extension + NotebookLM

### [IDENTIDADE PENTALATERAL]
Esta skill governa a automação programática do SÓCIO-AUDITOR (NotebookLM) via browser. Você (Músculo) controla a interface do NotebookLM para extrair auditorias, gerar Studio Outputs e forçar sincronização documental. O Diretor apenas recebe o veredito final.

### [NUNCA — 4 PROIBIÇÕES]
1. NUNCA criar cadernos sem o prefixo exato `[YYYY-MM] [NOME_CLIENTE]`. (Violação do Isolamento de Contexto P-059).
2. NUNCA adicionar URLs externas, links de YouTube ou textos via clipboard. Toda fonte adicionada DEVE vir fisicamente de `NOTEBOOKLM_FONTES/`. (Violação do MANIFESTO_DE_FONTES P-053).
3. NUNCA fechar a aba do NotebookLM antes de salvar a Skill gerada fisicamente no diretório `.claude/skills/`. (Violação de Output Irrecuperável P-049).
4. NUNCA aguardar a geração de Studio Outputs (Audio Overview) de forma síncrona. Dispare e solte. (Violação P-125).

### [GATES DE CONTROLE — Step 0 Pentalateral]
*   **Gate P-045:** O Músculo deve verificar se `MEMORIA_V[N-1]` e `relatorio_V[N-1]` existem no histórico antes de acionar a extensão.
*   **Gate P-059:** Confirme que a variável global `$CLIENTE_ATIVO` está definida e corresponde ao caderno alvo.
*   **Gate P-053:** `preparar_notebooklm_projeto.ps1` deve ter sido executado para compilar a pasta de fontes.

### [MATRIZ DE AUTORIZAÇÃO]
| Ator | Pode acionar? | Em qual momento do ciclo? | Gate obrigatório antes? |
| :--- | :--- | :--- | :--- |
| **Músculo** | SIM | Passo 5 (Extração de Skill / Sync) | P-045 + P-059 + P-053 |
| **Embaixador**| NÃO DIRETAMENTE | N/A | Opera via Músculo (P-034) |
| **n8n / Daemon**| SIM | Background (Studio Outputs) | P-112 (Apenas extração) |
| **Diretor** | SIM | A qualquer momento | Veredito Soberano (P-018) |

### [Step 0 Técnico: tabs_context_mcp + screenshot + login check]
1. Chame a ferramenta `tabs_context_mcp` (ou equivalente de automação de browser) para listar abas ativas.
2. Se NotebookLM não estiver aberto, navegue para `https://notebooklm.google.com/`.
3. Tire um **screenshot inicial** da página inteira.
4. Verifique visualmente no screenshot se a tela de login do Google está ativa. Se sim, **PARE** e solicite ao Diretor a autenticação. Não tente preencher credenciais.

### [Abrir Notebook com validação $CLIENTE_ATIVO via URL + título do DOM]
1. Na homepage do NotebookLM, use Computer Use / OCR para buscar o card cujo título contém a string de `$CLIENTE_ATIVO`.
2. Clique no card. 
3. Após o carregamento, extraia o título do DOM (h1 ou header principal) e verifique se a URL mudou.
4. **Gate de Segurança:** Se o título no DOM não contiver `$CLIENTE_ATIVO`, aborte imediatamente a operação (Kill-Switch P-059) e feche a aba.

### [Action: Wipe & Sync — passos detalhados no DOM]
*Operação obrigatória ao atualizar contexto:*
1. Navegue até o painel esquerdo de fontes ("Sources").
2. Identifique as fontes antigas. Clique no checkbox para "Selecionar Tudo" (Select all) ou itere clicando nos ícones de lixeira (Delete) de cada fonte.
3. Clique em "Delete" no modal de confirmação.
4. **Aguarde 2 segundos** para a UI refletir a exclusão completa.
5. Siga para a Action: Add Sources.

### [Action: Add Sources — APENAS de NOTEBOOKLM_FONTES/]
1. Clique no botão "Add Source" (ícone de `+`).
2. Selecione a opção "Upload file" / "File".
3. Na janela do sistema operacional ou interface de upload, navegue estritamente para o path: `CLIENTES/[$CLIENTE_ATIVO]/NOTEBOOKLM_FONTES/`.
4. Selecione o pacote de arquivos preparados. (O `MANIFESTO_DE_FONTES.md` deve ser o primeiro da lista).
5. Aguarde o loader visual do NotebookLM atingir 100% de processamento para todos os arquivos antes de iniciar qualquer chat.

### [Action: Studio Outputs — fire-and-forget com P-125 explícito]
1. Clique no botão "Studio" ou "Audio Overview".
2. Configure as instruções opcionais no prompt de áudio, se exigido pelo briefing.
3. Clique em "Generate" ou "Start".
4. **P-125 EXPLÍCITO:** *Do NOT wait for generation*. A geração leva de 3 a 10 minutos. O Músculo não deve travar o terminal aguardando. Feche a aba ou mova para background. O n8n alertará quando estiver pronto, ou o Músculo pode checar novamente no final da sessão.

### [Action: Read/Extract — com skill_parser_gate.ps1 + timeout de 5 min]
1. Insira o prompt na caixa de chat e envie.
2. Inicie um loop de polling a cada 15 segundos verificando se a resposta terminou de ser gerada no DOM (procure pelo desaparecimento do ícone de "thinking/generating").
3. **TIMEOUT:** Limite máximo de **5 minutos**. Se exceder, tire screenshot e aborte com erro de timeout.
4. Após geração completa, raspe todo o texto do container de resposta.
5. Salve o texto fisicamente em `.claude/skills/[$CLIENTE_ATIVO]-v[N].md`.
6. Rode `.\scripts\skill_parser_gate.ps1 -skill ".claude\skills\[$CLIENTE_ATIVO]-v[N].md"`. O processo só avança se o gate retornar APROVADO.

### [Action: Create Notebook]
1. Na homepage, clique em "New Notebook".
2. No campo de título, insira obrigatoriamente: `[YYYY-MM] [NOME_CLIENTE]`.
3. Prossiga para Action: Add Sources.

---

## [AUDITORIA DE COERÊNCIA]
*   **Princípio P-075 (O Diretor não transporta):** Esta skill codifica a desintermediação operacional, transferindo o trabalho braçal de DOM manipulation para o Músculo.
*   **Princípio P-053 (Manifesto de Fontes):** As travas na seção `[Action: Add Sources]` garantem a validade ontológica do Pentalateral. Nada entra no NotebookLM que não esteja indexado no repo Git local.
*   **Princípio P-059 (Isolamento de Contexto):** A verificação rigorosa de `$CLIENTE_ATIVO` no DOM impede a contaminação cruzada de cadernos.
*   **Precedentes Reais:** No Loop V26 (Projeto Vanguard), a transição para o n8n comprovou que automações periféricas falham sem fallbacks locais. Esta skill atua como a contraparte local de RPA (Robotic Process Automation) para a nuvem.

## [CONEXÃO HISTÓRICA]
A ausência dessa automação causou gargalos severos de processamento nas V1 a V17. Especificamente na **FALHA-PROCESSO-2026-05-18-D**, o Diretor tentou abrir o NotebookLM mas o sistema travou com contexto defasado porque arquivos velhos não foram limpos manualmente. Se o *Wipe & Sync* manual já falhou no passado, sua ausência em uma automação destruiria a precisão do Auditor no primeiro ciclo. A inclusão do fluxo detalhado no DOM neutraliza esse risco.

## [PADRÃO DE SUCESSO/FALHA]
*   **Fluxo de Sucesso:** O Músculo abre o browser invisivelmente, deleta as fontes antigas, faz upload da pasta correta, emite o prompt do PASSO 5, aguarda a geração dentro de 5 minutos, salva o arquivo `.md` no disco e o `skill_parser_gate.ps1` aprova os 4 blocos. O Telegram notifica o Diretor: *"Auditoria extraída e validada."*
*   **Fluxo de Falha:** O DOM do Google sofre alteração, o seletor não é encontrado, ou o Wipe falha. O Músculo captura o erro, tira um screenshot da tela falha, não tenta salvar a skill pela metade, e dispara alerta via W-7 / W-1 ao Telegram do Diretor: *"ALERTA NOTEBOOKLM: Falha na manipulação do DOM na etapa [X]. Intervenção manual requerida."*

## [PERSPECTIVA DO SÓCIO]
Para garantir a sanidade da operação e evitar as abstrações da V1, as regras operacionais são as seguintes:
*   **Timeout e Extração:** O timeout de extração de resposta via chat é estrito em **5 minutos**. O Auditor exige tempo para conectar o histórico. Se falhar, o Músculo refaz o prompt uma (1) vez antes de abortar. Se o `skill_parser_gate.ps1` rejeitar (falta de blocos), o Músculo pede ao NotebookLM para corrigir estruturalmente a saída no mesmo chat.
*   **Falha no Wipe & Sync:** Se o modal de exclusão em massa não funcionar, o Músculo está autorizado a excluir as fontes uma a uma clicando nas lixeiras individuais. Se as lixeiras não existirem no DOM, aborte.
*   **Notebook Ausente:** Se a busca pelo notebook de `$CLIENTE_ATIVO` falhar na homepage, o Músculo NUNCA tenta adivinhar cadernos próximos. Ele ativa imediatamente a `[Action: Create Notebook]`, forjando um ambiente limpo.
*   **Reporte ao Diretor:** Ao final de cada *Action* principal (Wipe concluído, Upload concluído, Extração concluída), o Músculo consolida o log e o dispara silenciosamente via n8n (W-1 ou webhook de console) para que o Diretor tenha o tracking da automação em tempo real pelo celular.