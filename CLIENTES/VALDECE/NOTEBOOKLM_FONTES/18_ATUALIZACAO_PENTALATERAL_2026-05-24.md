# ATUALIZAÇÃO DO PENTALATERAL IAH — 2026-05-24
> Gerado pelo Músculo · Aprovado pelo Diretor Eduardo
> Distribuir: colar no início da próxima sessão de cada parceiro + incluir nas fontes do NotebookLM.

---

## O QUE MUDOU (visão geral)

O Pentalateral IAH ganhou um **pipeline de execução inline** neste ciclo.
O Embaixador entrega DECISOES.json (schema v1.1). Eduardo cola o output no Claude Code.
O Músculo lista as decisões — Eduardo responde "D1:A, D2:B" — Músculo executa tudo automaticamente.
**Eduardo só delibera.** Nenhum arquivo para mover, nenhum HTML para clicar.
3 novos campos no schema: `hypercare_ativo` · `artefato_editavel` · `requer_uso_confirmado` · `resumo_para_cliente`.
3 novos gates ativos: D1 (Hypercare) · D2 (uso confirmado) · D3 (Sentinel Report filtrado).
3 novos princípios inscritos no LEDGER (P-056, P-057, P-058).
1 nova deficiência formalizada (DEF-E-8).
Skill do protocolo: v6.1 → v6.2.
VEREDITOS_RESUMO.md gerado automaticamente pelo Músculo ao fechar cada ciclo de decisões.

---

## PARA O ESTRATEGISTA (GEMINI) — mudanças na sua operação

**Novo bloco obrigatório no PASSO3_GEMINI.md:**
O Músculo prepara o PASSO3 no **Passo ⓪** antes de Eduardo ir ao Gemini.
Isso significa que o PASSO3 que chega ao Estrategista está orientado pelo Diretor — Eduardo não improvisa mais o que quer que seja enfatizado.

**Novos princípios para considerar nas próximas DIRETRIZes:**

| Princípio | Resumo |
|---|---|
| P-056 | Deploy GitHub Pages exige sync explícito master → gh-pages — não assume que commit chegou à produção |
| P-057 | Abandono em EdTech ocorre no pico do resultado — CHURN-WATCH após primeiro resultado acima da média |
| P-058 | Ir ao Gemini antes de fechar loop técnico = contexto truncado — fechar build antes de ir ao Estrategista |

**Nenhuma mudança na sua estrutura de DIRETRIZ** — os 8 blocos continuam iguais.

---

## PARA O AUDITOR (NOTEBOOKLM) — mudanças nas fontes

**Documentos atualizados neste ciclo (carregar versões novas no próximo Wipe & Sync):**

| Documento | O que mudou |
|---|---|
| `01_SKILL_PROTOCOLO_VANGUARD.md` | v6.2 — DEF-E-8 + Pipeline DECISOES + P-056/057/058 |
| `03_MANUAL_DIRETOR.md` | v1.4 — Passo ⓪ Músculo + pipeline DECISOES no Embaixador |
| `04_INTELLIGENCE_LEDGER.md` | P-057 + P-058 inscritos |
| `07_WIP_BOARD.txt` | dias_completos Ingrid: dia12 adicionado |

**Ferramentas ativas do ciclo (Músculo):**
- `scripts/executar_vereditos.ps1` — executa ações após veredito inline do Diretor · gera VEREDITOS_RESUMO.md
- `scripts/ir_ao_embaixador.ps1` — verifica VEREDITOS_RESUMO + sobe DIRETRIZ antes de abrir browser
- `PENTALATERAL_UNIVERSAL/OPERACAO/MENSAGEM_INTERACAO_INICIAL_TEMPLATE.md` — template universal v1.1
- `PENTALATERAL_UNIVERSAL/OPERACAO/PASSO7_EMBAIXADOR_TEMPLATE.md` — pipeline completo v1.3

**Nova deficiência formalizada (DEF-E-8):**
O Embaixador que entrega análise sem DECISOES.json (schema v1.1) = ciclo incompleto.
Músculo lista as decisões e aguarda "D1:A, D2:B" do Diretor — sem isso, nenhuma ação é executada.

---

## PARA O EMBAIXADOR (Claude Projects) — mudanças no seu papel

**Novo entregável obrigatório ao fechar SEÇÃO D:**

```
DECISOES_[PROJETO]_[DATA].json  (schema v1.1)
```

Este arquivo estrutura cada decisão do ciclo com:
- ID, título, urgência, situação
- Novos campos obrigatórios: `hypercare_ativo` · `artefato_editavel` · `requer_uso_confirmado` · `resumo_para_cliente`
- Opções com ações mapeadas: `log_apenas` · `copiar_clipboard` · `log_contato` · `inscrever_ledger` · `criar_nota_regerar_pdf`
- `artefato_texto`: texto pré-redigido (obrigatório se artefato_editavel: true)

**O pipeline completo (inline — sem HTML):**
```
Você entrega [E-1 a E-5] + DECISOES.json
Eduardo cola o output no Claude Code (chat do Músculo)
Músculo lista: "D1: [título] — A: [opção] | B: [opção]"
Eduardo responde: "D1:A, D2:B"
Músculo executa: clipboard, MEMORIA, LEDGER, PENDENTES — automaticamente
Músculo gera VEREDITOS_RESUMO_[CLIENTE]_[DATA].md → você recebe na próxima ativação
```

**Critério de ativação corrigido (não B2C vs. B2B):**
JSON obrigatório quando há consequência formal: LEGAL-WATCH, pitch, inscrever_ledger, Change-Order.
JSON dispensável para decisões relacionais puras: tom de mensagem, horário de check-in.

**DECISOES.json NÃO sobe ao Claude Projects** — JSON não é lido como Knowledge Document.
**VEREDITOS_RESUMO_[DATA].md** É carregado no seu Project na próxima ativação.

**Schema mínimo v1.1:** ver `PASSO7_EMBAIXADOR.md → PARTE 4` nos arquivos do seu Project.

---

## STATUS DOS PROJETOS APÓS ESTE CICLO

| Projeto | Fase | Próximo passo |
|---|---|---|
| PROJ-001 Valdece | Hypercare ativo (até 18/06) | Embaixador ativado Loop 7 pós-assinatura |
| PROJ-002 Ingrid | Loop 5 — Dia 12 ✅ | Gemini Loop 5 → ingrid-v5.md → Embaixador → Dia 13 |

---

*Músculo · 2026-05-24 · Pentalateral IAH v6.2 · Pipeline inline · Schema DECISOES v1.1*
