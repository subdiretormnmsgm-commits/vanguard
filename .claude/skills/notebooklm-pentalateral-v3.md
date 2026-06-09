# SKILL: notebooklm-pentalateral-v3.md
Camada: Sistema Interno | Loop: Universal | Stack: notebooklm-py (CLI) + YT-SEARCH + RPA fallback
Supersede operacional de: notebooklm-pentalateral-v2 (rebaixada a FALLBACK, mantida viva)

### [IDENTIDADE PENTALATERAL]
Esta skill governa a automacao do SOCIO-AUDITOR (NotebookLM). O Musculo opera o NotebookLM
por LINHA DE COMANDO (notebooklm-py) como caminho primario, com RPA de browser (v2) como
paraquedas. O Diretor recebe o veredito; nunca transporta fontes nem clica botoes (P-075).

A skill tem DOIS MODOS. Errar de modo = incidente de contexto (P-059/P-124). Decida o modo ANTES.

### [MATRIZ DE MODOS -- DECIDA ANTES DE QUALQUER COMANDO]
| Voce quer...                                   | MODO     | Travas obrigatorias                                                       |
| :--------------------------------------------- | :------- | :----------------------------------------------------------------------- |
| Extrair Skill / Wipe&Sync / auditar CLIENTE    | CLIENTE  | Fontes SO de NOTEBOOKLM_FONTES/ - caderno [YYYY-MM] [CLIENTE] - ZERO URL  |
| Pesquisa de mercado / nicho (Intelligence Hub) | INTEL    | Deep Research + URL/YouTube liberados - saida SEMPRE p/ PENDING_REVIEW.md |

> Regra-mae: o modo CLIENTE herda P-053 (nada entra que nao esteja no repo Git) e P-059
> (isolamento por caderno). O modo INTEL e livre porque NAO e loop de cliente (P-124 ja o separa).
> A amplitude que e virtude no INTEL seria contaminacao no CLIENTE.

### [ROTEAMENTO DE FUNCAO -> CADERNO]  (diretriz do Diretor, 2026-06-09)
A capacidade do elo e aberta (fonte inesgotavel). MAS toda execucao tem endereco
fisico governado por isolamento. O criterio NAO e o nome da funcao -- e a ORIGEM
da fonte + o DESTINO da saida:
  - Funcao ligada a UM cliente (gestor/auditor/advogado do projeto) -> caderno do
    projeto [YYYY-MM][CLIENTE], modo CLIENTE. Fonte = repo daquele cliente (P-053/P-059).
  - Funcao de mercado (pesquisa de nicho, benchmarking dos gigantes) -> caderno
    especifico no INTELLIGENCE_HUB, modo INTEL. Fonte = web/YouTube. Saida -> PENDING_REVIEW (P-124).
  - Funcao juridica/regulatoria TRANSVERSAL (ex: LGPD do nicho) -> caderno especifico
    juridico, modo INTEL. Fonte = legislacao/web.
A MESMA funcao muda de caderno conforme o contexto (curadoria contextual): advogado do
contrato da Ingrid -> caderno Ingrid; advogado da LGPD do nicho -> caderno juridico INTEL.
INVIOLAVEL: fonte externa NUNCA entra em caderno de cliente (mata P-053/P-059); auditoria
ou juridico de UM cliente NUNCA vai para caderno generico (perde contexto e isolamento).
Caderno especifico do Hub so e criado no primeiro uso real -- caderno vazio e lixo.

### [NUNCA -- PROIBICOES POR MODO]
GERAL:
1. NUNCA preencher credenciais de login por automacao. Se a sessao expirou, PARE e peca ao
   Diretor: "rode `notebooklm login`". (Token expira; re-login e browser interativo.)
2. NUNCA aguardar geracao de Studio Output (audio/video) de forma sincrona -- dispare e solte (P-125).
3. NUNCA salvar Skill/relatorio pela metade. Output incompleto nao e salvo (P-049).

MODO CLIENTE (adicional):
4. NUNCA adicionar URL externa, YouTube ou texto via clipboard. Fonte SO de NOTEBOOKLM_FONTES/ (P-053).
5. NUNCA criar caderno sem o prefixo exato `[YYYY-MM] [NOME_CLIENTE]` (P-059).
6. NUNCA misturar dois clientes na mesma sessao de CLI -- use -n <id> ou NOTEBOOKLM_PROFILE por cliente.

MODO INTEL (adicional):
7. NUNCA jogar output do Auditor direto em DECISOES.json ou WIP_BOARD. Saida vai p/ PENDING_REVIEW.md;
   o Musculo revisa ANTES de qualquer acao (P-124, camara de eco proibida).

### [AUTENTICACAO -- verificar no Step 0]
- Checar (read-only, sem confirmacao): `notebooklm auth check --test --json`
  -> exigir BOTH "status":"ok" E checks.token_fetch=true. So "status":"ok" sem --test e falso-positivo.
- Se token_fetch=false -> PARE e peca ao Diretor: "rode `notebooklm login`".
- ATENCAO Python 3.13+: o extra [cookies]/rookiepy NAO compila. Re-auth automatica silenciosa
  (cron auth refresh) NAO e confiavel nesta maquina. E "autonomo entre logins", nao 24/7 sem o Diretor.

### [GATES DE CONTROLE -- Step 0]
- Gate P-045: antes de acionar em modo CLIENTE, confirmar MEMORIA_V[N-1] e relatorio_V[N-1] no historico.
- Gate P-059: $CLIENTE_ATIVO definido e batendo com o caderno alvo (verificar titulo via `list --json`).
- Gate P-053: `preparar_notebooklm_projeto.ps1 -cliente [NOME]` rodado (compila NOTEBOOKLM_FONTES/).
- Paralelismo (ate 20 projetos): SEMPRE usar -n <notebook_id> explicito; nunca depender de `use`
  global. Opcional: NOTEBOOKLM_PROFILE=cliente-<nome> para isolar contexto por cliente.

### [MOTOR PRIMARIO -- comandos essenciais (notebooklm-py)]
Manual tecnico completo e atualizavel: `.claude/skills/NotebookLM Automation.md` (upstream, NAO copiar para ca).
Prompts longos (PASSO5): SEMPRE `--prompt-file caminho.txt` (inline quebra no limite de linha de comando).
Abaixo, so o que o loop usa de fato:

  # contexto / auth
  notebooklm auth check --test --json
  notebooklm list --json

  # MODO CLIENTE -- caderno reutilizado por cliente (NAO criar um novo por loop)
  #   1. localizar caderno existente do cliente em `list --json` (titulo contem [YYYY-MM] [CLIENTE])
  #   2. se NAO existir -> criar:
  notebooklm create "[2026-06] Ingrid" --json            # -> .notebook.id
  #   3. WIPE & SYNC (a cada loop -- mandato 12 / P-033): trocar as fontes antigas pelas novas
  notebooklm source list -n <id> --json                  # capturar ids das fontes antigas
  notebooklm source delete <source_id> -n <id> --yes     # apagar cada fonte antiga (ou delete-by-title)
  notebooklm source add ./CLIENTES/Ingrid/NOTEBOOKLM_FONTES/00_MANIFESTO.md -n <id>   # 1a fonte
  notebooklm source add ./CLIENTES/Ingrid/NOTEBOOKLM_FONTES/<demais arquivos> -n <id>
  notebooklm source list -n <id> --json                  # esperar TODOS status=ready antes do ask
  #   4. extrair a Skill do PASSO5 (prompt longo -> arquivo):
  notebooklm ask --prompt-file ./CLIENTES/Ingrid/PASSO5_PROMPT.txt -n <id> --json
  #   5. salvar a saida em .claude/skills/<cliente>-v<N>.md -> rodar skill_parser_gate.ps1 (4 blocos)

  # MODO INTEL -- Deep Research + fontes de web/YouTube
  notebooklm create "[2026-06] INTEL <nicho>" --json
  notebooklm source add "<youtube-url-curada-pelo-YT-SEARCH>" -n <id>   # ver integracao abaixo
  notebooklm source add-research "<query do nicho>" --mode deep --no-wait -n <id>
  notebooklm research wait -n <id> --import-all --timeout 1800           # em subagente (longo)
  notebooklm generate report --format briefing-doc --language pt_BR --retry 3 -n <id>
  notebooklm download report ./PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/<nicho>.md -n <id>
  # -> registrar em INTELLIGENCE_HUB/PENDING_REVIEW.md, nunca direto em decisao (P-124)

  # geracao em PT-BR: language e setting GLOBAL -> sempre passar --language pt_BR por comando.
  # fire-and-forget (nao travar terminal -- P-125): generate audio/video -> checar artifact list depois.

### [INTEGRACAO YT-SEARCH -> DEEP RESEARCH DO AUDITOR]  (insight do Diretor, 2026-06-09)
PRE-REQUISITO: YT-SEARCH instalado (Bloco 1 item B -- ainda PENDENTE: yt-dlp + /yt-search). Ate la,
esta integracao e plano, nao operacao.
Antes de um Deep Research de nicho (modo INTEL), o Musculo CURA as fontes de video:
  1. /yt-search "<nicho>" --months 3        -> ranqueia por ratio views/subs (sinal de tracao real)
  2. Selecionar os videos com ratio > 1 (estouraram acima da base do canal)
  3. Alimentar essas URLs como fontes: notebooklm source add "<url>" -n <id>
  4. Disparar o add-research --mode deep -> o Auditor combina videos curados + web
Por que: sem curadoria, o Auditor importa video aleatorio. Com YT-SEARCH, so entra o que ja provou demanda.
Embaixador: NAO usa YT-SEARCH diretamente (Claude Projects nao roda codigo local). Consome o resultado
via Musculo, como contexto de nicho -- encaixe fraco, nao vender como integracao nativa.

### [ENGENHARIA DE PROMPT DO AUDITOR -- MODO INTEL]  (diretriz do Diretor, 2026-06-09)
Prompt fraco = busca rasa. O prompt ao Auditor (add-research e generate report) DEVE ser analitico
e exigir rigor. Combate as deficiencias nativas do NotebookLM (Yes-Man, alucinacao, Lost-in-the-Middle).
Usar SEMPRE via --prompt-file (prompts longos). Estrutura obrigatoria do prompt:

  1. PAPEL: "Aja como auditor de mercado + advogado de inteligencia. Ceticismo e obrigatorio."
  2. OBJETIVO: pergunta unica e especifica (1 nicho, 1 recorte) -- nunca generico.
  3. FONTES CONFIAVEIS: "Priorize fontes primarias e verificaveis: relatorios setoriais, dados
     oficiais, empresas estabelecidas. Para cada afirmacao, cite a fonte (autoria + data + URL).
     Rejeite blog promocional, marketing disfarcado e fonte sem autoria."
  4. RECENCIA: "Priorize material dos ultimos 12 meses. Marque explicitamente o que for mais antigo."
  5. TRIANGULACAO: "Confirme cada dado em >=2 fontes independentes. Onde houver divergencia, mostre as duas."
  6. ANTI-ALUCINACAO: "Se nao encontrar evidencia, escreva 'NAO ENCONTRADO' -- nunca preencha com suposicao.
     Separe FATO (com fonte) de INTERPRETACAO (sua analise) em blocos distintos."
  7. SAIDA: seguir o modelo de relatorio Vanguard (SWOT + tamanho de mercado + players + tracao +
     5 oportunidades para a Vanguard) e listar ao final LACUNAS (o que faltou pesquisar).

> Heuristica: um bom prompt ao Auditor parece um briefing de due diligence, nao uma pergunta de busca.

### [FALLBACK -- quando a CLI falhar]
notebooklm-py e projeto de terceiros (engenharia reversa das RPCs internas do NotebookLM, NAO API
oficial Google). Se retornar "RPC protocol error" / "No result found for RPC ID" persistente apos
1 retry e 5 min -> o motor caiu (Google mudou as RPCs).
ACAO: cair para `.claude/skills/notebooklm-pentalateral-v2.md` (RPA de browser/DOM).
Os dois quebram por causas DIFERENTES (CLI = RPC mudou; RPA = layout mudou) -> dificilmente caem juntos.
Isto e redundancia de protecao hierarquizada (P-110), nao desperdicio.

### [PADRAO DE SUCESSO / FALHA]
SUCESSO (cliente): auth ok -> caderno [YYYY-MM][cliente] reutilizado -> wipe&sync das fontes do repo ->
  todos ready -> prompt PASSO5 (--prompt-file) -> saida salva em .claude/skills/<cliente>-v<N>.md ->
  skill_parser_gate APROVA 4 blocos -> Telegram avisa.
SUCESSO (intel): YT-SEARCH cura URLs -> Deep Research -> report baixado p/ INTELLIGENCE_HUB ->
  linha em PENDING_REVIEW.md -> Musculo revisa antes de propor ao Diretor.
FALHA: token expirado (-> pedir login) | RPC error persistente (-> fallback v2) | skill_parser rejeita
  (-> pedir ao NotebookLM corrigir estrutura no mesmo chat, 1 vez, antes de abortar).

## [AUDITORIA DE COERENCIA]
- P-075 (Diretor nao transporta): CLI desintermedia o trabalho bracal -- zero copy/paste/arrastar.
- P-053 (Manifesto de Fontes): modo CLIENTE so aceita fontes do repo Git.
- P-059 (Isolamento): prefixo de caderno + -n explicito impedem contaminacao entre 20 projetos.
- P-124 (Camara de eco proibida): modo INTEL sempre passa por PENDING_REVIEW.md.
- P-110 (Fallback <=3 passos): RPA v2 e o paraquedas; este doc e o caminho primario.
- P-125 (fire-and-forget): nunca travar terminal em geracao de Studio Output.
- P-033 / mandato 12 (Wipe & Sync): modo CLIENTE troca fontes antigas pelas novas a cada loop.
