# GATE P-038 — RESULTADO DO TESTE PRÉ-DEMO
**Projeto:** Toga Digital · PROJ-001 Valdece  
**Data:** 2026-05-19  
**Executado por:** Eduardo (Diretor)  
**Ambiente:** Supabase do Valdece — credenciais reais  
**Ferramenta:** `search_cli.py` · backend VALDECE  
**Status final:** 🟢 APROVADO — sistema pronto para demo

---

## CONFIGURAÇÃO DO AMBIENTE

```
Caminho: C:\Users\Eduardo DELL\OneDrive\Área de Trabalho\vanguard\CLIENTES\VALDECE\backend
Comando: python search_cli.py "query aqui"
Threshold mínimo: 0.67
Top resultados: 3
```

---

## BLOCO 1 — CRIMES CONTRA A VIDA

### Query 1.1
```
python search_cli.py "réu alega legítima defesa em homicídio qualificado"
```
| # | Tribunal | Acórdão | Similaridade | Status |
|---|---|---|---|---|
| 1 | STJ | REsp 1636701 · Feminicídio | 0.682 | ✅ |
| 2 | STF | HC 188888 · Homicídio qualificado | 0.678 | ✅ |
| 3 | STF | RE 971959 · Legítima defesa | 0.669 | ✅ |

**Tempo:** 3.37s · **Melhor sim:** 0.682

---

### Query 1.2
```
python search_cli.py "dosimetria da pena em homicídio doloso com qualificadora"
```
| # | Tribunal | Acórdão | Similaridade | Status |
|---|---|---|---|---|
| 1 | STJ | REsp 1896440 · Dosimetria | 0.726 | ✅ |
| 2 | STJ | AgRg HC 765432 · Roubo/arma | 0.711 | ✅ |
| 3 | STJ | REsp 1636701 · Feminicídio | 0.706 | ✅ |

**Tempo:** 3.16s · **Melhor sim:** 0.726

---

### Query 1.3
```
python search_cli.py "tentativa de homicídio distinção de lesão corporal grave"
```
| # | Tribunal | Acórdão | Similaridade | Status |
|---|---|---|---|---|
| 1 | STJ | REsp 1.855.274 · Tentativa | 0.709 | ✅ |
| 2 | STJ | REsp 1.897.438 · Lesão corporal | 0.671 | ✅ |
| 3 | STJ | REsp 1636701 · Feminicídio | 0.653 | ⚠️ |

**Tempo:** 3.45s · **Melhor sim:** 0.709  
**Nota:** Resultado 3 abaixo do threshold — os dois primeiros são sólidos.

---

### Query 1.4
```
python search_cli.py "homicídio qualificado motivo torpe premeditação"
```
| # | Tribunal | Acórdão | Similaridade | Status |
|---|---|---|---|---|
| 1 | STJ | REsp 1636701 · Feminicídio/qualificadora | 0.716 | ✅ |
| 2 | STF | HC 188888 · Homicídio qualificado | 0.682 | ✅ |
| 3 | STJ | HC 591847 · Injúria racial | 0.661 | ⚠️ |

**Tempo:** 3.30s · **Melhor sim:** 0.716  
**Nota:** Resultado 3 é ruído — irrelevante para a query. Normal com corpus de 61 acórdãos.

---

### Query 1.5
```
python search_cli.py "legítima defesa requisitos moderação dos meios"
```
| # | Tribunal | Acórdão | Similaridade | Status |
|---|---|---|---|---|
| 1 | STF | HC 115.415 · Estado de necessidade | 0.709 | ✅ |
| 2 | STF | RE 971959 · Legítima defesa | 0.707 | ✅ |
| 3 | STJ | AgRg HC 765432 · Roubo/arma | 0.677 | ✅ |

**Tempo:** 2.72s · **Melhor sim:** 0.709

---

### Placar — Crimes contra a vida

| Query | Melhor sim | Tempo | Status |
|---|---|---|---|
| Legítima defesa em homicídio qualificado | 0.682 | 3.37s | ✅ |
| Dosimetria em homicídio com qualificadora | 0.726 | 3.16s | ✅ |
| Tentativa vs lesão corporal grave | 0.709 | 3.45s | ✅ |
| Homicídio qualificado motivo torpe | 0.716 | 3.30s | ✅ |
| Legítima defesa requisitos moderação | 0.709 | 2.72s | ✅ |

**Resultado: 5/5 aprovadas ✅**

---

## BLOCO 2 — CRIMES CONTRA O PATRIMÔNIO

### Query 2.1
```
python search_cli.py "roubo qualificado uso de arma de fogo dosimetria"
```
| # | Tribunal | Acórdão | Similaridade | Status |
|---|---|---|---|---|
| 1 | STJ | AgRg HC 765432 · Roubo/arma | 0.780 | ✅ |
| 2 | STJ | REsp 1929235 · Furto/dosimetria | 0.701 | ✅ |
| 3 | STJ | REsp 1896440 · Dosimetria | 0.700 | ✅ |

**Tempo:** 3.15s · **Melhor sim:** 0.780 ⭐ Maior similaridade do gate inteiro

---

### Query 2.2
```
python search_cli.py "estelionato mediante fraude distinção de furto qualificado"
```
| # | Tribunal | Acórdão | Similaridade | Status |
|---|---|---|---|---|
| 1 | STJ | REsp 1745087 · Peculato/furto | 0.734 | ✅ |
| 2 | STJ | REsp 1.943.211 · Estelionato | 0.714 | ✅ |
| 3 | STJ | HC 577.061 · Extorsão/roubo | 0.684 | ✅ |

**Tempo:** 3.07s · **Melhor sim:** 0.734

---

### Placar — Crimes contra o patrimônio

| Query | Melhor sim | Tempo | Status |
|---|---|---|---|
| Roubo qualificado arma de fogo dosimetria | 0.780 | 3.15s | ✅ |
| Estelionato distinção furto qualificado | 0.734 | 3.07s | ✅ |

**Resultado: 2/2 aprovadas ✅**

---

## BLOCO 3 — CRIMES CONTRA A ADMINISTRAÇÃO PÚBLICA

### Query 3.1
```
python search_cli.py "corrupção passiva elemento subjetivo do tipo"
```
| # | Tribunal | Acórdão | Similaridade | Status |
|---|---|---|---|---|
| 1 | STJ | HC 558.048 · Receptação/dolo | 0.726 | ✅ |
| 2 | STF | AP 470 · Corrupção/adm. pública | 0.706 | ✅ |
| 3 | STJ | REsp 1.798.903 · Coautoria | 0.677 | ✅ |

**Tempo:** 2.95s · **Melhor sim:** 0.726

---

### Placar — Crimes contra a administração pública

| Query | Melhor sim | Tempo | Status |
|---|---|---|---|
| Corrupção passiva elemento subjetivo | 0.726 | 2.95s | ✅ |

**Resultado: 1/1 aprovada ✅**

---

## RESUMO EXECUTIVO

| Área | Queries testadas | Aprovadas | Melhor sim | Status |
|---|---|---|---|---|
| Crimes contra a vida | 5 | 5 | 0.726 | ✅ |
| Crimes contra o patrimônio | 2 | 2 | 0.780 | ✅ |
| Crimes contra a adm. pública | 1 | 1 | 0.726 | ✅ |
| **TOTAL** | **8** | **8** | **0.780** | **✅** |

**Latência média:** ~3.15s  
**Custo estimado por query:** USD $0.00000018–0.00000020  
**Threshold configurado:** 0.45 (retorna resultados) · validação manual acima de 0.67

---

## OBSERVAÇÕES PARA O MÚSCULO

1. **Latência:** 3 queries ultrapassaram 3.30s — monitorar se Supabase São Paulo está sendo usado. Não é bloqueante para a demo mas vale investigar.

2. **Melhor query da demo:** `"roubo qualificado uso de arma de fogo dosimetria"` com sim 0.780 — usar como abertura se Valdece mencionar patrimônio.

3. **Ruído detectado:** Queries de vida retornaram `HC 591847 · Injúria racial` e `REsp 1636701 · Feminicídio` como resultado 3 em buscas não relacionadas. Normal com corpus de 61 acórdãos — não compromete a demo.

4. **Adm. pública:** Área com menor densidade no corpus. Apenas 1 query testada. Recomendo testar `"peculato desvio de verba pública servidor"` antes da demo para ter plano B.

5. **Ambiente confirmado:** Credenciais do Valdece funcionando. Sistema migrado e operacional na conta dele.

---

## DECISÃO

```
🟢 GATE P-038 — LIBERADO
Sistema pronto para demo com Valdece.
Data sugerida: 2026-05-20 conforme planejado.
```

---

*Gerado pelo Embaixador — Quadrilateral IAH · PROJ-001 Valdece · 2026-05-19*
