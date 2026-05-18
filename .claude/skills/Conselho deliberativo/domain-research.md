# Pesquisa de Domínio — Conselho Deliberativo (LLM Council)

## Domínio

**Domínio:** Deliberação multi-agente para suporte a decisões de alta consequência.

**Definição operacional:** Submeter uma decisão a múltiplos "conselheiros" com perspectivas
radicalmente distintas, que analisam de forma independente, revisam anonimamente o trabalho
uns dos outros, e sintetizam um veredicto estruturado via síntese presidencial.

---

## Fontes Autoritativas

- Karpathy, A. (2025). *LLM Council* — projeto open-source original. GitHub.
- Wynn, A. et al. (2025). *Talk Isn't Always Cheap: Understanding Failure Modes in Multi-Agent Debate*. PMLR 267.
- Arxiv 2510.07517 (2025–2026). *When Identity Skews Debate: Anonymization for Bias-Reduced Multi-Agent Reasoning*.
- Arxiv 2509.23055 (2025). *Peacemaker or Troublemaker: How Sycophancy Shapes Multi-Agent Debate*.
- Arxiv 2511.07784 (2025). *Can LLM Agents Really Debate? A Controlled Study of Multi-Agent Debate in Logical Reasoning*.

---

## Fluxo de Trabalho Canônico (Karpathy Original)

1. **Formulação** — pergunta vai para todos os modelos simultaneamente
2. **Respostas independentes** — cada modelo responde sem ver os outros
3. **Revisão anônima** — modelos avaliam respostas sem saber quem produziu cada uma
4. **Síntese do chairman** — um modelo sintetiza o veredicto final

**Adaptação desta skill:** substitui modelos diferentes por conselheiros com lentes cognitivas
distintas, executados dentro do mesmo modelo (Claude), replicando a diversidade de perspectivas.

---

## Gatilhos Linguísticos Identificados

**Explícitos (alta confiança):**
- "consultar isso", "executar o conselho", "sala de guerra isso"
- "testar isso sob pressão", "testar isso sob estresse", "debater isso"

**Fortes (quando combinados com decisão real):**
- "devo X ou Y", "qual opção", "o que você faria"
- "esta é a decisão certa?", "validar isso", "múltiplas perspectivas"
- "não consigo decidir", "estou indeciso"

**Contextuais (sem gatilho explícito mas decisão com consequências):**
- Usuário apresenta opções com trade-offs reais
- Usuário menciona custo, risco, prazo ou impacto de uma decisão

**Falsos positivos (NÃO acionar):**
- Perguntas factuais com resposta única ("qual é a capital?")
- Tarefas de criação pura ("escreva um tweet")
- Tarefas de processamento ("resuma este artigo")
- "Devo" casual sem consequência real ("devo usar markdown?")

---

## Modos de Falha Críticos (Pesquisa MAD)

| Falha | Frequência | Impacto | Mitigação |
|-------|-----------|---------|-----------|
| Sycophancy coletiva | Alta | Degrada qualidade do veredicto | Anonimização + protocolo anti-sycophancy |
| Viés posicional | Média | Distorce revisão por pares | Randomização das letras A–E |
| Colapso prematuro de consenso | Média | Elimina valor da deliberação | Reforço das personas, reformulação neutra |
| Presidente indeciso | Alta | Veredicto inútil para o usuário | Instrução explícita de posicionamento obrigatório |
| Respostas genéricas | Alta | Conselho sem valor específico | Formulação rica em contexto na Etapa 1 |

**Achado crítico da pesquisa:** modelos frequentemente mudam de resposta correta para incorreta
ao receberem pressão de pares — mesmo com incentivos explícitos de correção. A anonimização
é a mitigação mais eficaz documentada.

---

## Boas Perguntas para o Conselho

- "Devo lançar X agora ou esperar mais 6 meses?"
- "Qual destes 3 ângulos de posicionamento é mais forte?"
- "Estou pensando em mudar de X para Y. Estou errado?"
- "Devo contratar um assistente ou automatizar primeiro?"
- "Aqui está minha proposta. O que está fraco?"

## Perguntas Ruins para o Conselho

- "Qual é a capital da França?" → resposta única, sem deliberação necessária
- "Escreva um tweet para mim" → tarefa criativa, não de julgamento
- "Resuma este artigo" → processamento, não decisão
- "Devo usar vírgula aqui?" → trivial, sem consequência
