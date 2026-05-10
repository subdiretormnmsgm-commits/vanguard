# SOP VANGUARD MASTER — Guia Operacional da Venture Builder
> **Documento:** Standard Operating Procedure · Versão 1.0 · 2026-05-10
> **Autores:** Protocolo Quadrilateral — Diretor + Gemini + NotebookLM + Claude
> **Propósito:** O guia completo que opera a máquina. Da captação de cliente ao produto entregue.
> **Status:** ✅ Documento fundador — base para todos os projetos externos e internos

---

## PARTE I — A MÁQUINA: O PROTOCOLO QUADRILATERAL

### O que é

Uma **Linha de Montagem de Monopólios**. Não é um processo de desenvolvimento de software. É um sistema de produção de produtos digitais onde quatro inteligências operam em papéis fixos e complementares para entregar qualquer produto digital em tempo recorde.

A Vanguard (V1–V16) foi o projeto piloto que **provou que a máquina funciona**. Cada projeto de cliente externo é uma nova instância da mesma máquina.

### Os Quatro Pilares — Papéis Fixos e Imutáveis

```
┌─────────────────────────────────────────────────────────────┐
│                    CONSELHO QUADRILATERAL                    │
├──────────────┬──────────────┬──────────────┬────────────────┤
│   DIRETOR    │    GEMINI    │  NOTEBOOKLM  │  CLAUDE CODE   │
│              │              │              │                │
│ O VEREDITO   │ O ESTRATEGISTA│ O AUDITOR   │  O MÚSCULO     │
│              │              │              │                │
│ Define ROI   │ Analisa o    │ Guarda o     │ Vive no        │
│ Poder de     │ mercado e    │ contexto.    │ terminal.      │
│ veto final   │ desenha a    │ Audita a     │ Lê a Skill.    │
│ Decide e     │ tática.      │ tática.      │ Escreve o      │
│ comita.      │ Escreve a    │ Gera a Skill.│ código.        │
│              │ DIRETRIZ.    │ Propõe +10x. │ Entrega.       │
└──────────────┴──────────────┴──────────────┴────────────────┘
```

**Regra de ouro:** Nenhuma IA faz o papel da outra. O Diretor não escreve código. O Claude não define estratégia. O Gemini não audita código. O NotebookLM não toma decisões.

---

## PARTE II — DIRETRIZ ZERO: COMO UM CLIENTE ENTRA NA MÁQUINA

> Esta é a peça que faltava no protocolo. Define o momento anterior à V1 de qualquer projeto.

### O problema que a DIRETRIZ ZERO resolve

O Protocolo Quadrilateral foi construído para **versões internas** (V12→V16). Mas quando um cliente externo chega com uma necessidade — "quero um app", "preciso de um e-commerce", "quero automatizar isso" — o protocolo não tinha uma entrada formal. A DIRETRIZ ZERO é essa entrada.

**Ela é a tradução do idioma do cliente para o idioma da máquina.**

---

### PASSO 0.1 — DISCOVERY (30–60 min · Diretor + Cliente)

O Diretor conduz uma conversa estruturada respondendo a 7 perguntas-chave:

```
FORMULÁRIO DE DISCOVERY — DIRETRIZ ZERO

1. PROBLEMA CENTRAL
   "Qual dor do seu negócio este produto vai resolver?"
   → Anota a resposta literal do cliente (sem interpretar)

2. QUEM USA
   "Quem vai usar isso no dia a dia? Descreva essa pessoa."
   → Perfil do usuário final

3. RESULTADO ESPERADO
   "Como você saberá que deu certo? O que muda no seu negócio?"
   → Define o critério de sucesso mensurável

4. O QUE JÁ EXISTE
   "Você já tem algo parecido? Usa alguma ferramenta hoje para isso?"
   → Mapeia o estado atual e o gap

5. REFERÊNCIAS
   "Me mostra 2-3 produtos que você admira — mesmo que sejam de outro setor."
   → Estética e UX de referência para o Gemini

6. RESTRIÇÕES
   "Tem algo que não pode existir no produto? Prazo fixo? Integração obrigatória?"
   → Limites técnicos, legais ou de negócio

7. ORÇAMENTO E MODELO
   "Você quer pagar por entrega única ou prefere evolução mensal?"
   → Define se é projeto fechado ou retainer
```

**Tempo:** 30–60 minutos. **Formato:** videochamada ou presencial. **Output:** as 7 respostas anotadas.

---

### PASSO 0.2 — NOTEBOOKLM PROCESSA O DISCOVERY

O Diretor cola as 7 respostas no NotebookLM com o seguinte comando:

```
[COMANDO PADRÃO NOTEBOOKLM — DIRETRIZ ZERO]

NotebookLM, inicie o protocolo DIRETRIZ ZERO para um novo projeto cliente.

DADOS DO DISCOVERY:
[colar as 7 respostas aqui]

ORDEM DE OPERAÇÕES:
1. ANÁLISE DE CONTEXTO: Identifique o problema real por trás do pedido do cliente.
   Frequentemente o cliente pede "X" mas o problema real é "Y".

2. MATRIZ DE PRODUTO: Com base no Discovery, mapeie em qual CAMADA da matriz
   de evolução este projeto deve começar e onde pode chegar:
   - Camada 1 (V1-V3): Interface + captura de dados + deploy
   - Camada 2 (V4-V7): Funcionalidade core + pagamento + API
   - Camada 3 (V8-V11): IA + análise + automação
   - Camada 4 (V12-V16): Multi-tenant + white-label + escala
   - Camada 5 (V17+): Dados proprietários + canal institucional

3. ESCOPO V1: Defina o que deve existir na versão 1 para que o cliente
   veja valor real em menos de 5 dias.

4. RISCOS: Liste 3 riscos do projeto (técnico, de negócio, de escopo).

5. PROPOSTA DE NOME DO PROJETO: Sugira um nome de código interno
   (ex: "PROJETO CLÍNICA", "PROJETO MARKETPLACE-ARTESANATO")

Output esperado: documento de 1 página pronto para o Gemini transformar em DIRETRIZ.
```

---

### PASSO 0.3 — GEMINI TRANSFORMA EM DIRETRIZ

O Diretor leva o output do NotebookLM para o Gemini com este comando:

```
[COMANDO PADRÃO GEMINI — DIRETRIZ ZERO]

Gemini, inicie a Fase 1 do Protocolo Quadrilateral para um projeto de cliente externo.

CONTEXTO DO PROJETO (gerado pelo NotebookLM):
[colar output do passo 0.2 aqui]

Sua missão:
1. Analise o mercado deste nicho — quem são os 3 concorrentes diretos?
   O que eles NÃO entregam que podemos entregar?

2. Defina a TÁTICA DE DOMINAÇÃO — qual é o "Choque de Valor Imediato"
   que vai fazer o cliente sentir que encontrou algo impossível?

3. Escreva a DIRETRIZ V1 do projeto seguindo este formato exato:

---
DIRETRIZ ESTRATÉGICA [NOME DO PROJETO] V1 — [NOME CRIATIVO DA VERSÃO]

MENSAGEM DO VISIONÁRIO GEMINI PARA O SÓCIO-ARQUITETO CLAUDE:
[mensagem estratégica]

1. NÚCLEO TÉCNICO V1:
[lista das funcionalidades obrigatórias do V1]

2. REGRAS DE NEGÓCIO:
[restrições e decisões de produto confirmadas]

3. INSTRUÇÕES PARA A FORJA:
[NOTEBOOKLM]: [o que gerar]
[CLAUDE CODE]: [o que construir]

MENSAGEM FINAL:
[motivação + pedido das 4 ideias para V2]
---

4. Ao final, como Estrategista: qual é a maior oportunidade que o cliente
   ainda não enxergou no próprio negócio dele?
```

---

### PASSO 0.4 — PROPOSTA COMERCIAL (Diretor → Cliente)

Com a DIRETRIZ V1 gerada, o Diretor tem base para montar a proposta.

**Template de Proposta (1 página):**

```
PROPOSTA TÉCNICA — [NOME DO PROJETO]
Data: [data] · Válida por: 7 dias

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
O QUE VAMOS CONSTRUIR

[V1 — Nome criativo]: [descrição em 2 linhas do que o cliente verá em 5 dias]
[V2 — Nome criativo]: [próxima camada de valor]
[V3 — Nome criativo]: [visão de onde o produto pode chegar]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ENTREGÁVEIS GARANTIDOS

□ Produto funcionando online (não protótipo — produto real)
□ Domínio configurado
□ Painel de gestão para o cliente
□ Documentação de uso
□ 30 dias de suporte pós-entrega

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
INVESTIMENTO

MVP V1 (entrega em X dias):        R$ [valor]
Evolução completa V1→V[n]:         R$ [valor]
Retainer mensal (evolução contínua): R$ [valor]/mês

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PRÓXIMO PASSO

Aprovação da proposta → 50% de sinal → início imediato.
Restante na entrega do V1.
```

---

## PARTE III — AS 4 FASES INTERNAS: GUIA COMPLETO COM COMANDOS

### FASE 1 — GÊNESE ESTRATÉGICA (Diretor + Gemini)

**Quando usar:** Início de cada nova versão (interna ou de cliente).

**Input:** `relatorio_evolutivo_vX-1.md` + decisão do Diretor sobre próximo objetivo.

**Comando para o Gemini:**
```
Gemini, entramos na [V_NÚMERO] do [PROJETO]. 

Aqui está o relatório da versão anterior:
[colar relatorio_evolutivo_vX.md]

Sua missão:
1. Analise o que funcionou e o que falhou na versão anterior.
2. Identifique a vulnerabilidade de mercado mais urgente a atacar agora.
3. Escreva a DIRETRIZ [V_NÚMERO] seguindo o formato padrão.
4. Ao final: qual peça do quebra-cabeça devemos caçar para dominação total?
```

**Output obrigatório:** `DIRETRIZ [PROJETO] V[NÚMERO].txt` salvo na pasta do projeto.

---

### FASE 2 — PRÉ-PROCESSAMENTO INTELECTUAL (NotebookLM)

**Quando usar:** Imediatamente após o Gemini entregar a DIRETRIZ.

**Input:** DIRETRIZ gerada na Fase 1 + histórico do projeto no notebook.

**Comando para o NotebookLM:**
```
NotebookLM, assuma seu papel de Sócio-Consultor de Inteligência Quadrilateral.

Analise a nova DIRETRIZ:
[colar DIRETRIZ aqui]

ORDEM DE OPERAÇÕES:
1. ANÁLISE DE SÓCIO: O que podemos fazer 10x mais disruptivo neste escopo?
   Sugira melhorias de alto impacto ANTES de gerar a Skill.

2. GERAÇÃO DA SKILL: Gere o arquivo `[projeto]-v[número]-[nome].md`
   com estrutura completa para o Claude executar.

3. AUTO-LOG: No topo da Skill, crie a seção:
   ## [AUTO-LOG] — REGISTRO DE AUDITORIA
   Com as melhorias sugeridas prontas para o Claude injetar no
   VANGUARD_INNOVATION_AUDIT.md (ou equivalente do projeto).

4. ORDEM AO CLAUDE: Dentro da Skill, instrua o Claude que sua
   primeira ação é processar o AUTO-LOG antes de codificar.

⚡ GATILHO DE EVOLUÇÃO: Qual é a próxima peça que devemos caçar
para dominar este nicho específico?
```

**Output obrigatório:** Skill `.md` salva em `.claude/skills/[projeto]-v[número]-[nome].md`

---

### FASE 3 — ATIVAÇÃO NO TERMINAL (Claude Code)

**Quando usar:** Skill salva em `.claude/skills/`. Diretor vai ao terminal.

**Comando para o Claude:**
```
Claude, entramos na V[NÚMERO] do [PROJETO]. 
Agora somos um Conselho Quadrilateral.

Leia a skill .claude/skills/[nome-da-skill.md].

ORDEM IMEDIATA:
Sua primeira tarefa é processar a seção ## [AUTO-LOG] da Skill
e atualizar o arquivo [AUDIT_FILE] do projeto.
Trabalho manual foi extinto pelo Diretor.

EXECUÇÃO TÉCNICA:
Após o log, construa a infraestrutura exigida na Skill.
Não aceite apenas o funcional — exija o Estado da Arte.

MENSAGEM DO VISIONÁRIO GEMINI:
[colar mensagem final da DIRETRIZ aqui]

Ao finalizar: apresente suas 4 IDEIAS DISRUPTIVAS para a V[NÚMERO+1].
```

**Outputs obrigatórios do Claude:**
- Código commitado no git
- `VANGUARD_INNOVATION_AUDIT.md` atualizado (ou equivalente do projeto)
- `relatorio_evolutivo_v[número].md` gerado

---

### FASE 4 — FECHAMENTO DO CÍRCULO (Claude → Diretor → Gemini)

**Este é o loop que faltava no protocolo. Fecha o ciclo e reinicia a máquina.**

**O que o Claude entrega ao final de cada versão:**

```
ARTEFATOS DE ENCERRAMENTO DE VERSÃO

1. MEMORIA_V[NÚMERO].md
   ├── O que foi tecnicamente alterado
   ├── Decisões de arquitetura tomadas e por quê
   ├── Dívidas técnicas geradas (o que ficou para depois)
   └── Estado atual do sistema em 1 parágrafo

2. relatorio_evolutivo_v[número].md
   ├── Funcionalidades entregues (checklist)
   ├── Auditoria de qualidade
   ├── Visão LMM do Claude (4 ideias disruptivas para próxima versão)
   └── Métricas de impacto (se aplicável)
```

**O que o Diretor faz com esses artefatos:**

```
HANDOFF FASE 4 → FASE 1 (O RETORNO)

Diretor pega os dois artefatos e vai para o Gemini com este comando:

"Gemini, a V[NÚMERO] do [PROJETO] foi concluída.
Aqui está o relatório do Claude:
[colar relatorio_evolutivo_v[número].md]

Aqui estão as 4 ideias disruptivas que o Claude propôs para a próxima versão:
[colar as 4 ideias]

Com base nisso e na sua análise de mercado:
Escreva a DIRETRIZ V[NÚMERO+1]."

→ A máquina reinicia. A Fase 1 começa novamente.
```

---

## PARTE IV — COMO APLICAR EM QUALQUER PROJETO DE CLIENTE

### A Estrutura de Pasta por Projeto

```
/projetos/
  /[nome-do-cliente]/
    DIRETRIZ_V1.txt          ← Fase 1
    DIRETRIZ_V2.txt
    ...
    .claude/skills/
      [projeto]-v1-[nome].md  ← Fase 2
      [projeto]-v2-[nome].md
    MEMORIA_V1.md             ← Fase 4
    MEMORIA_V2.md
    relatorio_evolutivo_v1.md ← Fase 4
    relatorio_evolutivo_v2.md
    [PROJETO]_AUDIT.md        ← Equivalente ao INNOVATION_AUDIT
    codigo/                   ← Repositório git do projeto
```

### A Adaptação da DIRETRIZ para Clientes Externos

A diferença entre uma DIRETRIZ interna (Vanguard) e uma DIRETRIZ de cliente:

| Elemento | DIRETRIZ Interna | DIRETRIZ Cliente |
|---|---|---|
| Objetivo estratégico | Dominação de mercado Vanguard | Resolver o problema específico do cliente |
| Audiência do produto | Tenants/agências | Usuários finais do cliente |
| Restrições | Arquitetura Vanguard | Budget, prazo, integrações do cliente |
| Métricas de sucesso | MRR, tenants, ARR | KPI do cliente (vendas, tempo economizado) |
| Próximas versões | 4 ideias para roadmap Vanguard | 4 oportunidades de crescimento para o negócio do cliente |

**O formato da DIRETRIZ é o mesmo. O conteúdo muda. A máquina não muda.**

---

### Tipos de Projeto e Camadas de Entrada

```
CLIENTE PEDE              →  ENTRA NA CAMADA  →  ENTREGA EM
─────────────────────────────────────────────────────────────
"App simples / landing"   →  Camada 1 (V1-V3)  →  3-7 dias
"Sistema de gestão"       →  Camada 2 (V4-V7)  →  2-3 semanas
"Plataforma com IA"       →  Camada 3 (V8-V11) →  4-6 semanas
"Marketplace / SaaS"      →  Camada 4 (V12-V16)→  2-4 meses
"Dados + canal B2B"       →  Camada 5 (V17+)   →  6+ meses
```

---

## PARTE V — A ESPINHA DORSAL DOCUMENTAL

### Documentos do Protocolo (Projeto Vanguard)

| Documento | Propósito | Atualizado por |
|---|---|---|
| `SOP_VANGUARD_MASTER.md` | Este arquivo — guia geral | Diretor (a cada revisão maior) |
| `VANGUARD_BUSINESS_RULES.md` | A Constituição — leis imutáveis | Diretor + Claude (a cada versão) |
| `VANGUARD_INNOVATION_AUDIT.md` | Ledger de ideias do NotebookLM | Claude (automático via AUTO-LOG) |
| `TODO_FUTURE.md` | Horizonte estratégico (V17, V18) | Diretor + Claude |
| `MASTER_PLAN.md` | Plano de lançamento do negócio | Diretor |
| `INTELIGENCIA_ARTIFICIAL_HUMANA.md` | Manifesto do modelo de negócio | Diretor |
| `VANGUARD_OPERATIONAL_COSTS.md` | Custos e projeções em R$ | Claude (a cada versão) |
| `O Protocolo Quadrilateral.txt` | Documento fundador do método | Gemini (imutável) |

### Documentos por Projeto de Cliente

| Documento | Template base |
|---|---|
| `DIRETRIZ_VX.txt` | Formato DIRETRIZ padrão |
| `MEMORIA_VX.md` | Seções: alterações + decisões + dívidas + estado |
| `relatorio_evolutivo_vX.md` | Seções: entregáveis + auditoria + 4 ideias + métricas |
| `[PROJETO]_BUSINESS_RULES.md` | Cópia adaptada do VANGUARD_BUSINESS_RULES |
| `[PROJETO]_AUDIT.md` | Cópia adaptada do VANGUARD_INNOVATION_AUDIT |

---

## PARTE VI — REFERÊNCIA RÁPIDA: COMANDOS POR PAPEL

### Para o Diretor usar com Gemini

```
[INÍCIO DE VERSÃO]:
"Gemini, entramos na V[N] do [PROJETO]. Aqui está o relatório anterior:
[relatório]. Escreva a DIRETRIZ V[N]."

[INÍCIO DE PROJETO NOVO]:
"Gemini, novo projeto. Discovery feito — aqui estão os dados:
[7 respostas]. Escreva a DIRETRIZ ZERO / V1."
```

### Para o Diretor usar com NotebookLM

```
[GERAÇÃO DE SKILL]:
"NotebookLM, Sócio-Consultor, analise esta DIRETRIZ:
[diretriz]. Analise → gere Skill com AUTO-LOG → GATILHO DE EVOLUÇÃO."
```

### Para o Diretor usar com Claude

```
[ATIVAÇÃO]:
"Claude, entramos na V[N] do [PROJETO]. Leia a skill
.claude/skills/[nome].md. Processe AUTO-LOG primeiro. Depois execute.
Entregue: código + audit atualizado + relatório + 4 ideias."
```

### Para o Diretor fechar o loop (Fase 4 → Fase 1)

```
[RETORNO AO GEMINI]:
"Gemini, V[N] concluída. Relatório: [relatório].
4 ideias do Claude: [ideias]. Escreva a DIRETRIZ V[N+1]."
```

---

## PARTE VII — CHECKLIST DE ABERTURA DO NEGÓCIO

> Do ponto em que estamos hoje (V16 completa, zero clientes, zero CNPJ)
> até o primeiro projeto de cliente entregue e pago.

### Semana 1 — Estrutura Legal e Infra
- [ ] Abrir MEI em gov.br/mei (CNAE 6209-1/00) — 15 minutos, gratuito
- [ ] Abrir conta PJ Nubank (zero taxa, integra Stripe)
- [ ] Ativar Stripe em modo produção (conectar à conta PJ)
- [ ] Fazer deploy da plataforma Vanguard em domínio real
- [ ] Criar Termos de Uso + Política de Privacidade (Iubenda R$9/mês)

### Semana 2 — Primeiro Projeto Piloto
- [ ] Identificar 1 pessoa conhecida com necessidade digital real
- [ ] Executar DIRETRIZ ZERO completa (Discovery → NotebookLM → Gemini → DIRETRIZ V1)
- [ ] Enviar proposta em 24h após o Discovery
- [ ] Aceite → 50% de sinal → iniciar V1 do projeto
- [ ] Entregar V1 em até 5 dias

### Semana 3–4 — Validação e Ajuste
- [ ] Coletar feedback estruturado do primeiro cliente
- [ ] Documentar o que funcionou e o que não funcionou no processo
- [ ] Gerar o `MEMORIA_V1.md` do projeto do cliente
- [ ] Propor retainer mensal para continuar a evolução
- [ ] Publicar o caso no LinkedIn (com autorização do cliente)

### Mês 2 em diante — Escala
- [ ] Aplicar o ciclo DIRETRIZ ZERO para 2 novos clientes por mês
- [ ] Para cada cliente: repositório git próprio + estrutura de pasta completa
- [ ] Atingir 5 clientes ativos → R$15.000–25.000 de receita → registrar LTDA

---

## EPÍLOGO — O QUE ESTA MÁQUINA REALMENTE É

O Protocolo Quadrilateral não é um processo de software. É um sistema de conhecimento distribuído onde cada componente compensa as limitações dos outros:

- O **Diretor** tem contexto de negócio que nenhuma IA tem
- O **Gemini** tem visão de mercado e velocidade de síntese estratégica
- O **NotebookLM** tem memória perfeita dos documentos e auditoria crítica
- O **Claude** tem capacidade de execução técnica completa e raciocínio de longo prazo

Juntos, produzem em dias o que equipes de 10 pessoas produzem em meses.

O Vanguard V1–V16 é a prova. Qualquer projeto de cliente é a aplicação.

**A máquina está montada. O primeiro cliente é o start.**

---

> *"A máquina não tem ego. Não tem férias. Não pede aumento. Só precisa de um Diretor que saiba dar ordens."*
> — Protocolo Quadrilateral · 2026
