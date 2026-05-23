# REPOSITÓRIO VANGUARD — Estrutura e Convenções
> **Propósito:** Como o repositório git é organizado e como usar para projetos de clientes  
> **Data:** 2026-05-10  
> **Princípio:** O git é a memória permanente da fábrica. Tudo que não está no git não existe.

---

## VISÃO GERAL DA ESTRUTURA

```
vanguard/                          ← ROOT — este repositório
│
├── 📁 platform/                   ← A plataforma Vanguard (produto interno)
│   ├── api/                       ← FastAPI endpoints
│   ├── dashboard/                 ← Cockpit do cliente Vanguard
│   ├── js/                        ← Scripts da landing e dashboard
│   ├── assets/                    ← CSS, imagens, ícones
│   ├── infra/                     ← SQL, Docker, nginx
│   └── index.html                 ← Landing page pública
│
├── 📁 methodology/                ← A metodologia IAH (o produto que vendemos)
│   ├── INTELIGENCIA_ARTIFICIAL_HUMANA.md
│   ├── SOP_VANGUARD_MASTER.md
│   ├── O Protocolo Pentalateral.txt
│   └── EMPRESA_VANGUARD.md
│
├── 📁 knowledge/                  ← Constituição e inteligência institucional
│   ├── VANGUARD_BUSINESS_RULES.md
│   ├── VANGUARD_INNOVATION_AUDIT.md
│   ├── VANGUARD_OPERATIONAL_COSTS.md
│   └── TODO_FUTURE.md
│
├── 📁 history/                    ← Memória de cada versão interna
│   ├── MEMORIA_V11.md
│   ├── MEMORIA_V12.md
│   ├── ...
│   ├── MEMORIA_V16.md
│   ├── relatorio_evolutivo_v13.md
│   └── relatorio_evolutivo_v16.md
│
├── 📁 ai-council/                 ← Comandos e instruções para o Conselho
│   ├── COMANDO_GEMINI_V17.md
│   ├── TEMPLATE_COMANDO_GEMINI.md
│   ├── HANDOFF_V16_PARA_GEMINI.md
│   └── skills/                   ← Skills geradas pelo NotebookLM
│       ├── vanguard-v13-domination.md
│       ├── vanguard-v14-optimization.md
│       ├── vanguard-v15-sovereign-invasion.md
│       └── vanguard-v16-visual-authority.md
│
├── 📁 clients/                    ← Projetos de clientes (1 pasta por cliente)
│   ├── [YYYY-MM-cliente-projeto]/
│   │   ├── DISCOVERY.md           ← Briefing da chamada inicial
│   │   ├── PROPOSTA.md            ← Proposta comercial enviada
│   │   ├── CONTRATO.md            ← Contrato assinado (ou link DocuSign)
│   │   ├── DIRETRIZ_V1.md         ← DIRETRIZ gerada pelo Gemini
│   │   ├── MEMORIA_V1.md          ← O que foi construído na V1
│   │   ├── MEMORIA_V2.md          ← O que foi construído na V2
│   │   ├── relatorio_final.md     ← Relatório de entrega
│   │   └── code/                  ← Código do projeto (ou link para repo separado)
│   │       ├── api/
│   │       ├── frontend/
│   │       └── infra/
│   │
│   └── [YYYY-MM-cliente2-projeto]/
│       └── ...
│
├── 📁 templates/                  ← Arquivos reutilizáveis para qualquer projeto
│   ├── DISCOVERY_TEMPLATE.md
│   ├── PROPOSTA_TEMPLATE.md
│   ├── CONTRATO_PROJETO.md
│   ├── MEMORIA_TEMPLATE.md
│   └── boilerplate/               ← Código base por tipo de projeto
│       ├── landing-page/
│       ├── saas-starter/
│       ├── ecommerce/
│       ├── dashboard/
│       └── api-only/
│
├── 📁 actions/                    ← Planos de ação comerciais e operacionais
│   ├── PLANO_DE_ACAO_SEMANA1.md
│   └── MASTER_PLAN.md
│
└── CLAUDE.md                      ← Instruções para o Claude Code (este arquivo)
```

---

## COMO COMEÇAR UM PROJETO DE CLIENTE

### Passo 1 — Criar a pasta do cliente

Convenção de nome: `YYYY-MM-nomecliente-tipoprojeto`

```
Exemplos:
  2026-05-drcosta-clinica-agendamento
  2026-06-artesanato-do-brasil-ecommerce
  2026-06-advocacia-silva-sistema-orcamentos
```

Comando no terminal:
```bash
mkdir -p clients/2026-05-[nome]/code
cd clients/2026-05-[nome]
```

### Passo 2 — Executar DIRETRIZ ZERO (Discovery)

Copiar e preencher o template:
```
cp templates/DISCOVERY_TEMPLATE.md clients/2026-05-[nome]/DISCOVERY.md
```

Preencher durante a chamada com o cliente.

### Passo 3 — Gerar DIRETRIZ V1 (Gemini)

Após o Discovery, o Diretor copia o conteúdo de DISCOVERY.md e passa ao Gemini com:
```
Gemini, analise este briefing e crie a DIRETRIZ V1 para o projeto [NOME].
Inclua: posicionamento visual, stack técnica recomendada, funcionalidades da V1.
```

Salvar o output do Gemini em `clients/2026-05-[nome]/DIRETRIZ_V1.md`.

### Passo 4 — Clonar boilerplate adequado

Com base na camada de entrada:

| Projeto do cliente precisa de | Boilerplate a clonar |
|---|---|
| Landing page + formulário + leads | `templates/boilerplate/landing-page/` |
| E-commerce + pagamento | `templates/boilerplate/ecommerce/` |
| SaaS com auth + dashboard | `templates/boilerplate/saas-starter/` |
| Apenas API / automação | `templates/boilerplate/api-only/` |
| Dashboard analítico | `templates/boilerplate/dashboard/` |

```bash
cp -r templates/boilerplate/saas-starter/ clients/2026-05-[nome]/code/
```

### Passo 5 — Adaptar variáveis do cliente

No boilerplate, existe um arquivo `brand-config.js` (herdado da arquitetura Vanguard) com as variáveis a substituir:

```javascript
// brand-config.js — editar por cliente
window.__VANGUARD_BRAND__ = {
  name:    "Dr. Costa Clínica",
  tagline: "Agendamento fácil, cuidado real",
  primary: "#1B4FE8",      // cor principal da marca
  logo:    "/logo.svg",
  whatsapp: "+5511999887766"
};
```

### Passo 6 — Criar notebook no NotebookLM

1. Abrir novo notebook: `[YYYY-MM] [Nome do Cliente] — Projeto [Tipo]`
2. Adicionar fontes: DISCOVERY.md + DIRETRIZ_V1.md + documentos do cliente
3. Isso é o contexto que o NotebookLM usará para gerar as próximas Skills

### Passo 7 — Primeiro commit

```bash
git add clients/2026-05-[nome]/
git commit -m "feat([nome]): V1 kickoff — [nome do projeto]"
```

---

## CONVENÇÕES DE NOMENCLATURA

### Commits
```
feat([cliente]): V[N] — [o que foi entregue]
docs([cliente]): DISCOVERY + PROPOSTA + CONTRATO
fix([cliente]): [o que foi corrigido]

Exemplos:
  feat(drcosta): V1 — agendamento online com calendário
  feat(drcosta): V2 — auth de pacientes + painel da clínica
  docs(drcosta): contrato assinado + proposta V2
```

### Branches (quando o projeto é grande)
```
main                    ← plataforma interna estável
feature/[cliente]-v[N]  ← desenvolvimento do cliente

Exemplo:
  feature/drcosta-v3
  feature/artesanato-v1
```

### Arquivos de memória por versão de cliente
```
MEMORIA_V1.md   ← O que foi construído, arquivos criados, próximos passos
MEMORIA_V2.md
...
relatorio_final.md  ← Relatório de entrega ao cliente
```

---

## REGRAS DO REPOSITÓRIO

### O que vai no repositório principal (este)

```
✅ Metodologia IAH (documentos)
✅ Plataforma Vanguard (código interno)
✅ Templates e boilerplates
✅ Comandos para o Conselho IA
✅ Histórico de versões internas
✅ Estrutura de cada projeto de cliente (docs + código genérico)
```

### O que vai em repositório SEPARADO (quando aplicável)

Projetos de clientes grandes, com código sensível ou que o cliente quer ter o próprio repositório, ganham um repo separado no GitHub/GitLab. Nesse caso, a pasta `clients/[nome]/code/` contém apenas um `README.md` com o link para o repo externo.

```markdown
# Projeto Dr. Costa — Agendamento
Repositório privado: github.com/vanguardtech/drcosta-agendamento (acesso sob demanda)
```

### O que NUNCA vai no repositório

```
❌ Chaves de API, senhas, tokens (usar .env — já está no .gitignore)
❌ Dados pessoais de pacientes, clientes, usuários
❌ Arquivos de mídia grandes (> 10MB) — usar Supabase Storage
❌ Contratos com dados sensíveis (usar link DocuSign em vez do PDF)
```

---

## FLUXO COMPLETO: DO PEDIDO AO COMMIT

```
CLIENTE ENTRA EM CONTATO
         ↓
[Diretor] Preenche DISCOVERY_TEMPLATE.md durante a chamada
         ↓
[Gemini] Cria DIRETRIZ_V1 com base no Discovery
         ↓
[Diretor] Envia PROPOSTA_TEMPLATE.md (em 24h)
         ↓
[Cliente] Aceita + paga 50%
         ↓
[Claude] Clona boilerplate + adapta brand-config
         ↓
[Claude] V1 online em 48h — commit feat([nome]): V1
         ↓
[Cliente] Valida + feedback
         ↓
[Loop] V2, V3... até a camada contratada
         ↓
[Claude] Gera relatorio_final.md
         ↓
[Diretor] Entrega + treina + propõe retainer
         ↓
[Git] Todos os arquivos do projeto commitados em clients/[nome]/
```

---

## TEMPLATES NECESSÁRIOS (a criar)

Os boilerplates serão criados progressivamente. Ordem de prioridade:

```
[ ] Prioridade 1: templates/DISCOVERY_TEMPLATE.md  ← já existe parcialmente no SOP
[ ] Prioridade 2: templates/PROPOSTA_TEMPLATE.md   ← já existe em EMPRESA_VANGUARD.md
[ ] Prioridade 3: templates/CONTRATO_PROJETO.md    ← criar na próxima sessão
[ ] Prioridade 4: templates/boilerplate/landing-page/  ← clonar da landing atual
[ ] Prioridade 5: templates/boilerplate/saas-starter/  ← clonar da V6 do Vanguard
[ ] Prioridade 6: templates/boilerplate/ecommerce/     ← criar do zero na V17
```

---

## ÍNDICE DE CLIENTES (atualizar a cada novo projeto)

| Data | Cliente | Projeto | Camada | Status | MRR |
|---|---|---|---|---|---|
| — | — | (aguardando primeiro cliente) | — | — | — |

---

> **Nota:** Este arquivo é um documento vivo. Cada novo projeto de cliente deve ser adicionado ao índice. Cada nova convenção estabelecida deve ser documentada aqui.  
> O repositório é a fábrica. A fábrica só funciona quando está organizada.
