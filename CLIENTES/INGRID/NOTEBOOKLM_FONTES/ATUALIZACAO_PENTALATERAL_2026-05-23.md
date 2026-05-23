# ATUALIZAÇÃO DO PENTALATERAL IAH — 2026-05-23
> Gerado pelo Músculo · Aprovado pelo Diretor Eduardo
> Distribuir: colar no início da próxima sessão de cada parceiro + incluir nas fontes do NotebookLM.

---

## O QUE MUDOU (visão geral)

O Pentalateral IAH passou por uma **expansão de papéis e instrumentos** neste ciclo.
Não foi uma mudança de fundamentos — foi uma densificação do protocolo existente.
12 novas deficiências foram formalizadas. 8 novas ferramentas obrigatórias foram criadas.
3 novos documentos de processo foram adicionados ao fluxo.

---

## PARA O ESTRATEGISTA (GEMINI) — mudanças na sua operação

**Novos instrumentos obrigatórios em toda DIRETRIZ:**

| Instrumento | Quando usar | O que resolve |
|---|---|---|
| `REFORMULAÇÃO_DO_PROBLEMA` | Antes do BLOCO 0 — obrigatório | DEF-G-1: Alucinação Otimista |
| `POSIÇÃO_ADVERSARIAL_OBRIGATÓRIA` | Antes do BLOCO 0 — obrigatório | DEF-G-2: Complacência |
| `ARCO_DE_CONSEQUÊNCIAS` | Em cada [G-X] ideia disruptiva | DEF-G-4: Abstração Desconectada |
| `TRADUÇÃO_PARA_AÇÃO` | Ao final de toda DIRETRIZ | DEF-G-4: Análise sem ação |
| `MUDANÇA_DE_TESE` | Ao mudar posição de tese | DEF-G-5: Volatilidade sem evidência |
| `[SINAL_FRACO]` | Dado relevante detectado sem ser pedido | DEF-G-7: Antena Desligada |

**Novas deficiências formalizadas:**
- DEF-G-5: Volatilidade de Tese sem Evidência
- DEF-G-6: Abstração Desconectada → gera análise sofisticada sem ação
- DEF-G-7: Antena Desligada → só pesquisa quando perguntado

**Novo documento de ativação (P-052):**
- `COMANDO_ESTRATEGISTA_MASTER_v1.md` — colar no início de TODA sessão
- Resolve amnésia estrutural entre sessões — o Estrategista não tem memória persistente
- O Músculo mantém o BLOCO 1 (estado atual) sempre atualizado

**BLOCO 3 da DIRETRIZ agora tem 4 sub-blocos obrigatórios (era 3):**
- [PARA O NOTEBOOKLM] + [PARA O MÚSCULO] + [VISÃO DE LONGO PRAZO] + **[PARA O EMBAIXADOR]** (novo)

---

## PARA O AUDITOR (NOTEBOOKLM) — mudanças na sua operação

**Novo documento obrigatório antes de cada sessão:**
- `MANIFESTO_DE_FONTES.md` — declara o que o Auditor pode e não pode ver
- Posição 15 nas fontes numeradas: `15_MANIFESTO_DE_FONTES.md`
- Resolve DEF-N-5: o Auditor não afirma sobre dados ausentes

**Novo instrumento obrigatório:**
- `MANIFESTO_DE_FONTES_ATIVO` — declarar no início de toda auditoria: documentos carregados + ausências + impacto

**Novas deficiências formalizadas:**
- DEF-N-5: Dependência de Qualidade das Fontes → afirma sobre o que não tem
- DEF-N-6: Perspectiva Única → não vê fora do sistema
- DEF-N-7: Latência de Ativação → acionado tarde demais

**Novo sinal obrigatório:**
- `[RISCO_PRECOCE]` — ao detectar risco que deveria ter sido visto antes do Gemini

---

## PARA O MÚSCULO (CLAUDE CODE) — mudanças na sua operação

**Novos documentos de projeto obrigatórios:**
- `REGISTRO_DE_PREMISSAS.md` — em cada projeto: `CLIENTES/[NOME]/REGISTRO_DE_PREMISSAS.md`
  - Declara premissas silenciosas antes de cada deliberação
  - Atualiza o que foi confirmado/refutado ao fechar cada loop
- `CANDIDATOS_A_PRINCIPIO.md` — captura no session_close.ps1

**Novos campos no AUTO-CHECKLIST:**
- DEF-M-6: Déficit de Visão Longitudinal → dívida técnica documentada no REGISTRO_DE_PREMISSAS?
- DEF-M-7: Isolamento do Contexto de Negócio → decisão faz sentido para o cliente real?
- DEF-M-8: Ausência de Retroalimentação → ponto de coleta de feedback definido?

**RITUAL DE FECHAMENTO expandido:**
- Novo item: atualizar `REGISTRO_DE_PREMISSAS.md` ao fechar cada loop
- Novo item: capturar `CANDIDATOS_A_PRINCIPIO` via session_close.ps1

**session_close.ps1 atualizado:**
- Nova seção: `CANDIDATOS_A_PRINCIPIO` — captura fricções que podem virar princípios
- Gera `CANDIDATOS_A_PRINCIPIO.md` na raiz quando há inputs

---

## PARA O EMBAIXADOR (CLAUDE PROJECTS) — mudanças na sua operação

**Novas deficiências formalizadas:**
- DEF-E-6: Silo de Cliente → vê um cliente por vez; não cruza padrões de nicho
- DEF-E-7: Temperatura Simples → temperatura sem tendência ou contexto de pagamento

**Novos instrumentos obrigatórios:**
- `INTELIGENCIA_CRUZADA_NICHO` — ao emitir [E-1 a E-5], se há 2+ clientes no mesmo nicho:
  ```
  INTELIGENCIA_CRUZADA_NICHO:
    Padrão em [CLIENTE-A]: [comportamento]
    Padrão em [CLIENTE-B]: [comportamento]
    O que isso sugere para o nicho [NOME]: [hipótese]
  ```
- `TEMPERATURA_PONDERADA` — substituiu "temperatura simples":
  ```
  Temperatura atual + Tendência + Contexto de pagamento → score 0-10
  Score < 6 = CHURN-WATCH automático
  ```

**[PARA O EMBAIXADOR] agora está no BLOCO 3 da DIRETRIZ do Gemini:**
- O Gemini prepara as ideias [G-1 a G-5] já formatadas para o Embaixador reagir
- Inclui: "qual hipótese da MEMORIA_EMBAIXADOR esta ideia confirma ou desafia?"

---

## NOVOS DOCUMENTOS DO SISTEMA

| Documento | Localização | Responsável |
|---|---|---|
| `COMANDO_ESTRATEGISTA_MASTER_v1.md` | `PENTALATERAL_UNIVERSAL/OPERACAO/` | Músculo mantém — Diretor cola no Gemini |
| `MANIFESTO_DE_FONTES_TEMPLATE.md` | `PENTALATERAL_UNIVERSAL/TEMPLATES/` | Template universal |
| `REGISTRO_DE_PREMISSAS_TEMPLATE.md` | `PENTALATERAL_UNIVERSAL/TEMPLATES/` | Template universal |
| `MANIFESTO_DE_FONTES.md` | `CLIENTES/VALDECE/NOTEBOOKLM_FONTES/` | Músculo cria por projeto |
| `MANIFESTO_DE_FONTES.md` | `CLIENTES/INGRID/NOTEBOOKLM_FONTES/` | Músculo cria por projeto |
| `REGISTRO_DE_PREMISSAS.md` | `CLIENTES/VALDECE/` | Músculo mantém |
| `REGISTRO_DE_PREMISSAS.md` | `CLIENTES/INGRID/` | Músculo mantém |

---

## DOCUMENTOS ATUALIZADOS NESTE CICLO

| Documento | Versão anterior | Nova versão | Mudança principal |
|---|---|---|---|
| `PASSO3_GEMINI_TEMPLATE.md` | v2.2 | v2.3 | 3 novas deficiências G + 6 novos campos obrigatórios |
| `PASSO5_NOTEBOOKLM_TEMPLATE.md` | v2.1 | v2.2 | MANIFESTO_DE_FONTES + 3 novas deficiências N |
| `PASSO6_MUSCULO_TEMPLATE.md` | v4.0 | v4.1 | REGISTRO_DE_PREMISSAS + CANDIDATOS + 3 novas deficiências M |
| `PASSO7_EMBAIXADOR_TEMPLATE.md` | v1.0 | v1.1 | 2 novas deficiências E + TEMPERATURA_PONDERADA |
| `SKILL_PROTOCOLO_VANGUARD.md` | v6.0 | v6.1 | 12 novas deficiências (M+G+N+E) + P-052/P-053 |
| `MANUAL_DIRETOR.md` | v1.2 | v1.3 | PARTE 0.6 — tabela definitiva de documentos por parceiro |
| `INTELLIGENCE_LEDGER.md` | P-051 | P-053 | P-052 (MASTER) + P-053 (MANIFESTO_DE_FONTES) adicionados |

---

## PRINCÍPIOS NOVOS (P-052 e P-053)

**[P-052] Estrategista requer MASTER de ativação em toda sessão — a amnésia é estrutural**
> O Gemini não tem memória entre sessões. Colar `COMANDO_ESTRATEGISTA_MASTER_v1.md` no início é obrigatório.
> Sessão sem o MASTER = Estrategista operando às cegas.

**[P-053] MANIFESTO_DE_FONTES declara o que o Auditor pode e não pode ver**
> O Auditor só sabe o que as fontes carregadas revelam.
> Afirmação sobre dado ausente = alucinação.
> Template em: `PENTALATERAL_UNIVERSAL/TEMPLATES/MANIFESTO_DE_FONTES_TEMPLATE.md`

---

## O QUE NÃO MUDOU

- Os 7 pontos de deliberação do Músculo
- O processo PASSO 1→2→3→5→7→6→7 do Diretor
- Os princípios P-001 a P-051
- A soberania do Veredito do Diretor
- A stack Supabase + Claude API + PWA/Netlify
- O posicionamento de nicho e precificação por ROI

---

## NOTA SOBRE RENAME PENDENTE

Eduardo sugeriu renomear Pentalateral → PENTALATERAL.
Esta é uma decisão de grande impacto (muitos caminhos de arquivo).
**Aguarda veredito formal do Diretor antes de executar.**
O Músculo pode executar o rename em uma sessão dedicada quando aprovado.

---
*Documento gerado pelo Músculo · Pentalateral IAH · 2026-05-23*
*Copiar inteiro para o chat de cada parceiro ao iniciar a próxima sessão.*
