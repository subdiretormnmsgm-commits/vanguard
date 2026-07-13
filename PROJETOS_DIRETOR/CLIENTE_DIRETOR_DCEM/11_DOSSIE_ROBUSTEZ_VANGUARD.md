# 11 — DOSSIÊ DE ROBUSTEZ VANGUARD → BASE DCEM
> Projeto pessoal do Diretor · DCEM · isolado (P-059). Destilação da experiência Vanguard (35 versões +
> INTELLIGENCE_LEDGER + KNOWLEDGE_BASE + método) aplicada à robustez da Base de Consultas Asse Ct Orç.
> Produzido por 3 agentes de destilação em paralelo (2026-07-11). Cada regra tem fonte em disco.
> **Função deste documento:** que a Base nasça robusta por HERANÇA — carregando o que já custou caro à Vanguard —
> não por sorte. É insumo de deliberação (P-124): nada muda no Gerador sem veredito do Diretor.

---

## VEREDITO EM 1 PÁGINA — o que a experiência Vanguard muda na Base

O esqueleto do plano (`10_PLANO...`) já acerta o essencial: Norma Viva como PK, `Hash_Parametros`,
`Status_Obsolescencia` read-time, `PARAMETROS` versionado, marcador `[CONFIRMAR]`, campo livre do macete,
separação armadilha/macete, 1-toque, autoria condicional. A destilação **confirma** isso e aponta
**5 endurecimentos** que separam um banco que sobrevive de um que "morre vazio" ou "envelhece mentindo".

| # | Endurecimento | Regra-fonte | Onde entra |
|---|---|---|---|
| **E-α** | `[CONFIRMAR]` vira **TRAVA**, não aviso: valor não confirmado retorna `#N/D` e recusa o parecer | Integridade R1/R2 · GATE DE FATO | **Gerador (Fase 1)** |
| **E-β** | Registro **congela a proveniência** (versão + hash da norma no instante da resposta) → obsolescência em 3 níveis (🔴 revogada / 🟠 versão / 🟡 parâmetro) | Integridade R4/R5/R6 | **Gerador (Fase 1)** colunas · fórmula na Fase 3 |
| **E-γ** | Aba **`PAINEL_AUDITORIA`** (semáforo de integridade) + **`LEIA-ME`** (dicionário que ensina o sucessor) + **`HANDOVER_LOG`** | Integridade R10/R15/R13 | **Gerador (Fase 1)** |
| **E-δ** | Núcleo de captura **sobrevive à morte de qualquer notificador**: grava linha → e-mail → *só então* notifica (best-effort); chave de API futura só em `Script Properties`; aba `_LOG`; `_selfTest()` | Arquitetura R4/R5/R6/R7 + R1 | **Fase 3 (motor.gs)** |
| **E-ε** | A **entrevista de saída deixa de ser "opcional"**: é o único gatilho de colheita do tácito de quem é movimentado — vira ritual leve disparado pela publicação da movimentação | Retenção R9 (ponto vermelho do Embaixador) | **Decisão do Diretor** (Fase 5/processo) |

**A lição-mãe (por que a empresa está pausada):** a notificação n8n/Telegram do Cowork era caminho crítico
**sem fallback** (P-101, P-110, P-112). A Base DCEM não pode repetir isso — o Trilho 3 (WhatsApp só metadado)
deixa de ser preferência e vira **invariante de arquitetura**: o conteúdo vive na planilha + e-mail; se o
notificador morre, a perda é "silêncio informado", nunca perda de dado.

---

## BLOCO 1 — ARQUITETURA SOBERANA & ANTI-FRAGILIDADE (agente 1)

1. **Chave de terceiro nunca no cliente** — a futura chave da API de consulta IA vive em `PropertiesService.getScriptProperties()`, jamais literal no `Code.gs`. O Web App é o proxy interno. *(P-061; HV-1)*
2. **Segredo ≠ identificador público** — ID da planilha e e-mail da seção podem estar em doc de operação; chave de API é tratada como `service_role`: nunca versionada, nunca em WhatsApp. *(feedback_credenciais_anon_ficam_nos_arquivos)*
3. **Todo export/backup filtra segredo** — nenhum e-mail/CSV/cópia gerado pelo Apps Script leva a Script Property nem PII fora de escopo; se uma chave cruzar o perímetro, **rotacionar**, não só apagar. *(P-185, FALHA-2026-06-16)*
4. **Fallback manual ≤3 passos** para toda automação crítica — se a notificação cai, o dado já está na planilha + e-mail (1 passo para ver). *(P-110)*
5. **Notificação é metadado descartável** — `MailApp.sendEmail` (conteúdo) executa e é confirmado ANTES de qualquer notificação; a falha da notificação não aborta nem reverte a gravação. *(P-101, P-103)*
6. **`continueOnFail` universal** — cada chamada externa do Apps Script em `try/catch`; o catch escreve na aba `_LOG` (timestamp, passo, erro). Erro visível, nunca engolido. *(FALHA-2026-06-12; V9-V11 "falha silenciosa")*
7. **Núcleo trivial, IA depois** — `doPost` faz UMA coisa: validar campos mínimos + append. Zero IA/call externa no caminho crítico dos <60s. A consulta IA (Caminho A) é camada separada; se cair, a captura continua 100%. *(P-112, P-124 — Trilho 4 vira invariante)*
8. **Soberania é pré-requisito de build** — Spreadsheet, projeto Apps Script e trigger criados **logado como a conta-função**; nada compartilhado de outra conta e "movido" depois. Nenhum `UrlFetchApp` de captura aponta para host fora do Google. *(P-013 "cliente refém por omissão")*
9. **IA de consulta só zero-retention** — envia o mínimo para responder, nunca o dump da base; contrato de não-retenção por escrito; marcar no design qual campo pode sair do perímetro e qual nunca (cofre × vitrine). *(contradição G-2 vs H-V6)*
10. **[boa prática] Trigger confirma sucesso** — trigger do Google falha em silêncio; cada execução escreve status no `_LOG` + ativar "notify on failure" no editor de triggers. "Ativo" só após captura de teste ponta-a-ponta comprovada.
11. **[boa prática] Projetar contra quotas** — `MailApp` tem cota diária, execução tem teto ~6 min; o append (verdade) nunca compartilha o `try` do e-mail; nunca colocar a chamada da API IA dentro da execução de captura.
12. **[boa prática] UTF-8 na fronteira** — `doPost` lê body como UTF-8; `ContentService` devolve JSON sem BOM; testar captura com texto "sujo" (aspas curvas, em-dash, quebras) antes do go-live. *(P-183, json-bom-guard — 3ª ocorrência)*

> **Lacuna honesta:** não há caso Apps Script/Google-backend no acervo Vanguard (histórico é Supabase/FastAPI).
> Regras 10-12 são boa prática ancorada em lições transferíveis — validar empiricamente com `_selfTest()` (R15) antes do go-live.

---

## BLOCO 2 — RETENÇÃO & ADOÇÃO / ANTI-MORTE-VAZIA (agente 2)

1. **O produto é o REGISTRO, não o e-mail** — quem responde é quem deposita; o e-mail de parecer é gerado do registro, nunca escrito "solto" (senão o tácito escapa junto). *(01_VEREDITO)*
2. **Sub-60s sim, dropdown-only NÃO** — o macete raramente cabe em taxonomia fechada. `MACETE_TACITO` é o único campo livre (~150 char). Nunca "otimizar" o campo livre para mais um dropdown. *(09B E-5c)*
3. **Armadilha ≠ Macete Cinzento** — dois custos de exposição diferentes; a armadilha (barata, alto volume) alimenta o banco cedo e deve ter fricção/OPSEC menores. *(09B E-3)*
4. **Autoria visível é combustível militar (honra > dever), mas sob consentimento** — crédito aparece no retrieval **enquanto o autor ainda está na seção**, não só no dossiê pós-saída. *(09B E-1; V-A)*
5. **OPSEC precede o schema (5º trilho)** — o campo persistente guarda "padrão do problema + resultado"; o raciocínio de bypass mais sensível fica reservado a conversa direta, nunca em campo buscável; compartimentar por função. *(01_VEREDITO; 09B ponto 2; V-B)*
6. **Norma Viva = índice canônico (dado); Caso-Tipo = porta de busca (UX)** — ninguém busca por norma com dúvida real, busca por situação parecida. Uma não substitui a outra. *(01_VEREDITO 5/5; 08_AUDITOR)*
7. **Vocabulário controlado é 80% do risco e é a 1ª ação** — sem lista fechada de temas + índice de normas, a base nasce SUJA (pior que vazia, parece cheia). Norma revogada não some: fica `Revogada` para não virar resposta errada pesquisável. *(01_VEREDITO)*
8. **Obsolescência com dono e alarme read-time** — o consultante precisa saber, na leitura, se a resposta ainda vale hoje. *(08_AUDITOR N-1; P-043/P-061 "dado frio")*
9. **⚠️ COLHEITA NA MOVIMENTAÇÃO (ponto vermelho)** — log voluntário contínuo tem morte quase universal em KM. A entrevista de saída é o **único** momento em que o tácito de quem sai ainda é recuperável. Hoje está "opcional" no plano → **endurecer para ritual leve disparado pela movimentação**. *(09B E-2)*
10. **Doutrina automática por reúso** — quando um par Norma×Caso passa de limiar de consultas, o painel sinaliza "candidato a doutrina" (e a norma pode precisar mudar). Fecha o loop evolutivo. *(01_VEREDITO; 08_AUDITOR N-2; P-005)*
11. **"Consulta evitada" é métrica de vaidade** — infalsificável. Medir **reúso** + queda de reincidência (a língua de risco do Comando). *(01_VEREDITO unânime; 09B ponto 4)*
12. **"Mapa de quem sabe" só agregado por SEÇÃO, nunca por nome** — por nome vira vigilância/ranking informal. O nome só vive na Vista Curadores (dossiê de sucessão). *(09B ponto 4; 01_VEREDITO)*
13. **Satisfação 1-toque (👍/👎), nunca "silêncio = aprovação"** — silêncio militar é ausência de canal seguro, não aval. É o único sinal que detecta "resposta limpa mas ERRADA". *(08_AUDITOR G-4 vetado; 09B 5d; V-D)*

---

## BLOCO 3 — INTEGRIDADE DE DADO NO TEMPO (agente 3)

1. **Valor não confirmado é INUTILIZÁVEL, não só avisado** — `Valor_Utilizavel = SE(Status="CONFIRMADO"; Valor; NA())`. Parecer que multiplique por `#N/D` é recusado. O erro é o gate. *(GATE DE FATO; T1.3)*
2. **Confirmação é ato assinado** — `Confirmado_Por` + `Confirmado_Em` + `Fonte_Conferida` (norma+dispositivo); `Status` só vira `CONFIRMADO` com os 3 preenchidos. *(P-010, P-183)*
3. **Parâmetro carrega sua norma-fonte** — `Norma_Fonte` valida contra `NORMAS!A:A`; guarda `Ref_Valida` sinaliza órfão; `PAINEL_AUDITORIA` conta órfãos (meta = 0). *(T1.2/T1.3)*
4. **Obsolescência é fórmula read-time, nunca campo estático** — congelar `Hash_Registrado` + `Versao_Registrada` no ato da resposta; `Status_Obsolescencia` recomputa comparando com o vigente. *(T3.3; P-091)*
5. **O gatilho é o HASH, não a data** — data é informativa, hash é o veredito. `Hash_Parametros` = concat de `Versao_Vigente` + valores daquela norma; muda quando muda. *(P-168, P-073)*
6. **Obsolescência em 3 níveis** — 🔴 NORMA REVOGADA · 🟠 VERSÃO MUDOU · 🟡 PARÂMETRO REAJUSTADO · 🟢 OK. O curador tria por cor. *(NORMAS.Status; P-172)*
7. **Um valor mora em UM lugar; resto lê por referência** — hardcode proibido; pareceres/painel usam `PROCV`/`FILTER`, nunca dígito digitado. *(P-073; T1.3 "0,49 é como chave de API")*
8. **Mudar parâmetro cascateia total ou não vale** — como tudo lê por fórmula, a cascata é automática; `PAINEL_AUDITORIA` prova ("registros impactados pela última mudança"); `LOG_PARAMETROS` (onEdit) registra antigo→novo. *(P-074, P-060)*
9. **Ano corrente é versão datada** — `PARAMETROS` multi-ano por `Vigencia`; virar o ano ADICIONA linhas (`[CONFIRMAR]`), nunca sobrescreve — parecer de 2024 recalcula com valor de 2024. *(P-171; T1.3)*
10. **A prova é o artefato, não a afirmação** — `PAINEL_AUDITORIA` VERDE só com zero pendências (params `[CONFIRMAR]`, registros ⚠️/🔴, órfãos). Célula-mestre `INTEGRIDADE`. *(P-091, P-033 "INTEGRIDADE VERDE")*
11. **Toda escrita carrega timestamp + autor automáticos** — `Data_Hora` no ingest; `Ultima_Alteracao` + `Alterado_Por` via `onEdit`; `ID_Consulta` `C-AAAAMMDD-HHMMSS` imutável. *(P-181, P-168; T3.1)*
12. **Frescor compara datetime, não só data** — reajuste às 09h e parecer às 14h do mesmo dia têm de ser comparáveis. *(P-168)*
13. **Titularidade por função, transferível e auditável** — conta-função dona; `HANDOVER_LOG` (data, sai/entra, checklist senha/2FA/custódia). *(Fase 0 V-G; FASE0_CUSTODIA)*
14. **Autoria do macete é dado de 1ª classe, com consentimento** — sobrevive à saída e alimenta o dossiê de sucessão; visível só se `Autoria_Visivel="Sim"`. *(T1.4/E-1; T5.3)*
15. **O sucessor herda um banco AUTO-EXPLICÁVEL** — aba `LEIA-ME` (dicionário: cada coluna, o que a valida, o que NÃO fazer); validações travam entrada errada; cabeçalho/fórmulas protegidos. A confiança vem da arquitetura, não da boa-fé. *(P-151, P-063)*

---

## MAPA DE APLICAÇÃO POR FASE

- **Fase 1 (Gerador — AGORA):** E-α (trava `Valor_Utilizavel` + assinatura de confirmação), E-β (colunas de proveniência `Versao_Registrada`/`Hash_Registrado` + `Versao_Schema`), E-γ (abas `PAINEL_AUDITORIA` + `LEIA-ME` + `HANDOVER_LOG`), multi-ano em `PARAMETROS`, `Ref_Valida` anti-órfão, cabeçalhos protegidos.
- **Fase 2 (captura premium):** núcleo trivial <60s, UTF-8 na fronteira, campo livre nunca vira dropdown, cronômetro de 60s corta campo excedente.
- **Fase 3 (motor.gs):** ordem grava→e-mail→notifica; `try/catch`+`_LOG`; `_selfTest()`; `PropertiesService` para chave; `onEdit` (timestamp/autor + `LOG_PARAMETROS`); fórmula de `Status_Obsolescencia` 3 níveis; recusa de parecer com `#N/D`.
- **Fase 5 (painel + processo):** painel duplo eficiência/auditoria; reúso→candidato a doutrina; mapa por seção nunca por nome; **decisão E-ε: entrevista de saída deixa de ser opcional**.
- **Fase 6 (IA Caminho A):** zero-retention verificado; mínimo necessário, nunca o dump; fronteira cofre×vitrine.

---

_Criado por: Músculo (síntese de 3 agentes de destilação) · 2026-07-11 · fonte de robustez da Base DCEM._
