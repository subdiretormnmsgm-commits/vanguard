# Relatório Evolutivo — Protocolo Hermes
**Secretário Executivo Virtual Autónomo**
*Data: 2026-05-09*

---

## 1. O que foi construído

O Protocolo Hermes é a primeira inteligência conversacional da Vanguard Tech — um secretário virtual autónomo que qualifica leads via WhatsApp sem intervenção humana.

### Componentes entregues

| Componente                     | Ficheiro                        | Status |
|--------------------------------|---------------------------------|--------|
| Schema Supabase                | `infra/schema_hermes.sql`       | ✅     |
| Webhook Python (FastAPI)       | `hermes/webhook.py`             | ✅     |
| Dockerfile Hermes              | `hermes/Dockerfile`             | ✅     |
| Workflow n8n (importável)      | `n8n-workflow-hermes.json`      | ✅     |
| Docker Compose (Hostinger VPS) | `docker-compose.yml`            | ✅     |

---

## 2. Arquitectura do Protocolo

```
WhatsApp (cliente)
        ↓
Meta Graph API
        ↓
Webhook Hermes (FastAPI :8000) ←── VPS Hostinger
        ↓
Memória Conversacional (Supabase: hermes_conversas)
        ↓
Claude Haiku AI (extracção estruturada)
        ↓
leads_qualificados (Supabase)
        ↓
Resposta humanizada → WhatsApp
        ↑
n8n (:5678) — orquestração visual alternativa
```

---

## 3. Fluxo Conversacional

### Passo 1 — Gatilho
Webhook recebe evento POST da Meta quando cliente envia mensagem.

### Passo 2 — Memória
Busca histórico da conversa anterior em `hermes_conversas` (últimas 6 mensagens). O Hermes reconhece clientes que já contactaram a Vanguard.

### Passo 3 — Extracção IA
Claude Haiku analisa a mensagem + histórico e retorna JSON com:
- `nome`, `nicho`, `gargalo_tecnologico`, `status_agendamento`, `resposta`

### Passo 4 — Persistência
Lead salvo em `leads_qualificados` com status automático (NOVO → QUALIFICADO → AGENDADO).

### Passo 5 — Resposta
Mensagem humanizada enviada ao cliente via Meta API. Conversa registada na memória.

---

## 4. Deploy na Hostinger VPS

### 4.1 Pré-requisitos
```bash
# Na VPS (SSH)
apt update && apt install -y docker.io docker-compose-plugin
```

### 4.2 Configuração
```bash
git clone https://github.com/subdiretormnmsgm-commits/vanguard.git
cd vanguard
cp docker-compose.env.example .env
nano .env   # preencher todas as variáveis
```

### 4.3 Subir stack
```bash
docker compose up -d
docker compose logs -f hermes   # verificar webhook
docker compose logs -f n8n      # verificar n8n
```

### 4.4 Configurar Webhook na Meta
1. Meta Developers → App → WhatsApp → Configuração
2. URL do Webhook: `https://SEU_IP_VPS:8000/webhook`
3. Token de verificação: `hermes_vanguard_2026`
4. Subscrever evento: `messages`

### 4.5 Importar workflow no n8n
1. Aceder `https://n8n.seudominio.com`
2. Menu → Import from file → `n8n-workflow-hermes.json`
3. Configurar variáveis de ambiente no n8n (Settings → Variables)
4. Activar workflow

---

## 5. Variáveis n8n (configurar em Settings → Variables)
| Variável               | Valor                    |
|------------------------|--------------------------|
| `ANTHROPIC_API_KEY`    | `sk-ant-...`             |
| `SUPABASE_URL`         | `https://...supabase.co` |
| `SUPABASE_SERVICE_KEY` | `eyJ...service_role...`  |
| `WA_TOKEN`             | `EAAxxxxx`               |
| `WA_PHONE_NUMBER_ID`   | `1234567890`             |

---

## 6. Visão LMM do Claude

**Como implementar Chat Memory com PostgreSQL para o Hermes reconhecer clientes e aprimorar o follow-up:**

O n8n tem um nó nativo chamado `Postgres Chat Memory` (parte dos nós LangChain) que persiste o histórico conversacional directamente na base de dados PostgreSQL que já corre no mesmo contêiner. A implementação correcta é:

**1. Adicionar o nó de memória ao workflow n8n:**
```
AI Agent node
  ├── Model: Anthropic (Claude Haiku)
  └── Memory: Postgres Chat Memory
       ├── Connection: hermes_postgres (já configurado no compose)
       ├── Table: hermes_chat_history (criada automaticamente)
       └── Session ID: {{ $('Extrair Mensagem').first().json.telefone }}
```

O `Session ID = telefone` é a chave disruptiva: cada número de WhatsApp tem a sua própria janela de memória. O Hermes passa a saber:
- Se o cliente já falou antes e o que disse
- Qual foi o último status de qualificação
- Se estava a ser seguido por reunião

**2. Follow-up automático com memória:**
Adicionar um segundo workflow com trigger de `Schedule` (cron diário às 09:00):
```
Schedule Trigger (diário)
  → Supabase: buscar leads com status='QUALIFICADO' e created_at > 48h
  → Para cada lead: buscar últimas 3 mensagens na memória
  → Claude: gerar mensagem de follow-up contextualizada ("Olá [nome], na nossa última conversa você mencionou [gargalo]...")
  → WhatsApp: enviar follow-up
  → Supabase: actualizar status para 'FOLLOW_UP_ENVIADO'
```

**Impacto estimado:** leads com follow-up contextualizado têm **3-5× mais probabilidade** de agendar reunião vs mensagens genéricas. A memória transforma o Hermes de chatbot em relacionamento contínuo.

---

*Operação Protocolo Hermes concluída. Humano: Salve as configurações, suba o contêiner na Hostinger e teste o Webhook.*
