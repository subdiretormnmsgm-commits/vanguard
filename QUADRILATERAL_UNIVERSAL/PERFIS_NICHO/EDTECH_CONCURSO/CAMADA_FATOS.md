# CAMADA_FATOS — PROJ-002 INGRID
> **Regra absoluta:** apenas o que aconteceu ou foi dito, registrado verbatim.
> Sem interpretação, sem inferência, sem síntese. Se está com aspas, é fala literal.
> Se descreve evento, é o evento mínimo necessário para reconstruir o fato.
>
> **Quem mantém:** Embaixador (Claude Projects).
> **Quem lê:** Auditor (NotebookLM), Estrategista (Gemini), Músculo (Claude Code), Diretor.
> **Como ler:** esta camada é a única fonte da verdade factual. Interpretações ficam em CAMADA_INFERENCIA.
>
> **Versão:** v1 (refatoração inicial — 2026-05-18) | **Última atualização:** 2026-05-18

---

## IDENTIFICAÇÃO DA CLIENTE

| Campo | Valor |
|---|---|
| Nome | Ingrid |
| Concurso | TDAS — Cargo 202 (Técnico Administrativo) |
| Órgão | Sedes-DF |
| Banca | Instituto Quadrix |
| Data da prova | 2026-09-06 |
| Canal principal de comunicação | WhatsApp |

---

## TIMELINE VERBATIM — INTERAÇÕES E EVENTOS

### 2026-05-16
- **Evento:** Termo de Uso enviado para Ingrid via WhatsApp.
- **PDF gerado:** `Termo_Uso_Ingrid_PROJ002_30052026.pdf` — corpo do documento contém data "30/05/2026" como data de assinatura prospectiva (inconsistência identificada em 2026-05-18).
- **Fala verbatim do Diretor (mensagem enviada à Ingrid):**
  > *"Ingrid, tô finalizando os últimos ajustes na sua ferramenta e preciso só de uma coisa antes de liberar o acesso pra você: a assinatura do termo que te mandei. É só isso que falta. Me confirma quando assinar! 🙂"*

### 2026-05-18
- **Evento:** Ingrid assinou o Termo de Uso.
- **Data real de assinatura:** 2026-05-18 (confirmada verbatim pelo Diretor em sessão de 2026-05-18).
- **Documento de referência:** PDF original com data 30/05/2026 no corpo — divergência aberta entre data impressa e data real de assinatura.

### 2026-05-18 (mesmo dia)
- **Evento:** PWA da Ingrid publicado em GitHub Pages.
- **URL pública:** `https://subdiretormnmsgm-commits.github.io/vanguard/`
- **Branch:** gh-pages.

### 2026-05-18 (mesmo dia — primeira sessão real)
- **Evento:** Ingrid abriu o app, usou pela primeira vez, respondeu pelo menos até a questão 18.
- **Feedback verbatim relatado pelo Diretor:**
  > *"Gostou muito do aplicativo, só fez essa ressalva: na questão 18, não houve palavra destacada em negrito, como informava o enunciado."*

### 2026-05-19
- **Evento:** Bug de renderização de negrito da questão 18 corrigido e deployado.
- **Commit:** `da9887a` — função `md2html()` adicionada ao frontend (app.js); 4 instâncias de `textContent` substituídas por `innerHTML` com rendering seguro.
- **Evento:** WIP_BOARD.json sincronizado — status do Termo atualizado para "ASSINADO — 2026-05-18".
- **Evento:** P-042 a P-046 adicionados ao INTELLIGENCE_LEDGER.md (universal + projeto Ingrid).

---

## ESTADO TÉCNICO REGISTRADO (factos do build, não inferência)

| Campo | Valor registrado |
|---|---|
| Questões no banco Supabase | 460 — Cargo 202 |
| Proporção do feed | 70% Peso 2 / 30% Peso 1 |
| Gate Dia 2 (10 questões) | APROVADO |
| Gate Dia 5 (feed 7 dias) | APROVADO em 2026-05-17 — 0 erros |
| Custo acumulado de API até Gate Dia 5 | $1,56 |
| Stack | PWA Vanilla JS + Supabase + Claude API |
| Modelos em uso | Haiku (gerais + tutor) / Sonnet (específicos) |

---

## ESTADO CONTRATUAL REGISTRADO

| Campo | Valor |
|---|---|
| Termo de Uso — status real | ASSINADO em 2026-05-18 |
| Termo de Uso — PDF de referência | `Termo_Uso_Ingrid_PROJ002_30052026.pdf` (data 30/05 no corpo, inconsistência aberta) |
| WIP_BOARD.json — status do Termo | "minuta — aguarda assinatura" (DESATUALIZADO em relação ao fato real) |
| Clickwrap no PWA | implementado — confirma aceite digital adicional na primeira sessão |
| Vigência contratual | até 2026-09-06 |

---

## DELIBERAÇÕES FORMAIS DO CONSELHO (factos de decisão, não opinião)

### 2026-05-18 — Síntese Final P-037
Itens decididos formalmente pelo Conselho, registrados aqui apenas como fato deliberativo. A análise das decisões fica em CAMADA_INFERENCIA, o registro do que foi decidido fica em CAMADA_DECISAO.

- Número visível na UI: Pontos Ponderados (Score de Sobrevivência foi removido).
- E-2 frase de abertura: dois estados aprovados (cold start edital / erro recente).
- E-5 frase de encerramento: só exibir se `total_respostas >= 10`.
- Beacon de abandono: padrão 3+/semana, não evento único.
- TTI de acerto: `acerto_provavel_chute: true` quando TTI < 10s + acerto.
- Debug Mode: 5 toques no logo (nunca query string).

---

## PROTOCOLO DE ATUALIZAÇÃO

**Quando adicionar nesta camada:**
- Cliente disse ou escreveu algo → captura verbatim com data e canal.
- Algo aconteceu no relacionamento ou no produto → registrar evento mínimo necessário para reconstruir o que ocorreu.
- Decisão formal foi tomada pelo Conselho → registrar o item decidido sem comentário.

**Quando NÃO adicionar nesta camada:**
- Interpretação de um fato → vai para CAMADA_INFERENCIA.
- Hipótese sobre comportamento → vai para CAMADA_INFERENCIA.
- Ideia estratégica do Embaixador → vai para CAMADA_INFERENCIA.
- Análise de impacto de uma decisão → vai para CAMADA_DECISAO ou CAMADA_INFERENCIA.

**Formato de entrada nova:**
```
### YYYY-MM-DD
- **Evento:** [descrição factual mínima do que aconteceu]
- **Canal:** [WhatsApp / Telegram / presencial / etc.]
- **Fala verbatim (se aplicável):** "..."
```

---

> **Princípio que governa esta camada (P-039 proposto):**
> Transcrição verbatim É a purificação. Síntese interpretada é onde mora o viés.
> O Auditor lê esta camada para formar interpretação independente sem viés do Embaixador.
