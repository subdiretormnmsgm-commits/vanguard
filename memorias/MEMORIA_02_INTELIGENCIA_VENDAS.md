# MEMORIA_02_INTELIGENCIA_VENDAS — Vanguard Tech V2

**Data:** 2026-05-09
**Versão do Projecto:** 2
**Componentes:** Shadow Closer Lite (Python) + Cockpit (Supabase Auth) + Quiz "IA Processando"

---

## 1. Arquitectura V2

```
vanguard/
├── shadow_closer_v2.py          # Lead Scoring Engine — CLI Python standalone
├── dashboard/
│   ├── index.html               # Cockpit — área logada do Director
│   ├── dashboard.js             # Auth + fetch leads + scoring JS + heatmap
│   └── dashboard.css            # Estilos do Cockpit (cyber-premium)
├── infra/
│   └── schema_v2.sql            # Migration: política SELECT para autenticados
├── assets/css/style.css         # Adicionado: animação orbPulse (IA Processando)
├── js/quiz.js                   # Adicionado: step-processing com delay 2s
└── index.html                   # Adicionado: step-processing div
```

---

## 2. Algoritmo de Lead Scoring (Shadow Closer Lite)

### 2.1 Fórmula

```
Score = clamp(round(base_gargalo × multiplicador_nicho + bónus_semântico), 0, 100)
```

### 2.2 Tabela de Pesos — Gargalo (base score)

| Gargalo                                          | Score Base | Justificação                              |
|--------------------------------------------------|------------|-------------------------------------------|
| Dificuldade em escalar a equipa                  | 100        | Gargalo de escala = urgência máxima + VIP |
| Falta de visibilidade sobre métricas do negócio  | 85         | BI/analytics = alto ticket médio          |
| Captação e retenção de clientes                  | 80         | CRM = dor recorrente e perda de receita   |
| Processos manuais que consomem tempo             | 70         | Automação = ROI mensurável imediato       |
| Dependência de ferramentas de terceiros          | 65         | Ownership = projecto de médio prazo       |

### 2.3 Multiplicadores por Nicho

| Nicho       | Multiplicador | Justificação                        |
|-------------|---------------|-------------------------------------|
| Finanças    | 1.00          | Maior ticket médio do ecossistema   |
| Consultoria | 0.95          | Alto ticket + decisor acessível     |
| Tecnologia  | 0.90          | Comprador técnico, ciclo mais longo |
| Saúde       | 0.85          | Regulação aumenta tempo de venda    |
| Imobiliário | 0.80          | Sazonalidade afecta urgência        |
| E-commerce  | 0.75          | Margens menores, maior volume       |
| Educação    | 0.70          | Orçamentos mais apertados           |
| Outro       | 0.65          | Desconhecido = menor confiança      |

### 2.4 Bónus Semântico (±20)

Analisa o texto livre do gargalo à procura de palavras-chave de urgência:

| Keyword    | Bónus |
|------------|-------|
| `escal`    | +10   |
| `crise`    | +15   |
| `urgente`  | +15   |
| `bloqueio` | +10   |
| `travar`   | +10   |
| `perder`   | +8    |
| `queda`    | +8    |

O bónus é truncado entre -20 e +20 para evitar distorção por respostas manipuladas.

### 2.5 Classificação de Tier

| Tier   | Threshold | Acção recomendada                        |
|--------|-----------|------------------------------------------|
| VIP    | ≥ 75      | Contacto imediato — Shadow Closer agora  |
| QUENTE | 55–74     | Sequência de nurturing em 24h            |
| FRIO   | < 55      | Sequência longa — educação + prova social|

---

## 3. Cockpit — Supabase Auth

### 3.1 Fluxo de Autenticação

```
1. getSession() ao carregar → se sessão activa, mostra Cockpit
2. Login form → signInWithPassword({ email, password })
3. Sessão JWT guarda-se automaticamente (Supabase JS)
4. signOut() limpa sessão local e redirige para login
```

### 3.2 Criar Conta de Administrador

Executar no Supabase Dashboard → Authentication → Users → Add User:
- E-mail: e-mail do Director
- Password: senha forte
- Confirm email: sim

### 3.3 Política RLS V2 (schema_v2.sql)

```sql
-- Utilizadores autenticados podem ler todos os leads
CREATE POLICY "auth_read_leads"
  ON leads_diagnostico FOR SELECT TO authenticated USING (true);
```

Esta política é a única adição necessária. A chave `anon` continua a não ter SELECT.

### 3.4 Componentes do Cockpit

| Componente        | Ficheiro          | Descrição                              |
|-------------------|-------------------|----------------------------------------|
| KPIs              | `dashboard.js`    | Total, VIP, Score Médio, Hoje          |
| Mapa de Calor     | `dashboard.js`    | Frequência de cada gargalo (barras CSS)|
| Tabela de Leads   | `dashboard.js`    | Filtro por tier, link WhatsApp directo |
| Score Bar         | `dashboard.css`   | Barra gradiente cyan→purple por score  |
| Tier Badge        | `dashboard.css`   | Badge colorido: VIP/Quente/Frio        |

---

## 4. Quiz — Animação "IA Processando"

### 4.1 Fluxo V2 do Submit

```
Click "Enviar" →
  btn.disabled = true
  showStep('step-processing')  ← orbPulse animation
  await saveLeadDiagnostico()
  setTimeout(() => showStep('step-success'), 2000)  ← 2s de "processamento"
```

### 4.2 Efeito Visual

- **OrbPulse:** orb circular com gradiente cyan→purple, animação scale 1→1.12 com glow variável
- **Mensagem:** "IA a processar o seu diagnóstico... Verifique o seu WhatsApp em 2 minutos."
- **Impacto:** aumenta percepção de valor, reduz abandono pós-submit, cria antecipação

---

## 5. Como Usar o Shadow Closer

### Execução local

```bash
# Windows PowerShell
$env:SUPABASE_URL = "https://ehyaecxqijgyuuiorzcj.supabase.co"
$env:SUPABASE_ANON_KEY = "eyJ..."
python shadow_closer_v2.py
```

```bash
# Linux/Mac
SUPABASE_URL=https://... SUPABASE_ANON_KEY=eyJ... python shadow_closer_v2.py
```

Os diagnósticos são gerados em `diagnosticos/NOME_ID.md`.

---

## 6. Lições Aprendidas

1. **Score mirror em JS e Python** — o algoritmo de scoring está duplicado em `dashboard.js` e `shadow_closer_v2.py`. Na V3, migrar para Edge Function e chamar de ambos os clientes elimina a duplicação.

2. **anon key não tem SELECT** — decisão deliberada. O Cockpit usa `authenticated` role. Nunca usar a service_role key no frontend.

3. **2s de delay artificial** — não é fake: o save ao Supabase leva ~500ms. O delay de 2s garante que o utilizador lê a mensagem antes de ver o sucesso. Efeito: retenção emocional.

4. **`/dashboard/` sem cache** — o nginx.conf tem `no-cache` para `/dashboard/`. Sem isto, o browser pode servir o HTML do cockpit sem autenticação após logout.

---

## 7. Próximos Passos (V3)

Ver `relatorio_evolutivo_v2.md` — Visão LMM sobre migração do scoring para Supabase Edge Functions (TypeScript/Deno) com resposta em tempo real na interface do quiz.

**Levar o `relatorio_evolutivo_v2.md` ao Gemini para gerar a DIRETRIZ da V3.**
