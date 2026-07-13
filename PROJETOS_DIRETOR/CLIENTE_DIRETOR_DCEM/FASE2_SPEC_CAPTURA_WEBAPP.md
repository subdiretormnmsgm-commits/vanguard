# FASE 2 — SPEC do Formulário de Captura (Web App) · Base Asse Ct Orç (DCEM)

> Projeto pessoal do Diretor · isolado (P-059). Documento de SPEC — fonte de verdade que o
> **EXECUTOR (Antigravity)** lê do disco. O EXECUTOR **age pelo que está aqui, nunca por intuição**.
> Nada é implantado sem "vai" do Diretor (P-124). Autor: Músculo · 2026-07-11.

---

## 0. OBJETIVO (o que a Fase 2 resolve)

Fazer a base **parar de nascer vazia**. Hoje ela é o continente correto (Fase 1 fechada), mas sem
conteúdo. A Fase 2 entrega o **único ponto de entrada de consulta**: um formulário que o **próprio
demandante** preenche em **< 60 s** (Trilho 2), gravando direto na aba `REGISTROS` da planilha
soberana — **sem o demandante nunca ver a planilha**.

Meta verificável: um demandante de outra seção abre o link, preenche 4 campos e envia em menos de
60 segundos; a linha aparece em `REGISTROS` na conta `orcamentariodcem@gmail.com`; o demandante
recebe um e-mail de confirmação (Trilho 3). Nenhum dado transita fora do perímetro Google soberano.

---

## 1. RESTRIÇÕES INVIOLÁVEIS (os 4 trilhos aplicados à Fase 2)

1. **Trilho 1 (soberania):** o Web App é um **Apps Script container-bound** da própria planilha
   `BASE_ASSE_CT_ORC`. Roda **como o dono** (`Executar como: eu`). O dado nasce e permanece dentro
   da conta da seção. **Nenhum servidor externo. Nada de n8n** (fura o perímetro + cruza P-059).
2. **Trilho 2 (captura em <60s pelo demandante):** formulário de **uma tela**, 4 campos, zero login
   exigido do demandante além do acesso ao link.
3. **Trilho 3 (e-mail leva conteúdo):** a confirmação e, depois, o parecer, vão por **e-mail**
   (`MailApp`, Fase 3). O formulário só **capta**; não devolve conteúdo substantivo na tela.
4. **Trilho 4 (sem IA embutida):** o formulário é HTML/JS puro servido pelo Apps Script. **Zero IA**
   no produto de captura.
5. **5º Trilho (OPSEC):** como o Web App roda como dono, o demandante **não recebe acesso à planilha**.
   A aba `REGISTROS` (com os campos OPSEC `MACETE_TACITO`) continua invisível às 12 seções. O
   formulário é a **única porta de escrita** — o demandante escreve sem enxergar o acervo.

---

## 2. QUEM PREENCHE O QUÊ (mapa contra o schema real de REGISTROS A–Q)

> GATE DE FATO: colunas conforme `FASE1_GERADOR_BASE.gs` → `criarRegistros()` (lidas do disco).

| Col | Campo | Preenchido por | Na Fase 2? |
|---|---|---|---|
| A | `ID_Consulta` | **Sistema** (auto) | Sim — gerar no `doPost` |
| B | `Data_Hora` | **Sistema** (auto) | Sim — timestamp do servidor |
| C | `Demandante_Email` | **Demandante** | **Sim — campo do form** |
| D | `Secao_Demandante` | **Demandante** | **Sim — dropdown (13 seções)** |
| E | `Caso_Tipo_Tema` | **Demandante** | **Sim — dropdown (14 casos)** |
| G | `Fato_Gerador` | **Demandante** | **Sim — textarea (a dúvida)** |
| F | `Norma_Chave_Primaria` | Curador | Não — o demandante pode não saber a norma |
| H–P | resto (macete, parecer, autoria, anexo…) | Curador (dentro da planilha) | Não |
| Q | `Status_Obsolescencia` | Fórmula (já existe) | Não |

**O formulário do demandante toca exatamente 4 campos: C, D, E, G.** Sistema preenche A e B. Todo o
resto é do curador, dentro da planilha OPSEC.

> **DESCARTADO PELO DIRETOR 2026-07-11:** a semente 4 do Embaixador (prioridade por evidência via
> "precisa até quando" + função) exigiria uma coluna nova em REGISTROS. O Diretor descartou. Não
> entra na captura. (O EXECUTOR-Antigravity re-propôs a mesma ideia sem saber do descarte — mantida
> descartada salvo reabertura explícita do Diretor.)

---

## 3. COMPORTAMENTO EXATO

### 3.1 `doGet(e)` — serve o formulário
- Retorna `HtmlService.createTemplateFromFile('captura').evaluate()` com
  `.setTitle('Consulta — Asse Ct Orç / DCEM')` e
  `.addMetaTag('viewport','width=device-width, initial-scale=1')` (mobile-first).
- Injeta no template, **lidos da própria planilha** (fonte única, sem hardcode duplicado):
  - lista de seções ← coluna D validation OU constante espelhada de `criarRegistros` (13 seções).
  - lista de casos ← `CASOS!B2:B15` (14 temas).

### 3.2 `doPost(e)` — grava a linha
Sequência obrigatória:
1. **Validar servidor-side** (nunca confiar só no HTML): `Demandante_Email` com formato válido;
   `Secao_Demandante` ∈ lista; `Caso_Tipo_Tema` ∈ lista; `Fato_Gerador` não-vazio e ≤ 1000 chars.
   Se inválido → retornar erro legível, **não gravar**.
2. Gerar `ID_Consulta`: formato `CONS-AAAAMMDD-NNN` (NNN = sequencial do dia; derivar de
   `getLastRow()` ou contador). Determinístico, sem colisão.
3. `Data_Hora` = `new Date()` do servidor.
4. `appendRow` **apenas** nas colunas A, B, C, D, E, G — deixar F e H–Q intocadas (curador preenche).
   Como `appendRow` escreve a linha inteira, montar o array com strings vazias em F, H…P e **não**
   tocar Q (a fórmula ARRAYFORMULA da linha 2 já propaga; confirmar que `appendRow` não quebra a
   ARRAYFORMULA da coluna Q — se quebrar, gravar via `getRange().setValues()` nas colunas certas).
5. **CONFIRMADO PELO DIRETOR 2026-07-11 — fica na Fase 2:** disparar e-mail de confirmação ao
   `Demandante_Email` via `MailApp.sendEmail` (Trilho 3): assunto `Consulta registrada —
   {ID_Consulta}`, corpo curto confirmando recebimento + prazo médio. É o que dá ao demandante o
   "enviei e recebi retorno" dentro do <60s.
6. Retornar à tela um estado de **sucesso** com o `ID_Consulta` (para o demandante anotar).

### 3.3 Lock (concorrência)
Envolver a escrita em `LockService.getScriptLock()` (tryLock ~10s) para evitar corrida de
`ID_Consulta`/linha quando dois demandantes enviam ao mesmo tempo.

---

## 4. UX DO FORMULÁRIO (design direction — não pode ser genérico)

Uma tela, sem rolagem no celular, identidade da seção. Não é "AI slop":
- **Cabeçalho sóbrio, institucional:** brasão/'"Asse Ct Orç — DCEM"' + subtítulo "Registro de
  consulta". Paleta militar-sóbria (verde-oliva escuro / grafite / um único acento), **não** o
  cyber-cyan da Vanguard — este produto é da seção, não da empresa. Tipografia legível e séria
  (uma display institucional + corpo sem-serifa de alta legibilidade), nunca Inter/Arial padrão.
- **4 campos, nesta ordem, rótulos em linguagem de quartel:**
  1. "Sua seção" (select)
  2. "Assunto da consulta" (select — os 14 casos)
  3. "Descreva sua dúvida" (textarea, placeholder com exemplo real de movimentação)
  4. "Seu e-mail para receber o parecer" (input email)
- **Alvos de toque grandes** (≥ 44px), campos altos, um único botão primário "Registrar consulta".
- **Estado de sucesso** ocupa a tela: "✔ Consulta {ID} registrada. Você receberá o parecer por
  e-mail." + botão "Registrar outra".
- **Contador de caracteres** discreto na textarea; **sem** spinners longos — feedback imediato.
- Acessibilidade: labels associadas, foco visível, contraste AA. (Casa com `web-design-guidelines`
  antes do teste do Diretor.)

---

## 5. ENTREGÁVEIS (o que o EXECUTOR produz)

No projeto Apps Script **container-bound** da planilha `BASE_ASSE_CT_ORC`:
- `captura_webapp.gs` — `doGet`, `doPost`, `gerarIdConsulta_`, `validar_`, helpers, `LockService`.
- `captura.html` — a tela única (HTML + CSS inline + JS mínimo de submit via `google.script.run`
  **ou** `<form>` POST; preferir `google.script.run` para receber o `ID_Consulta` sem recarregar).
- Não mexer em nenhuma das 7 funções de construção da base já existentes. Arquivo **novo**, isolado.

---

## 6. IMPLANTAÇÃO — O CLIQUE É DO DIRETOR (OAuth / controle de acesso)

O EXECUTOR **escreve o código**; **não implanta** e **não autoriza permissões** — isso é ação do
Diretor (regra de credenciais/OAuth). Passos que ficam com o Diretor:
1. `Implantar → Nova implantação → Tipo: App da Web`.
2. `Executar como: **Eu** (orcamentariodcem@gmail.com)` — é o que preserva o Trilho 1/5º Trilho
   (demandante não recebe acesso à planilha).
3. `Quem pode acessar:` **DECISÃO DO DIRETOR 2026-07-11 → "Qualquer pessoa com conta Google".**
   Intenção do Diretor era restringir à organização "Assessoria de Controle Orçamentário", mas a
   conta soberana é Gmail comum (Fase 0, V-G) — **não há opção de restrição por domínio** (só existe
   em Google Workspace). "Qualquer pessoa com conta Google" é o mais próximo de institucional
   possível e mantém rastreabilidade (cada militar loga com a própria conta → e-mail registrado).
   OPSEC do acervo permanece intacto independentemente: o Web App roda como dono, o demandante nunca
   vê REGISTROS. Trava opcional adicional: código da seção no próprio form (EXECUTOR pode propor).
4. Autorizar os escopos na primeira execução (tela "Revisar permissões" → o Diretor clica).
5. Copiar a URL `/exec` → é o link que vai às 12 seções.

---

## 7. CRITÉRIOS DE ACEITE (prova de disco, não de memória)

- [ ] Abrir a URL `/exec` numa janela anônima → o formulário carrega em 1 tela, mobile OK.
- [ ] Preencher 4 campos e enviar → **nova linha em REGISTROS** com A,B,C,D,E,G corretos; F e H–P
      vazios; Q calcula sem `#ERROR!`.
- [ ] `ID_Consulta` no formato `CONS-AAAAMMDD-NNN`, único para dois envios seguidos.
- [ ] Demandante recebe e-mail de confirmação com o ID.
- [ ] Demandante **não** consegue abrir a planilha (sem acesso concedido).
- [ ] Validação server-side rejeita e-mail malformado e dúvida vazia sem gravar.
- [ ] Cronômetro real: preenchimento típico ≤ 60 s.

---

## 8. FORA DE ESCOPO DESTA FASE
- Campo de prioridade/"precisa até quando" (coluna nova) — DESCARTADO pelo Diretor 2026-07-11.
- Painel/telemetria de consultas evitadas (semente 1 do Embaixador — fase posterior).
- Motor de notificação Telegram (Fase 3 — `UrlFetchApp`).
- Camada de consulta com IA (Fase 6 — Caminho A).
