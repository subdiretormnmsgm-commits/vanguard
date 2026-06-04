# PASSO 7 — EMBAIXADOR · Seção D · Stack Interno Pentalateral
# Sessão: 2026-06-05 · Músculo preparou · Diretor cola no Claude Projects Ingrid
#
# DOCUMENTOS A ANEXAR ANTES DE COLAR ESTE TEXTO:
#   1. CLIENTES/INGRID/NOTEBOOKLM_FONTES/07_WIP_BOARD.txt  (estado de todos os projetos)
#   2. PENTALATERAL_UNIVERSAL/OPERACAO/PASSO3_GEMINI_STACK_INFRA_2026-06-05.md (análise técnica)
#
# O Embaixador já tem memória de Ingrid. Os documentos acima adicionam:
#   - Estado atual de Valdece (segundo cliente, perfil completamente diferente)
#   - Decisões técnicas desta sessão (o que o Pentalateral aprovou para a infraestrutura)

---

Você é o Embaixador do Pentalateral IAH — inteligência persistente de clientes, nichos e da Vanguard como empresa.

Neste ciclo, o Pentalateral tomou decisões sobre **infraestrutura interna** que afetam como a Vanguard serve **qualquer** cliente — não apenas Ingrid. Preciso da sua análise com a Vanguard inteira em mente.

---

## DECISÕES APROVADAS NESTA SESSÃO

O Pentalateral aprovou (ciclo Gemini + NotebookLM concluído):

- **n8n** como orquestrador central: check-ins automáticos 7h/13h/20h · monitor Supabase por cliente · webhook GitHub · session_close → MEMORIA atualiza sem ação manual
- **Notion** como cockpit visual: WIP_BOARD de todos os projetos em interface visual · view-only para o Diretor · escrita exclusiva via n8n
- **OpenClaw V2** (após 30 dias de n8n estável): gateway AI multi-canal — WhatsApp/Telegram/Discord/iMessage bidirecional com Claude para qualquer cliente

**Data de início do build: 19-06-2026** (após Hypercare Valdece)

---

## SEÇÃO D — FILTRO DE REALIDADE

Você tem dois clientes reais como referência: **Ingrid** (que você conhece em profundidade) e **Valdece** (perfil nos documentos anexados — advogado, sistema de jurisprudência, R$5.000, perfil completamente diferente).

Para cada uma das ideias abaixo, avalie nas **três camadas do seu mandato**:
- **CLIENTES ATUAIS** — o que Ingrid e Valdece revelam sobre essa ideia (com evidência; se não tiver, diga)
- **NICHO** — o que essa ideia significa para os diferentes perfis de cliente que a Vanguard quer atender (EdTech-Concurso · Legal Tech · Médico · Contabilidade · Psicólogo)
- **VANGUARD** — o que muda para a empresa: posicionamento, escala, diferencial, risco

Use CONFIRMA / EXPANDE / ALERTA em cada camada.

### [G-1 a G-5] — Ideias do Estrategista:
- G-1: Notion como cockpit visual — WIP_BOARD de todos os projetos, view-only para o Diretor
- G-2: Bot Telegram com prefixos (/mem, /status, /alerta) — Diretor gerencia todos os projetos pelo celular
- G-3: Toda mensagem externa passa pelo n8n antes do Claude — nenhum cliente acessa o modelo diretamente
- G-4: Watchdog do servidor — detecta queda antes do cliente perceber
- G-5: Buffer de notificação — CRÍTICO imediato vs. INFORMATIVO buffer 4h

### [M-1 a M-5] — Ideias do Músculo:
- M-1: Protocolo de prefixos Telegram é gate — sem lista definida, build não começa
- M-2: Verificar Docker socket antes do watchdog — se EasyPanel não expõe socket, arquitetura muda
- M-3: Migração gradual — PENDENTES.md continua na FASE 1, Notion só recebe WIP_BOARD
- M-4: Princípio novo: "mensagem externa → n8n → Claude, nunca direto"
- M-5: CLAUDE.md e session_close.ps1 não mudam na FASE 1

### [N-1 a N-5] — Alertas do Auditor:
- N-1: Lock manual no Notion — qualquer edição manual do Diretor conflita com n8n
- N-2: Watchdog no mesmo servidor é ponto cego — se o servidor cair, o alerta cai junto
- N-3: session_close.ps1 deve disparar webhook em fire-and-forget (assíncrono)
- N-4: Exports de workflow n8n para repositório podem expor credenciais de todos os clientes
- N-5: LEDGER.md deve ser gravado localmente ANTES de qualquer sync para Notion

---

## PERGUNTAS ESTRATÉGICAS

**[Q-1] O que a Vanguard realmente vende — ferramenta ou atenção?**
Com automação total, o Diretor passa a gerenciar 20 clientes com o esforço de hoje para 2.
Com Ingrid e Valdece como referência: o valor percebido veio da ferramenta entregue ou do acompanhamento do processo?
Se for acompanhamento, a automação escala receita mas pode matar o diferencial. Se for ferramenta, a automação é o produto.

**[Q-2] OpenClaw por perfil de cliente — quem quer WhatsApp com IA?**
Canal bidirecional via WhatsApp com Claude a qualquer hora — valor diferente por nicho.
Uma candidata de concurso sob pressão antes da prova usa de forma diferente de um advogado que precisa de resposta técnica formal.
Qual nicho mais se beneficia? Qual nicho pode ver isso como impessoal demais?

**[Q-3] Moat real ou commodity?**
Qualquer agência com n8n pode replicar check-ins automáticos e cockpit Notion.
O que desta infraestrutura é diferencial real que concorrentes não copiam facilmente?
E o que é apenas eficiência operacional — valiosa internamente, mas invisível para o cliente?

**[Q-4] Risco de dependência e plano B:**
Com n8n + EasyPanel como coluna vertebral de todos os projetos, uma falha afeta todos os clientes simultaneamente.
O que o Embaixador recomenda como gate de segurança antes de chegar em 10 clientes nesta infraestrutura?

---

## ENTREGÁVEIS

1. **Seção D completa:** CONFIRMA / EXPANDE / ALERTA para cada uma das 15 ideias nas 3 camadas (cliente / nicho / Vanguard)
2. **Respostas Q-1 a Q-4:** direto, com evidência onde tiver — inferência declarada onde inferir
3. **[E-1 a E-5]:** 5 observações exclusivas do Embaixador — o que os outros membros não têm acesso. Priorize cruzamentos entre camadas (ex: comportamento de cliente que revela algo sobre o nicho ou sobre o posicionamento da Vanguard)

---

*Músculo — Pentalateral IAH — 2026-06-05*
*Localização: CLIENTES/INGRID/PASSO7_EMBAIXADOR_INFRA_2026-06-05.md*
