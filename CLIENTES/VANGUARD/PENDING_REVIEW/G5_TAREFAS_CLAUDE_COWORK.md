# Matriz de Tarefas Automáticas: Claude Cowork ↔ Projetista

De acordo com o volume de materiais no `INTELLIGENCE_HUB` (incluindo `NICHE_MODELS`, `COMPETITORS`, `TRENDS` e o `CALENDARIO_NICHE_INTELLIGENCE.md`), o **Claude Cowork (Embaixador)** não deve apenas ler dados passivamente, mas atuar como o elo de tradução entre a regulação (mercado) e a engenharia (Vanguard). 

Abaixo, sugiro **5 Tarefas Estratégicas (Workflows)** que o Claude Cowork deve executar rotineiramente para se retroalimentar e direcionar o Projetista (Músculo).

---

## TAREFA 1: A "Tradução de Gatilho Regulatório" (Semanal - Quarta-feira)
**Onde o Cowork se alimenta:** Pasta `INTELLIGENCE_HUB/NICHE_MODELS/` (lê os arquivos `.json` focando no nó `gatilho_regulatorio`).
**O que ele faz:** Escaneia todos os modelos cujo `status` seja `MOVER_AGORA` e que possuam um deadline regulatório próximo (ex: *02/08/2026 para o AI Act* ou *30/06/2026 para ECD*).
**O output para o Projetista (Retroalimentação):** 
Gera um documento de requisito rápido:
> *"[DIRETRIZ DE PRODUTO - URGÊNCIA]: Projetista, o nicho `eventos-fiscais-contadores` tem um deadline em 30/06. Precisamos de um MVP (Camada 1) de um painel de validação do SPED. A dor é: 'Autuação automática por erro'. Foque a arquitetura em upload de XML e validação de regras."*

## TAREFA 2: O "Scanner de Objeções" (Mensal - Dia 1)
**Onde o Cowork se alimenta:** Relatórios da pasta `COMPETITORS/` e as `objecoes[]` atualizadas pelos BDRs e pelo Diretor no Hub.
**O que ele faz:** O Cowork analisa por que os prospects estão recusando os serviços ou onde a concorrência está ganhando. Ele consolida os "buracos" no discurso comercial ou no produto atual.
**O output para o Projetista:**
> *"[ENHANCEMENT DE PRODUTO]: Projetista, 40% das objeções no nicho `rastreabilidade-sanitaria-premium` citam que o sistema XYZ do concorrente tem API nativa com o ERP SAP. Você deve priorizar a documentação e criação de uma ponte (webhook/API) simulando integração SAP na Camada 2."*

## TAREFA 3: O "Destilador de Tendências" (Semanal - Segunda-feira)
**Onde o Cowork se alimenta:** Pasta `TRENDS/` (relatórios semanais de YouTube e LinkedIn).
**O que ele faz:** Ele cruza os tópicos que estão gerando mais visualizações no mercado B2B tech com o nosso `NICHE_INDEX.json`.
**O output para o Projetista:**
> *"[ALERTA DE FEATURE]: Projetista, o relatório de tendências aponta um aumento de 300% em buscas sobre 'Agentic AI para Compliance'. Verifique se podemos conectar a arquitetura atual do n8n a um agente autônomo (Camada 3) para demonstrarmos essa capacidade nas próximas reuniões de Discovery."*

## TAREFA 4: O "Construtor do Business Case" (Pós-lançamento)
**Onde o Cowork se alimenta:** Documentos e logs de clientes atuais (via `WIP_BOARD` ou Relatórios do Sentinel).
**O que ele faz:** Quando o Projetista termina um MVP que reduz uma dor mapeada (ex: reduziu o tempo de auditoria do cliente X em 40%), o Cowork ingere esse número.
**O output para o Projetista e o Diretor:**
> *"[RETROSPECTIVA DE PRODUTO]: O módulo de auditoria construído pelo Projetista economizou 40h mensais do cliente. Projetista, o fluxo funcionou perfeitamente, mas o cliente reclamou da UI do formulário. Sugestão: adicione uma interface mais fluida usando o padrão X. Diretor: use o número de 40h de economia no LinkedIn hoje."*

## TAREFA 5: A "Vigilância de Escalabilidade" (Quinzenal)
**Onde o Cowork se alimenta:** `INTELLIGENCE_HUB/NICHE_INDEX.json` (foco em `fit_score` e `cross-sell clusters`).
**O que ele faz:** Analisa se um produto que o Projetista construiu para um cliente específico (ex: portal para clínicas de saúde digital) serve para os outros modelos `MOVER_AGORA` (ex: peritos médicos).
**O output para o Projetista:**
> *"[OPORTUNIDADE DE ECOSSISTEMA - Camada 4]: Projetista, a arquitetura de 'agendamento + consentimento LGPD' que você fez no projeto da Clínica é 90% reutilizável para o nicho `medicos-peritos-laudos`. Empacote esse código como um módulo separável (Boilerplate) para o Diretor poder vender amanhã."*

---

> [!TIP]
> **Como operacionalizar:** O Diretor pode copiar o texto da "TAREFA 1", por exemplo, e enviar como *Prompt* no Claude Project do Cowork a cada semana, mandando ele varrer a pasta `NICHE_MODELS` no seu *Knowledge Base*. Ele retornará a resposta mastigada para ser colada no Claude Code (Músculo).

> [!IMPORTANT]
> **Aprovação:** Se esta matriz de tarefas faz sentido, eu formalizarei estas sugestões. Se quiser focar em alguma delas (como começar apenas com a Tarefa 1 de Gatilhos Regulatórios), me avise!
