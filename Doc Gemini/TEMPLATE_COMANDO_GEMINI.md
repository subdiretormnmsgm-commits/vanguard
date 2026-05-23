# TEMPLATE — Comando Gemini (Reutilizável para Qualquer Versão)
> Use este template para criar o COMANDO_GEMINI_VXX.md de cada nova versão.  
> Substitua os marcadores `[VXX]`, `[NUMERO]`, `[NOME]` pelos valores corretos.

---

════════════════════════════════════════════════════════════
INÍCIO DO COMANDO — COPIAR A PARTIR DAQUI
════════════════════════════════════════════════════════════

Gemini, a Missão **[VXX] — [NOME DA VERSÃO]** foi concluída com sucesso. Abaixo está o conteúdo completo da MEMORIA_[VXX] e do relatorio_evolutivo_[vxx], incluindo a **Visão LMM do Claude** com as **[N] Ideias Disruptivas** que ele propôs.

Analise o que foi construído e as ideias que o Claude sugeriu. Com base neste relatório e nas nossas metas de construir o nosso modelo único de negócio, crie a **DIRETRIZ ESTRATÉGICA — VERSÃO [NUMERO + 1]** para eu alimentar o NotebookLM.

---

## CONTEXTO DO PROJETO — QUEM SOMOS

Somos uma **IAH — Inteligência Artificial Humana**: uma fábrica de produtos digitais proprietários. O Diretor orquestra três IAs como conselho:

- **Diretor (Eduardo):** O veredito.
- **Gemini (você):** O Estrategista — cria a DIRETRIZ.
- **NotebookLM:** O Auditor — guarda o histórico, gera a Skill.
- **Claude Code:** O Músculo — escreve o código, entrega o software.

**Modelo de negócio:** Fabricamos qualquer produto digital (e-commerce, app, SaaS, site) para qualquer cliente, usando o ecossistema que construímos como motor. Não somos uma SaaS — somos uma metodologia de fábrica digital, como uma McKinsey com IA.

**Estado actual ([DATA]):** [X] versões construídas. [N] clientes pagantes. MRR actual: R$[VALOR].

---

## MEMORIA_[VXX] — O QUE FOI CONSTRUÍDO

[COLAR AQUI O CONTEÚDO COMPLETO DE MEMORIA_VXX.md]

---

## RELATORIO_EVOLUTIVO_[VXX] — VISÃO LMM DO CLAUDE

[COLAR AQUI O CONTEÚDO COMPLETO DE relatorio_evolutivo_vxx.md]

---

## DOCUMENTOS DISPONÍVEIS (que o NotebookLM tem indexados)

| Documento | Conteúdo |
|---|---|
| `SOP_VANGUARD_MASTER.md` | Processo completo da venture builder |
| `INTELIGENCIA_ARTIFICIAL_HUMANA.md` | Manifesto IAH + pricing |
| `MASTER_PLAN.md` | Roadmap V1-V18 + gestão de riscos |
| `VANGUARD_BUSINESS_RULES.md` | Constituição — regras imutáveis |
| `VANGUARD_INNOVATION_AUDIT.md` | Ledger de inovações |
| `TODO_FUTURE.md` | Backlog de versões futuras |
| `MEMORIA_[VXX].md` | Registo técnico completo desta versão |
| `relatorio_evolutivo_[vxx].md` | Relatório com ideias disruptivas |

---

## O QUE PRECISO DE TI, GEMINI

Assuma o seu papel de **Arquitecto de IA e Estrategista do Conselho Pentalateral**. Responde com exactamente esta estrutura em **4 blocos**:

---

**BLOCO 1 — ANÁLISE ESTRATÉGICA**
A tua leitura sobre o que foi construído na [VXX]. O que foi mais disruptivo? O que falta? Contra-ataque às ideias do Claude: qual priorizar para gerar receita em 30 dias?

---

**BLOCO 2 — DIRETRIZ GEMINI [VXX+1]** *(vira o arquivo `DIRETRIZ GEMINI V[NUMERO+1].txt`)*
Fala directamente com o Claude. Não é competição — é um brainstorm entre sócios. Inclui:
- As 2 ideias prioritárias a implementar
- O foco comercial (nicho, 1º R$ rápido)
- Decisões de design se houver visão nova
- O que proteger (regras imutáveis)

---

**BLOCO 3 — COMANDO NOTEBOOKLM** *(texto pronto para colar no NotebookLM)*
Instrução completa para o NotebookLM gerar a Skill da [VXX+1]. Inclui:
- Papel de Sócio-Consultor
- ANÁLISE DE SÓCIO antes da Skill
- Geração de `vanguard-v[NUMERO+1]-[nome].md`
- Criação do `## [AUTO-LOG] — REGISTRO DE AUDITORIA`

---

**BLOCO 4 — COMANDO CLAUDE CODE** *(texto pronto para colar no terminal)*
Instrução exacta para o terminal. Inclui:
- Referência à Skill (`.claude/skills/vanguard-v[NUMERO+1]-[nome].md`)
- Ordem de processar AUTO-LOG primeiro
- Construir a infraestrutura exigida
- Mensagem do Visionário para o Sócio-Arquitecto
- Pedido das ideias para a versão seguinte

---

Mantem **todas as ideias do Claude** na tua análise. Critíca, prioriza, propõe ordem. Somos quatro sócios.

════════════════════════════════════════════════════════════
FIM DO COMANDO
════════════════════════════════════════════════════════════

---

## GUIA DE USO RÁPIDO

Ao final de cada versão, o Claude cria automaticamente:
1. `MEMORIA_VXX.md` — registo técnico
2. `relatorio_evolutivo_vxx.md` — relatório com ideias disruptivas
3. `COMANDO_GEMINI_VXX.md` — este template preenchido, pronto para copiar

O Diretor só precisa de:
1. Abrir `COMANDO_GEMINI_VXX.md`
2. Copiar tudo
3. Colar no Gemini
4. Receber os 4 blocos
5. Salvar BLOCO 2 como `DIRETRIZ GEMINI VXX.txt`
6. Colar BLOCO 3 no NotebookLM
7. Salvar a Skill gerada em `.claude/skills/`
8. Colar BLOCO 4 no terminal Claude Code
