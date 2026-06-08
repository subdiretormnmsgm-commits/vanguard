# SKILL: notebooklm-pentalateral-v1.md
Camada: Sistema Interno | Loop: Universal | Stack: Claude Chrome Extension + NotebookLM

> **IDENTIDADE PENTALATERAL:** 
> Esta skill automatiza o SÓCIO-AUDITOR (NotebookLM). Só pode ser acionada pelo Músculo (Claude Code) durante o Passo 5 do Protocolo Pentalateral, ou pelo n8n para extração de Studio Outputs. O Diretor não arrasta mais arquivos. Você (Músculo) controla o browser.

## 🛑 O QUE ESTA SKILL NUNCA FAZ
1. NUNCA criar cadernos sem prefixo exato: `[YYYY-MM] [NOME_CLIENTE]`.
2. NUNCA adicionar URLs externas, links de YouTube ou textos livres via extensão. Toda fonte DEVE vir obrigatoriamente do diretório local `NOTEBOOKLM_FONTES/` (P-121).
3. NUNCA fechar a aba do NotebookLM antes de salvar a Skill gerada fisicamente no diretório `.claude/skills/` (P-049).
4. NUNCA acionar o Auditor com loop incompleto (Gate P-045).

## ⚙️ GATES DE CONTROLE (STEP 0 - Executar antes de abrir o Browser)
*   **Gate P-045:** Verifique se `MEMORIA_V[N-1]` e `relatorio_V[N-1]` existem no histórico. Se não, cancele a automação.
*   **Gate P-059:** Confirme que o caderno alvo contém a string exata do `$CLIENTE_ATIVO`.
*   **Gate Wipe & Sync (P-122):** Instrua a extensão a deletar as fontes do caderno antigo antes de subir o novo payload gerado por `preparar_notebooklm_projeto.ps1`.
*   **Gate Manifesto:** Garanta que `MANIFESTO_DE_FONTES.md` suba em primeiro lugar.

## 👤 MATRIZ DE AUTORIZAÇÃO
*   **Músculo:** AUTORIZADO no Passo 5 (para extrair a Skill) usando o Comando Curto do PASSO5.
*   **Diretor:** AUTORIZADO via Veredito Soberano.
*   **n8n / Daemon:** AUTORIZADO apenas em background para acionar geração de *Audio Overviews* (Studio) para o cliente.

### [AUDITORIA DE COERÊNCIA]
A automação de browser cumpre o mandato **P-075** (desintermediação operacional do Diretor). A ausência histórica desta integração causou gargalos severos de tempo na transição V17-V24. O Músculo ganha, por fim, o poder de dialogar diretamente com a memória institucional.

### [CONEXÃO HISTÓRICA]
Projetos anteriores (V1 a V27) dependeram do humano para mover a sabedoria. O "Sovereign Proxy" da V19 nos ensinou que controlar a interface (DOM) vale mais que controlar o banco. O Claude agora "sequestra" a interface do NotebookLM para forçar a auditoria, alinhando-se com a estratégia de "Edge Hijack" do Pentalateral.

### [PADRÃO DE SUCESSO/FALHA]
*   **Sucesso:** Automação que lê a pasta preparada localmente, limpa as fontes antigas via cliques no DOM, sobe o pacote atual, e raspa a PARTE 3 gerada diretamente para um `.md`.
*   **Falha:** O Músculo colar o prompt, o Auditor não estruturar nos 4 blocos obrigatórios, e o Músculo fechar a aba sem aplicar o *Gatilho de Calibração* (exigido no P-007). O Músculo DEVE ler o output via browser e rodar o `skill_parser_gate.ps1` antes de fechar.

### [PERSPECTIVA DO SÓCIO]
Ter o Músculo pilotando o NotebookLM remove a latência. Contudo, se o Músculo não for rigoroso no Wipe & Sync (P-122), o NotebookLM vai enlouquecer com duplicidade de dados em três ciclos. A extensão do Chrome é a mão; as regras do LEDGER continuam sendo o cérebro.