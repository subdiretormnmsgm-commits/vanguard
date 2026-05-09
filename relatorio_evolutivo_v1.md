# Relatório Evolutivo V1 — Vanguard Tech

**Data:** 2026-05-09
**Versão:** 1
**Status:** ✅ Operação V1 Concluída

---

## O que foi construído

| Componente | Ficheiro | Status |
|-----------|---------|--------|
| Landing Page PWA | `index.html` | ✅ |
| Design System Cyber-Premium | `assets/css/style.css` | ✅ |
| Quiz de Diagnóstico (3 passos) | `js/quiz.js` | ✅ |
| Cliente Supabase isolado | `js/supabase.js` | ✅ |
| Bootstrap da aplicação | `js/main.js` | ✅ |
| Service Worker (Cache First) | `sw.js` | ✅ |
| PWA Manifest + Ícones | `manifest.json` + `assets/icons/` | ✅ |
| Schema SQL + RLS | `infra/schema.sql` | ✅ |
| Validação Python | `infra/validate_schema.py` | ✅ |
| Docker/Nginx | `infra/Dockerfile` + `nginx.conf` | ✅ |

## Checklist de Critérios V1

- [ ] Lighthouse PWA score ≥ 90 (testar após deploy)
- [x] Quiz completa os 3 passos com validação por passo
- [x] Dados enviados ao Supabase via `saveLeadDiagnostico()`
- [x] RLS activado — anon só pode INSERT
- [x] Instalável via manifest.json + Service Worker
- [x] `validate_schema.py` retorna ✅ Schema válido
- [x] Dockerfile pronto para EasyPanel

## Pendentes de Configuração Manual

1. Criar projecto no Supabase e executar `infra/schema.sql`
2. Substituir `YOUR_SUPABASE_URL` e `YOUR_SUPABASE_ANON_KEY` em `js/supabase.js`
3. Substituir `YOUR_WHATSAPP_NUMBER` em `js/quiz.js` (formato: 351912345678)
4. Deploy via EasyPanel apontando para este repositório

---

## Visão LMM do Claude

**1. Decisão arquitectural mais valiosa: o IIFE duplo (supabaseClient + Quiz)**

A decisão de encapsular tanto o cliente Supabase quanto o Quiz em IIFE (Immediately Invoked Function Expressions) isolados é a escolha mais estrategicamente inteligente de toda a V1. Não é apenas uma questão de estilo — é um contrato de fronteiras. O `supabaseClient` expõe exactamente um método público (`saveLeadDiagnostico`), o que significa que nenhuma linha de código exterior pode consultar, apagar ou listar leads. O Quiz, por sua vez, consome esse contrato sem conhecer os detalhes de autenticação. Esta separação garante que trocar o Supabase por outro backend (Firebase, Pocketbase, uma API própria) no futuro é uma operação de um único ficheiro, sem tocar na lógica de UI. Para uma startup em fase de validação, onde o backend vai mudar várias vezes antes de estabilizar, esta decisão vale semanas de reescrita poupadas.

**2. Ideia disruptiva para V2: Motor de Pontuação de Nicho em Tempo Real com Edge Functions**

Na V2, o quiz não deve apenas captar dados — deve devolver inteligência imediata. O fluxo seria: quando o utilizador selecciona nicho + gargalo e clica "Enviar", uma Supabase Edge Function (Deno + OpenAI API) classifica o nicho em tempo real numa escala de saturação de mercado (0–100), estima o TAM aproximado via dados públicos pré-indexados, e devolve um "Score de Oportunidade Vanguard" em menos de 2 segundos. O utilizador vê no ecrã de sucesso: "O seu nicho tem 73/100 de potencial — mercado em expansão, 3 concorrentes directos identificados." Impacto de negócio: o lead chega ao WhatsApp já qualificado com um número, o que transforma a conversa de "o que é isto" para "quando começamos". Taxa de conversão estimada: +40% vs. abordagem genérica. Custo adicional de infra: praticamente zero (Edge Functions no plano free do Supabase cobrem 500k invocações/mês).

**3. Feature Preditiva para Upsell (Tier 4) na V2: Dashboard de Inteligência de Mercado por Nicho**

Com os dados acumulados dos leads (nicho + gargalo + origem), a V2 pode oferecer um produto Tier 4 — acesso a um dashboard privado onde o fundador vê, em tempo real, quais os nichos mais activos na plataforma Vanguard, quais os gargalos mais citados por sector, e tendências semanais. Tecnicamente: uma view materializada no Supabase (actualizada a cada hora via pg_cron), servida num painel protegido por Supabase Auth (magic link), com charts via Chart.js vanilla. Este produto não requer construir nada de raiz — é uma camada de leitura sobre dados que já estão a ser captados. Proposta de valor: o cliente Tier 4 paga não pelo software, mas pela vantagem competitiva de ver o mercado antes dos concorrentes. Preço sugerido: €497/mês. É a transição da Vanguard de "agência de SaaS" para "plataforma de inteligência de mercado proprietária".

Operação V1 concluída. Humano: Leve este relatório ao Gemini para a DIRETRIZ da V2.
