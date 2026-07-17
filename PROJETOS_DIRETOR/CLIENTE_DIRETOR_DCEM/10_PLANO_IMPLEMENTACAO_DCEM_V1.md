# Base de Consultas Asse Ct Orç (DCEM) — Plano de Implementação V1

> **Para executores:** este plano é a fonte de verdade da construção. Cada tarefa tem artefato exato, conteúdo real (sem placeholder) e uma verificação ("como você sabe que funcionou"). Passos usam checkbox (`- [ ]`).
> **Domínio:** Google Workspace (Forms + Sheets + Apps Script) — não é código Python. A disciplina de TDD vira **verificação de artefato** por etapa.
> **Projeto PESSOAL do Diretor · ISOLADO (P-059) · empresa Vanguard em PAUSA.**
> **GATE P-124: NADA neste plano é construído antes do veredito do Diretor.** Este documento existe para ser deliberado — não para ser executado silenciosamente.

**Goal:** Construir o **banco de dados de gestão do conhecimento** da Asse Ct Orç — a memória da seção — que retém o raciocínio tácito (macete/armadilha) acoplado à norma, existindo **independente de IA**, com uma camada de consulta por IA (Caminho A) plugável depois sem refazer nada.

**Architecture:** Três camadas desacopladas. (1) **CAPTURA** — Google Forms via QR, sem IA, ≤60s (Trilho 4 intacto). (2) **A BASE** — Google Sheets multi-aba com Norma Viva como chave primária e Caso-Tipo como índice; é o ativo, modelado AI-ready mas 100% funcional sem IA. (3) **CONSULTA IA** — camada posterior, API externa zero-retention (Caminho A), lê a base sem que o dado vá treinar modelo; IA nunca entra na captura. OPSEC por compartimentação (IMPORTRANGE): Comando vê métrica, demandante vê parecer, macete fica só na Asse Ct Orç.

**Tech Stack:** Google Forms · Google Sheets (validação de dados, IMPORTRANGE, QUERY, fórmulas) · Google Apps Script (ID, e-mail de parecer, alarme de obsolescência, 1-toque) · Looker Studio (painel) · [Fase 6] API LLM externa com política de não-treinamento.

---

## MAPA DE ARTEFATOS (decisões de decomposição travadas aqui)

| Artefato | Responsabilidade única | Camada |
|---|---|---|
| **Conta Google da seção (titular = função)** | Perímetro soberano + titularidade transferível na movimentação (5º Trilho) | Fundação |
| **Planilha `BASE_ASSE_CT_ORC`** | O ativo. Contém todas as abas abaixo | Base |
| → Aba `REGISTROS` | Uma linha por consulta resolvida (schema central) | Base |
| → Aba `NORMAS` | Índice canônico — Norma Viva como PK + versão/hash | Base |
| → Aba `CASOS` | Índice relacional — Caso-Tipo (vocabulário de temas) | Base |
| → Aba `PARAMETROS_ANO_CORRENTE` | Variáveis financeiras versionadas (tira o hardcode) | Base |
| → Aba `PAINEL_DADOS` | Camada agregada para o Comando (sem nome, sem macete) | Base |
| **Forms `CONSULTA_ASSE_CT_ORC`** | Captura ≤60s pelo demandante via QR | Captura |
| **Apps Script `motor.gs`** | ID, e-mail de parecer, alarme de obsolescência, 1-toque | Base/Fluxo |
| **Vistas IMPORTRANGE** (3 planilhas espelho) | Compartimentação OPSEC por função | OPSEC |
| **Painel Looker Studio** | Eficiência + prontidão de auditoria (painel duplo) | Painel |
| **[Fase 6] Serviço de consulta IA** | Busca semântica sobre a base (Caminho A) | Consulta IA |

**Princípio de ouro do desacoplamento:** a Base (Camada 2) é entregável e útil **sozinha**. Se as Fases 6 (IA) nunca acontecerem, a seção já tem gestão de conhecimento pesquisável. A IA é upside, não dependência.

---

## DECISÕES DO DIRETOR JÁ TRAVADAS (2026-07-11)

1. **Ambição B** — ativo soberano AI-ready, não formulário.
2. **Camada de consulta = Caminho A** — API externa com política de não-treinamento (zero-retention).
3. **O banco de dados existe independente de IA** — a IA é camada de consulta sobre ele.
4. Custo de IA neste volume (~22 consultas/mês) = **R$ 2 a R$ 25/mês** — não é fator; o fator é soberania (resolvido pelo Caminho A).
5. Trilho 4 mantido na captura; reaberto **só** na consulta/recuperação (Fase 6).

## VEREDITOS DO DIRETOR (RESOLVIDOS — 2026-07-11)

- **V-A — Atribuição (E-1): CONDICIONAL** ✔ — o autor marca "posso ser identificado? sim/não". `Autoria_Visivel` é preenchida pelo autor. (Tarefa 2.4 destravada.)
- **V-B — 5º Trilho (OPSEC): SIM** ✔ — OPSEC/controle de acesso por função vira trilho duro. (Fase 0 e Fase 4 destravadas.)
- **V-C — Obsidian: FORA** ✔ — confirmado fora; Trilho 4 vence.
- **V-D — Satisfação: SIM (1 toque 👍/👎)** ✔ — mantém o Passo 5 do fluxo, troca o formulário longo por 1 toque. (Tarefa 3.4 destravada.)
- **V-E — DESIGN PREMIUM: SIM** ✔ (novo pedido do Diretor) — a captura deixa de ser Google Forms cru e passa a **front premium servido por Apps Script Web App** (dado em repouso continua 100% no Google — Trilho 1 intacto). Ver "MUDANÇA DE ARQUITETURA — CAPTURA PREMIUM" abaixo.
- **V-F — REGISTRO VISUAL: HÍBRIDO ("sóbrio com alma Vanguard")** ✔ (Diretor 2026-07-11) — base institucional-militar sóbria (fundo grafite sério, tipografia Inter, layout oficial) **+ um único acento ciano contido** (faixa fina no cabeçalho / detalhe de foco) como assinatura Vanguard. **Regra dura:** premium = contenção + velocidade, nunca enfeite. Zero glassmorphism pesado, zero animação que atrase o carregamento. Abre em ≤1s, ≤60s para enviar (Trilho 2 + veredito do Embaixador "peso mata a base"). Público = Comando militar → o sério vence o efeito. `frontend-design` + `web-design-guidelines` obrigatórios antes do teste do Diretor.

---

## FASE 0 — FUNDAÇÃO SOBERANA (precede qualquer schema)

> Depende de: veredito **V-B**. O Auditor é explícito: OPSEC precede o schema, senão o militar autocensura e a base guarda só ementa fria.

### DECISÃO V-G — MODELO DE CONTA (Diretor 2026-07-11)

**Conta Gmail dedicada à função** (não Workspace institucional, não pasta compartilhada). Rápida, zero dependência da TI da OM, dado em repouso 100% no Google (Trilho 1 OK). **Trade-off assumido:** é conta de consumidor, sem admin/offboarding institucional → o risco (recuperação e transferência) é **mitigado por um Protocolo de Custódia de Credencial documentado** (artefato `FASE0_CUSTODIA_TITULARIDADE.md`). Titularidade "por função" aqui = **repasse formal e auditável da credencial no handover da movimentação.**

### Tarefa 0.1: Criar a conta-função e travar a titularidade

**Artefato:** conta Gmail nomeada pela função (ex.: `assectorc.dcem@gmail.com`) + `FASE0_CUSTODIA_TITULARIDADE.md`.

- [ ] **Passo 1: Criar a conta-função** — ação do Diretor (exige telefone/navegador). Nome = função, nunca pessoa. Candidatos por disponibilidade (Passo 1 do guia no chat).
- [ ] **Passo 2: Blindar recuperação e 2FA de forma transferível** — o ponto fraco da conta Gmail é a recuperação. Telefone/e-mail de recuperação e 2FA **não** podem ficar amarrados ao aparelho pessoal de quem sai. Seguir o Protocolo de Custódia.
- [ ] **Passo 3: Documentar o modelo de titularidade** — Músculo gera `FASE0_CUSTODIA_TITULARIDADE.md` (dono = função, curadores = editores, 12 seções sem leitura de `REGISTROS`, ritual de repasse no handover).
- [ ] **Passo 4: Verificação** — logar na conta-função em navegador limpo com a credencial documentada → deve entrar. Simular repasse (trocar senha + atualizar custódia) → acesso segue a função, não a pessoa.
- [ ] **Passo 5: Checkpoint do Diretor** — confirmar perímetro soberano (Trilho 1) + custódia antes de criar o schema (Fase 1).

---

## FASE 1 — A BASE (o ativo · Norma Viva como chave)

> Depende de: Fase 0. Esta fase entrega gestão de conhecimento **mesmo sem Forms e sem IA**.

### Tarefa 1.1: Criar a planilha e a aba `NORMAS` (índice canônico)

**Artefato:** `BASE_ASSE_CT_ORC` → aba `NORMAS`.

- [ ] **Passo 1: Criar as colunas exatas**

| Coluna | Conteúdo |
|---|---|
| `Cod_Norma` (PK) | ex.: `DEC-4307-2002` |
| `Titulo_Norma` | ex.: Decreto 4.307/2002 — Movimentação, Indenização, Cubagem |
| `Ementa_Curta` | 1 linha |
| `Anexo_Referencia` | ex.: Anexo I e II |
| `Versao_Vigente` | ex.: `2026-01` |
| `Hash_Parametros` | célula que muda quando os parâmetros ligados mudam (alarme N-1) |
| `Status` | Vigente / Revogada / Em revisão |

- [ ] **Passo 2: Popular com o Índice de Normas fundacional (do disco)**

```
MP-2215-10-2001   | MP 2.215-10/2001 — Remuneração, Adicionais, Ajuda de Custo
LEI-13954-2019    | Lei 13.954/2019 — Reestruturação da carreira
DEC-4307-2002     | Decreto 4.307/2002 — Movimentação, Indenização, Limites de Cubagem
PORT-DGP-290-2013 | Portaria DGP 290/2013 — Gestão de Recursos Financeiros/Movimentação
PORT-CEX-1746-2022| Portaria C Ex 1.746/2022 — Despesas de Exercícios Anteriores (DEA)
PORT-DGP-410-2022 | Portaria DGP 410/2022 — Despesas de Exercícios Anteriores (DEA)
DEC-20910-1932    | Decreto 20.910/1932 — Prescrição Quinquenal
DEC-2040-1996     | Decreto 2.040/1996 — Regulamento de Movimentação
```

- [ ] **Passo 3: Verificação** — cada linha tem `Cod_Norma` único; nenhum código repetido (validação `COUNTIF=1`).

### Tarefa 1.2: Criar a aba `CASOS` (índice relacional — Caso-Tipo)

**Artefato:** aba `CASOS`.

- [ ] **Passo 1: Colunas** — `Cod_Caso` (PK) · `Tema` · `Normas_Relacionadas` (lista de `Cod_Norma`).
- [ ] **Passo 2: Popular com a Lista Fechada de TEMAS (do disco)**

```
CASO-01 | Pagamento de Ajuda de Custo
CASO-02 | Indenização de Transporte de Bagagem (Mobília, Auto, Moto)
CASO-03 | Indenização de Transporte de Pessoal (Passagens)
CASO-04 | Requisição de Transporte por Conta da União
CASO-05 | Despesa de Exercício Anterior (DEA)
CASO-06 | Complementação Pecuniária
CASO-07 | Restituição/Recolhimento de Crédito
CASO-08 | Diárias / Taxa de Embarque
```

- [ ] **Passo 3: Verificação** — cada `Normas_Relacionadas` referencia um `Cod_Norma` que existe na aba `NORMAS` (nenhuma referência órfã).

### Tarefa 1.3: Criar a aba `PARAMETROS_ANO_CORRENTE` (mata o hardcode)

**Artefato:** aba `PARAMETROS_ANO_CORRENTE`. Motivo (Auditor): embutir "0,49" ou "28%" no prompt é como expor uma chave de API — separa-se a base de conhecimento do motor de execução.

- [ ] **Passo 1: Colunas** — `Parametro` · `Valor` · `Norma_Fonte` (`Cod_Norma`) · `Vigencia`.
- [ ] **Passo 2: Popular com os valores atuais (do disco — confirmar contra a norma vigente antes de usar em cálculo real)**

```
Indice_Rodoviario    | 0,50   | DEC-4307-2002 | 2026
Indice_Aereo         | 0,49   | DEC-4307-2002 | 2026
Taxa_General         | 28%    | MP-2215-10-2001 | 2026
Taxa_Praca           | 13%    | MP-2215-10-2001 | 2026
Tarifa_m3            | 29,64  | DEC-4307-2002 (Anexo II) | 2026
```

- [ ] **Passo 3: Verificação (GATE DE FATO)** — marcar cada valor `[CONFIRMAR CONTRA NORMA VIGENTE]` até o militar curador validar contra a MP/Decreto atual. **Nenhum cálculo real usa a aba antes dessa validação.**

### Tarefa 1.4: Criar a aba `REGISTROS` (schema central — o coração)

**Artefato:** aba `REGISTROS`. Colunas do schema do Auditor **+** os campos do Embaixador (anti-morte-vazia).

- [ ] **Passo 1: Colunas exatas**

| Coluna | Origem | Observação |
|---|---|---|
| `ID_Consulta` | Auditor | auto (Apps Script, Tarefa 3.1) |
| `Data_Hora` | Auditor | auto |
| `Demandante_Email` | Auditor | do Forms |
| `Secao_Demandante` | Auditor | dropdown das 13 |
| `Caso_Tipo_Tema` | Auditor | dropdown `CASOS` |
| `Norma_Chave_Primaria` | Auditor | dropdown `NORMAS` (**PK — Norma Viva**) |
| `Fato_Gerador` | Auditor | ex.: "Adt DCEM com legenda 10" |
| `Tipo_Registro` | Embaixador (E-3) | dropdown: `Ponto de atenção` \| `Atalho de resolução` (rótulos atualizados 2026-07-17; antes `Armadilha`/`Macete Cinzento`) |
| `MACETE_TACITO` **[OPSEC]** | Auditor | 1 campo curto (~150 char) — texto livre limitado, não dropdown |
| `Parecer_Oficial_Email` | Auditor | texto limpo/público enviado ao militar |
| `Autoria_Posto_Nome` | Embaixador (E-1) | quem resolveu |
| `Autoria_Visivel` | Embaixador (E-1) | `Sim`\|`Não` — **depende de V-A** |
| `Dono_da_Norma_Funcao` | Auditor | ex.: Chefe Asse Ct Orç |
| `Satisfacao` | Embaixador (D)/(fluxo P5) | `👍`\|`👎` (1 toque) |
| `Status_Obsolescencia` | Auditor (N-1) | fórmula read-time (Tarefa 3.3) |

- [ ] **Passo 2: Validação de dados (dropdowns fechados = captura rápida + dado limpo)**
  - `Secao_Demandante` → lista das 13: `QEMA, QSG, Cursos e Estágios, Praças, Ajudância Geral, Seção de Seleção, SPEC, Assessoria Jurídica, AI, Diretor, Subdiretor, Adjunto de Comando, Assistente`.
  - `Caso_Tipo_Tema` → `=CASOS!B2:B` (intervalo).
  - `Norma_Chave_Primaria` → `=NORMAS!B2:B`.
  - `Tipo_Registro`, `Autoria_Visivel`, `Satisfacao` → listas fixas acima.
- [ ] **Passo 3: Verificação** — inserir 1 linha-teste; cada dropdown recusa valor fora da lista; `MACETE_TACITO` aceita texto livre mas trava acima de ~150 caracteres (regra de validação de comprimento).
- [ ] **Passo 4: Checkpoint do Diretor** — a Base está de pé. Deliberar: este schema retém o tácito? Só avançar para captura após o "ok".

---

## MUDANÇA DE ARQUITETURA — CAPTURA PREMIUM (V-E)

> **Google Forms não é premium — é genérico.** Para design premium mantendo soberania (Trilho 1), a captura vira um **front custom servido por Apps Script Web App (HtmlService)**: o Google serve a página premium (CSS/tipografia/glassmorphism próprios) e grava direto no Sheets. Dado em repouso continua 100% na conta Google. Nada hospedado fora. QR aponta para a URL do Web App.
>
> **Regra inegociável (Embaixador + Trilho 2):** premium na estética, **brutal na velocidade**. 1 tela, ≤60s. Design não pode adicionar 1 segundo de fricção — o peso mata a base. Bonito E rápido, nunca bonito E lento.
>
> **Registro visual:** a definir com o Diretor (público = Comando militar). Ver pergunta em aberto.

## FASE 2 — CAPTURA (Web App premium + QR · ≤60s · sem IA)

> Depende de: Fase 1 + registro visual definido. Trilho 2 (≤60s) e Trilho 4 (sem IA) mandam aqui.

### Tarefa 2.1: Criar o front premium `CONSULTA_ASSE_CT_ORC` (Apps Script Web App)

**Artefato:** Apps Script Web App (HtmlService) vinculado a `BASE_ASSE_CT_ORC`. Front custom, não Google Forms.
**Sub-skills obrigatórias na construção:** `frontend-design` + `web-design-guidelines` (antes do teste do Diretor).

- [ ] **Passo 1: Campos do demandante (do BRIEF — mínimo que não vira gaiola)**
  - `Seção de movimentação` — **dropdown das 13** (obrigatório).
  - `Militar/interessado` — texto curto (obrigatório).
  - `E-mail` — validação de e-mail (**obrigatório** — carrega a resposta, Trilho 3).
  - `WhatsApp` — texto (só notificação/metadado, Trilho 3).
  - `Assunto` — texto curto.
  - `Descrição da consulta` — parágrafo.
  - `Norma relacionada?` — dropdown `NORMAS` + opção "Não sei".
  - `Prioridade` — Baixa/Média/Alta.
  - `Precisa até quando?` — data.
  - `Anexo` — upload opcional.
- [ ] **Passo 2: Verificação de tempo (Trilho 2)** — cronometrar o preenchimento com dados reais: **deve fechar em ≤60s**. Se passar, cortar campo opcional (prioridade/anexo primeiro).
- [ ] **Passo 3: Gerar o QR** — apontar para a URL do Forms; imprimir para parede + assinatura de e-mail.

### Tarefa 2.2: Ligar respostas do Forms à aba `REGISTROS`

- [ ] **Passo 1:** configurar destino de respostas → mesma planilha `BASE_ASSE_CT_ORC` (aba de entrada `_FORMS_RAW`).
- [ ] **Passo 2:** Apps Script (Tarefa 3.1) copia da `_FORMS_RAW` para `REGISTROS` gerando `ID_Consulta` e `Data_Hora`.
- [ ] **Passo 3: Verificação** — enviar 1 resposta de teste pelo Forms → aparece 1 linha nova em `REGISTROS` com ID e data preenchidos.

### Tarefa 2.4: Campo de atribuição condicional (E-1)

> **Depende de V-A.** Só construir depois do veredito.

- [ ] **Passo 1 (se V-A = condicional):** no momento em que o militar registra a solução, incluir a pergunta `Posso ser identificado como autor deste macete? Sim/Não` → grava em `Autoria_Visivel`.
- [ ] **Passo 2 (se V-A = visível sempre):** `Autoria_Visivel` = `Sim` fixo; a pergunta some.
- [ ] **Passo 3: Verificação** — na vista de consulta (Fase 4), autoria só aparece quando `Autoria_Visivel = Sim`.

---

## FASE 3 — ROTEAMENTO, RESPOSTA E MOTOR (Apps Script)

> Depende de: Fase 2. Implementa os Passos 2, 3 e 5 do Fluxo Oficial.

### Tarefa 3.1: `motor.gs` — geração de ID e normalização

**Artefato:** Apps Script ligado à planilha.

- [ ] **Passo 1: Escrever a função de ingestão**

```javascript
function aoReceberResposta(e) {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const reg = ss.getSheetByName('REGISTROS');
  const r = e.values; // ordem dos campos do Forms
  const id = 'C-' + Utilities.formatDate(new Date(), 'GMT-3', 'yyyyMMdd-HHmmss');
  reg.appendRow([id, new Date(), /* Demandante_Email */ r[2], /* Secao */ r[1],
    '', '', /* Caso e Norma: preenchidos pelo militar depois */
    r[5] /* Fato/descrição */, '', '', '', '', '', '', '', '']);
}
```

- [ ] **Passo 2: Ligar o gatilho** — Trigger `onFormSubmit` → `aoReceberResposta`.
- [ ] **Passo 3: Verificação** — resposta de teste gera linha com `ID_Consulta` no formato `C-AAAAMMDD-HHMMSS`.

### Tarefa 3.2: `motor.gs` — parecer por e-mail (Trilho 3)

- [ ] **Passo 1: Função de envio** (o conteúdo substantivo vai por e-mail Google; WhatsApp nunca)

```javascript
function enviarParecer(linha) {
  const reg = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('REGISTROS');
  const email = reg.getRange(linha, COL_EMAIL).getValue();
  const parecer = reg.getRange(linha, COL_PARECER).getValue();
  const idc = reg.getRange(linha, COL_ID).getValue();
  MailApp.sendEmail({
    to: email,
    subject: 'Asse Ct Orç — Parecer da consulta ' + idc,
    htmlBody: parecer + '<br><br>Avalie: ' + linkPolegar(idc, 'up') + ' | ' + linkPolegar(idc, 'down')
  });
}
```

- [ ] **Passo 2: Verificação** — chamar `enviarParecer` numa linha-teste → e-mail chega com o parecer; WhatsApp não recebe conteúdo (só, se houver, um aviso "chegou parecer da consulta C-…").

### Tarefa 3.3: `Status_Obsolescencia` — alarme read-time (N-1)

- [ ] **Passo 1: Fórmula na coluna `Status_Obsolescencia` de `REGISTROS`**

```
=SE(PROCV(Norma_Chave_Primaria; NORMAS!A:E; 5; FALSO) <> Hash_Registrado;
   "⚠️ BASE DE CÁLCULO ATUALIZADA"; "OK")
```
(guardar `Hash_Registrado` na linha no momento da resposta; comparar com o hash vigente da norma na leitura.)

- [ ] **Passo 2: Verificação** — mudar um valor na `PARAMETROS_ANO_CORRENTE` que altere o hash da norma → consultas antigas ligadas viram `⚠️ BASE DE CÁLCULO ATUALIZADA`.

### Tarefa 3.4: Satisfação de 1 toque (Passo 5 + veto G-4 reconciliado)

> **Depende de V-D.** Substitui a pesquisa longa (que o Auditor vetou matar e o Embaixador alertou não matar sem substituto).

- [ ] **Passo 1:** dois links no rodapé do e-mail (👍/👎) → gravam `Satisfacao` na linha via web app do Apps Script.
- [ ] **Passo 2: Verificação** — clicar 👍 num e-mail de teste → célula `Satisfacao` da linha recebe `👍`.

---

## FASE 4 — OPSEC POR COMPARTIMENTAÇÃO (IMPORTRANGE · N-4)

> Depende de: V-B + Fase 1. Resolve a autocensura (alerta central do Auditor) sem sair do Google.

### Tarefa 4.1: Três vistas por função

- [ ] **Passo 1: Vista Comando** — planilha espelho que puxa **só** `PAINEL_DADOS` (volume, reúso, satisfação, reincidência). **Sem nome, sem macete.** `=IMPORTRANGE(chave; "PAINEL_DADOS!A:F")`.
- [ ] **Passo 2: Vista Demandante** — o militar recebe o `Parecer_Oficial_Email` por e-mail; **nenhum acesso à planilha**.
- [ ] **Passo 3: Vista Curadores (Asse Ct Orç)** — única com acesso à coluna `MACETE_TACITO`.
- [ ] **Passo 4: Verificação** — abrir a Vista Comando → a coluna `MACETE_TACITO` **não existe/não vem**; abrir com conta de curador → aparece.

---

## FASE 5 — PAINEL DUPLO (eficiência + auditoria)

> Depende de: Fase 1 + 4. Atende o E-4 (o Diretor quer as duas coisas).

### Tarefa 5.1: Aba `PAINEL_DADOS` (agregada, anônima)

- [ ] **Passo 1: Métricas de EFICIÊNCIA** (via `QUERY`): consultas resolvidas/mês · tempo médio de resolução · **reúso** (mesma norma+caso repetida) · reincidência por seção · % satisfação 👍.
- [ ] **Passo 2: Métricas de AUDITORIA/PRONTIDÃO**: % de registros com `Norma_Chave_Primaria` preenchida (rastreabilidade) · nº de registros com `Status_Obsolescencia = OK` · trilha norma↔parecer completa.
- [ ] **Passo 3: "Mapa de quem sabe" — só agregado por seção, NUNCA por nome** (alerta do Embaixador: por nome vira vigilância).
- [ ] **Passo 4: Verificação** — nenhuma métrica do painel expõe nome individual nem texto de macete.

### Tarefa 5.2: Looker Studio sobre `PAINEL_DADOS`

- [ ] **Passo 1:** conectar Looker Studio à aba `PAINEL_DADOS` (não à `REGISTROS`).
- [ ] **Passo 2: Verificação** — o painel abre para o Comando sem dar acesso à planilha mestre.

### Tarefa 5.3: Dossiê de Sucessão (N-5 / Semente 2 · E-2 no critério do Diretor)

> O Diretor declarou: **não há handover formal**; a captura mora no fluxo normal e a entrevista de saída é opcional, a critério dele.

- [ ] **Passo 1:** salvar uma vista filtrada `Autoria_Posto_Nome = [militar movimentado]` na Vista Curadores → lista os macetes que ele deixou.
- [ ] **Passo 2: Verificação** — o dossiê é gerado por filtro nativo, sem exportar nada para fora do Google.

---

## FASE 6 — CAMADA DE CONSULTA IA (Caminho A · POSTERIOR)

> **Não bloqueia as Fases 0–5.** A Base já funciona sem isto. Reabre o Trilho 4 **só aqui**, com o veredito já dado (Caminho A).

### Tarefa 6.1: Serviço de busca semântica sobre a Base

- [ ] **Passo 1:** exportar `NORMAS` + `CASOS` + macetes **curados/liberados** para um índice de embeddings.
- [ ] **Passo 2:** consulta em linguagem natural ("me ache casos como bagagem negada por documento no nome da mãe") → API LLM externa **sob política de não-treinamento (zero-retention)** retorna os registros relevantes.
- [ ] **Passo 3: Guarda de soberania** — só trafega o trecho recuperado no momento da consulta; nada é armazenado/treina modelo; macete OPSEC só entra no índice se o curador liberar.
- [ ] **Passo 4: Verificação de custo** — medir o gasto real ao fim do mês contra a estimativa (R$ 2–25/mês).

---

## AUTOAVALIAÇÃO (checklist do próprio plano)

**Cobertura do briefing/ciclo:**
- 4 Trilhos → Fase 0 (T1), Fase 2 T2.2 (T2 ≤60s), Fase 3 T3.2 (T3 e-mail), Trilho 4 na captura + reaberto só na Fase 6. ✔
- Fluxo Oficial 5 passos → Forms (P1), roteamento do Chefe (Fase 3), registro do militar (Fase 1/3), banco (Fase 1), satisfação (T3.4). ✔
- Schema do Auditor (Norma Viva PK + Caso índice) → Fase 1. ✔ · hardcode → PARAMETROS (T1.3). ✔ · N-1 obsolescência → T3.3. ✔ · N-4 OPSEC → Fase 4. ✔ · N-5 sucessão → T5.3. ✔
- Anti-morte-vazia Embaixador → E-1 (T2.4/V-A), E-3 `Tipo_Registro` (T1.4), 1-toque (T3.4/V-D), painel por seção não por nome (T5.1), E-4 painel duplo (Fase 5). ✔
- Decisões do Diretor → Ambição B, Caminho A (Fase 6), base independente de IA (Fases 0–5 autônomas). ✔

**Placeholders:** os `[CONFIRMAR CONTRA NORMA VIGENTE]` na T1.3 são intencionais (GATE DE FATO — valores financeiros nunca de memória), não preguiça de plano.

**Pendências que travam tarefas específicas:** V-A (T2.4), V-B (Fase 0/4), V-D (T3.4). O resto flui sem elas.

---

## HANDOFF DE EXECUÇÃO

**Este plano NÃO é executado antes do veredito do Diretor (P-124).** Quando o Diretor aprovar:

1. Resolver os 4 vereditos pendentes (V-A atribuição · V-B 5º trilho OPSEC · V-C Obsidian fora · V-D satisfação 1-toque).
2. Construir na ordem das fases (0 → 5); a Fase 6 (IA) fica marcada como posterior.
3. Cada Fase fecha num **checkpoint do Diretor** antes da próxima (não avança por momentum).
4. `writing-plans` consolidou a arquitetura; a execução em Google Workspace é manual/assistida pelo Músculo (o Diretor não opera terminal).

> Projeto isolado (P-059) — nenhum artefato aqui entra em `CLIENTES/`, `WIP_BOARD` ou máquina autônoma (empresa em pausa).
