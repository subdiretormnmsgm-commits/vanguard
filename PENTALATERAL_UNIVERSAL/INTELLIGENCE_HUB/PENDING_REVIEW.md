# PENDING_REVIEW — INTELLIGENCE HUB
> Canal de comunicação: Antigravity Intel Loop → Músculo (Claude Code)
> Antigravity adiciona entradas ao concluir relatório. Músculo revisa e move para APROVADO ou REJEITADO.

---

## DERIVA DOCUMENTAL
> **Destino ÚNICO de achado prosa-vs-LEDGER do Detector de Deriva (DECISÃO 2/A do Diretor, 2026-06-21).**
> Escrito SÓ em append pelo subagente read-only da skill `doc-drift-audit` — nunca por mão humana, nunca direto para DECISOES/WIP.
> **Gatilho da camada semântica (DECISÃO 1):** o subagente NÃO roda toda sessão. É acionado pelo `detector_deriva.ps1`
> quando (a) o determinístico acusa ≥ AMARELO **ou** (b) a DOUTRINA mudou desde a última sessão
> (commit tocando INTELLIGENCE_LEDGER.md · CLAUDE.md · `**/SKILL.md` · PENTALATERAL_UNIVERSAL/).
> Formato de cada achado: `[DERIVA] <arquivo:trecho> — diverge de <P-XXX/regra> — <1 linha>`. O Músculo revisa ANTES de qualquer correção (P-124).

_(sem achados pendentes)_

---

## AGUARDANDO VEREDITO

### [ANÁLISE VIBEHUB/LASY AI] — 4 ações → atores designados · 2026-06-20 (Embaixador → Músculo)

> Origem: Embaixador | Destino: Músculo → atores designados | **AGUARDA VEREDITO DO DIRETOR** (P-124).
> Colado pelo Diretor ao fechar a sessão de 2026-06-20 como pauta da PRÓXIMA sessão. NADA executado nesta sessão — só registro.

**AÇÃO 1 — Criar KPI Human-to-Revenue Ratio**
- Ator: Músculo executa; Estrategista valida meta alvo.
- Destino: `CLIENTES/WIP_BOARD.json` → novo item **W-14**.
- Bloco a gravar:
  - **W-14: Human-to-Revenue Ratio** — KPI que mede receita gerada por humano na operação.
  - Fórmula: `MRR_atual ÷ humanos_na_operação`.
  - Dados atuais: MRR R$5.000 (fonte MEMORIA_EMBAIXADOR, campo receita) ÷ 2 humanos (Eduardo + sócio) = **R$2.500/pessoa**.
  - Meta alvo: **AGUARDA veredito do Diretor**.
  - Uso: define o teto de MRR possível com a estrutura atual antes de nova contratação humana. Loop que produz só build sem contato externo → comparar com este KPI para acionar alerta **PF-1**.

**AÇÃO 2 — Atualizar frame de pitch nos arquivos de canal**
- Ator: Músculo localiza/edita; Embaixador Digital (8º) aplica nos posts.
- Destino: `ESTRATEGIA_CANAIS_VANGUARD.md` + `INTENCAO_LINKEDIN.md` (Músculo localiza caminho exato no vault).
- Substituir: DE *"orquestração governada de IA"* PARA *"crescimento sem headcount proporcional, com auditoria embutida em cada etapa"*.
- Razão: mercado regulado (Valdece/LegalTech) não compra "orquestração" — compra crescer sem contratar proporcionalmente mantendo controle. Mesmo conteúdo, linguagem do problema do cliente (não da solução técnica). Após editar → sinalizar ao Embaixador Digital.

**AÇÃO 3 — Testar novo hook no próximo post LinkedIn**
- Ator: Embaixador Digital redige; Auditor valida contra NICHE_INDEX antes de publicar.
- Destino: rascunho do próximo post (calendário Seg/Qua/Sex) → `PENDING_REVIEW`.
- 1ª linha testa o frame novo (ex.: *"Você não precisa contratar mais pessoas para crescer. Precisa de um sistema que escale sem você precisar escalar junto. E que prove isso para o auditor quando ele chegar."*).
- Fluxo: Embaixador Digital redige → Auditor verifica nicho vs NICHE_INDEX → Músculo grava rascunho em PENDING_REVIEW → Diretor aprova antes de publicar.

**AÇÃO 4 — Inserir critério MVA no BLOCO A de qualificação de prospects**
- Ator: Músculo localiza o arquivo; Auditor verifica conflito com LEDGER antes de gravar.
- Destino: arquivo de qualificação de prospects (BLOCO A) — Músculo localiza o caminho exato no vault.
- Critério **MVA (Minimum Viable Automation)**: *"Prospect sem processo mínimo documentado não entra no pipeline da Vanguard."*
- Justificativa: sem fluxo mapeado, o produto Vanguard não tem onde ancorar; o diagnóstico vira retrabalho pago pela Vanguard, não pelo cliente.
- Gate prático na 1ª conversa: *"qual processo você quer automatizar e quem é o dono desse processo hoje?"* — se não souber → qualificação falhou → não avança.
- Auditor verifica conflito com INTELLIGENCE_LEDGER antes de gravar; se conflitar → sinalizar ao Diretor antes de executar.

> **Nota do Músculo (a deliberar):** AÇÃO 4 (MVA = exige processo documentado) tensiona o DNA `dor→quiz→Loop monta` (Ingrid/Valdece entraram pela dor, não por processo mapeado) e a AÇÃO 3 do CONTEXTO (abordagem pós-inteligência). Levar essa tensão à mesa na próxima sessão — não resolver em silêncio (Pilar III). Casa com `[[feedback_funil_dna_mira_ingrid_valdece]]`.

---

### [M-STATS] — Market Sizing `eventos-fiscais-contadores` · 2026-06-19 BASE (Músculo) · ROBUSTECIDO 2026-06-20 (Executor Cowork) · números-âncora VERIFICADOS (Músculo 2026-06-20)

> Origem: solicitação do Projetista (SAÍDA_PROJETISTA 2026-06-19 — ROI/infográfico bloqueados sem parecer frio).
> Regime B (dado esparso → Módulo Market Sizing TAM/SAM/SOM dupla via). **Cliente Vanguard = o escritório de contabilidade** (não a empresa-fim).
> Toda cifra = número + intervalo + fonte/data. N de clientes Vanguard = **0** → SOM é **cenário de capacidade, NÃO previsão estatística** (GATE N pequeno / P-010).

**INSUMOS (fonte/data — coleta 2026-06-19):**
- Organizações contábeis ativas no Brasil: **~98.000–101.228** (CFC, consolidações 2024–2025). Distribuição: Sudeste ~50%, Sul ~20%.
- Profissionais contábeis ativos: ~538 mil (CFC).
- Universo empresarial: 21,6 mi ativas (2024); Simples 84% (18,2 mi) → **base obrigada a ECD/ECF ≈ 1,74 mi** (Lucro Real **230.237** confirmado + Presumido ~1,51 mi [estimativa — sem nº oficial 2024 nos resultados]).
- Lucro Real (volume exato): **230.237 empresas** (Receita Federal — regimes de tributação; LR+LP = 14,8% das empresas e 68% da arrecadação federal). **[VERIFICADO MÚSCULO 2026-06-20]** Lacuna fechada.
- Ticket Vanguard: R$8.000–R$40.000/projeto (MODEL.json). Ponto de trabalho **R$18.000** (peso no diagnóstico de entrada).

**TAM** (teto teórico — evento único de adequação): top-down 99.500 escritórios × R$18.000 = **~R$1,8 bi** (faixa R$0,8–4,0 bi conforme ticket piso/teto).

**SAM** (perfil ideal servível — porte 5–30 func., carteira >20 clientes ECD, foco Sudeste+Sul):
- Top-down: 99.500 × ~20% (porte+carteira relevante) × ~70% (região do canal) ≈ **13.900 escritórios → ~R$250 mi**.
- Bottom-up (checagem independente): ~1,3 mi empresas não-Simples relevantes ÷ ~90 (carteira média/escritório) ≈ **14.400 escritórios**.
- **Convergência: gap ≈ 3% (< 15%) ✅** — universo servível confiável na ordem de **~14 mil escritórios**.
- Premissa frágil declarada: a fração de porte (20%) é estimativa (sem censo de porte por carteira) → IC largo nesse eixo.

**SOM** (alcançável — 0 clientes, canal WhatsApp/LinkedIn):
- Janela imediata (prazo ECD 30/06, ~11 dias): **cenário 3–8 diagnósticos** (ticket piso R$8k) = **R$24k–R$64k**. Teto de esforço de prospecção concentrada, não projeção.
- Ano-1 (penetração 0,3–1,0% da SAM): **~42–139 escritórios → R$0,75–2,5 mi**. Incerteza alta (alarga com o horizonte; sem base histórica própria).

**LEITURA FRIA (sem discurso — o Projetista traduz em R-3):**
- O gargalo **não é tamanho de mercado** (SAM ~14 mil escritórios / ~R$250 mi é amplo). É **conversão na janela curta** + capacidade de entrega com 0 clientes.
- Número publicável para ROI/deck: usar **SAM ~14 mil escritórios** + ticket R$8–40k. **Não** usar TAM como promessa; SOM da janela = cenário, marcar como tal.
- Coleta que fecharia o N firme: **[EXECUTADO]** tabela RFB integrada (volume Lucro Real ~230 mil).

**Método:** Market Sizing dupla via (top-down × bottom-up), regra dos 15%. Sem regressão/ARIMA (N insuficiente — evitado por GATE P-010).
**Handoff:** parecer → camada quente do Projetista (ROI/infográfico/deck slides 5–6). **Dependência operacional: `rclone sync` (G2 / Gate 10) deve rodar para o parecer chegar ao Drive que o Projetista lê.**
**Fontes:** CFC via [robertodiasduarte.com.br](https://www.robertodiasduarte.com.br/relatorio-executivo-evolucao-das-organizacoes-contabeis-no-brasil-1995-2024/) · [andersonhernandes.com.br](https://andersonhernandes.com.br/numero-de-escritorios-contabeis-no-brasil/) · [contabeis.com.br](https://www.contabeis.com.br/noticias/16964/contabilidade-no-brasil-possui-490-mil-profissionais/) · universo empresarial [ftcontabilidade.com.br](https://ftcontabilidade.com.br/noticias/contabil/brasil-atinge-21-6-milhoes-de-empresas-ativas-em-2024;-simples-nacional-domina-84-do-mercado/7832a1d9-f0a7-4604-9e1a-0dc3fe7c5183) · **Lucro Real 230.237** (Receita Federal) [reformatributaria.com](https://www.reformatributaria.com/brasil/286-das-empresas-estao-no-simples-so-230-mil-estao-no-lucro-real/) [VERIFICADO MÚSCULO 2026-06-20].

---

### [M-STATS] — Market Sizing `compliance-aduaneiro-ncm` · 2026-06-19 BASE (Músculo) · ROBUSTECIDO 2026-06-20 (Executor Cowork) · números-âncora VERIFICADOS (Músculo 2026-06-20)

> Origem: nicho-âncora aprovado pelo Diretor 2026-06-19 (foco único; B+C cluster saúde engatilhados pós-1ª conversa real / Gate E-4). Handoff para o Projetista.
> Regime B (dado esparso → Módulo Market Sizing TAM/SAM/SOM dupla via). **Cliente Vanguard = a empresa importadora** (decisor: Diretor Financeiro / Gerente de Importação / Compliance).
> Toda cifra = número + intervalo + fonte/data. N de clientes Vanguard = **0** → SOM é **cenário de capacidade, NÃO previsão estatística** (GATE N pequeno / P-010).

**INSUMOS (fonte/data — coleta 2026-06-19):**
- Empresas importadoras ativas no Brasil: **60.115 (2025; +7,6% vs 2024 ≈ 55.877)** (MDIC — *Relatório Anual de Comércio Exterior por Porte de Empresas* / Comex Stat). Distribuição por porte 2025: médias+grandes +5,5% (1.517), menor porte +9,5% (2.624). **[VERIFICADO MÚSCULO 2026-06-20]** Lacuna fechada.
- Volume de importações 2024: **US$ 262,484 bi** (MDIC). Conversão ~R$1,4 tri (premissa câmbio ~R$5,4/US$ 2024 — declarada).
- Base concentrada: poucas grandes respondem por maior parte do volume; alvo de auditoria preventiva é o **meio** (portfólio relevante, sem departamento fiscal robusto).
- Ticket Vanguard: **R$15.000–R$40.000**/auditoria de portfólio (MODEL.json interno — **não é fonte de mercado**; declarado). Ponto de trabalho ~R$22.000.

**TAM** (teto teórico — adequação única de portfólio): top-down 60.115 importadoras × R$22.000 = **~R$1,32 bi** (faixa R$0,9–2,4 bi conforme ticket piso/teto).

**SAM** (perfil ideal servível — portfólio importado relevante, >50 SKUs, sem revisão sistemática nos últimos 12 meses):
- Top-down: 60.115 × ~28% (distribuição por porte MDIC: médias e grandes focadas) ≈ **16.832 empresas → ~R$370 mi**.
- Bottom-up (checagem independente): importadores **frequentes/recorrentes** (≠ esporádicos) ~30% da base ≈ **18.034 empresas**.
- **Convergência: gap ≈ 6,6% sobre a base bottom-up (< 15%) ✅** — universo servível na ordem de **~16–18 mil empresas**. Intervalo de confiança (IC) largo no horizonte distante, porém a base inicial está validada.
- Premissa fixada: fração de porte (28%) e recorrência (30%) ancoradas no *Relatório Anual de Comércio Exterior por Porte de Empresas* (MDIC).

**SOM** (alcançável — 0 clientes, canal LinkedIn/indicação):
- Janela imediata: **SEM prazo de corte** (gatilho estrutural — Reforma Tributária / rejeição automática SEFAZ é contínua). Cenário de prospecção **sustentável**: 3–8 diagnósticos nos primeiros meses = **R$45k–R$320k** (ticket R$15–40k). Teto de esforço de prospecção, não projeção estatística (GATE N pequeno).
- Ano-1 (penetração 0,2–0,8% da SAM): **~33–144 empresas → R$0,7–3,1 mi**. Incerteza muito alta (IC se alarga com o horizonte; sem base histórica própria).

**LEITURA FRIA (sem discurso — o Projetista traduz em R-3):**
- Ao contrário de eventos-fiscais, **não há janela que force pressa** — o gatilho é estrutural e contínuo. Confirma a tese do Diretor: prospecção no ritmo da Vanguard, independente do Cowork rodar.
- O gargalo aqui é **acesso ao decisor** (Diretor Financeiro / Gerente de Importação / Compliance), **não** tamanho de mercado nem urgência. SAM ampla (~R$370 mi) sustenta a operação.
- Número publicável para ROI/deck: usar **SAM ~16–18 mil empresas** + ticket R$15–40k. **Não** usar TAM como promessa. Convergência agora validada (< 15%) — marcar a faixa de incerteza no longo prazo.
- Coleta que fecharia o N firme: **[EXECUTADO]** relatório Secex/MDIC integrado. Fração ancorada.

**Método:** Market Sizing dupla via (top-down × bottom-up), regra dos 15%. Sem regressão/ARIMA (N insuficiente — evitado por GATE P-010).
**Handoff:** parecer → camada quente do Projetista (ROI/abordagem/deck). **G2 EXECUTADO 2026-06-20 11:42 (rclone sync VERDE — Drive em dia) — parecer disponível ao Projetista em gdrive:vanguard.**
**Fontes:** importadoras [funcex.org.br](https://www.funcex.org.br/publicacoes/analises/Funcex_NegociosInternacionaisEmFoco_2023_02.pdf) · [ocean360.com.br](https://ocean360.com.br/empresas-importadoras-no-brasil-confira-o-estudo-exploratorio-da-funcex/) · volume importações 2024 [agenciabrasil.ebc.com.br](https://agenciabrasil.ebc.com.br/economia/noticia/2025-01/balanca-comercial-tem-superavit-de-us-7455-bilhoes-em-2024) · **importadoras 60.115 (2025)** relatório MDIC por porte [gov.br/mdic](https://www.gov.br/mdic/pt-br/assuntos/noticias/2026/marco/brasil-chega-a-29-818-empresas-exportadoras-maior-numero-da-serie-historica) · [fecomercio.com.br](https://www.fecomercio.com.br/noticia/meis-e-microempresas-puxam-recorde-de-importadoras-e-exportadoras-no-brasil) [VERIFICADO MÚSCULO 2026-06-20] · ticket: MODEL.json interno Vanguard (não-mercado, declarado).

---

### [GOVERNANCA-ATORES] — Analise cirurgica PROJETISTA x EMBAIXADOR DIGITAL · 2026-06-16

> Origem: Diretor pediu analise cirurgica das atividades dos 2 novos atores (Projetista + Embaixador
> Digital) e da integridade da cadeia COWORK -> PROJETISTA -> EMBAIXADOR DIGITAL.
> Insumos: system prompt Projetista v5.0 + fontes/entregas Embaixador Digital + inventario 31 tasks.
> Skills da etapa ANALISE_DELIBERACAO: ultrathink-trigger (Read) + brainstorming. writing-plans pos-veredito.
> NATUREZA: governanca/instrumentacao -- NAO exige modificar os system prompts (ja corretos). A correcao
> e alinhar a EXECUCAO (SKILL.md das tasks Cowork + pastas do Drive) ao que os prompts ja mandam.

**TESE CENTRAL:** existem DOIS atores por nome com permissoes opostas -- a encarnacao A (Claude Project,
deliberativa, read-only no acervo, P-124/P-075) e a encarnacao B (Cowork Scheduled Task, que ESCREVE).
O sistema os trata como um so. Esta dualidade e a raiz da maioria dos furos.

| # | Severidade | Achado | Onde corrige (NAO e prompt) | Dono |
|---|---|---|---|---|
| 1 | 🔴 | Cadeia quebrada: ninguem grava `PROJETISTA/PLANOS`; Digital le de pasta inexistente | pastas Drive (FEITO 2026-06-16) + rotina Musculo grava plano aprovado | Infra+Musculo |
| 2 | 🔴 | Tasks `projetista-task1..4` escrevem em INTELLIGENCE_HUB/Drive -- viola Mandato 6/P-124 | reapontar destino p/ INBOX_COWORK na SKILL.md das tasks | Cowork (Diretor) |
| 3 | 🟡 | Triplice sobreposicao no status DELTA (P-T1 x F3 x F5) | definir F3 dono unico; F5 audita; P-T1 so sinaliza | Cowork (Diretor) |
| 4 | 🟡 | Radar regulatorio quadruplicado (F1+F17+M2+embaixador-radar) -- custo API/E-4 | Digital consome INBOX em vez de varrer | Cowork (Diretor) |
| 5 | 🟡 | Embaixador Digital sem pasta de saida definida | criar `EMBAIXADOR_DIGITAL/{RADAR,CAMPANHAS,VALIDACOES}` se Diretor aprovar | Infra |
| 6 | 🟡 | P-T5 retroalimentacao roda sem fonte (sem campo/metricas reais ainda) | [AGUARDA-CAMPO]; FONTE DEFINIDA = loop de calibracao (retorno de prospeccao real) | Cowork (Diretor) |
| 7 | ⚪ | WhatsApp/Instagram no mandato do Digital sem task (sub-execucao) | aceitar (canal de envio manual) ou criar task | Diretor |
| 8 | ⚪ | P-T2 (terca 5h04) consolida F1 antes do F1 de terca (7h05) -- defasagem 1 dia | trivial; reordenar horario se incomodar | Cowork |
| 9 | ⚪ | Dois diarios quase simultaneos: P-T3 (23h02) x Sintese Digital (23h00) | lentes distintas; aceitavel | -- |
| 10 | ✅ | Regra global #1 ("output -> INBOX exclusivo") ja contrariada por P-T3/P-T4/Sintese Digital -> Drive | RESOLVIDO 2026-06-16: regra alinhada ao real = NAO ha 1 INBOX unico, ha 3 INBOX por ator (Vanguard->INBOX_COWORK · Projetista->PROJETISTA/INBOX · Digital->DIGITAL/INBOX). O portao P-124 fica na SAIDA (Opcao B), nao na entrada. Texto novo entregue ao Diretor p/ colar na SKILL.md | Cowork (Diretor) |

**TOPOLOGIA CONFIRMADA PELO DIRETOR (2026-06-16) -- documento: MOTOR_INTELIGENCIA_NICHO.md:**
- ENGRENAGENS = tarefas agendadas do Cowork (rodam por calendario) -> motor perpetuo, sempre gera PRODUTO VANGUARD.
- PRODUTO = a ENTREGA DO COWORK (robustecida pelo Executor). A analise do Musculo e a base/insumo; o Musculo
  NAO e autor do produto -- e PORTAO de governanca (revisa via PENDING_REVIEW, grava apos veredito, P-124).
- Embaixador Digital consome 2 fontes: a entrega do Cowork + os produtos do Projetista -> prospecta a Vanguard.
- DIRETOR = unico no humano (origina P-160 / veredito P-124 / recebe briefing / executa abordagem final).
- CAMADA CRITICA: rclone/Drive-First -- atores leem do Google Drive; produto nao propagado ao Drive nao existe
  para eles (G2 obrigatorio apos gravar/editar arquivo que ator remoto le).

**VEREDITO PARCIAL (aguarda Diretor):**
- Achado 1: pastas `PROJETISTA/PLANOS` e `/CAMPANHA` criadas (OneDrive + Drive). VEREDITO DIRETOR 2026-06-16:
  Musculo grava o plano aprovado (P-124) -- escrita unica, motivo correto (portao com veredito, nao autoria).
- Achado 5: pastas `EMBAIXADOR_DIGITAL/{RADAR,CAMPANHAS,VALIDACOES}` -- APROVADO pelo Diretor; criadas 2026-06-16.
- Achados 2/3/4/6: correcao nas SKILL.md das tasks -- ambiente Cowork, prerrogativa do Diretor (Musculo nao edita).
  Texto de reapontamento entregue ao Diretor para colar no Cowork (2026-06-16).

**VEREDITO 31 TASKS COWORK + B1 (Diretor 2026-06-16):**
- 31 tasks conferidas (aritmetica 18+7+6): 18 Vanguard (noticias mercado -> INBOX_COWORK) OK ·
  7 Projetista (projeto -> PROJETISTA/INBOX, sao INPUT do ator) OK · 6 Embaixador Digital (redes -> DIGITAL/INBOX).
- NENHUMA das 31 precisa mudar a SAIDA para INBOX_COWORK. OPCAO B macro confirmada: portao P-124 fica na SAIDA
  (Musculo grava PLANO pos-veredito + Diretor 2 cliques), NAO na entrada. As 3 INBOX por ator sao INPUT-only.
- ACHADO B1 (gemeo do Achado 1): as 6 tasks Digital escreviam em DIGITAL/INBOX mas o prompt do Embaixador Digital
  (BLOCO 7) NAO lia DIGITAL/INBOX -> cadeia orfa. RESOLVIDO: template v2.1 religado (BLOCO 2 + BLOCO 7 PASSO 2 +
  BLOCO 10). Instancia RE-COLADA pelo Diretor no Claude Project em 2026-06-17 (P-073) -> B1 100% (template + instancia).

**PROJETISTA v5.1 -- CAMADA FRIA M-STATS + NOMEACAO DE PASTAS (Diretor 2026-06-17):**
- Template TEMPLATE_INSTRUCAO_PROJETISTA.md editado v5.0 -> v5.1 (10 pontos, somente adicoes). Instancia RE-COLADA
  pelo Diretor no Claude Project do Projetista em 2026-06-17 (P-073) -> mudanca em vigor.
- DIFERENCIACAO CENTRAL: camada FRIA (M-STATS: TAM/SAM/SOM dupla via, convergencia +-15%, tendencia com IC, fonte/data/N)
  e RECEBIDA pelo Projetista, NAO calculada. Quem roda a skill market-stats-analysis = Musculo + Executor Cowork (linha 14).
  Camada QUENTE (projecao/plano/campanha) = funcao do Projetista. Mandato 23 + BLOCO 4 tabela + BLOCO 9 secao 3b.
- NOMEACAO DE PASTAS (gemeo do B1, agora fechado): PROJETISTA/INBOX (INPUT-only, tasks Cowork ao Projetista) +
  PROJETISTA/PLANOS (output, Musculo grava pos-veredito) + PROJETISTA/CAMPANHA (output, material p/ Embaixador Digital).
- HANDOFF M-STATS -> DRIVE -> PROJETISTA VERIFICADO FISICAMENTE CONECTADO: parecer vai a PENDING_REVIEW.md (canonico,
  P-124); rclone espelha a RAIZ inteira a gdrive:vanguard (verify_gdrive_freshness.ps1 linha 169 -- PENDING_REVIEW.md
  NAO esta em nenhuma exclusao). Dependencia operacional: rclone sync (G2 / Gate 10) deve rodar APOS o parecer ser escrito.
- propagate_changes.ps1: 0 cascade (TIPO 2 puro, instancia fora do repo) · sync_vanguard_docs.ps1: integridade VERDE
  (0 falhas hash, 0 desatualizados; AMARELO so por 14 orfaos pre-existentes).

### INBOX_COWORK — 18 arquivos · Embaixador Agentado · Cowork · registrados 2026-06-12

> Lidos pelo Músculo via MCP Drive em 2026-06-12. Gap de design detectado (F5 v2): Embaixador não atualiza PENDING_REVIEW automaticamente — correção necessária na skill v2.1.

| Data | Frente | Arquivo | Drive ID | Status |
|---|---|---|---|---|
| 2026-06-11 | F1 | `2026-06-11_F1_radar_dor.md` (v1) | `1_aCZyaz1n6U_I6Ly-WfrAMGp8xdrr1Rv` | AGUARDANDO |
| 2026-06-11 | F1 | `2026-06-11_F1_radar_dor.md` (v2 expandida) | `1oH0dFEUhAOvEV5Xbg3YT0pPoqwAnUIi4` | AGUARDANDO |
| 2026-06-11 | F5 | `2026-06-11_F5_espelho_estrategico.md` | `1EXfGHS-YEnjLHQnLC7E_5a7lDWrPWhMQ` | AGUARDANDO |
| 2026-06-12 | F5 | `2026-06-12_F5_espelho_estrategico.md` ⚠️ crítico | `1dyD090v6lMl2kZdnKKaqUehmGDhrHaf5` | AGUARDANDO |
| 2026-06-11 | F7 | `2026-06-11_F7_simulador_objecao.md` | `1v42fEZkWa9uxAdf3Rt9b-LILZMrIt9Xl` | AGUARDANDO |
| 2026-06-11 | F8 | `2026-06-11_F8_demo_licitacoes.html` | `1DlG_kITYXqEx72f-pRwtpXwk8dfYtxhM` | AGUARDANDO |
| 2026-06-11 | F8 | `2026-06-11_F8_roteiro_demo_licitacoes.md` | `17EDSQVB_x2TlUgYpvuIX6-XRBIFyZ9ml` | AGUARDANDO |
| 2026-06-11 | F8 | `2026-06-11_F8_demo_rastreabilidade_sanitaria.html` 🆕 | `1blZ-I8Ok26uj95nuGEocJEJa3Zu8CFKN` | AGUARDANDO |
| 2026-06-11 | F9 | `2026-06-11_F9_fomento_radar.md` (v1) | `1neMbW5RdoTMXmipGBAx0sSeBMnRZLBEi` | AGUARDANDO |
| 2026-06-11 | F9 | `2026-06-11_F9_fomento_radar.md` (v2 expandida) | `1Fm-zXLNVP17ulrA2ReRyg2aMkrgdeIqy` | AGUARDANDO |
| 2026-06-11 | F11 | `2026-06-11_F11_radar_preco.md` 🆕 | `1vGC9NYw2bvzwdvivo4bAbg40Io83FGDk` | AGUARDANDO |
| 2026-06-11 | F12 | `2026-06-11_F12_briefing_fundador.md` (v1) | `1FB9kxPt_9P-no_V9L0RU1mxTs7xGSRa3` | AGUARDANDO |
| 2026-06-11 | F12 | `2026-06-11_F12_briefing_fundador_v2.md` 🆕 | `1BtTZpgCzAfAvc_ojHJdoxOc4GVEHxrgj` | AGUARDANDO |
| 2026-06-11 | F13 | `2026-06-11_F13_touchpoint_ingrid.md` | `10d1yLeXMz775oWOghY-QWld50UuY2gfS` | STANDBY — aguarda ordem do Diretor |
| 2026-06-11 | F13 | `2026-06-11_F13_touchpoint_valdece.md` | `1dvs46XmcFagKW5XzwwL7BQdz1M-51RUo` | STANDBY — aguarda ordem do Diretor |
| 2026-06-11 | F15 | `2026-06-11_F15_guardiao_promessas.md` 🆕 | `1xQOBdnKxDSnOUMGNIH6CnCUWtnroLrAe` | AGUARDANDO |
| 2026-06-11 | INFRA | `HANDOFF_MUSCULO_LOOP33.md` | `12cwSNNvyZX-RzIJqMthcLfuHAuDpRby4` | LIDO — registrado |
| 2026-06-11 | INFRA | `SKILL.md` v2.0 | `1vZdmy6CrktwlL1x5NbEbPT4Sza0KbYBM` | LIDO — registrado |

**Ação pendente Músculo:** emitir veredito APROVADO/STANDBY/REJEITAR para cada arquivo acima. F1, F5, F7, F8, F12, F15 = revisão prioritária.

### MÚSCULO — Loop 33 · 2026-06-12

| Data | Tipo | Arquivo | Enviado ao Conselho |
|---|---|---|---|
| 2026-06-12 | DOSSIE | `CLIENTES/VANGUARD/PENDING_REVIEW/G2_DOSSIE_PNCP_V33.md` | Aguarda aprovação Diretor |
| 2026-06-12 | PITCH | `CLIENTES/VANGUARD/PENDING_REVIEW/G3_PITCH_REVERSO_V33.md` | Aguarda aprovação Diretor |
| 2026-06-12 | PITCH | `CLIENTES/VANGUARD/PENDING_REVIEW/E4_PITCH_ANTI_ALUCINACAO_V33.md` | Aguarda aprovação Diretor |

### ANTIGRAVITY ESTRATEGISTA — Loop 34 · 2026-06-14

| Data | Tipo | Arquivo | Status |
|---|---|---|---|
| 2026-06-14 | PLANO | `CLIENTES/VANGUARD/PENDING_REVIEW/G4_PLANO_EMBAIXADOR_VIA_DUPLA.md` | AGUARDANDO_VEREDITO |
| 2026-06-14 | DIRETRIZ | `CLIENTES/VANGUARD/PENDING_REVIEW/G5_TAREFAS_CLAUDE_COWORK.md` | AGUARDANDO_VEREDITO |
| 2026-06-14 | PROMPT | `CLIENTES/VANGUARD/PENDING_REVIEW/G6_SYSTEM_PROMPT_EMBAIXADOR.md` | AGUARDANDO_VEREDITO |

### ANTIGRAVITY ESTRATEGISTA — Loop 34 · 2026-06-15

| Data | Tipo | Arquivo | Status |
|---|---|---|---|
| 2026-06-15 | DIRETRIZ | `CLIENTES/VANGUARD/PENDING_REVIEW/DIRETRIZ_ESTRATEGICA_V34.md` | AGUARDANDO_VEREDITO |

### ANTIGRAVITY EXECUTOR — Sessão de Infraestrutura · 2026-06-16

| Data | Tipo | Arquivo | Status |
|---|---|---|---|
| 2026-06-16 | BLUEPRINT | `CLIENTES/VANGUARD/PENDING_REVIEW/OPS_INCIDENTS_PROPOSAL.md` | ✅ APROVADO DIRETOR 2026-06-16 · W-10 já aplicado pelo Diretor |

### ANTIGRAVITY COWORK CONDUCTOR — Sessão Única · 2026-06-13 · Aguarda veredito Músculo+Diretor

> P-124: output bruto colado pelo Diretor no chat. Músculo valida ANTES de qualquer ação.
> Corpus usado: BLOCO B (Biblioteca v4 + Competitors) + BLOCO C (NICHE_INDEX v1.4 + 11 MODELs) + BLOCO D (N16/N17/N18 CARTAO)

| Elemento | Conteúdo | Status Músculo |
|---|---|---|
| PARTE 1 — 11 modelos validados | Todos CONFIRMADOS. Glosa PROMOVER_PARA_MOVER_AGORA (já feito v1.4) | ✅ AUTO-VERDE |
| PARTE 2A — N17 Engenheiros (fit 4.6) | MOVER_AGORA — acervo técnico ART+CREA+TCU | ✅ APROVADO DIRETOR · engenheiros-acervo-tecnico_MODEL.json + NICHE_INDEX v1.5 |
| PARTE 2A — N18 Saúde Digital (fit 4.8) | MOVER_AGORA — RNDS+LGPD+CFM 2.448 | ✅ APROVADO DIRETOR · saude-digital-conformidade_MODEL.json + NICHE_INDEX v1.5 |
| PARTE 2A — N16 Farmacêuticos RT (fit 4.4) | MONITORAR (fit abaixo do threshold) | ✅ APROVADO DIRETOR · farmaceuticos-rt-compliance_MODEL.json + NICHE_INDEX v1.5 |
| PARTE 2B — N09 CSRD/ESG Exportadores (fit 5.0) | MONITORAR (diferenciação carbon-esg pendente) | ✅ APROVADO DIRETOR · csrd-esg-exportadores-eu_MODEL.json + NICHE_INDEX v1.5 |
| PARTE 3 — POST 4 Eventos Fiscais | Novo — não existia em INTENCAO_LINKEDIN | ✅ APROVADO DIRETOR · adicionado como POST 4 |
| PARTE 4 — Mapa Prioridade Comercial | Eventos Fiscais→Setor Elétrico→AI Act→Saúde Digital→ANVISA | INFORMATIVO |
| PARTE 5 — Cross-sell Clusters A/B/C | Hospitais / ESG Exportadores / Obras Públicas | INFORMATIVO |
| Alertas | 3 CRÍTICOS já registrados em PENDENTES.md | AUTO-VERDE — duplicata ignorada |

### ANTIGRAVITY COWORK CONDUCTOR — Oferta Emergencial M2 · 2026-06-16

> Origem: BRIEFING_MUSCULO_M2 (Drive ID 1ZH81i4EdGiPrGy3qwKsDmOKTf4Rm26uD)
> Objetivo: Adequação de NF para IBS/CBS obrigatórios (prazo 31/07/2026)

#### 🚨 CARD DE OFERTA COMERCIAL: ADEQUAÇÃO TRIBUTÁRIA IBS/CBS

**Nicho:** Produtoras de Shows e Eventos (Eixo Rio-SP, Faturamento > R$500k/ano)
**Gatilho:** Implementação obrigatória IBS/CBS na NF-e a partir de agosto de 2026
**Deadline de Adequação:** 31/07/2026 (45 dias)
**Ticket:** R$ 8.000 a R$ 15.000

**O Problema (Urgência):**
A partir do dia 1º de agosto, qualquer nota fiscal emitida sem o destaque correto da nova CBS e do IBS será sumariamente rejeitada pela SEFAZ. Produtoras que não adaptarem seus ERPs e revisarem seus contratos até 31/07 ficarão com a operação travada e impedidas de faturar no início do segundo semestre.

**A Solução Vanguard:**
Nossa equipe de especialistas desenhou um pacote de adequação emergencial rápido. Nós auditamos a parametrização do seu ERP atual, revisamos e elaboramos aditivos contratuais para repasse e retenção da nova carga tributária, e homologamos a emissão da NF-e para garantir que sua produtora vire a chave em agosto sem nenhuma interrupção operacional.

**Abordagem (Copy para WhatsApp/LinkedIn):**
> "O prazo para adequação da sua emissão de NF-e ao novo formato do IBS/CBS encerra em 31/07 (45 dias). A partir de agosto, notas no padrão antigo serão rejeitadas. Seu ERP e seus contratos já estão adaptados para evitar o travamento do seu faturamento? Os especialistas da Vanguard estão conduzindo a adequação emergencial em produtoras do eixo Rio-SP para garantir uma virada de semestre segura. Vamos agendar uma call de 15 minutos para avaliar sua operação?"

**Status:** ✅ APROVADO DIRETOR 2026-06-16 · liberado para prospecção (Embaixador Digital / Diretor)

---

### NICHE MODELER — Antigravity Cowork · 2026-06-13
> Corpus: 9 arquivos Drive (F1v1, F1v2, F5, F7, F8-roteiro, F9v2, F11, F12v2, F15) + Biblioteca + Competitors + NICHE_INDEX.json
> Status: **✅ APROVADO PELO DIRETOR · 2026-06-13** — Niche Intelligence Repository commitado em `173c5f4` · PASSO_NICHE_MODELER pronto para sessão Antigravity
> P-124: output bruto em `.gemini_raw_response.txt` · esta seção é a versão curada para veredito

---

**NICHE MODELER — SESSÃO ÚNICA — 2026-06-13**

#### PARTE 1: VALIDAÇÃO DOS MODELOS

```
NICHO: licitacoes-contratos-publicos
FIT_SCORE: 4.8 → CONFIRMO
GAPS: Risco sistema Alice (TCU) + Lei 14.133/21 + Acórdão 117/2024 — incluir no modelo.
INCONSISTÊNCIAS: PL 2338 (IA) afeta nicho — exige supervisão humana em sistemas de alto risco.
STATUS_AJUSTE: CONFIRMO

NICHO: glosa-hospitalar
FIT_SCORE: 4.6 → 5.0
GAPS: Taxa de glosa atingiu 17% no Q1/2025. CFM 2.448/2025 judicializada pela FenaSaúde em fev/2026.
INCONSISTÊNCIAS: Nenhuma.
STATUS_AJUSTE: MOVER_AGORA ✅ UPGRADE

NICHO: medicos-peritos-laudos
FIT_SCORE: 4.7 → 5.0
GAPS: CFM 2.448/2025 criou novo padrão de documentação para laudos — atualização metodológica obrigatória para evitar impugnações.
INCONSISTÊNCIAS: Nenhuma.
STATUS_AJUSTE: MOVER_AGORA ✅ UPGRADE

NICHO: rastreabilidade-sanitaria-premium
FIT_SCORE: 4.5 → 5.0
GAPS: Casos Ypê/Nestlé (2025/2026) aumentaram rigor. Norma ANVISA 09/06/2026 com deadline 09/12/2026.
INCONSISTÊNCIAS: Nenhuma.
STATUS_AJUSTE: MOVER_AGORA ✅ UPGRADE

NICHO: ma-reestruturacao-societaria
FIT_SCORE: 4.5 → 5.0
GAPS: Due Diligence Cibernética (BCB 538 + CMN 5.274 de mar/2026) e passivo trabalhista oculto como novos gatilhos.
INCONSISTÊNCIAS: Nenhuma.
STATUS_AJUSTE: MOVER_AGORA ✅ UPGRADE

NICHO: setor-eletrico-regulatorio
FIT_SCORE: 4.8 → 5.0
GAPS: CP 009/2026 encerrada 06/06/2026 → 60 dias para auditoria compulsória de 100% das conexões GD.
INCONSISTÊNCIAS: urgencia_regulatoria estava "ESTRUTURAL" → corrigir para "CRÍTICA" no JSON.
STATUS_AJUSTE: MOVER_AGORA ✅ UPGRADE + INCONSISTÊNCIA DETECTADA

NICHO: compliance-aduaneiro-ncm
FIT_SCORE: 4.3 → 5.0
GAPS: LC 227/2026 substituiu multa de 1% por R$20.000 por informação incorreta. Reforma Tributária bloqueia NF com NCM errado diretamente na SEFAZ.
INCONSISTÊNCIAS: Nenhuma.
STATUS_AJUSTE: MOVER_AGORA ✅ UPGRADE

NICHO: carbon-esg-mrv
FIT_SCORE: 4.5 → 5.0
GAPS: Lei 15.042/2024 sancionada. CBAM em fase definitiva jan/2026.
INCONSISTÊNCIAS: Status "MONITORAR" não reflete urgência — inventários 2026 são pré-requisito para MRV 2027.
STATUS_AJUSTE: PROMOVER_PARA_MOVER_AGORA ✅ UPGRADE + PROMOÇÃO DE STATUS

NICHO: ifrs17-seguros
FIT_SCORE: 4.3 → 5.0
GAPS: 88% das seguradoras brasileiras adotarão CPC 50. Mercado de R$630M em investimentos de transição.
INCONSISTÊNCIAS: Nenhuma.
STATUS_AJUSTE: PROMOVER_PARA_MOVER_AGORA ✅ UPGRADE + PROMOÇÃO DE STATUS
```

#### PARTE 2: NICHOS NOVOS (2 identificados — ambos fit 5.0 MOVER_AGORA)

**NOVO 1 — `conformidade-ai-act`** · Deadline 02/08/2026 · Ticket R$15K–R$80K
```json
{
  "id": "conformidade-ai-act",
  "nome": "Conformidade AI Act + PL 2338",
  "vertical": 6,
  "status": "MOVER_AGORA",
  "fit_score": 5.0,
  "setor": "Tecnologia / Compliance de IA",
  "subsetor": "Auditoria de Algoritmos e Governança de Risco",
  "match_keywords": ["AI Act", "PL 2338", "inteligência artificial", "alto risco", "compliance de IA", "multa europeia"],
  "match_setores": ["fintechs", "healthtechs", "legaltechs", "e-commerces", "SaaS exportador"],
  "dores": [
    "Desconhecimento do escopo de alto risco",
    "Ausência de documentação técnica detalhada",
    "Risco de multa de até €35M ou 7% do faturamento"
  ],
  "gatilho_regulatorio": {
    "norma": "AI Act UE e PL 2338",
    "prazo": "02/08/2026",
    "impacto": "Sanções financeiras massivas e bloqueio de mercado"
  },
  "roi_vanguard": {
    "ticket_estimado": "R$15.000 a R$80.000",
    "retorno": "Prevenção de multa de até €35M e manutenção de operações internacionais"
  },
  "pricing": { "modelo": "Diagnóstico inicial + Roadmap de adequação" },
  "narrativas": {
    "argumento_abertura": "2 de agosto de 2026 é a data. Vocês têm algum sistema que toma decisão sobre pessoas ou que serve clientes europeus? A multa é de até €35 milhões.",
    "linkedin": "A regulação europeia afeta empresas brasileiras a partir de agosto. Diagnósticos estruturados garantem a continuidade dos negócios.",
    "whatsapp": "Sua empresa exporta software ou atende a UE? O AI Act entra em vigor dia 2 de agosto. Os especialistas da Vanguard entregam o dossiê técnico necessário para evitar bloqueios."
  },
  "cadencia_cowork": { "frentes_alimentadoras": ["F17", "F22"] }
}
```

**NOVO 2 — `eventos-fiscais-contadores`** · Deadline 30/06/2026 ⚠️ · Ticket R$8K–R$40K
```json
{
  "id": "eventos-fiscais-contadores",
  "nome": "Automação Auditável de Eventos Fiscais para Contadores",
  "vertical": 3,
  "status": "MOVER_AGORA",
  "fit_score": 5.0,
  "setor": "Contabilidade / Tributário",
  "subsetor": "Auditoria de Obrigações Acessórias e SPED",
  "match_keywords": ["Eventos Fiscais", "SPED", "ECD 2026", "ECF 2026", "autuação automática", "compliance tributário"],
  "match_setores": ["escritórios de contabilidade", "departamentos fiscais corporativos"],
  "dores": [
    "Transição do SPED para Eventos Fiscais em tempo real",
    "Autuações automáticas por erros de preenchimento",
    "Processos de validação manuais ineficientes"
  ],
  "gatilho_regulatorio": {
    "norma": "ECD 2026 (leiaute 12) e ECF 2026",
    "prazo": "30/06/2026 (ECD) e 31/07/2026 (ECF)",
    "impacto": "Multas automáticas de 0,02% ao dia ou 5% sobre valor omitido"
  },
  "roi_vanguard": {
    "ticket_estimado": "R$8.000 a R$40.000",
    "retorno": "Eliminação de multas fiscais automáticas e redução do tempo de auditoria manual"
  },
  "pricing": { "modelo": "Diagnóstico de prontidão + Fluxo de validação documentado" },
  "narrativas": {
    "argumento_abertura": "O SPED está sendo substituído por Eventos Fiscais em tempo real. O erro agora é detectado imediatamente pela Receita. Sua operação suporta essa mudança?",
    "linkedin": "A transição para Eventos Fiscais exige auditoria contínua. Contabilidades de ponta substituem a checagem manual por fluxos estruturados.",
    "whatsapp": "O prazo da ECD encerra em 30 de junho. Sua contabilidade tem um processo validado para mitigar multas automáticas? Nossa equipe implementa fluxos de auditoria seguros."
  },
  "cadencia_cowork": { "frentes_alimentadoras": ["F20"] }
}
```

#### PARTE 3: NARRATIVAS COMPLEMENTARES (→ INTENCAO_LINKEDIN.md)

> Posts colados em `CLIENTES/VANGUARD/INTENCAO_LINKEDIN.md` na mesma sessão.

**POST 1 — Setor Elétrico ANEEL:** "O ONS identificou 14 GW de geração distribuída não declarada no Brasil em 2026..." → [ver INTENCAO_LINKEDIN.md]
**POST 2 — AI Act:** "O dia 2 de agosto de 2026 representa um divisor de águas..." → [ver INTENCAO_LINKEDIN.md]
**POST 3 — NCM Aduaneiro:** "As importações brasileiras superam R$ 1,6 trilhão anuais..." → [ver INTENCAO_LINKEDIN.md]

#### PARTE 4: MAPA DE PRIORIDADE COMERCIAL

| # | Nicho | Razão | Prazo |
|---|---|---|---|
| 1 | Eventos Fiscais (Contadores) | Prazo ECD 30/06 — urgência máxima e dor operacional imediata | 30/06/2026 |
| 2 | Conformidade AI Act | Deadline 02/08 — €35M de multa, concorrência inexistente | 02/08/2026 |
| 3 | Setor Elétrico (ANEEL) | Auditoria 60 dias iniciada 06/06 — retroatividade pesada | 05/08/2026 |
| 4 | Compliance Aduaneiro NCM | Rejeição automática SEFAZ — perda de receita diária | Contínuo |
| 5 | Glosa Hospitalar | CFM 2.448/2025 — argumento legal que hospitais ainda não operacionalizam | Contínuo |

**PRIMEIRO PROSPECT CONCRETO:**
Alvo: Sócio/Diretor de Compliance de escritório de contabilidade de médio porte.
Canal: WhatsApp / LinkedIn.
Mensagem: "O prazo da ECD encerra no dia 30 de junho. A transição para Eventos Fiscais gera multas automáticas pela Receita para processos não estruturados. Nossa equipe implementa os fluxos de auditoria necessários hoje. Sua operação já suporta essa mudança?"

#### [ALERTAS] — 3 CRÍTICOS

```
[ALERTA NICHE] — Automacao de Eventos Fiscais — 2026-06-13
Urgencia: CRITICA
Gatilho: Prazo de entrega ECD 2026 (leiaute 12) encerra 30/06/2026
Prazo: 30/06/2026
Destinatarios: Diretor + Musculo + Embaixador + Socios
Acao imediata: Prospectar escritórios de contabilidade de médio porte via WhatsApp/LinkedIn esta semana
Canal de prospecao: WhatsApp / LinkedIn
Mensagem de abertura sugerida: O prazo da ECD encerra em 30 de junho e a Receita automatizou as multas por erro de preenchimento; sua contabilidade já opera com auditoria de Eventos Fiscais?

[ALERTA NICHE] — Conformidade AI Act — 2026-06-13
Urgencia: CRITICA
Gatilho: AI Act UE ativa obrigações de IA de alto risco em 02/08/2026
Prazo: 02/08/2026
Destinatarios: Diretor + Musculo + Embaixador + Socios
Acao imediata: Mapear e contatar 3 CTOs/Diretores Jurídicos de fintechs brasileiras que operam na Europa
Canal de prospecao: LinkedIn
Mensagem de abertura sugerida: Faltam apenas 7 semanas para o AI Act europeu exigir conformidade dos seus algoritmos sob pena de €35 milhões; o que o regulador encontrará na sua operação?

[ALERTA NICHE] — Setor Eletrico / GD — 2026-06-13
Urgencia: CRITICA
Gatilho: ANEEL encerrou CP 009/2026 em 06/06/2026 — 60 dias para auditoria compulsória de 100% das conexões GD
Prazo: 05/08/2026
Destinatarios: Diretor + Musculo + Embaixador + Socios
Acao imediata: Identificar 2 integradoras GD com mais de 500 kW instalados para abordagem imediata
Canal de prospecao: WhatsApp / Indicacao
Mensagem de abertura sugerida: A ANEEL iniciou auditoria de 60 dias em 100% das conexões de GD; suas instalações possuem trilha documental para evitar retroatividade de 36 ciclos?
```

---

### EMBAIXADOR AGENTADO — COWORK · Stream NICHO MÚSICA/ENTRETENIMENTO · anunciado 2026-06-15

> Mensagem terminal do Embaixador ao Músculo, marcada **"Para conhecimento"**. Anúncio de 7 frentes (M1–M7)
> de pesquisa do mercado brasileiro de música/entretenimento. **COWORK ≠ LOOP** — inteligência de mercado dinâmica,
> não ciclo Pentalateral de cliente. **P-059 N/A** (pesquisa de mercado, não dado de cliente ativo).
> Fluxo declarado pelo Embaixador: "O Embaixador entrega. Você delibera e redige as instruções. O Antigravity executa."
> Saída das frentes → INBOX_COWORK (Folder `1EjaH6TmsxbYpgKWb7ASm7CohFJfwSLKi`) → registradas aqui quando entregues.

| Frente | Status |
|---|---|
| M1–M7 — mercado música/entretenimento BR | ✅ ENTREGUE — corpus rodando no INBOX_COWORK. Colheita do dia 15/06 abaixo. |

**Ação Músculo:** quando o corpus M1–M7 chegar ao INBOX_COWORK, deliberar em sessão COWORK dedicada e redigir as instruções para o Antigravity (P-124). Sem ação de build imediata — anúncio é "para conhecimento".

---

### COLHEITA COWORK FONOGRÁFICO — 2026-06-15 (segunda) · GATE DE DATA aplicado

> Inteligência de mercado da Vanguard (Claude Cowork). **NÃO é loop. P-059 N/A** (pesquisa de nicho, não dado de cliente).
> Alimentará o discovery do PROJ-003 Mumuzinho/Dudu Félix quando o projeto sair de STANDBY.
> GATE DE DATA (Diretor 2026-06-15): hoje, segunda dia 15 → previstos **M1 + M4 + M7**. Colhidos os 3. Fonte+data sempre (P-132).

| Task | Arquivo (versão colhida) | Drive ID | Sinal #1 (mais urgente) |
|---|---|---|---|
| **M1** Radar de Artista | `2026-06-16_BRIEFING_MUSCULO_M1_radar_artista.md` | `1l0FyDNPe9Df1Pr302IJ0-OCuh1tLEQqP` | Lei 15.270/2025 — IRRF 10% sobre dividendos de PJ artística (vigente 2026) |
| **M4** ECAD + Streaming | `2026-06-15_BRIEFING_MUSCULO_M4_ecad_v2.md` | `15xuPmXptzQJ25LYk5fc2_7f1Op4qehy0` | ECAD cobra por música gerada por IA — precedentes TJSC + TJPA ("Suno free" encerrada) |
| **M7** Concorrência Musical | `2026-06-15_BRIEFING_MUSCULO_M7_concorrencia_v2` | `11zZzk5azzCtSg5y9frUnL0AOnBH4F_tq` | Nenhum dos 24+ players oferece compliance preventivo integrado (gap-núcleo Vanguard) |

**Oportunidades recorrentes nos 3 briefings (convergência — sinal forte):**
1. **Diagnóstico Pós-Lei 15.270/2025** — revisão de estrutura societária de artistas PJ/holdings (M1 + M7 cruzam com a Lei). Ticket alto, mercado sem oferta especializada.
2. **Compliance ECAD × IA** — regularização retroativa (Suno) + auditoria de declaração de uso de IA (M4). Precedentes judiciais já firmados; ticket R$10–15k.
3. **Compliance preventivo multi-regulatório integrado** (ECAD + tributário + trabalhista + contratual) — gap confirmado por M7: ninguém integra os 4 eixos. Produto-núcleo possível: "Raio-X de Conformidade do Artista".
4. **Reforma Tributária 2026 para artistas** (M7) — janela aberta, zero concorrentes comunicando; CBS efetiva 2027.

**Alerta operacional do próprio Cowork (não comercial):**
- **M4 e M7 rodaram 2× hoje** (v1 + v2). O briefing M7 (pergunta 5 + Prioridade 4) sinaliza **possível duplicação de agendamento no scheduler** → verificar para evitar consumo desnecessário.
- **M1 com rótulo de data divergente:** arquivo nomeado `2026-06-16` mas criado/executado em 15/06 (primeira execução). Conferir convenção de nomeação do Cowork.

**Concorrente a monitorar (M7):** **Luna Advogados** — jurídico preventivo para entretenimento, o mais próximo da proposta Vanguard no eixo jurídico. Ameaça BAIXA-MÉDIA; elevar se ampliar para tributário/financeiro.

**Ação Músculo (pendente de veredito do Diretor):** estes são **insumos de nicho**, não decisões. Nenhum vira ação/DECISOES sem veredito. Sugestões de routing aguardam o Diretor (P-075).

---

### COLHEITA COWORK — 2026-06-16 (terça) · GATE DE DATA aplicado (M2 + F1)

> Cowork Artifact Engine conduzido pelo Músculo (skill `cowork-engine-v1` lida — orientação). **NÃO é loop.** Output cru para veredito (P-124).
> GATE DE DATA: terça 16-06 → previstos **M2 (fonográfico) + F1 (radar diário)**. NICHE_MODELER é Mensal-1 → **não roda hoje**.
> GATE DE SINAIS: `CALIBRACAO.md` tem 1 run (2026-06-13) já enviada (Loop 34) → **0 runs novas → ida ao Antigravity NÃO justificada hoje** (correto: Músculo conduz, Antigravity só com run nova).

**STREAM F1 — genérico (Biblioteca de Nichos) · 6 sinais novos + 2 evoluídos**

Inventário: todos os sinais F1 de hoje são **ADICIONAL/EVOLUÍDO de nichos já catalogados** — nenhum nicho novo. Mais importante: **confirmam (2ª aparição = DELTA) os upgrades que o NICHE_MODELER já fez em 2026-06-13.** Não altera a Biblioteca (TIPO 1); valor = manter prioridade de pipeline.

| Sinal | Nicho (status atual) | Score D1-D5 | Veredito |
|---|---|---|---|
| ANVISA recall/rastreabilidade (180d, ~dez/2026; multa até R$1,5M) | `rastreabilidade-sanitaria-premium` (já 5.0 MOVER_AGORA) | **5.0** (D1 5·D2 5·D3 5·D4 4·D5 5 +0.5) | 🟢 **MOVER AGORA** — CONFIRMA upgrade 13/06 |
| LC 227/2026 retroatividade benigna NCM (cancela multa no CARF) | `compliance-aduaneiro-ncm` (já 5.0 MOVER_AGORA) | **4.2** | 🟢 **MOVER AGORA** — nova dimensão: serviço pontual ROI imediato |
| CFM 2.448/2025 sob contestação judicial + ANS CP 170 | `glosa-hospitalar` / `medicos-peritos-laudos` (já 5.0) | **4.4** | 🟢 **MOVER AGORA** ⚠️ **só com narrativa de janela** — norma pode ser suspensa; não construir produto pesado em cima |
| TCU Acórdão 37/2026 (dever de motivação em licitações) | sem nicho dedicado (adjacente `licitacoes-contratos-publicos`) | **3.2** | 🟡 **MONITORAR** — difuso; janela operacional apertada |
| Reforma Tributária complexifica due diligence M&A | `ma-reestruturacao-societaria` (ângulo tributário novo) | **3.4** | 🟡 **MONITORAR** — verificar capacidade interna |

**STREAM M2 — fonográfico (→ PROJ-003 Mumuzinho/Dudu Félix) · `[NICHO-FONOGRÁFICO]` · P-059 N/A**

3 sinais NOVOS desta semana (não entram no Score Vanguard da Biblioteca — insumo de discovery fonográfico):
1. **IBS/CBS obrigatório em NF** (ago/2026 — **45 dias**, prazo crítico): produtoras/agências/casas de show precisam adequar ERP+contratos até 31/07. Ticket sugerido R$8–15k.
2. **PEC 13/26** — última barreira antes da extinção automática de incentivos culturais (ICMS/ISS) → produto "planejamento de captação pós-Reforma".
3. **PL 2269/24** — licença ambiental obrigatória para grandes eventos (pena de detenção aprovada em comissão) → checklist pré-evento.
- PL 2338/23 (IA autoral, escalada 2ª semana) cruza com `conformidade-ai-act` já catalogado. Decreto Segurança Privada → repetido.

**Perguntas que exigem o Diretor (dos briefings):** (a) há fabricante de alimentos/cosméticos na carteira p/ abordar ANVISA esta semana? (b) Vanguard executa levantamento NCM internamente ou precisa de parceiro tributarista? (c) acelerar clínicas antes de possível suspensão da CFM 2.448?

**Ação Músculo:** registro consolidado, sem alterar Biblioteca/MODELs (sem nicho novo). Nenhum vira DECISOES/WIP sem veredito (P-124/P-075). Stream M2 fica como insumo de discovery do PROJ-003 (STANDBY).

**DELIBERAÇÃO DO DIRETOR — 2026-06-16** (resposta às 3 perguntas dos briefings):
- **Não há prospecção imediata.** Antes de abordar qualquer prospect (ANVISA/NCM/CFM), é preciso **criar a infraestrutura de ativação** — "iniciar página, outras coisas para tais atividades".
- **Cadência incremental:** "iremos criando nichos aos poucos" — não despejar os MOVER_AGORA de uma vez; ativar nicho a nicho.
- **Ressalva CFM (#3):** acelerar só **com narrativa de janela** ("use enquanto a norma te protege") — norma sob contestação judicial pode ser suspensa; não construir produto pesado em cima.
- **ATRELAMENTO:** toda essa frente (páginas + atividades + criação de nichos) está **atrelada a um assunto maior que o Diretor abordará depois**. Portanto: **intenção registrada, build NÃO iniciado.** Aguardar o Diretor trazer o tema antes de qualquer construção.

---

## MISSÕES DE INTELIGÊNCIA ATIVAS (deliberadas Loop 29, D5:A — aguardando execução/output)

> P-134: missão aberta vive aqui, nunca na memória de turno. Firewall P-132/P-124/P-119/P-059.
> Cadência (D9:A): competitivo/tendências **semanal** · edital **quinzenal até 06/09** · tecnológico **sob gatilho**.

| Missão | Quem | Prazo | Status |
|---|---|---|---|
| **M-INTEL-1** Triangulação cega do fact-check "venture-studio agentado é viável" | Músculo (WebSearch) + Auditor (Deep Research) — **cegos entre si** | — | ABERTA |
| **M-INTEL-2** Benchmark de pricing LegalTech para Valdece V4 (ancorar P-108) | Embaixador (Cowork) + Auditor (Deep Research) | **2026-06-18** (antes do fim do Hypercare) | ABERTA |
| **M-INTEL-3** Watch de Edital Ingrid (Quadrix / Sedes-DF) | Embaixador (Cowork) + Auditor | **2026-06-09 PRAZO DURO** → depois quinzenal | DESCARTADA — Por ordem do Diretor |

> Saída de cada missão: FONTE (URL + data) sempre, ou "não confirmado". Resultado entra como linha em AGUARDANDO VEREDITO acima. Nunca direto a DECISOES.json/WIP.

---

## APROVADOS

| Data aprovação | Tipo | Arquivo | Enviado ao Conselho |
|---|---|---|---|
| 2026-06-07 | COMPETITORS | `COMPETITORS/REPORT_COMPETITORS_2026-06.md` | Sim — gerado pelo Músculo na sessão inaugural |
| 2026-06-11 | DIRETRIZ | `CLIENTES/VANGUARD/PENDING_REVIEW/DIRETRIZ_ESTRATEGICA_V33.md` | Sim — G-1..G-5 aprovados pelo Diretor · PASSO5 gerado |
| 2026-06-11 | ARTEFATO_PRECEDENTES | `CLIENTES/VANGUARD/PENDING_REVIEW/artefato_precedentes_V33.md` | Sim — aprovado pelo Músculo (P-124) |
| 2026-06-11 | ARTEFATO_AUDITORIA | `CLIENTES/VANGUARD/PENDING_REVIEW/artefato_auditoria_M_V33.md` | Sim — tensões M-1..M-5 vs LEDGER validadas |
| 2026-06-11 | ARTEFATO_NICHOS | `CLIENTES/VANGUARD/PENDING_REVIEW/artefato_nichos_V33.md` | Sim — 5 nichos aprovados; Licitações como Vertical 1 |
| 2026-06-11 | WALKTHROUGH | `CLIENTES/VANGUARD/PENDING_REVIEW/walkthrough_DIRETRIZ_V33_2026-06-11.md` | Sim — fontes e trade-offs documentados |
| 2026-06-13 | COWORK_SCHEMA | `INTELLIGENCE_HUB/NICHE_MODELS/SCHEMA.md` | Sim — commit 173c5f4 |
| 2026-06-13 | COWORK_MODEL | `NICHE_MODELS/licitacoes-contratos-publicos_MODEL.json` | Sim — commit 173c5f4 |
| 2026-06-13 | COWORK_MODEL | `NICHE_MODELS/glosa-hospitalar_MODEL.json` | Sim — commit 173c5f4 · promovido MOVER_AGORA |
| 2026-06-13 | COWORK_MODEL | `NICHE_MODELS/rastreabilidade-sanitaria-premium_MODEL.json` | Sim — commit 173c5f4 |
| 2026-06-13 | COWORK_MODEL | `NICHE_MODELS/compliance-aduaneiro-ncm_MODEL.json` | Sim — commit 173c5f4 |
| 2026-06-13 | COWORK_MODEL | `NICHE_MODELS/ma-reestruturacao-societaria_MODEL.json` | Sim — commit 173c5f4 |
| 2026-06-13 | COWORK_MODEL | `NICHE_MODELS/setor-eletrico-regulatorio_MODEL.json` | Sim — commit 173c5f4 |
| 2026-06-13 | COWORK_MODEL | `NICHE_MODELS/medicos-peritos-laudos_MODEL.json` | Sim — commit 173c5f4 · promovido MOVER_AGORA |
| 2026-06-13 | COWORK_MODEL | `NICHE_MODELS/carbon-esg-mrv_MODEL.json` | Sim — commit 173c5f4 |
| 2026-06-13 | COWORK_MODEL | `NICHE_MODELS/ifrs17-seguros_MODEL.json` | Sim — commit 173c5f4 |
| 2026-06-13 | COWORK_INDEX | `INTELLIGENCE_HUB/NICHE_INDEX.json` v1.4 | Sim — commit 86853b4 · 7 MOVER_AGORA / 4 MONITORAR |
| 2026-06-13 | COWORK_SCRIPT | `scripts/match_niche.ps1` | Sim — commit 173c5f4 |
| 2026-06-13 | COWORK_PASSO | `CLIENTES/VANGUARD/PASSO_NICHE_MODELER.md` | Sim — pronto para sessão Antigravity Cowork |

---

## REJEITADOS

| Data rejeição | Tipo | Arquivo | Razão |
|---|---|---|---|
| *(Músculo move aqui com razão do rejeito)* | — | — | — |

---

## REGRAS OPERACIONAIS

**Antigravity:** ao concluir qualquer relatório, adicionar linha no bloco AGUARDANDO VEREDITO antes de encerrar.

**Músculo:** ao iniciar sessão, verificar se há entradas em AGUARDANDO VEREDITO — revisão tem prioridade sobre qualquer nova pesquisa.

**Veredito possíveis:**
- `APROVADO` → mover para bloco APROVADOS + registrar se foi encaminhado ao Conselho
- `REJEITADO` → mover para bloco REJEITADOS + declarar razão objetiva + Antigravity refaz

| 2026-06-15 | CURADORIA | `CLIENTES/VANGUARD/PENDING_REVIEW/CURADORIA_SKILLS_V35.md` | AGUARDANDO_VEREDITO |

---

# 🛰️ DETECTOR DE DERIVA — PRIMEIRA VARREDURA (ATIVAÇÃO F7 · 2026-06-17)

> Prova-de-vida do Detector ativado na Operação Vault Soberano F7. Camada determinística
> (`scripts/detector_deriva.ps1`) + auto-auditoria §7 da persona + P-059 sweep. O Detector
> **detecta, não corrige** (Mandato 1/P-124) — cada achado abaixo aguarda veredito do Diretor;
> a correção, quando aprovada, é do Músculo. Modo: `[fallback grep — Obsidian fechado]`.

## DERIVA DETECTADA — 2026-06-17 — F7-01

### TIPO
Omissão de frescor (documento defasado)

### PRINCÍPIO VIOLADO
[P-005] Inteligência acumulada por sessão — documento de timeline deve refletir o loop atual.

### DOCUMENTO(S) EM DERIVA
`CLIENTES/VANGUARD/CLAUDE_PROJECT/16_VANGUARD_TIMELINE.md`
`CLIENTES/VANGUARD/NOTEBOOKLM_FONTES/17_VANGUARD_TIMELINE.md`

### TRECHO DIVERGENTE
> (ausência) Nem "Loop 35" nem "Loop 34" aparecem na Timeline — sistema está no Loop 35.

### NATUREZA DA DERIVA
A Timeline da Vanguard parou ≥2 loops atrás. Gate 0.5 (`doc_freshness_checker`) marca VERMELHO.
Documento de histórico que não acompanha o loop corrente induz contexto defasado em quem o lê.

### SUGESTÃO AO DIRETOR
Atualizar as duas Timelines com os marcos dos Loops 34–35 (tarefa do Músculo, pós-veredito).
Não é bloqueante para a Operação Vault — é dívida de conteúdo do loop VANGUARD.

### SEVERIDADE
MÉDIA

---

## DERIVA DETECTADA — 2026-06-17 — F7-02

### TIPO
Erro de referência (caminho inexistente no próprio mapa do Detector)

### PRINCÍPIO VIOLADO
[P-033] Sync/coerência de mapa — caminho citado deve existir na estrutura real.

### DOCUMENTO(S) EM DERIVA
`CONSELHO/SYSTEM_PROMPT_DETECTOR_DERIVA.md` (§7, linha ~441)

### TRECHO DIVERGENTE
> `PENTALATERAL_UNIVERSAL/MAPA_VAULT.md ← mapa do vault (verificar consistência com estrutura real)`

### NATUREZA DA DERIVA
A persona v1.4 §7 lista `PENTALATERAL_UNIVERSAL/MAPA_VAULT.md` como alvo de varredura, mas o
arquivo NÃO existe — só existe `CONSELHO/MAPA_VAULT.md`. Auto-auditoria pós-reorg F2–F5: o §7
referencia um caminho que a reorg tornou órfão (ou que nunca foi criado nesse local).

### SUGESTÃO AO DIRETOR
Corrigir o §7 da persona: ou apontar para `CONSELHO/MAPA_VAULT.md`, ou criar o MAPA_VAULT
em PENTALATERAL_UNIVERSAL/. Dogfooding bem-sucedido: o Detector pegou deriva no próprio prompt.

### SEVERIDADE
MÉDIA

---

## DERIVA DETECTADA — 2026-06-17 — F7-03

### TIPO
Zona-cinza P-059 (possível cross-referência cliente fora de CLIENTES/*) — deliberação do Diretor

### PRINCÍPIO VIOLADO
[P-059] Isolamento de Contexto por Cliente — a decidir se aplica ou se é inteligência de nicho.

### DOCUMENTO(S) EM DERIVA
`PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/COMPETITORS/REPORT_COMPETITORS_2026-06.md`
`PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/TRENDS/README.md`
`PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/NICHE_MODELS/compliance-aduaneiro-ncm_MODEL.json`

### TRECHO DIVERGENTE
> COMPETITORS: "competição direta com Valdece" · "Relevância Ingrid: ALTO"
> TRENDS: "Valdece + próximos clientes jurídicos" · "Ingrid + próximos clientes educação"
> NICHE_MODELS: "Ha empresas de importacao na rede ... de clientes atuais (Ingrid, Valdece)?"

### NATUREZA DA DERIVA
Três docs do Intelligence Hub cross-referenciam clientes ativos por nome para priorização de
mercado. NÃO há dado privado/credencial/segredo de cliente — é correlação nicho↔cliente. Precedente:
`CALENDARIO_NICHE_INTELLIGENCE.md` faz o mesmo e foi declarado "P-059 N/A — inteligência de NICHO"
pelo Diretor (2026-06-15). Por isso NÃO marco CRÍTICA: é decisão do Diretor se o mesmo veredito
de exceção se estende a estes três (padrão consistente) ou se exige refatorar para anonimizar.

### SUGESTÃO AO DIRETOR
Decidir: (a) estender a exceção "inteligência de nicho, P-059 N/A" e anotar nos 3 docs (como já
está no CALENDARIO), OU (b) anonimizar as referências (trocar nome do cliente por "cliente jurídico
ativo" etc.). Recomendação do Detector: (a) — é o precedente vigente; basta anotar a exceção.

### SEVERIDADE
MÉDIA

---

## DERIVA DETECTADA — 2026-06-17 — F7-04

### TIPO
Omissão de robustez (guardrail de leitura)

### PRINCÍPIO VIOLADO
[OWASP ASI01 / §2.6 persona] Deny-list de credenciais — declarada na prosa, sem enforcement em hook.

### DOCUMENTO(S) EM DERIVA
`.claude/hooks/protected_paths.txt` (cobre Write/Edit de canônicos; não cobre READ de credenciais)

### TRECHO DIVERGENTE
> protected_paths.txt protege LEDGER/CLAUDE.md/DEPENDENCY_MAP/PASSO/skills contra Write/Edit —
> nenhuma entrada `.env`/`CHAVES`/`*.key` como deny de LEITURA.

### NATUREZA DA DERIVA
A persona v1.4 (§2.6 + Mandato 10) proíbe o Detector de abrir credenciais, mas não há hook que
BARRE a leitura de `.env`/CHAVES. Risco residual BAIXO: segredos já estão fora do git (`.gitignore`)
e fora do Drive (`rclone_secrets_exclude.txt`, P-185), e o Detector roda como subagente read-only
com escrita só em PENDING_REVIEW. Mas a defesa é "por confiança na persona", não mecânica.

### SUGESTÃO AO DIRETOR
Opcional (defesa em profundidade): adicionar `\.env$`, `CHAVES_SISTEMA`, `\.key$` a um read-guard.
Não bloqueia F7 — é endurecimento futuro. Registrado para não virar dívida silenciosa (P-146).

### SEVERIDADE
BAIXA

---

> **Resumo da varredura F7 (Detector ativado):** 4 derivas — 0 CRÍTICA · 3 MÉDIA · 1 BAIXA.
> Mais grave: nenhuma é crítica (nenhum vazamento de dado privado de cliente). O Detector
> **funciona** — pegou deriva real em 3 frentes distintas (frescor, referência da própria persona,
> zona-cinza P-059) + 1 achado de guardrail. Detecta e reporta; o Diretor decide; o Músculo corrige.

---

## [GOVERNANCA-ATORES-FINAL] Convergencia Projetista <-> Embaixador Digital (LinkedIn) -- 2026-06-20

> Analise FINAL ("daqui pra frente") confirmada pelo Diretor 2026-06-20 (opcao 1: Embaixador Digital = operador LinkedIn v2.0 em disco).
> Consolida o bloco [GOVERNANCA-ATORES] de 2026-06-16. GATE DE FATO: 31 tarefas Cowork = 18 Vanguard + 7 Projetista + 6 Embaixador Digital.

### EIXO (entradas -> saidas)
- COWORK (madrugada, Categoria A): 18 Vanguard -> INBOX_COWORK | 7 Projetista -> PROJETISTA/INBOX | 6 Digital -> DIGITAL/INBOX. Os 3 INBOX sao INPUT-only (input livre).
- PROJETISTA (Claude Project) PRODUZ -> PROJETISTA/PLANOS + PROJETISTA/CAMPANHA (cards, roteiros, infograficos, abordagem blindada R-3).
- PORTAO P-124 fica na SAIDA (veredito do Diretor sela a passagem do material entre os dois atores), nao na entrada.
- EMBAIXADOR DIGITAL (LinkedIn) CONSOME PROJETISTA/PLANOS+CAMPANHA -> campanha LinkedIn (5 fases B2B, auditoria ICP).

### 2 pontos de convergencia real (onde moravam os furos)
1. Projetista -> Digital (material de campanha): cadeia PROJETISTA/PLANOS + PROJETISTA/CAMPANHA. Furo Achado 1 (vermelho) RESOLVIDO 2026-06-16 (pastas criadas + Musculo grava pos-veredito).
2. Digital -> Projetista (resultado de campo): comando `retroalimentacao` (sexta) + Task 5 do Projetista. Fecha o loop com licoes aprendidas.

### CAMADA FRIA vs QUENTE (confirmado)
- M-STATS (market-stats-analysis) e RECEBIDA pelo Projetista via PENDING_REVIEW; quem roda = Musculo + Executor Cowork. Projetista faz a camada quente (projecao/plano/campanha, R-3).

### Notificacao de abertura (mecanismo, ATIVO/pendente)
- W-11 (07:05) = ativacao MANUAL Projetista/Embaixador Digital (comando para colar no Claude Project). ATIVO.
- W-12 (07:10) = marcos de inteligencia de mercado. ATIVO.
- W-13 (07:15) = F(x) Cowork que exigem o Musculo abrir sessao (id n8n g06fYsG6kxduv7ZA). DESATIVADO -- aguarda veredito do Diretor (ativar_w13.ps1). w13_logic.js nao commitado.
- Fonte de verdade da cadencia: scripts/cowork_calendar.ps1 (session_start gate 0C) + scripts/comandos_ativacao_atores.json.

### Edicao executada nesta sessao
- BLOCO 7 (template canonico v5.1 + espelho CONSELHO): Projetista usa skill /notebooklm para criar o caderno PROJETISTA-ACERVO (executada pelo Musculo, ator e Claude Project). Ordem direta do Diretor.

### Drift remanescente (para veredito)
- comandos_ativacao_atores.json cita "Embaixador Digital v2.1" mas disco mostra SYSTEM_PROMPT_EMBAIXADOR_DIGITAL.md v2.0 -- verificar versao vigente.
- Espelho CONSELHO/SYSTEM_PROMPT_PROJETISTA.md ainda marcado v5.0 (so o BLOCO 7 foi ressincronizado cirurgicamente); diferencas v5.0->v5.1 restantes (camada fria M-STATS, pastas nomeadas) pendem de ressincronizacao completa.

## [DESENHO-MAE-AQUISICAO] Esteira de Aquisicao Vanguard -- inteligencia mira, DNA monta -- 2026-06-20

> Sintese estrategica ORIGINADA pelo Diretor 2026-06-20 e confirmada por ele nesta sessao ("Sim").
> Status: MODELO DO FUNIL = CONFIRMADO. Sub-decisoes de execucao = AGUARDANDO_VEREDITO (ver fim do bloco).
> Contexto que disparou: atores Projetista v5.1 + Embaixador Digital v2.2 inicializados; diagnostico "inteligencia de sobra, materializacao de menos -- esteira represada no Projetista".

### PRINCIPIO RAIZ (o DNA nao mudou -- a mira mudou)
- Como a Vanguard nasceu (intacto): cliente com DOR -> responde PERGUNTAS (Diagnostico/quiz) -> LOOP Pentalateral monta o projeto. Foi assim com INGRID e VALDECE. O mecanismo e o coracao e permanece.
- O que a inteligencia de mercado acrescentou: antes o cliente chegava aleatorio; agora SABEMOS quais nichos elevados perseguir. A inteligencia e a CAMADA DE MIRA -- nao substitui o DNA, aponta ele.

### FUNIL UNIFICADO
INTELIGENCIA DE MERCADO (mira: quais nichos elevados)
  -> SITE + LINKEDIN orientados ao nicho (atracao: "chama a atencao" do cliente certo)
  -> QUIZ / DIAGNOSTICO (as perguntas: captura a dor)
  -> LOOP PENTALATERAL (monta o projeto, como Ingrid/Valdece)
  -> CLIENTE
LinkedIn e site NAO competem: ambos orientados pela inteligencia para os nichos elevados, ambos desaguam no quiz, que aciona o Loop.

### DECISOES TRAVADAS (veredito do Diretor 2026-06-20)
1. MARCA LARGA, ATRACAO MIRADA. "Vende qualquer projeto" intacto na capacidade; inteligencia escolhe em quem bater. Mesmo principio do LinkedIn (marca larga/campanha afiada) estendido ao site. Ver memory feedback-vanguard-vende-qualquer-projeto-linkedin.
2. SITE JA EXISTE -- ORIENTAR, NUNCA RECONSTRUIR. Site no ar (vanguardtech.cloud), feito antes da inteligencia existir (Vanguard v1). Evolui COM DIRECAO: ganha superficies de atracao para os nichos elevados (secao/landing que fala a dor + gatilho de cada nicho), reaproveitando o quiz existente. Nao e rebuild.
3. DESTINO DO CANAL = QUIZ/DIAGNOSTICO -> LOOP (nao "conversa avulsa"; o quiz e o mecanismo de captura de dor que sempre foi). [CORRIGE proposta anterior do Musculo de "site fora do caminho critico".]
4. RECUO DO ECD. eventos-fiscais-contadores (ECD 30/06, 10 dias) NAO ancora lancamento -- "10 dias e muita correria, temos material para nao sair desesperado". ECD vira, no maximo, post de autoridade da semana. Sem sprint de outbound.
5. CANAL NASCE NA MARCA AMPLA (Vanguard movida a inteligencia, resolve problema de alto risco). Nichos = pipeline ROTATIVO de campanhas (1 por vez, no seu tempo).

### LEI DE PRECEDENCIA (ja vigente, reconfirmada em disco)
Projetista PRODUZ antes; Embaixador Digital CONSOME. Verificado nesta sessao: PROJETISTA/PLANOS vazio -> Digital corretamente parou em [AGUARDA Projetista]. Mecanismo vivo.

### SITE -- GATE DE FATO (corrigido pelo Diretor 2026-06-20: "Ja construimos o site, tem tudo na memoria")
- Site JA EXISTE e esta NO AR: vanguardtech.cloud. Stack estatica (HTML/CSS/JS vanilla + Supabase), deploy via EasyPanel/Hostinger (memory project_deploy_hostinger; historico V1-V23). NAO construir do zero.
- Conteudo atual (lido 2026-06-20): Vanguard v1 -- agencia de transformacao digital p/ PMEs de servicos: Diagnostico Vanguard(TM) (Presenca/Aquisicao/Conversao/Retencao), Hermes (prospeccao WhatsApp), planos R$97/mes e R$3-6k. O quiz/Diagnostico do site E o "responde perguntas" do DNA -> reaproveitar.
- Acao = ORIENTAR aos nichos elevados (superficies de atracao mirada), no ritmo da trilha separada, sem correria.

### AGUARDANDO_VEREDITO (sub-decisoes de execucao -- nao agir sem o Diretor)
- A1. Nicho-ancora da 1a campanha COM push real de outbound: AI Act (02/08, com folego) ou um nicho ESTRUTURAL sem prazo (glosa-hospitalar / ifrs17-seguros)? [Musculo recomenda AI Act -- runway ~6 semanas.]
- A2. Orientacao do site aos nichos elevados: localizar a pasta-fonte exata do vanguardtech.cloud no repo + definir quais nichos ganham superficie de atracao primeiro e como o EasyPanel/Hostinger redeploya.
  NOTA (DIFERIDO -- Diretor 2026-06-20 "depois vemos isso"): existe uma versao "www" construida que NUNCA foi ao ar -- provavel problema tecnico de deploy. Diagnosticar antes/junto da orientacao do site.
- A3. Ordem operacional do lancamento do canal (Projetista projeta -> Digital setup marca-ampla -> MUSCULO cria a Company Page remotamente -> 1o lote). So apos A1.
  CORRECAO (Diretor 2026-06-20): a Company Page do LinkedIn e criada REMOTAMENTE pelo Musculo (Playwright / claude-projects-remote-v1), nao pelo Diretor. Marca AMPLA (memory feedback-vanguard-vende-qualquer-projeto-linkedin).
  NOTA TECNICA (Pilar I -- deliberar na execucao): LinkedIn exige perfil pessoal vinculado a Company Page + tem deteccao anti-automacao. Criacao via Playwright e viavel mas pode demandar 1 passo manual do Diretor (login/verificacao). Confirmar viabilidade no inicio do A3.
