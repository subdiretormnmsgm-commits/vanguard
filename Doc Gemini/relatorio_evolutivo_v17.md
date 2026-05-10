# Relatório Evolutivo V17 — Sovereign Intent Engine
> **Data:** 2026-05-10
> **Versão:** V17
> **Status:** Concluída

---

## O QUE FOI CONSTRUÍDO

A V17 transformou o Vanguard de uma plataforma de diagnóstico em uma **infraestrutura de intenção**. Dois sistemas novos:

**Sovereign Pixel** — script de 3KB instalado nos sites dos clientes finais via Cloudflare Worker. Classifica cada visitante em COLD/WARM/HOT/FIRE com base em comportamento real (dwell time, scroll, hover em CTAs, exit intent). Dados vão directo para as tabelas UNLOGGED da V16. LGPD/GDPR integrado.

**Neural Audit Trail** — PDF de 12 páginas que traduz os gargalos técnicos do RealScanner (V15) em receita perdida (R$/mês). A capa mostra "R$18.000/mês perdidos" antes do cliente abrir a página 2. Versão free 3 páginas → versão completa R$50 via Stripe Connect (V16). É o primeiro produto com preço unitário da Vanguard.

**Motor Comercial** — `prospectar.ps1`: pipeline CSV com funil COLD→FIRE, gerador de mensagens WhatsApp personalizadas, follow-up automático, métricas de conversão. Preenche o gap entre tecnologia e venda.

**Ritual Pós-Versão** — 8 passos cronológicos com dependências explícitas. Nenhuma versão fecha sem instrução clara para o Conselho (Gemini → NotebookLM → Claude → vendas).

---

## O QUE MUDOU NA ARQUITECTURA

- `pixel.js` + `cloudflare/pixel-worker.js` → nova camada de captura de dados no edge
- `neural-audit-trail.js` → motor de tradução financeira (score → R$) + jsPDF 12 páginas
- `PROTOCOLO_INTERATIVO.md` → PDCA obrigatório + Directiva Arquitecto-Mestre
- `scripts/fechar_versao.ps1` → Bloco B comercial adicionado ao output final
- `VANGUARD_INNOVATION_AUDIT.md` → AUTO-LOG [ID-004] processado

---

## AVALIAÇÃO TÉCNICA DAS IDEIAS DO GEMINI

| Ideia Gemini | Avaliação | Decisão |
|---|---|---|
| Sovereign Pixel | Correcta — base de tudo | ✅ Implementado V17 |
| Neural Audit Trail | Correcta — receita imediata | ✅ Implementado V17 |
| Hermes Autonomous | Correcta — depende de dados do Pixel | V18 (precisa de 30d de dados reais) |
| Vanguard Exchange | Prematura — precisa de massa crítica de tenants | V18/V19 |
| Sovereign Playbook | Tecnicamente simples — Haiku + jsPDF já existe | V18 rápido |

---

## 5 IDEIAS DISRUPTIVAS PARA V18

### IDEIA 1 — INTENT GRAPH: API de Intenção Cross-Tenant
Ao agregar dados FIRE de todos os tenants, o sistema tem a matéria-prima de um grafo de intenção nacional. V18 expõe uma API privada: "quais PMEs no sector de saúde em SP tiveram sessões FIRE nas últimas 72h?" — vendida a bancos, fundos de M&A e seguradoras. Ticket mínimo R$15.000/mês por cliente institucional. É o início do Acto III (Bolsa de Intenção B2B) planeado no VANGUARD_INNOVATION_AUDIT.md.

**Fundação necessária:** 30+ dias de dados do Sovereign Pixel activo.

### IDEIA 2 — NEURAL SENTINEL: Subscrição Semanal R$97/mês
Em vez de R$50 único, o Neural Audit Trail passa a ser um serviço recorrente: relatório automático toda segunda-feira com deltas — "esta semana perdeu R$3.200 a mais vs semana passada". O dado de comparação temporal é o lock-in mais forte: o cliente não pode sair sem perder o histórico. Stack: cron job + `neural-audit-trail.js` + Stripe subscriptions (V16).

**Impacto:** transforma produto unitário em MRR recorrente.

### IDEIA 3 — HERMES AUTONOMOUS LOOP COMPLETO
Loop fechado sem intervenção humana: sessão FIRE → Claude Haiku gera mensagem personalizada com comportamento real → WhatsApp envia → Haiku classifica a resposta (INTERESTED / NOT_NOW / NEGOTIATING) → actualiza `lead_stage` na tabela → cadência diferenciada automática. Custo: R$0,12/lead total (Pixel + Haiku + WhatsApp). Taxa de resposta esperada: +45% vs outbound frio. Depende do Pixel activo com dados reais.

### IDEIA 4 — SOVEREIGN PLAYBOOK: Plano de 90 dias gerado por IA
Pós-scan, gerar automaticamente um plano de 90 dias onde cada tarefa está ancorada a um módulo Vanguard — o cliente não executa o plano sem usar a plataforma. Gerado por Haiku (R$0,04/doc) + jsPDF (já existe desde V12). Versão gratuita como isca pós-diagnóstico. Implementação: 1 dia de trabalho. Alta prioridade para V18.

### IDEIA 5 — PIXEL FEDERATION: Instalação via DNS sem código
Hoje o pixel.js requer um `<script>` tag manual. Em V18, criar um fluxo onde o tenant adiciona um CNAME DNS (`vpx.seudominio.com → pixel.vanguard.tech`) e o Worker injeta o pixel automaticamente. Zero fricção de instalação → adoção 10x maior. Tecnicamente viável com Cloudflare Snippets (beta 2026). Elimina a barreira técnica para tenants não-técnicos.

---

## PLANO IMEDIATO (próximas 4 semanas)

| Semana | Acção | Meta |
|---|---|---|
| 1–2 | 40 diagnósticos gratuitos via prospectar.ps1 + Neural Audit Trail | 3+ respostas |
| 2–3 | 1ª reunião de vendas + Neural Audit Trail pago (R$50) | 1 cliente R$270/mês |
| 3–4 | 5 clientes activos → instalar Sovereign Pixel nos sites deles | Dados reais acumulando |
| 4+ | Iniciar V18: Hermes Autonomous + Neural Sentinel | MRR >R$1.350 |

---

## ESTADO DO ECOSSISTEMA (2026-05-10)

- **Versões construídas:** 17
- **Clientes pagantes:** 0
- **MRR actual:** R$0
- **Ferramentas prontas para vender:** Neural Audit Trail + prospectar.ps1 + Hermes Closer + Sovereign Pixel
- **Próximo milestone:** 1 cliente em 30 dias
- **Próxima versão:** V18 — Hermes Autonomous + Neural Sentinel + Sovereign Playbook
