# WIP BOARD — Pentalateral IAH
**Atualizado em:** 2026-06-05
**Fonte:** WIP_BOARD.json (versao Markdown para o Auditor — NotebookLM nao le JSON)

---

## LIMITES WIP
| Coluna | Limite |
|--------|--------|
| Build  | 2 |
| Check  | 1 |

---

## CHECK (HYPERCARE)

### PROJ-001 — Valdece
- **Projeto:** Ferramenta de Busca Jurisprudencia STF/STJ
- **Area:** LegalTech - Direito Penal
- **Status:** HYPERCARE — ate 18-06-2026
- **Loop:** 7 CONCLUIDO — V3 entregue + Deploy Netlify OK
- **Deploy:** https://toga-digital-valdece.netlify.app
- **Contrato:** Assinado 2026-05-19 | R$5.000
- **Ultimo contato:** 2026-06-04
- **Churn threshold:** 3 dias
- **Sentinel:** VERDE — 2026-06-04 (Supabase pause resolvido)
- **Corpus:** 61 acordaos | 22 temas | threshold 0.45 | TESTADO E VERDE
- **Loop fase atual:**
  - Gemini: OK | NotebookLM: OK | Embaixador: OK | Musculo: **OK**
  - Proximo: Loop 8 gate — Sentinel Report uso ativo + Gemini anchor DIRETRIZ V8 Valdece
- **V2 Pipeline:** Sovereign Upload + Radar de Divergencia + Citacao DOCX | R$8.500-12.000
- **Proximo passo:** Hypercare termina 18-06-2026 — aguardar feedback Valdece apos Sentinel

---

## RETAINER

### PROJ-002 — Ingrid
- **Projeto:** Ferramenta de Estudo — Concurso Sedes-DF
- **Area:** EdTech - Concursos Publicos
- **Status:** RETAINER
- **Loop:** 8 CONCLUIDO
- **Ultimo contato:** 2026-06-04
- **Churn threshold:** 3 dias (P-106 — EdTech perfil nao-verbal)
- **Depoimento:** Ingrid gostou muito da ferramenta — capturado 2026-06-04
- **Prova:** 2026-09-06 (Instituto Quadrix)
- **URL publica:** https://subdiretormnmsgm-commits.github.io/vanguard/
- **Banco questoes:** 460 validadas
- **Loop fase atual:**
  - Gemini: OK | NotebookLM: OK | Embaixador: OK | Musculo: OK
  - Proximo: Loop 9 — Gate 7.2 RLS + captacao 2a candidata antes 04-07-2026
- **Pendentes abertos:**
  - D5: Link Demo bloqueado ate 2a usuario
  - D6: Semente E-4 aguardar engajamento verbal
  - Gate 7.2 RLS refactor: julho 2026

---

## BUILD / DISCOVERY / ENTREGUE

| Coluna     | Projetos |
|------------|----------|
| Discovery  | 0        |
| Build      | 0        |
| Entregue   | 0        |

---

## PERFIS DE NICHO

| Nicho | Maturidade | Cliente Referencia | Status |
|-------|------------|-------------------|--------|
| EdTech-Concurso | 70% | PROJ-002 Ingrid | consolidado — Loop 8 concluido |
| LegalTech-Criminal | 75% | PROJ-001 Valdece | HYPERCARE — V3 entregue — Sentinel Verde |

---

## POLITICA

1. Nada entra em BUILD sem Briefing aprovado pelo Diretor
2. Nada sai de BUILD sem check_leis.ps1 aprovado
3. Nada vai para ENTREGUE sem Sovereign Playbook gerado
4. Sentinel do cliente atual validado antes de novo projeto entrar em BUILD
5. Retainer so apos 30 dias de dados reais do Sentinel

---

## META

| Campo | Valor |
|-------|-------|
| Loops desde ultimo checkup | 1 |
| Data ultimo checkup | 2026-05-27 |
| Data ultima sessao | 2026-06-04 |
| Claude Projects pendente | Nao |
