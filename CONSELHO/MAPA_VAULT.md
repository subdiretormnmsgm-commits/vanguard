# MAPA DO VAULT — VANGUARD TECH
> Documento de navegação. Todo agente lê este arquivo antes de atuar no vault.
> Mantido pelo Músculo. Atualizado no início de cada Loop via /update-map.
> Versão: 1.0 · Loop 34 · 2026-06-15
> Caminho canônico: vanguard/PENTALATERAL_UNIVERSAL/MAPA_VAULT.md

---

## RAIZ DO VAULT

```
OneDrive:  C:\Users\Eduardo DELL\OneDrive\Área de Trabalho\vanguard\
Drive:     vanguard/   (clonado por rclone — estrutura idêntica)
```

---

## ÁRVORE DE PASTAS

```
vanguard/
└── PENTALATERAL_UNIVERSAL/
    │
    ├── MAPA_VAULT.md                    ← este arquivo
    ├── WIP_BOARD.json                   ← estado do Loop atual
    ├── INTELLIGENCE_LEDGER.md           ← 78 princípios P-XXX (régua do sistema)
    │
    ├── INTELLIGENCE_HUB/                ← inteligência de mercado
    │   ├── NICHE_INDEX.json             ← 15 nichos, status DELTA, fit_score
    │   ├── NICHE_MODELER_SESSIONS.json  ← histórico de sessões do NICHE_MODELER
    │   ├── PENDING_REVIEW.md            ← alertas, mapa de prioridade comercial
    │   ├── CALENDARIO_NICHE_INTELLIGENCE.md
    │   │
    │   ├── NICHE_MODELS/                ← [id]_MODEL.json + SCHEMA.md por nicho
    │   ├── BIBLIOTECA_NICHOS/           ← cartões de nicho versionados
    │   ├── PIPELINE/                    ← contatos de prospecção
    │   │   └── [data]_[nicho]_contato.txt
    │   ├── CONTEUDO/                    ← posts prontos por canal
    │   │   └── linkedin_/instagram_[data]_[nicho].txt
    │   ├── COMPETITORS/                 ← análise de concorrentes
    │   ├── TRENDS/                      ← relatórios de tendências + transcrições
    │   │   └── [data]_[nicho]_clip_[fonte].md   (Web Clipper)
    │   │   └── [data]_[nicho]_transcript_[título].md  (TranscriptAPI MCP)
    │   └── SOCIAL_MEDIA/               ← estratégia de presença social
    │
    ├── INTELLIGENCE_HUB/PROJETISTA/     ← ⚠️ A CRIAR NO LOOP 34
    │   ├── INBOX/                       ← tasks do Cowork depositam preparação
    │   ├── PLANOS/                      ← planos de execução
    │   │   └── [data]_PLANO_[nicho]_v[N].md
    │   └── CAMPANHA/                    ← material para o Embaixador Digital
    │       └── [data]_CAMPANHA_[nicho].md
    │
    ├── INTELLIGENCE_HUB/DIGITAL/        ← ⚠️ A CRIAR NO LOOP 34
    │   └── INBOX/                       ← tasks do Cowork depositam preparação
    │
    ├── CLAUDE_PROJECTS/                 ← memórias e templates dos agentes
    │   ├── MEMORIA_PROJETISTA.md        ← memória persistente do Projetista
    │   ├── TEMPLATE_INSTRUCAO_PROJETISTA.md
    │   └── TEMPLATE_INSTRUCAO_EMBAIXADOR_DIGITAL.md
    │
    ├── NOTEBOOKLM_BASE/                 ← 11 arquivos espelho para o Auditor
    │   ├── 00_INSTRUCAO_AUDITORIA.md
    │   ├── 01_SKILL_PROTOCOLO_VANGUARD.md
    │   ├── 02_MEMORANDO_PENTALATERAL_UNIVERSAL.md
    │   ├── 03_MANUAL_DIRETOR.md
    │   ├── 04_INTELLIGENCE_LEDGER.md
    │   ├── 05_PROCESSO_EVOLUTIVO.md
    │   ├── 06_TEMPLATES_COMUNICACAO.md
    │   ├── 07_WIP_BOARD.txt
    │   ├── 08_ANALISE_SOCIOECONOMICA.md
    │   ├── 20_LOOP_STATE_SCHEMA.md
    │   └── LEDGER_INDEX.md
    │
    ├── VANGUARD_HISTORICO/              ← acervo histórico completo (rclone)
    │   ├── MEMORIA_V[N].md (V16...V33+) ← memória de cada loop
    │   ├── DELIBERACAO_LOOP_*.md        ← decisões formais
    │   ├── skills de cada versão        ← o que a Vanguard sabe fazer
    │   └── processos evolutivos         ← como o sistema evoluiu
    │
    ├── CONSELHO/                        ← ⚠️ A CRIAR NO LOOP 34
    │   ├── SYSTEM_PROMPT_PROJETISTA.md (v5.0)
    │   ├── SYSTEM_PROMPT_EMBAIXADOR_DIGITAL.md (v2.0)
    │   └── SYSTEM_PROMPT_DETECTOR_DERIVA.md (v1.1)
    │
    ├── _pending/                        ← notas de deriva (Detector → Músculo)
    │   └── DERIVA_[data]_[id].md
    │
    └── CLIENTES/                        ← ⚠️ ISOLAMENTO ABSOLUTO (P-059)
        ├── VALDECE/                     ← isolamento total
        ├── INGRID/                      ← isolamento total
        └── MUMUZINHO/                   ← isolamento total
```

---

## PERMISSÕES POR AGENTE

| Agente | LÊ | ESCREVE | NUNCA TOCA |
|--------|-----|---------|------------|
| **Músculo** | tudo | _pending/, MEMORIAS, LEDGER, CLAUDE_PROJECTS/, MAPA_VAULT.md | CLIENTES/* sem autorização explícita |
| **Projetista** | INTELLIGENCE_HUB/* (temáticas), VANGUARD_HISTORICO/, CLAUDE_PROJECTS/MEMORIA_PROJETISTA.md, PROJETISTA/INBOX/ | nada — P-124 | CLIENTES/*, CONSELHO/*, LEDGER |
| **Embaixador Digital** | INTELLIGENCE_HUB/PROJETISTA/PLANOS/, PROJETISTA/CAMPANHA/, DIGITAL/INBOX/, NICHE_INDEX.json, PENDING_REVIEW.md | nada — P-124 | CLIENTES/*, tudo mais |
| **Detector de Deriva** | tudo (vault + infraestrutura Claude Code) | _pending/ apenas | todos os docs canônicos |
| **Embaixador Cowork** | pastas temáticas (PIPELINE, CONTEUDO, COMPETITORS, TRENDS, NICHE_MODELS) | PIPELINE/, CONTEUDO/, COMPETITORS/, TRENDS/, PROJETISTA/INBOX/, DIGITAL/INBOX/ | CLIENTES/*, CONSELHO/*, LEDGER |
| **Auditor** | caderno próprio V16 ARQUIVO (NotebookLM) | caderno próprio | vault OneDrive — P-123 |

---

## CADERNOS NOTEBOOKLM

| Caderno | Namespace | Quem usa | Fontes |
|---------|-----------|---------|--------|
| Vanguard Tech — Conselho V16 (ARQUIVO) | `c0cfb852-...` | Auditor | 128 fontes |
| PROJETISTA-ACERVO | `f7d72bc0-...` | Projetista | NOTEBOOKLM_BASE/ (11 arquivos) |

> Regra P-123: os dois cadernos NUNCA se misturam. O Projetista opera APENAS o PROJETISTA-ACERVO.

---

## REGRAS DE ACESSO INVIOLÁVEIS

**P-059 — Isolamento de Cliente é Lei:**
- `CLIENTES/VALDECE/`, `CLIENTES/INGRID/`, `CLIENTES/MUMUZINHO/` são zonas de acesso restrito
- Nenhum agente cruza dados entre clientes
- Nenhum dado de cliente entra em documento do sistema (INTELLIGENCE_HUB, CONSELHO, etc.)

**P-124 — Só o Músculo escreve no acervo canônico:**
- Projetista, Embaixador Digital e Auditor são read-only no vault
- Toda escrita em documento canônico passa pelo Músculo após aprovação do Diretor

**P-075 — Roteamento é do Diretor:**
- Nenhum agente despacha diretamente para outro
- Todo fluxo de informação passa pelo Diretor

**R-3 — Linguagem externa blindada:**
- Arquivos em PIPELINE/, CONTEUDO/, PROJETISTA/CAMPANHA/ NUNCA mencionam IA, automação, Claude, Cowork, Gemini, NotebookLM, modelos ou ferramentas
- Sempre "especialistas da Vanguard", "nossa equipe", "nosso método"

---

## PROTOCOLO DE ATUALIZAÇÃO

**Responsável:** Músculo  
**Frequência:** início de cada Loop, via slash command `/update-map`  
**Gatilhos adicionais:** sempre que o Músculo criar ou remover uma pasta

**O que o /update-map faz:**
1. Executa `find PENTALATERAL_UNIVERSAL -type d | sort` para listar a estrutura real
2. Compara com este arquivo
3. Atualiza a árvore, mantendo as permissões e regras intactas
4. Incrementa a versão e atualiza a data no cabeçalho
5. Salva e roda o rclone sync

**O que o Detector de Deriva verifica neste arquivo:**
- Pasta referenciada aqui que não existe no vault → erro de referência
- Pasta que existe no vault mas não está aqui → omissão de mapeamento
- Agente com permissão de escrita que não deveria ter → deriva de governança

---

## HISTÓRICO DE VERSÕES

| Versão | Data | O que mudou |
|--------|------|-------------|
| 1.0 | 2026-06-15 | Criação. Estrutura real do Drive + pastas a criar no Loop 34. |
