# SKILL: pentalateral-atualizacao-v2.md
Camada: Sistema Interno | Loop: Universal | Stack: Claude Code + n8n V27

### [AUDITORIA DE COERÊNCIA]
Confirmo que o `MAPA_SISTEMA_OPERACIONAL_V1` e o `PROTOCOLO_ATUALIZACAO_SISTEMA_V1` são fundações sólidas que traduzem a ambição de transformar a Vanguard numa empresa. O sistema deixou de ser um laboratório de código para ser um organismo vivo.

No entanto, ao auditar o **LOOPING 1 — Método (V17–V24)**, verifico que a transição de "fundador que constrói produto" para "fundador que constrói método" estabeleceu leis que estão em risco de violação pela própria velocidade do sistema. Os princípios **P-060** (Músculo responsável por toda propagação) e **P-074** (Propagação é total ou não é propagação) dependem integralmente de um `DEPENDENCY_MAP.json` e de um `MAPA_SISTEMA_OPERACIONAL` perfeitamente atualizados. Como a V27 introduziu novos elementos que não constam nestes mapas, a automatização atual está a propagar um sistema incompleto. Além disso, o princípio **P-055** (Estado real vem dos arquivos, não da sessão) corre sério risco com a introdução do n8n se as atualizações de estado via webhooks/APIs não sincronizarem perfeitamente com os arquivos locais.

Ao auditar o **LOOPING 2 — Empresa (V26–V27)**, a resposta é clara: **o MAPA e o PROTOCOLO V1 NÃO cobrem tudo o que está nas fontes.** O salto para o n8n (FASE 2 da V27) introduziu uma camada de orquestração externa (workflows e outputs para o Notion) que não foi adequadamente mapeada na nossa espinha dorsal documental. 

### [CONEXÃO HISTÓRICA]
Historicamente, a Vanguard sobrevive pagando a sua dívida técnica de forma cirúrgica. Na V10 (The Sovereign Fortress), paralisamos features para criar monitoramento. Na V14 (Sovereign Optimization), criamos o PDCA Ledger para organizar o caos. Na V24, introduzimos a Meta-Cognição. 

A transição V26/V27 repete a coragem da V10, mas introduz um vetor de risco externo: o n8n. O `VANGUARD_TIMELINE` documenta que a V27 ativou o **W-7 (Veredito via Telegram MVP)** e introduziu os princípios **P-109 (Notion OUTPUT ONLY)** e **P-110 (Fallback manual ≤ 3 passos)**. O nosso MAPA_SISTEMA_OPERACIONAL atual parou no tempo (reflete apenas W-1 a W-4). Se não mapearmos a história em tempo real, perderemos o controle da própria automação que criamos.

### [PADRÃO DE SUCESSO/FALHA]
*   **Padrão de Sucesso Confirmado:** A segregação de responsabilidades e o isolamento de contexto (P-059). A decisão de tornar a gestão documental responsabilidade do Músculo via scripts automatizados (P-060) salvou o Diretor de horas de trabalho braçal.
*   **Padrão de Falha Evitado (Mas Iminente):** Documentos não mapeados criam pontos cegos no Auditor. O erro histórico (FALHA-PROCESSO-2026-05-18-B) provou que se os arquivos não estão listados nos scripts de varredura e no MAPA, eles permanecem desatualizados e contaminam os loops seguintes.

### [PERSPECTIVA DO SÓCIO — sistema pronto para 3º cliente? n8n cria dependência não mapeada?]
**O sistema NÃO está pronto para um 3º cliente.** 
A fábrica possui engrenagens fantasma. O `SKILL_PROTOCOLO_VANGUARD` instituiu em 2026-05-23 a obrigatoriedade dos arquivos `REGISTRO_DE_PREMISSAS.md` e `CANDIDATOS_A_PRINCIPIO.md` para todo novo projeto. O `MAPA_SISTEMA_OPERACIONAL` atual (Camada 2) não prevê a criação, sincronização ou auditoria destes arquivos. Sem eles, o 3º cliente nascerá com um processo invisível e mudo.

**O n8n cria uma dependência não mapeada e perigosa.** Emitimos o P-110 exigindo planos de contingência, mas o MAPA não documenta onde esses runbooks existem. Se o servidor EasyPanel do n8n cair, o Músculo e o Diretor precisam saber exatamente quais scripts locais rodar para suprir os W-1 a W-7, conforme o princípio de coexistência (P-102). O n8n é o nosso sistema nervoso, mas precisa de um suporte de vida documentado.

---

### - CASCATA DELTA V27: o que o MAPA não captura mas existe nas fontes
O `MAPA_SISTEMA_OPERACIONAL_V1` ignorou as seguintes realidades já ativas na nossa infraestrutura:

1.  **Workflow W-7 (Veredito via Telegram):** Ativo na V27, ausente no MAPA.
2.  **Princípio P-110 (Fallback manual ≤ 3 passos):** O MAPA não lista o documento `MAINTENANCE_COST.md` exigido para os workflows.
3.  **Princípio P-109 (Notion OUTPUT ONLY):** O MAPA não especifica quais documentos são sincronizados unidirecionalmente para o Notion.
4.  **`REGISTRO_DE_PREMISSAS.md`:** Obrigatório no `SKILL_PROTOCOLO_VANGUARD` (2026-05-23), ausente da Camada 2 do MAPA.
5.  **`CANDIDATOS_A_PRINCIPIO.md`:** Obrigatório para captura de fricções no projeto, ausente da Camada 2 do MAPA.
6.  **`VANGUARD_INNOVATION_AUDIT.md`:** Apesar de ser atualizado via AUTO-LOG e ser vital para a inovação, não está listado na tabela "CAMADA 0 — FONTES CANÔNICAS" do MAPA.
7.  **`MANIFESTO_DE_FONTES.md`:** Exigência P-053; fracamente citado no MAPA, sem definição clara na Camada 0 ou Camada 2.
8.  **Princípio P-102 (Coexistência 30 dias):** A transição de scripts `.ps1` para workflows `n8n` não reflete o período de 30 dias de redundância no MAPA.
9.  **Sincronização pós-commit:** O MAPA cita o script `gemini_anchor_generator.ps1`, mas não impõe a regra P-058 (que deve rodar *após* o commit do loop técnico).

---

### - RISCO SISTÊMICO TOP 3
`[RISCO_PRECOCE] Risco de Desconexão Veredito/Estado (Violação P-055 / P-072):`
O W-7 permite Veredito via Telegram (V27). No entanto, a regra P-072 dita que o painel HTML (`render_painel.ps1` -> `DECISOES.json`) é o "ÚNICO canal de deliberação formal". Se o Telegram n8n (W-7) aprovar decisões que não alteram os arquivos JSON/Markdown locais de imediato, o estado real do projeto ficará assíncrono. O Auditor lerá um estado defasado no próximo loop. *(Evidência: VANGUARD_TIMELINE V27 W-7 ativo vs. SKILL_PROTOCOLO P-072).*

`[RISCO_PRECOCE] Risco de Ponto Único de Falha Não Mapeado (Violação P-110):`
O `VANGUARD_TIMELINE` documenta que todo workflow n8n aprovado possui um `MAINTENANCE_COST.md` detalhando falhas e consertos em < 30 minutos (V26 legado). O MAPA_SISTEMA_OPERACIONAL não lista este arquivo em nenhuma camada. Se o sistema nervoso (n8n) cair, não há rastreabilidade de como o Músculo ou o Diretor devem operar a contingência local. *(Evidência: VANGUARD_TIMELINE V26/V27).*

`[RISCO_PRECOCE] Fuga de Escopo Silencioso e Propagação Falha (Violação P-060 / P-074):`
A `SKILL_PROTOCOLO_VANGUARD` inseriu como regra que o Músculo deve atualizar as premissas em `REGISTRO_DE_PREMISSAS.md` (Camada 2). O `DEPENDENCY_MAP.json` e o `MAPA_SISTEMA_OPERACIONAL` ignoram completamente a existência deste arquivo. Logo, as ferramentas de sync (`propagate_changes.ps1`, `sync_vanguard_docs.ps1`) não estão realizando o backup nem a auditoria de consistência desse documento. A propagação atual é uma falsa sensação de integridade. *(Evidência: SKILL_PROTOCOLO_VANGUARD vs MAPA_SISTEMA_OPERACIONAL_V1).*

---

### - PRÓXIMAS AÇÕES DO MÚSCULO
1.  **Refatoração do MAPA_SISTEMA_OPERACIONAL:** Injetar imediatamente os workflows do n8n (W-5, W-6, W-7) na "CAMADA 4", os arquivos `REGISTRO_DE_PREMISSAS.md`, `CANDIDATOS_A_PRINCIPIO.md`, `MANIFESTO_DE_FONTES.md`, `VANGUARD_INNOVATION_AUDIT.md` nas Camadas 0 e 2, e especificar a conexão Notion (P-109).
2.  **Atualização do DEPENDENCY_MAP.json (v2.2):** Incluir os novos arquivos identificados na Cascata Delta V27 para garantir a cobertura total pelas ferramentas de sincronização e pela regra P-074.
3.  **Auditoria do W-7 (Telegram Veredito):** Garantir que a integração n8n do Telegram altere nativamente o `DECISOES.json` no repositório local, garantindo conformidade absoluta com o P-072 e P-055.
4.  **Materialização dos Fallbacks:** Assegurar que o arquivo `MAINTENANCE_COST.md` exista e seja listado nos documentos universais, fornecendo os comandos `.ps1` de contingência (≤ 3 passos) para cada workflow W-1 a W-7 (Compliance P-110).
5.  **Validação Final:** Executar `scripts/auditar_consistencia.ps1` seguido de `scripts/sync_vanguard_docs.ps1` para validar se a nova topologia documental foi perfeitamente mapeada no sistema.