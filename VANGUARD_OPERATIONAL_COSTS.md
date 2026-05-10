# VANGUARD OPERATIONAL COSTS — Auditoria Financeira da Operação Hermes
> **Versão:** V15  
> **Data:** 2026-05-10  
> **Autor:** Claude Sonnet 4.6 · Sócio-Arquitecto Vanguard  
> **Objectivo:** Mapa de custos unitários por lead + análise de breakeven para decisão do Director

---

## 1. CUSTOS FIXOS MENSAIS

| Componente | Plano/Spec | Custo/mês | Notas |
|------------|-----------|-----------|-------|
| **VPS Hostinger** | KVM2 (4 vCPU, 8GB RAM) | **€9.99** | Aloja: backend Python, Evolution API, Nginx, Docker |
| **Supabase** | Pro Plan | **€23.00** | DB 8GB, Storage 100GB, Edge Functions, pg_cron |
| **Domínio vanguardtech.io** | Anual amortizado | **€1.00** | ~€12/ano |
| **Evolution API** | Self-hosted (no VPS) | **€0.00** | Open-source, sem custo adicional |
| **Let's Encrypt SSL** | Auto (via Traefik/EasyPanel) | **€0.00** | Renovação automática |
| **Total Fixo** | | **€33.99/mês** | |

> **Nota:** Se optar por Z-API (hosted) em vez de Evolution API self-hosted: +€29/mês → total €62.99/mês

---

## 2. CUSTO VARIÁVEL POR LEAD

### 2.1 Cérebro — Claude API (Anthropic)

**Modelo recomendado:** Claude Sonnet 4.6  
**Preço:** Input $3.00/M tokens · Output $15.00/M tokens  

| Fase | Input Tokens | Output Tokens | Custo USD | Custo EUR |
|------|-------------|--------------|-----------|-----------|
| Qualificação inicial (1 turno) | 900 | 300 | $0.0072 | €0.0067 |
| Conversa completa (4 turnos) | 3,600 | 1,000 | $0.0258 | €0.0239 |
| Geração de proposta PDF | 1,200 | 500 | $0.0111 | €0.0103 |
| **Total por conversa Hermes** | **4,800** | **1,500** | **$0.0369** | **€0.034** |

**Com Claude Opus 4.7** (para leads VIP, score > 8.0):
- Input $15/M · Output $75/M
- Custo/conversa: ~€0.17 (5× mais caro — usar apenas para VIPs)

### 2.2 Voz — Vapi / ElevenLabs (opcional)

| Plataforma | Custo | Chamada 4min | Custo EUR |
|------------|-------|-------------|-----------|
| **Vapi** | $0.05/min | 4 minutos | **€0.19** |
| **ElevenLabs** | $0.30/1k chars | 500 chars avg | **€0.14** |
| **Vapi + ElevenLabs combinados** | — | — | **€0.33** |

> Voz é opcional — só activar para leads VIP (score ≥ 75) ou Maturity ≥ 8.0

### 2.3 Braço — WhatsApp API

| Solução | Custo por conversa 24h | Custo por mensagem | Recomendação |
|---------|----------------------|-------------------|--------------|
| **Evolution API (self-hosted)** | **€0.00** | **€0.00** | ✅ Preferida |
| **Meta WABA oficial (Portugal)** | $0.0588 por conversa | — | Para compliance legal |
| **Z-API** | €0/msg (plano fixo €29/mês) | €0 (no limite) | Alternativa simples |

> Com Evolution API: custo do Braço = €0 (incluído no VPS já pago)

### 2.4 Infra — Pro-rata por Lead

| Volume mensal | Custo fixo | Custo/lead (pro-rata) |
|--------------|-----------|----------------------|
| 100 leads/mês | €33.99 | €0.34 |
| 200 leads/mês | €33.99 | **€0.17** |
| 500 leads/mês | €33.99 | €0.07 |
| 1,000 leads/mês | €33.99 | €0.03 |

> **Lei dos retornos crescentes:** quanto mais volume, menor o custo por lead. A infra é o custo que mais reduz à escala.

---

## 3. CUSTO TOTAL POR LEAD (RESUMO)

| Modo de Operação | Cérebro | Voz | Braço | Infra* | **Total/lead** |
|------------------|---------|-----|-------|--------|----------------|
| **Texto puro (Sonnet)** | €0.034 | €0 | €0 | €0.17 | **€0.20** |
| **Texto + Trojan PNG** | €0.034 | €0 | €0 | €0.17 | **€0.20** |
| **Texto + Voz (Vapi)** | €0.034 | €0.19 | €0 | €0.17 | **€0.39** |
| **Full stack VIP** (Opus + Voz) | €0.17 | €0.33 | €0 | €0.17 | **€0.67** |

*Infra calculada a 200 leads/mês

---

## 4. ANÁLISE DE BREAKEVEN

### 4.1 Breakeven de Infra (Quantos clientes pagantes para cobrir custos fixos?)

| Plano Vanguard | Preço/mês | Meses até breakeven | Leads/mês incluídos |
|----------------|-----------|--------------------|--------------------|
| Agency (€49) | €49 | **< 1 mês** (€49 > €33.99) | 500 |
| White-Label (€149) | €149 | < 1 mês | 2,000 |

**Conclusão:** 1 único cliente Agency cobre toda a infra mensal com €15 de margem.

### 4.2 Breakeven do Hermes como Motor de Vendas

**Premissas conservadoras:**
- 200 leads/mês processados pelo Hermes
- Custo total: €33.99 (fixo) + 200 × €0.034 (Claude) = **€40.79/mês**
- Ticket médio de um negócio fechado: **€500** (projecto 30 dias)
- Taxa de conversão do Hermes (qualificação bem executada): **5%**

| Métrica | Valor |
|---------|-------|
| Leads/mês | 200 |
| Fechos esperados (5%) | 10 |
| Receita bruta | **€5,000** |
| Custo total Hermes | €40.79 |
| **Margem líquida** | **€4,959.21** |
| **ROI** | **121×** |

**Break-even de 1 fecho:**
- 1 fecho a €500 cobre: €500 / €40.79 = **12× o custo mensal**
- Para cobrir apenas os custos: €40.79 / €500 = **0.08 fechos = 1 fecho a cada 12 meses**

### 4.3 Quantos Leads para Pagar 1 Mês de Infra?

```
Custo fixo: €33.99/mês
Custo variável/lead: €0.034 (Claude)

Se 1 fecho = €500:
  Fechos necessários: €33.99 / €500 = 0.07 → 1 fecho/14 meses cobre infra

A taxa de conversão mínima para breakeven:
  34/500 = 6.8% de 1 lead → 0.07%
  → Qualquer lead único fechado paga vários meses de infra
```

### 4.4 Escalabilidade do Breakeven

| Volume leads/mês | Custo total | Fechos 5% | Receita | Margem | ROI |
|-----------------|------------|-----------|---------|--------|-----|
| 100 | €37.39 | 5 | €2,500 | €2,462 | 66× |
| 200 | €40.79 | 10 | €5,000 | €4,959 | 121× |
| 500 | €50.99 | 25 | €12,500 | €12,449 | 244× |
| 1,000 | €67.99 | 50 | €25,000 | €24,932 | 366× |

**Tendência:** o ROI do Hermes aumenta com o volume. A infra escala linear; a receita escala proporcional aos leads.

---

## 5. CENÁRIOS DE DECISÃO PARA O DIRECTOR

### Cenário A — Arranque Mínimo (Bootstrap)
- **Stack:** VPS €9.99 + Supabase Pro €23 + Evolution API gratuito
- **Custo fixo:** €32.99/mês
- **Sem voz, sem WABA Meta**
- **Recomendado para:** fase 0 → primeiros 3 clientes
- **Breakeven:** 1 cliente Agency a €49/mês

### Cenário B — Operação Standard (Recomendado)
- **Stack:** Cenário A + Z-API €29/mês para robustez
- **Custo fixo:** €61.99/mês
- **Com Voz Vapi apenas em VIPs (score ≥ 8.0)**
- **Breakeven:** 2 clientes Agency ou 1 White-Label
- **Volume óptimo:** 200-500 leads/mês

### Cenário C — Escala Total (V15+)
- **Stack:** VPS dedicado €19.99 + Supabase Pro + WABA Meta + Vapi full
- **Custo fixo:** ~€90/mês
- **Com IA Agent n8n + Claude Orchestrator**
- **Recomendado para:** 10+ clientes activos, 1,000+ leads/mês
- **ROI esperado:** 200-300× sobre o custo

---

## 6. RECOMENDAÇÕES AO DIRECTOR

1. **Iniciar com Cenário A** — A Evolution API self-hosted é gratuita e suficiente para os primeiros 6 meses.

2. **Activar Voz apenas para VIPs** — O custo de Vapi (€0.33/lead full stack) só é justificável para leads com Maturity Score ≥ 8.0. Para os restantes, texto puro tem ROI 5× maior.

3. **Meta WABA apenas após 50+ leads/dia** — Antes disso, Evolution API cobre sem compliance adicional. Activar Meta WABA quando o volume exigir garantias de deliverability.

4. **Usar Claude Sonnet (não Opus) como padrão** — Sonnet a €0.034/conversa vs Opus a €0.17. Para Hermes conversacional, Sonnet é indistinguível em qualidade. Reservar Opus para geração de propostas PDF com score > 8.0.

5. **Regra de Margem Mínima:** Preço de qualquer plano ≥ 3× (custo_lead × volume_leads + custo_fixo_proporcional). A plano Agency cumpre com margem de 95%.

---

## 7. MAPA DE CUSTOS MENSAIS PROJECTADO (6 MESES)

| Mês | Clientes | Leads | Custo Var. | Custo Fixo | Total | Receita | Lucro |
|-----|----------|-------|-----------|-----------|-------|---------|-------|
| M1 | 0 | 100 | €3.40 | €32.99 | €36.39 | €0 | -€36.39 |
| M2 | 1 | 150 | €5.10 | €32.99 | €38.09 | €49 | +€10.91 |
| M3 | 2 | 200 | €6.80 | €32.99 | €39.79 | €98 | +€58.21 |
| M4 | 3 | 300 | €10.20 | €32.99 | €43.19 | €147 | +€103.81 |
| M5 | 5 | 500 | €17.00 | €32.99 | €49.99 | €245 | +€195.01 |
| M6 | 8 | 800 | €27.20 | €32.99 | €60.19 | €392 | +€331.81 |

*Apenas receita SaaS contabilizada. Leads fechados em projectos próprios não incluídos.

---

> **Conclusão do Sócio-Arquitecto:**  
> O Hermes é o activo com maior ROI do ecossistema Vanguard. A €0.20/lead em texto puro,  
> o custo de prospecção é virtualmente zero comparado com qualquer alternativa de mercado.  
> O único risco financeiro real é a fase de arranque (M1) sem receita.  
> **Solução:** 1 cliente fechado manualmente pelo Director antes do M2 elimina qualquer risco.
