# INTELLIGENCE LEDGER — Quadrilateral IAH
**Organismo Vivo — atualizado a cada sessão pelo Músculo**
**Criado:** 2026-05-12 | **Compactação:** mensal (arquivar entradas > 90 dias)

> Este arquivo é lido pelo Músculo no INÍCIO de cada sessão.
> Cada princípio aqui vale mais do que qualquer código — é o que torna o sistema impossível de copiar.

---

## PROTOCOLO DE LEITURA — INÍCIO DE SESSÃO

Antes de qualquer deliberação, o Músculo executa:

```
1. Ler PRINCÍPIOS ATIVOS — há algum que se aplica à sessão atual?
2. Ler últimas 3 entradas do LOG DE SESSÕES — há fricção recente relevante?
3. Skill-Drift check — a direção desta sessão alinha com os princípios?
4. Se CONSELHO_SESSAO_[date].md existir na raiz → ler antes de deliberar
```

---

## PRINCÍPIOS ATIVOS

Princípios extraídos de fricções reais. Cada um tem evidência — não é teoria.

---

### [P-001] Claude Code ≠ Daemon Autônomo
**Descoberto:** 2026-05-12 | **Sessão:** V24 Setup
**Evidência:** Estrategista propôs que Claude Code "monitore pastas e inicie codificação automaticamente". Físicamente impossível — Claude Code exige sessão humana. Arquitetura correta usa Claude API via n8n.
**Princípio:** Toda proposta de "execução autônoma" deve especificar Claude API + n8n, nunca Claude Code como daemon.
**Aplica-se a:** qualquer DIRETRIZ que mencione automação, monitoramento contínuo, ou "Claude que age sozinho".

---

### [P-002] VEREDITO BINÁRIO não é burocracia universal
**Descoberto:** 2026-05-12 | **Sessão:** V24 Setup
**Evidência:** Protocolo criado para decisões com divergência real. Risco de virar overhead em decisões óbvias.
**Princípio:** Emitir VEREDITO BINÁRIO apenas quando há divergência técnica real entre duas abordagens. Decisões com clareza >90% → Plano de Build direto.
**Aplica-se a:** toda sessão de deliberação técnica.

---

### [P-003] Scraping de terceiros é dependência, não ativo
**Descoberto:** 2026-05-12 | **Sessão:** Análise SEDES-DF (descartada)
**Evidência:** Proposta de scraping QConcursos viola ToS e cria dependência de terceiro. IP some se API muda.
**Princípio:** Nunca construir sobre dados de terceiros sem acordo formal. Ativo de IP = dados gerados pelo nosso sistema.
**Aplica-se a:** qualquer proposta envolvendo scraping, integração não-oficial, ou dados de plataformas externas.

---

### [P-004] O primeiro cliente não vem do site — vem de uma ligação
**Descoberto:** 2026-05-12 | **Sessão:** Discussão site V24
**Evidência:** GUT do site reformulado = 12. GUT de prospectar.ps1 esta semana = 125. O site é importante, mas não é o caminho para o primeiro real.
**Princípio:** Melhorias de posicionamento (site, design) têm GUT baixo enquanto há 0 clientes. Só sobem na prioridade após o primeiro MRR confirmado.
**Aplica-se a:** qualquer proposta de redesign, branding, ou melhorias de funil antes do primeiro cliente.

---

### [P-006] Precificação de serviço deve ser calculada por ROI do cliente, não por feeling
**Descoberto:** 2026-05-12 | **Sessão:** PROJETO_001 — Valdece
**Evidência:** Primeiro cliente real (Valdece, advogado penal) propôs R$5.000 pela ferramenta. Cálculo GUT de aceitar vs. renegociar = 75 (G:5 · U:5 · T:3). ROI calculado para o cliente: ferramenta economiza ~20h/mês × R$200/h = R$4.000/mês de dívida de tempo. Payback em 1,25 meses. Valor justo de mercado: R$12.000–18.000.
**Princípio:** Antes de aceitar qualquer preço de cliente, rodar o algoritmo: (horas_perdidas × valor_hora_cliente) × 12 = valor_anual_gerado. Preço justo = 10–25% do valor anual gerado. Se o cliente propôs abaixo disso, aceitar apenas com contrapartida (% de MRR, cláusula de referência, ou direito de case público).
**Aplica-se a:** toda proposta de precificação de projeto cliente.

---

### [P-005] Inteligência acumulada por sessão, não por versão
**Descoberto:** 2026-05-12 | **Sessão:** V24 Intelligence Engine
**Evidência:** 23 versões aprenderam, mas o aprendizado ficou preso em MEMORIAs que descrevem "o que foi feito", não "o princípio descoberto". Lag de semanas entre fricção e princípio.
**Princípio:** Todo ALERTA emitido, toda fricção, todo override do Diretor → capturado imediatamente neste LEDGER. O princípio é extraído na mesma sessão, não na próxima versão.
**Aplica-se a:** toda sessão do Quadrilateral.

---

## PADRÕES CONFIRMADOS

O que sistematicamente funciona — com evidência de projeto real.

| Padrão | Confirmado em | Condição de aplicabilidade |
|---|---|---|
| Schema granular desde o Dia 1 | V13-V23 | Todo projeto com dados comportamentais |
| Burn Rate Shield antes de features de IA | V15-V23 | Todo projeto com custo variável de API |
| Kill-Switch com 72h grace period | V6-V23 | Todo projeto SaaS com billing |
| COMANDO_ESTRATEGISTA fecha o loop Gemini↔Claude | V12-V23 | Todo ciclo PDCA completo |
| Freemium by Design desde Camada 1 | V16-V23 | Todo projeto com camadas de upgrade |

---

## PADRÕES REFUTADOS

O que sistematicamente falha — com evidência de projeto real.

| Padrão | Refutado em | Por que falha |
|---|---|---|
| Build de feature antes de billing | V1-V5 | Refatoração pesada quando Stripe é plugado depois |
| Marketplace com split manual | V7 | Compliance, IOF, responsabilidade legal em escala |
| Automação sem logs estruturados | V9-V11 | Falha silenciosa — impossível auditar ou debugar |
| Proposta de parceria sem case documentado | V23 | Argumento fraco — parceiro arrisca relação com cliente |

---

## CONSTITUIÇÃO DE PROCESSO — VETO DO MÚSCULO

### Hard Veto (bloqueia execução — override explícito do Diretor obrigatório)

```
[HV-1] Credencial hardcoded no código
[HV-2] PII sem consentimento auditável (LGPD/GDPR)
[HV-3] Custo acima de BURN_RATE_DAILY_LIMIT sem aprovação
[HV-4] Dívida P0 ativa sem plano de resolução nesta sessão
[HV-5] Breaking change em sistema com cliente ativo sem kill-switch
```

### Soft Veto (flag + 1 sessão de cooling antes de executar)

```
[SV-1] Stack nova sem inventário de soluções existentes
[SV-2] Feature que contradiz princípio ativo neste LEDGER
[SV-3] Acumulação de >3 dívidas P1 no mesmo componente
[SV-4] DIRETRIZ com >5 prioridades (foco perdido = entrega fraca)
[SV-5] Proposta de Claude Code como daemon autônomo [ver P-001]
```

### Protocolo de Override

```
DIRETOR OVERRIDE — [HV-X ou SV-X]
Aceito o risco de [descrição do risco] porque [justificativa].
Consequência esperada documentada: [o que pode acontecer].
```

O Músculo executa, documenta o override neste LEDGER como `[OVERRIDE]`, e monitora a consequência nas sessões seguintes.

---

## SHADOW ARCHITECT — Template Obrigatório

Todo PLANO DE BUILD inclui esta seção antes da execução:

```
[SHADOW ANALYSIS] — [nome do módulo]

Blast radius se falhar em produção:
  → [o que quebra, quem é afetado, reversibilidade]

Harder fix se errarmos a arquitetura agora:
  → [o que seria mais difícil de consertar depois]

Cenário 1000x (escala):
  → [como se comporta com 1000x o volume atual]

Ponto de falha mais provável:
  → [onde vai quebrar primeiro e por quê]

Avaliação: APROVADO / REQUER AJUSTE / BLOQUEADO
```

---

## LOG DE SESSÕES

### [SESSÃO 2026-05-12] — V24 Intelligence Compounding Engine

**Direção da sessão:** Construção da inteligência evolutiva do Quadrilateral — sistema de acumulação por sessão.

**Eventos capturados:**

`[FRICÇÃO]` Estrategista propôs Claude Code como daemon → Músculo vetou → Princípio P-001 extraído.

`[FRICÇÃO]` Sessão SEDES-DF aberta e descartada pelo Diretor ("foi errado, tudo") → Foco retornou ao projeto modelo.

`[PRINCÍPIO]` P-002 extraído: VEREDITO BINÁRIO é protocolo, não burocracia universal.

`[PRINCÍPIO]` P-004 extraído: site reformulado tem GUT 12 vs prospecção GUT 125 com 0 clientes.

`[INTENÇÃO]` Diretor declarou "inteligência evolutiva" como foco V24 → intenção real detectada: não features de produto, mas composição exponencial do conhecimento do sistema.

`[DERIVA]` Sessão quase divergiu para redesign do site (GUT baixo) → Músculo sinalizou → Diretor manteve foco em inteligência.

**Princípios gerados nesta sessão:** P-001, P-002, P-003, P-004, P-005

**Override do Diretor:** V24 aberta antes do primeiro cliente (override da regra V23). Aceito. Motivo: "construção de inteligência é o maior ativo". Documentado.

### [SESSÃO 2026-05-12] — PROJETO_001 · Primeiro Case Real · Valdece

**Direção da sessão:** Discovery completo com cliente Valdece (advogado penal). Ativação do PROTOCOLO VANGUARD para ferramenta de busca semântica de jurisprudências STF/STJ.

**Eventos capturados:**

`[INTENÇÃO]` Diretor declarou: "Tudo o que for gravado nesse nosso primeiro projeto é primordial." → Projeto Valdece = caso de sucesso fundacional do modelo IAH.

`[PRINCÍPIO]` P-006 extraído: precificação deve ser calculada por ROI do cliente, não por feeling. R$5.000 proposto pelo cliente = abaixo do mercado (valor justo: R$12k–18k). Decisão: aceitar com contrapartida de % MRR do SaaS do cliente.

`[FRICÇÃO]` Músculo entrou na Etapa 4 (build) antes da Etapa 2 (Gemini) e Etapa 3 (NotebookLM). Corrigido após sinalização do Diretor.

`[FRICÇÃO]` Processo do Quadrilateral não estava claro para o Diretor — revisão completa feita e documentada em sessão.

`[CONFIRMADO]` Algoritmo de qualificação BLOCO A funcionou: 3 respostas fortes = GO imediato. Prazo de 5 dias confirmado como restrição real, não negociável.

**Próximos passos em aberto:** COMANDO 1 → Gemini → DIRETRIZ · COMANDO 2 → NotebookLM → SKILL · Build 5 dias

**Princípios gerados nesta sessão:** P-006

---

## GLOSSÁRIO DO LEDGER

| Marcação | Significado |
|---|---|
| `[FRICÇÃO]` | Momento de resistência — ALERTA emitido, pushback, mudança de escopo |
| `[PRINCÍPIO]` | Padrão extraído de fricção real — lei do sistema |
| `[SOMBRA]` | Output do Shadow Architect — análise adversarial |
| `[DERIVA]` | Sessão divergindo de princípio ativo — sinalizado pelo Skill-Drift |
| `[INTENÇÃO]` | Intenção real detectada vs. declarada |
| `[OVERRIDE]` | Diretor ativou protocolo de override de veto |
| `[CONFIRMADO]` | Padrão confirmado por resultado real |
| `[REFUTADO]` | Padrão que sistematicamente falha |
