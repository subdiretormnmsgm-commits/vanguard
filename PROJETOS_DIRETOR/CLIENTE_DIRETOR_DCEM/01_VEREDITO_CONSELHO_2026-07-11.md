# Veredicto do Conselho Deliberativo — 2026-07-11 (sábado)

> Projeto: CLIENTE DIRETOR — Base de Consultas Asse Ct Orç (DCEM)
> Método: 5 conselheiros independentes → revisão anônima por pares (A–E embaralhadas) → síntese do Presidente.
> Anti-sycophancy: NÃO acionado — convergência com razão técnica; o Revisor 4 argumentou contra a resposta vencedora antes de confirmá-la.
> Parecer mais forte por unanimidade dos 5 revisores: **Primeiros Princípios** (norma viva como unidade atômica).

---

## Onde o Conselho Concorda

- **O valor está no lado da RESPOSTA, não da captura.** (Contrário + Forasteiro + Primeiros Princípios)
  Todo o rigor de design está no lado barato (QR, 60s, campos). O raciocínio a reter mora em quem RESPONDE.
  → **Decisão de design:** quem responde escreve um REGISTRO estruturado (tema + norma + porquê em 3 linhas);
  o e-mail ao demandante é GERADO a partir do registro. O registro é o produto; o e-mail é subproduto.

- **A unidade atômica é a NORMA VIVA, não a consulta.** (Primeiros Princípios; eleita por 5/5 revisores)
  Base = índice de normas com jurisprudência interna acumulada. Norma = chave primária; cada resposta = append datado.
  Resolve de uma vez: acoplamento consulta↔norma (nativo), obsolescência (estado mora na norma),
  descoberta (navega por norma/tema, não por lembrar a query) e KPI (reúso).

- **Semente 1 ("consulta evitada") é métrica de vaidade — infalsificável.** (unânime, 5 conselheiros)
  Substituir por REÚSO: "esta norma já foi consultada N×". É o KPI real e unifica com a Semente 3.

- **Vocabulário controlado é 80% do risco.** (Executor + Contrário)
  Sem lista fechada de `tema` e índice de `norma`, a base nasce SUJA — pior que vazia, porque parece cheia.

## Onde o Conselho Diverge

- **Semente 5 — "mapa de quem sabe":**
  - Posição A (Expansionista, Forasteiro): é a joia — ativo estratégico, a intenção literal; mostra o buraco antes da movimentação.
  - Posição B (Primeiros Princípios; Revisor 4): contradiz a intenção — recria a dependência do indivíduo; é conhecimento tácito que a base não captura.
  - Resolução do Presidente: manter como LEITURA EMERGENTE (derivada, custo zero), sob sigilo — alarme ao Comando, nunca a memória em si.

- **Ferramenta / altitude:** Executor = "esqueça n8n no início, Apps Script onFormSubmit basta"; Expansionista = grafo replicável ao Exército + corpus de treino futuro. Presidente fica com fundação-primeiro; n8n entra só quando o roteamento exigir.

## Pontos Cegos Identificados (só emergiram na revisão por pares)

- **OPSEC / sigilo é um 5º trilho não escrito** (4 de 5 revisores). Precede qualquer schema.
- **Governança de sucessão do próprio zelador** (Revisor 2): quem cura a base depois que o curador for movimentado? Função herdada, não pessoa — senão a base morre no 1º ciclo.
- **Confiança no read-time** (Revisores 4, 5): como o consultante sabe que a resposta ainda vale hoje? Exige dono de norma + gatilho de obsolescência.
- **Soberania da conta Google** (Revisor 3): a conta tem de ser da função/seção, com titularidade transferível.

## A Recomendação

Arquitetar a base como **ÍNDICE DE NORMAS VIVAS (norma = chave primária)**, não como arquivo de consultas —
única decisão que resolve base suja + obsolescência + descoberta + KPI de vaidade sem violar trilho, e faz as sementes boas caírem de graça:

- **Fundir 1 + 3** → KPI = reúso ("norma consultada N×") que dispara "promova a doutrina".
- **2 (dossiê de sucessão)** = derivada gratuita (filtro por militar). Se precisar ser "gerada", a base está errada.
- **5 (mapa de quem sabe)** = leitura emergente para o Comando, com sigilo — não produto.
- **4 (prioridade por evidência)** = V2; "precisa até quando" só vale cruzado com a função.
- Respondente preenche registro (tema lista fechada + norma + porquê 3 linhas); e-mail gerado dele.
- Adotar o 5º trilho (OPSEC/acesso) + nomear dono de norma e curador por função já no desenho.

## A Primeira Ação

**Montar o vocabulário controlado antes de qualquer Form ou Sheet:** lista fechada de `temas` +
índice de `normas` da seção (código · ementa curta · status vigente/revogada · dono), fechado nesta semana.
É a chave primária da base e 80% do risco.

---

### Anexo — Pareceres originais (resumo de 1 linha)
- **Contrário:** a base nasce SUJA (classificação sem dono); norma revogada vira resposta errada pesquisável; resolvem recuperação, não descoberta.
- **Primeiros Princípios:** unidade atômica = norma viva; consulta é evidência; reúso é a prova de memória; fundir 1+3; dossiê é derivado.
- **Expansionista:** o produto é o método, replicável ao Exército; 5 e 3 amplificam; corpus de treino é oportunidade futura (exportar, não embutir).
- **Forasteiro:** valor está em quem responde; registro > e-mail; quem tem tempo de pesquisar a base?
- **Executor:** Google Form → Sheet + 2 colunas (tema lista fechada + norma); Apps Script; n8n só p/ roteamento; (3) e (5) fáceis já, (1) fantasia, (2)(4) V2.
