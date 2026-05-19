# GATE P-038 — RESULTADO FINAL · PROJ-001 Valdece
**Data:** 2026-05-19 | **Ambiente:** Supabase Valdece (hqqxzecftkvtrlpkhvnc) | **Threshold:** sim ≥ 0.67

## PLACAR: 12/12 🟢 APROVADO

| Área | Queries | Verde | Amarelo | Vermelho |
|---|---|---|---|---|
| Crimes contra a vida | 5 | 5 | 0 | 0 |
| Crimes contra o patrimônio | 3 | 3 | 0 | 0 |
| Crimes contra a adm. pública | 2 | 2 | 0 | 0 |
| Coringa | 2 | 2 | 0 | 0 |
| **TOTAL** | **12** | **12** | **0** | **0** |

## QUERIES COMPLETAS

| # | Query | Melhor sim | Tempo | Status |
|---|---|---|---|---|
| 1 | "réu alega legítima defesa em homicídio qualificado" | 0.682 | 3.37s | 🟢 |
| 2 | "dosimetria da pena em homicídio doloso com qualificadora" | 0.726 | 3.16s | 🟢 |
| 3 | "tentativa de homicídio distinção de lesão corporal grave" | 0.709 | 3.45s | 🟢 |
| 4 | "homicídio qualificado motivo torpe premeditação" | 0.716 | 3.30s | 🟢 |
| 5 | "legítima defesa requisitos moderação dos meios" | 0.709 | 2.72s | 🟢 |
| 6 | "roubo qualificado uso de arma de fogo dosimetria" | 0.780 | 3.15s | 🟢 |
| 7 | "estelionato mediante fraude distinção de furto qualificado" | 0.734 | 3.07s | 🟢 |
| 8 | "extorsão mediante sequestro consumação" | 0.734 | 2.48s | 🟢 |
| 9 | "corrupção passiva elemento subjetivo do tipo" | 0.726 | 2.95s | 🟢 |
| 10 | "peculato desvio de verba pública servidor" | 0.746 | 2.03s | 🟢 |
| 11 | "habeas corpus constrangimento ilegal prisão preventiva" | **0.804** | 2.21s | 🟢 |
| 12 | "tráfico privilegiado requisitos quantidade droga" | 0.767 | 1.99s | 🟢 |

## DESTAQUES

- ⭐ **Maior sim:** 0.804 — query 11 (coringa prisão preventiva)
- ⭐ **Menor latência:** 1.99s — query 12
- ⚠️ **Maior latência:** 3.45s — query 3 (latência Supabase: região USA, ping ~600ms)
- ⚠️ **Menor sim aprovada:** 0.682 — query 1 (acima do threshold de 0.67)

## QUERIES RECOMENDADAS PARA ABERTURA DA DEMO

1. `"habeas corpus constrangimento ilegal prisão preventiva"` — sim 0.804 ← **CORINGA**
2. `"roubo qualificado uso de arma de fogo dosimetria"` — sim 0.780
3. `"tráfico privilegiado requisitos quantidade droga"` — sim 0.767

## AÇÕES PÓS-DEMO

- [ ] Investigar região Supabase (ping 600ms = fora do Brasil) → migrar para sa-east-1 pós-contrato
- [ ] Corpus gap: queries de legítima defesa retornam sim ~0.68-0.71 — prioridade de expansão no V2
- [ ] Registrar estrutura deste gate como template P-040 no LEDGER ✅ (feito em 2026-05-20)

## DECISÃO

```
🟢 GATE P-038 — APROVADO
Realizado por: Embaixador (12 queries) + Músculo (3 queries CLI + UI Playwright)
Sistema pronto para demo com Valdece em 2026-05-20.
```

---
*Documento gerado: 2026-05-19 | Embaixador + Músculo | PROJ-001 Toga Digital*
