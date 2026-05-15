# PASSO 5 — TEMPLATE UNIVERSAL: PARA O NOTEBOOKLM (AUDITOR)
# Versão: Universal · QUADRILATERAL_UNIVERSAL/OPERACAO/
# Uso: O Músculo preenche os [PLACEHOLDERS] com dados reais antes de enviar.

---

## 📌 INSTRUÇÕES PARA O DIRETOR — ANTES DE IR AO NOTEBOOKLM

**O que fazer (em 3 passos simples):**

```
1. RODAR no terminal:
   .\scripts\preparar_notebooklm_projeto.ps1 -cliente [NOME]
   → O Explorer abre com todos os documentos numerados (01 a 15) na pasta
     CLIENTES\[NOME]\NOTEBOOKLM_FONTES\
   → Importante: o arquivo 12_DIRETRIZ_GEMINI já estará lá se você salvou
     a DIRETRIZ do Gemini como DIRETRIZ_GEMINI_V[N].txt na pasta do cliente.

2. NO NOTEBOOKLM:
   Selecionar todos os arquivos da pasta (Ctrl+A) → arrastar como fontes.

3. NO CHAT DO NOTEBOOKLM:
   Colar o conteúdo completo deste arquivo (PASSO5_NOTEBOOKLM.md),
   com a DIRETRIZ do Gemini já inserida no campo indicado abaixo.
```

> Por que usar o script: ele monta a pasta certa com os 15 documentos na ordem
> correta. Fatos do passado (01-11) antes das novas ideias (12-15). Nunca inverter.

---

## 🛡️ PROTOCOLO ANTI-ALUCINAÇÃO — ATIVE ANTES DE GERAR A SKILL
> Este bloco é permanente. Nunca remover. Aplica-se a todo projeto do Quadrilateral.

Auditor, o Conselho mapeou 4 deficiências nativas do seu modelo. Auto-aplique os contra-ataques abaixo ANTES de escrever qualquer bloco da Skill:

**Contra-ataque 1 — Regra do Nutricionista (vs. Amnésia de Contexto)**
Você não tem memória entre sessões. Tudo que você sabe vem dos documentos carregados agora. Dê peso máximo à MEMORIA_V[X] e ao relatorio_evolutivo — eles representam o estado REAL do projeto. Se qualquer sugestão que for fazer contradiz decisão documentada nesses arquivos, a decisão documentada prevalece. Declare quando isso acontecer.

**Contra-ataque 2 — Proibição de Análise Genérica (vs. Alucinação Estrutural P-007)**
Você está proibido de preencher os blocos obrigatórios da Skill com afirmações genéricas. Cada bloco deve citar dados reais: nome do projeto, versão, decisão específica, princípio ativo do Ledger, ou padrão observado neste corpus. Se não tiver dado real para um bloco → escreva "dados insuficientes para este bloco" em vez de inventar. Skill genérica é pior que Skill incompleta.

**Contra-ataque 3 — Tensão Ativa (vs. Síndrome do Yes-Man)**
Sua função não é validar a DIRETRIZ do Gemini — é auditá-la. Para cada sugestão da DIRETRIZ, pergunte: "Isso realmente resolve a dor real do cliente ou é perfumaria tecnológica?" Se o Gemini propõe algo que viola o prazo, o orçamento ou qualquer princípio do Ledger — diga, com evidência. Seja o "chato" da sala.

**Contra-ataque 4 — Filtro de Recência (vs. Efeito Lost-in-the-Middle)**
Ao cruzar os documentos, docuemtno mais recente tem peso maior. DIRETRIZ V3 prevalece sobre V1. Princípio P-013 prevalece sobre padrão anterior que ele contradiga. Quando houver conflito entre documentos, sinalize qual prevalece e por quê.

---

## ⚠️ COMPENSAR DEFICIÊNCIAS DO MÚSCULO AO ESCREVER A SKILL
> Este bloco é permanente. Estruture a Skill para que o Músculo não falhe ao lê-la.

**Deficiência 1 — Amnésia de Sessão:** No bloco de Contexto, liste os princípios ativos do LEDGER que são obrigatórios nesta sessão. O Músculo deve encontrá-los na Skill — não precisa lembrar de buscá-los.

**Deficiência 2 — Momentum de Execução:** No bloco de Sequência de Build, inclua os gates de verificação obrigatórios entre cada dia. Defina o output real que deve existir antes de avançar. "Parece que funcionou" não é gate válido.

**Deficiência 3 — Otimismo de Estimativa:** No bloco de Alertas Críticos, inclua estimativas realistas de tempo para os módulos mais complexos desta entrega, baseadas no histórico de builds similares que você conhece. Se o histórico mostra que módulo similar levou 6h, diga isso.

**Deficiência 4 — Escopo Silencioso:** No bloco "O que NÃO construir nesta entrega", seja tão específico quanto no bloco de prioridades. Liste por nome as features que o Músculo pode ser tentado a adicionar e que estão fora do escopo aprovado.

**Deficiência 5 — Drift de Formato:** Na seção de Perspectiva do Sócio, inclua instrução explícita: "Ao deliberar sobre cada prioridade, use os 7 pontos: Certo → Diverge → Decisão → Enhancement → Custo → Impacto → Ação. Não resumir."

---

## 📋 CONTEXTO DO PROJETO
> O Músculo preenche esta seção antes de enviar ao NotebookLM.

[NOME_DO_CLIENTE] — [NOME_DO_PROJETO]

**Stack técnica:** [LISTAR]
**Dias entregues:** [LISTAR]
**Dias restantes e o que falta:** [DESCREVER]
**Maior risco identificado:** [DESCREVER]
**Decisões tomadas neste loop:** [LISTAR AS PRINCIPAIS]

---

## 📐 FORMATO OBRIGATÓRIO DA SKILL
> Gere a Skill exatamente nesta estrutura. Blocos genéricos = Skill inválida.

**PARTE 1 — AUDITORIA DE COERÊNCIA**
A DIRETRIZ do Gemini contradiz algo construído antes neste projeto ou em projetos anteriores? Há módulos que o Gemini propõe mas que já existem? Há riscos que a DIRETRIZ ignora e que o histórico mostra como recorrentes? Cite projeto e versão específicos ao identificar contradições.

**PARTE 2 — CONEXÃO HISTÓRICA**
Com base no histórico completo de projetos da Vanguard: o que sistematicamente funciona em projetos similares (nicho, stack, tipo de cliente)? O que sistematicamente falha? O que este projeto tem de diferente que pode mudar o padrão? Cite de qual projeto cada padrão vem.

**PARTE 3 — A SKILL PROPRIAMENTE DITA**
Escreva em formato copiável direto para `.claude/skills/[projeto]-v[X].md` com os seguintes blocos obrigatórios — todos preenchidos com dados reais:
- Contexto do projeto (stack, cliente, dor real, prazo)
- Conexão histórica (o que reutilizar e onde encontrar no repositório)
- Padrão de sucesso (confirmado com evidência deste projeto ou de projetos anteriores)
- Padrão de falha (com a falha específica e qual projeto a originou)
- Perspectiva do Sócio Consultor (o que Gemini e Músculo não estão vendo)
- Sequência de build recomendada (dia a dia, com gates obrigatórios)
- Alertas críticos com severidade (P0 / P1 / P2)
- O que NÃO construir nesta entrega (listado por nome)
- O que deve ser promovido ao SKILL_PROTOCOLO_VANGUARD como padrão universal

**PARTE 4 — SUAS 5 IDEIAS DISRUPTIVAS COMO AUDITOR**
Não as ideias do Gemini nem as do Músculo — as suas, fundamentadas no histórico completo. O que nenhum dos outros membros está vendo. Para cada ideia: o que é, qual o impacto estimado, e uma pergunta direta para o Diretor validar.

---
*Template Universal · Quadrilateral IAH · OPERACAO/ · Atualizar ao descobrir novo padrão*
