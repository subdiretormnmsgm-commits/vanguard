# MEMÓRIA V[X] — [NOME DO projeto] — [MISSÃO EM 3 PALAVRAS]

**Data:** [data] | **Tipo:** [ecommerce / app / site / SaaS / automação / outro]
**Camada:** [1–5] | **Stack:** [tecnologias] | **FIRE Event:** `[success_event]`

---

## O QUE FOI CONSTRUÍDO

### Módulo 0 — Injecções Soberanas
- **Sovereign Pixel:** [integrado via CNAME / snippet — endpoint: URL]
- **Burn Rate Shield:** [limite diário: $X | limite mensal: $Y | alerta: email]
- **Kill-Switch:** [ativo — grace period: 72h — estados: active/past_due_72h/past_due/canceled]
- **LGPD/GDPR:** [banner ativo — tabela user_consents no Supabase]
- **Ticket Médio Wizard:** [ticket médio: R$X | volume: Y clientes/mês | FIRE: success_event]

### Módulo 1 — [NOME]
[descrição técnica do que foi construído — arquivos criados, endpoints, schemas]
Localização: `[path/arquivo.ext]`

### Módulo 2 — [NOME]
[descrição técnica]
Localização: `[path/arquivo.ext]`

### Módulo 3 — [NOME]
[descrição técnica]
Localização: `[path/arquivo.ext]`

---

## VARIÁVEIS DE AMBIENTE NECESSÁRIAS

*(valores em `.env` — nunca commitar)*

```
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_KEY=
STRIPE_SECRET_KEY=           # se Camada 2+
ANTHROPIC_API_KEY=
BURN_RATE_DAILY_LIMIT_USD=
VANGUARD_PIXEL_TOKEN=
FIRE_EVENT_KEY=[success_event]
[outras variáveis específicas do projeto]
```

---

## COMO CORRER / DEPLOY

```bash
# Instalar dependências
[npm install / pip install -r requirements.txt / outro]

# Configurar .env
cp env_TEMPLATE.example .env
# Preencher com os valores reais

# Correr em desenvolvimento
[npm run dev / uvicorn main:app --reload / outro]

# Deploy em produção
[vercel deploy / railway up / outro]
```

**URL de produção:** [URL]
**Painel de administração:** [URL/path]
**Supabase dashboard:** [URL]

---

## DÍVIDAS TÉCNICAS

| Prioridade | Descrição | Módulo afectado | Prazo máximo |
|-----------|-----------|----------------|-------------|
| P0 | [descrição] | [módulo] | Próxima iteração |
| P1 | [descrição] | [módulo] | 2 iterações |
| P2 | [descrição] | [módulo] | 4 iterações |

---

## PRÓXIMOS MÓDULOS RECOMENDADOS

1. **[módulo]** — impacto estimado: [X] — depende de: [Y]
2. **[módulo]** — impacto estimado: [X]
3. **[módulo]** — impacto estimado: [X]

---

## CARTA AO MÚSCULO FUTURO — V[X]

Músculo,

Quando abrires esta memória, o projeto está em V[X]. Aqui está o que não está nos arquivos e precisas de saber:

**Decisões arquitecturais que parecem estranhas mas têm razão:**
- [decisão 1]: [razão — a alternativa foi descartada porque...]
- [decisão 2]: [razão]

**O que o cliente é sensível a (não tocar sem avisar o Diretor):**
- [sensibilidade 1]
- [sensibilidade 2]

**A parte mais frágil do sistema agora:**
- [módulo/componente] — vigiar. Se quebrar, o sintoma é [X].

**O que correu melhor do que esperava:**
- [descoberta técnica] — pode ser usada em projetos similares de [tipo].

**O que faria diferente:**
- [decisão que mudaria] — a alternativa seria [X] porque [razão].

**O que está incompleto mas não é P0:**
- [item] — fica para V[X+1] porque [razão — não é urgente agora].

Boa sorte. Sabes o que estás a fazer.
— Músculo V[X]
