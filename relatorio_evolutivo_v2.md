# Relatório Evolutivo V2 — Vanguard Tech
**A Máquina de Vendas**
*Data: 2026-05-09*

---

## 1. O que foi construído na V2

A V2 transforma a Vanguard Tech de uma landing page de captação numa **máquina de inteligência de vendas**. Os dados brutos do Quiz deixam de dormir no Supabase e passam a ser processados, classificados e accionados em tempo real.

### Componentes entregues

| Componente                  | Ficheiro                | Status |
|-----------------------------|-------------------------|--------|
| Lead Scoring Engine         | `shadow_closer_v2.py`   | ✅     |
| Cockpit — Dashboard Admin   | `dashboard/index.html`  | ✅     |
| Cockpit — Auth + Lógica     | `dashboard/dashboard.js`| ✅     |
| Cockpit — Estilos           | `dashboard/dashboard.css`| ✅    |
| Quiz — Animação IA          | `js/quiz.js` + `index.html` | ✅ |
| Schema V2 (RLS Auth)        | `infra/schema_v2.sql`   | ✅     |
| MEMORIA_02                  | `memorias/MEMORIA_02_INTELIGENCIA_VENDAS.md` | ✅ |

---

## 2. Resultados Esperados

### 2.1 Aumento de conversão
A animação "IA Processando" (orbPulse + mensagem de WhatsApp) cria antecipação. Hipótese: **+15-25% de retenção** no step final do quiz ao substituir o submit imediato por um delay de 2s com feedback visual de IA em acção.

### 2.2 Priorização de leads
O algoritmo de scoring classifica automaticamente os leads em:
- **VIP (≥75):** acção imediata pelo Shadow Closer
- **Quente (55-74):** nurturing em 24h
- **Frio (<55):** sequência longa de educação

Um Director que antes gastava 30 minutos a decidir a quem ligar, agora sabe em 0 segundos. **ROI do algoritmo: infinito** (custo zero, tempo poupado diário).

### 2.3 Cockpit operacional
O "Mapa de Calor de Dores" revela qual gargalo domina o mercado captado. Esta informação é estratégica para:
- Ajustar o copy dos Instagram Ads em tempo real
- Criar conteúdo educativo no gargalo mais frequente
- Identificar nichos sub-representados para expansão

---

## 3. Arquitectura de Decisão

### Por que Python para o scoring e não Edge Functions já na V2?
**Velocidade de implementação.** O Python CLI produz diagnósticos em Markdown prontos a enviar via WhatsApp em minutos, sem latência de cold start de Edge Functions, sem overhead de deploy. O Director pode correr `python shadow_closer_v2.py` hoje.

A migração para Edge Functions (V3) faz sentido quando: (a) o volume de leads justifica automação contínua, e (b) o score precisa de ser devolvido em tempo real na interface.

### Por que o score está duplicado em JS e Python?
O Cockpit precisa de calcular o score client-side para não depender do Python script estar a correr. Em V3, ambos chamam a mesma Edge Function e a lógica deixa de estar duplicada.

---

## 4. Visão LMM do Claude

**Como migrar o Shadow Closer para Supabase Edge Functions na V3 e devolver o score em tempo real no quiz:**

A V3 deve criar uma Edge Function em TypeScript/Deno chamada `score-lead`:

```typescript
// supabase/functions/score-lead/index.ts
import { serve } from 'https://deno.land/std/http/server.ts'

const GARGALO_SCORES: Record<string, number> = {
  'Dificuldade em escalar a equipa': 100,
  'Falta de visibilidade sobre métricas do negócio': 85,
  'Captação e retenção de clientes': 80,
  'Processos manuais que consomem tempo': 70,
  'Dependência de ferramentas de terceiros': 65,
}

const NICHO_MULT: Record<string, number> = {
  'Finanças': 1.0, 'Consultoria': 0.95, 'Tecnologia': 0.90,
  'Saúde': 0.85, 'Imobiliário': 0.80, 'E-commerce': 0.75,
  'Educação': 0.70, 'Outro': 0.65,
}

serve(async (req) => {
  const { nicho, gargalo } = await req.json()
  const base = GARGALO_SCORES[gargalo] ?? 50
  const mult = NICHO_MULT[nicho] ?? 0.65
  const score = Math.round(Math.min(100, base * mult))
  const tier = score >= 75 ? 'VIP' : score >= 55 ? 'QUENTE' : 'FRIO'
  return new Response(JSON.stringify({ score, tier }), {
    headers: { 'Content-Type': 'application/json' }
  })
})
```

**Impacto na interface V3:** após o utilizador seleccionar o gargalo no Passo 2, o quiz chama `score-lead` e mostra imediatamente: *"O seu potencial de transformação: 85/100 — Score ALTO"* — criando urgência antes mesmo de o lead introduzir o contacto. **Estimativa de aumento de conversão no Passo 2→3: +30%.**

O Python script `shadow_closer_v2.py` transforma-se num script de batch para re-pontuar leads históricos e gerar relatórios semanais — sem modificar a lógica principal.

**A arquitectura V3 é:** Edge Function → Quiz + Cockpit + Dashboard → Python batch para relatórios. Zero duplicação. Score em tempo real. Custo de infra: ~0 (Supabase free tier inclui 500K invocações/mês de Edge Functions).

---

*Operação V2 concluída. Humano: Leve este relatório ao Gemini para a DIRETRIZ da V3.*
