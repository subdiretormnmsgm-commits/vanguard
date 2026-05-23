# REGISTRO_DE_PREMISSAS — Toga Digital (Valdece)
> Mantido pelo Músculo. Acumula entre loops.
> Declara premissas silenciosas que orientaram as deliberações do Músculo.

---

## IDENTIFICAÇÃO

| Campo | Valor |
|---|---|
| Projeto | Toga Digital — RAG Jurídico Criminal |
| Cliente | Valdece Pereira (advogado criminal) |
| Início | 2026-05-19 (contrato assinado) |

---

## REGISTRO ATIVO — Loop 7 (2026-05-23)

**Premissas declaradas:**

| # | Premissa | Tipo | Status |
|---|---|---|---|
| 1 | APIs STF/STJ estarão acessíveis quando rodado `ingest.py --mode reingest` | técnica / infraestrutura | não verificada — DNS instável na sessão anterior |
| 2 | Valdece usa o sistema pelo menos 1x/semana para preparação de casos | usuário | não verificada — produto em produção há <7 dias |
| 3 | Os 61 acórdãos ingeridos são representativos do corpus que Valdece usa no dia a dia | negócio | não verificada — corpus definido por disponibilidade, não por curadoria |
| 4 | O badge PLENO/COLEGIADA é valorizado pelo cliente como diferenciador visual | usuário | não verificada — Valdece não testou ainda com clientes dele |
| 5 | A busca semântica V3 (outputDimensionality 3072) resolve a dor de "encontrar o precedente certo" descrita no Discovery | técnica / usuário | parcialmente confirmada — sistema em produção, sem feedback de campo ainda |

**Dívida técnica introduzida por estas premissas:**
- Se APIs STF/STJ continuarem inacessíveis → campos turma/repercussao_geral permanecem vazios → badges não aparecem → Valdece vê produto incompleto
- Se corpus de 61 docs é insuficiente → qualidade da busca decai em nichos específicos → experiência degrada sem aviso claro

---

## HISTÓRICO — Loops Anteriores

### Loop 6 (2026-05-19 a 2026-05-21)

**Premissas centrais do Loop 6:**
- Billingissue da API Gemini afetaria o projeto → resolvido: chave Vanguard substituída
- Deploy Netlify seria transparente para o cliente → confirmado: toga-digital-valdece.netlify.app funcional
- Migração Supabase Vanguard → banco Valdece poderia ser feita sem downtime → confirmado: 61/61 docs migrados com 0 erros

**Confirmações Loop 6:**
- V3 completo entregue e validado em produção ✅
- Contrato assinado presencialmente ✅
- Cliente capaz de usar o sistema via browser ✅

---

## PADRÕES IDENTIFICADOS

| Premissa recorrente | Loops afetados | Risco acumulado |
|---|---|---|
| APIs externas (STF/STJ) assumidas como acessíveis | Loop 6, Loop 7 | DNS pode bloquear enriquecimento em qualquer sessão — validar conectividade antes de qualquer `ingest.py` |
| Feedback de uso real do Valdece assumido como positivo | Loop 6, Loop 7 | Sem dados de campo — sistema pode estar com bugs que só aparecem no uso real |

---
*Instância: CLIENTES/VALDECE/ · Pentalateral IAH · 2026-05-23*
