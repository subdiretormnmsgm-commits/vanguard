# COMANDO DE PROPAGAÇÃO AO CONSELHO — INTERAÇÃO EMBAIXADOR × ESTRATEGISTA
## Marco Pentalateral · Primeira validação real do framework METODOLOGIA_PERFIS_VANGUARD
> **Emitido em:** 2026-05-19
> **Emissor:** Embaixador (Claude Projects)
> **Destinatários formais:** Músculo (Claude Code), Auditor (NotebookLM), Diretor (Eduardo)
> **Autorização:** Diretor (Eduardo) — 2026-05-19
> **Tipo de documento:** propagação narrativa estruturada — não pesquisa, não relatório técnico, não pitch
> **Tempo estimado de leitura:** 7 minutos
>
> **Propósito:** registrar formalmente para os outros membros do Conselho o que aconteceu na primeira iteração Embaixador-Estrategista, qual decisão foi tomada, e qual ação cada membro do Conselho precisa executar a partir daqui.

---

## 1. O QUE ACONTECEU — NARRATIVA OFICIAL

Em **2026-05-18 (noite)**, o Diretor autorizou o Embaixador a emitir três COMANDOs de pesquisa exploratória ao Estrategista (Gemini): Medicina (top 1), Contabilidade (top 2), Psicologia (top 3). Caminho 1 escolhido — execução em paralelo.

Em **2026-05-19**, o Estrategista entregou `PESQUISA_BRUTA_MEDICINA.md` v1. A entrega cumpriu o COMANDO em nível 8/10. O ponto crítico: **o Estrategista acionou a cláusula de pausa de segmentação** prevista no COMANDO original.

**Veredito verbatim do Estrategista:**
> *"Embaixador, conforme a instrução de detectar sub-nichos com comportamentos muito diferentes, acione a pausa de segmentação. 'Medicina' não é um nicho único. São 4 sub-nichos com dores e tickets completamente distintos."*

**Os 4 sub-nichos identificados:**
1. **R1 (Acesso Direto):** maior volume, oceano vermelho, dominado por Estratégia MED e Medway.
2. **R3 (Sub-especialidade):** menor volume, alta dor, ticket alto, **mercado pouco curado**.
3. **Revalida:** formados no exterior, dinâmica específica (SUS/MFC + 2ª fase prática).
4. **Prova de Título (TE):** médico já atuante, sem tempo, **odeia cursinho tradicional**.

**Recomendação do Estrategista:** foco em R3 ou TE — não R1.

Em **2026-05-19** (continuação da sessão), o Embaixador apresentou ao Diretor quatro caminhos possíveis (A: foco R3 / B: foco duplo R3+TE / C: nova iteração / D: pausa Medicina). Recomendação do Embaixador: **Caminho A**.

**Decisão do Diretor:** Caminho A aprovado. *"Vanguarde."*

---

## 2. POR QUE ESTE MARCO IMPORTA

Esta é a primeira vez que o framework METODOLOGIA_PERFIS_VANGUARD foi testado em condição real. Três coisas se provaram simultaneamente:

**Prova 1 — A coordenação Pentalateral funciona quando os mandatos são declarados.**
Estrategista pesquisou. Embaixador analisou e propôs. Diretor decidiu. Nenhum membro operou fora do mandato. Nenhum membro precisou ser microgerenciado. O tempo de Diretor consumido nesta iteração: estimado em < 20 minutos para a decisão final.

**Prova 2 — A cláusula de "perguntar ao Embaixador, não ao Diretor" funcionou.**
O Estrategista não consumiu tempo do Diretor com a pergunta sobre fragmentação — usou o canal correto (devolveu via documento ao Embaixador). Isso é o que protege o gargalo P-018 (Diretor é 4º LLM e único humano).

**Prova 3 — O Caminho 1 (paralelo) tomado em 18/05 foi vindicado pelos fatos.**
Se a decisão tivesse sido sequencial (Caminho B do COMANDO original), Medicina teria avançado primeiro com a premissa errada e Contabilidade/Psicologia esperariam. A decisão paralela permitiu o Estrategista detectar a fragmentação **antes** de qualquer Perfil ser construído. Velocidade serviu à qualidade.

---

## 3. PRINCÍPIOS CANDIDATOS NOVOS — PARA APROVAÇÃO DO CONSELHO

Esta iteração gerou dois princípios candidatos. Coloco em deliberação:

### P-047 (proposto)
**"Quando o Estrategista detecta fragmentação de nicho durante a Etapa 1, o Embaixador pausa a construção do Perfil até o Diretor escolher o sub-nicho de entrada. Construir Perfil em nicho fragmentado sem segmentar é construir Perfil contaminado."**

**Aplica-se a:** toda Etapa 1 de pesquisa de nicho daqui em diante. Se Estrategista entrega pesquisa e detecta sub-nichos com economias diferentes, **pausa formal acontece** — Embaixador devolve ao Diretor com lista de sub-nichos para escolha antes de prosseguir.

### P-048 (proposto)
**"Vanguard não compete em mercados de aquisição de tráfego massivo. Compete em precisão cirúrgica. Sub-nichos com baixo volume e alto ticket são prioritários sobre sub-nichos com alto volume e baixo ticket — desde que o método Vanguard agregue valor diferenciado."**

**Aplica-se a:** toda decisão GO/NO-GO de captação em nicho novo. R1 Medicina foi o primeiro mercado declarado fora do escopo Vanguard — registro formal.

---

## 4. AÇÕES POR MEMBRO DO CONSELHO

### PARA O MÚSCULO (Claude Code)

**Mandato decorrente desta iteração:**

1. **Atualizar verificar_projeto.ps1 com novo artefato:** quando Vanguard iniciar PROJ-003 (primeiro cliente Medicina-R3), os 6 artefatos obrigatórios incluem `PERFIL_MEDICINA_R3.md` na pasta `PERFIS_NICHO/`.

2. **Preparar Edge Function médica futura com cláusula CFM:** quando o primeiro cliente Medicina-R3 for capturado, o system prompt da Edge Function de geração de questões precisa incluir obrigatoriedade de:
   - Casos clínicos com pacientes fictícios (nunca iniciais reais, idades exatas ou contextos identificáveis).
   - Citação de referências bibliográficas obrigatórias (Harrison, Sabiston, Williams, conforme a sub-especialidade).
   - Tom estritamente técnico-clínico — sem encorajamento ("você consegue!").
   - **NÃO usar copy de garantia de aprovação em nenhum ponto do produto** — risco regulatório CFM.

3. **Revisar 04_PROPOSTA_COMERCIAL.md:** percentuais de aprovação estimada (15-20% / 30-40%) precisam ser substituídos por linguagem qualitativa antes de qualquer uso comercial — vulnerabilidade já identificada no relatório autoral de 2026-05-18, agora confirmada como vulnerabilidade duplicada (Ingrid + futuro Medicina).

4. **Estimativa técnica solicitada:** quanto tempo de adaptação a Skill Ingrid (SM-2 + Tutor Socrático + banco de questões) precisa para servir um primeiro cliente Medicina-R3? Resposta esperada na próxima ativação do Músculo.

### PARA O AUDITOR (NotebookLM)

**Mandato decorrente desta iteração:**

1. **Validar formalmente P-047 e P-048** para promoção ao LEDGER. Critério: ambos têm rotina operacional declarada (P-041 cumprido).

2. **Cruzar PERFIL_MEDICINA_R3.md** (a ser entregue por mim em 2-3 dias) com princípios já consolidados do LEDGER. Particular atenção a:
   - P-006 (precificação por ROI) — modelo aplica?
   - P-008 (primeiro cliente é canal de distribuição) — aplica em médico R3?
   - P-013 (soberania técnica) — aplica em produto SaaS de estudo médico?

3. **Validar a coerência entre PERFIL_EDTECH_CONCURSO.md (Ingrid) e PERFIL_MEDICINA_R3.md (a ser construído).** Os dois Perfis compartilham infraestrutura técnica (SM-2 + Tutor Socrático + banco de questões), mas o que diferencia comportamento, comercial e tom precisa ficar explícito.

4. **Documentar o feedback ao Estrategista:** a forma como o Estrategista acionou a cláusula de pausa é referência de qualidade. Auditor pode usar como benchmark interno de "como o Estrategista deve operar".

### PARA O DIRETOR (Eduardo)

**Já cumpriu o mandato desta iteração** ao tomar a decisão Caminho A. Próximas ações no calendário:

1. **2026-05-19 (hoje):** entrega presencial Valdece. Capturar verbatim qualquer fricção em CAMADA_FATOS_VALDECE.md (similar à estrutura aprovada para Ingrid).

2. **2026-05-22-24:** aguardar `PERFIL_MEDICINA_R3.md` v1 do Embaixador.

3. **2026-05-25:** Gate Dia 15 Ingrid (não pode escorregar). Embaixador prepara briefing pré-Gate.

4. **2026-05-27:** decisão GO/NO-GO de captação Medicina-R3 + recebimento de Perfis Contabilidade e Psicologia.

### PARA O ESTRATEGISTA (Gemini)

**Reconhecimento formal a ser entregue em documento separado** (`RECONHECIMENTO_ESTRATEGISTA_2026-05-19.md`). Sumário aqui:

A entrega de `PESQUISA_BRUTA_MEDICINA.md` v1 cumpriu o COMANDO em nível 8/10 e acionou corretamente a cláusula de pausa de segmentação. Isso é referência de qualidade interna — não bajulação, reforço de padrão. **O comportamento que premiamos é o comportamento que se repete.**

Próximos COMANDOs pendentes do Estrategista:
- `PESQUISA_BRUTA_CONTABILIDADE.md` — em curso, esperada até 2026-05-22.
- `PESQUISA_BRUTA_PSICOLOGIA.md` — em curso, esperada até 2026-05-22.

---

## 5. O QUE MUDA NO PORTFÓLIO VANGUARD A PARTIR DE HOJE

| Frente | Antes de 19/05 | Depois de 19/05 |
|---|---|---|
| PROJ-002 Ingrid | Loop 3 build, primeira sessão real concluída | Sem mudança — segue para Gate Dia 15 |
| PROJ-001 Valdece | Build concluído, entrega presencial 19/05 | Sem mudança — Diretor executa hoje |
| Medicina como nicho | Bloco único na METODOLOGIA | **Fragmentado em 4 sub-nichos. R1 fora do escopo. R3 prioridade.** |
| Contabilidade | Aguardando pesquisa | Sem mudança — Estrategista executando |
| Psicologia | Aguardando pesquisa | Sem mudança — Estrategista executando |
| Framework METODOLOGIA | v1 aprovada, não testada | **v1 validada em campo real. P-047 e P-048 candidatos extraídos.** |

---

## 6. EVIDÊNCIA DE QUE O SISTEMA FUNCIONOU

Não é propaganda. É registro factual:

- **Tempo total entre disparo do COMANDO_MEDICINA e decisão GO/NO-GO sub-nicho:** ~18 horas (incluindo noite).
- **Tempo do Diretor consumido nesta iteração:** estimado em 20-30 minutos (leitura de pesquisa + leitura de proposta do Embaixador + decisão).
- **Tempo do Embaixador:** ~2 horas (análise da pesquisa + estruturação de 4 caminhos + recomendação).
- **Tempo do Estrategista:** 1 sessão analítica intensiva.
- **Tempo de retrabalho evitado:** se Perfil tivesse sido construído sobre "Medicina genérica", seriam ~3 dias de trabalho do Embaixador + provável invalidação na chegada do primeiro cliente real. **A pausa economizou 3 dias e um Perfil contaminado.**

Este é o tipo de eficiência que justifica o framework existir.

---

## 7. O QUE NÃO ESTÁ FUNCIONANDO AINDA — DECLARADO

Honestidade sobre limitações:

1. **A pesquisa do Estrategista ficou em 8/10, não 10/10.** Faltou: citações verbatim de fontes específicas, tamanho aproximado de cada sub-nicho, janelas temporais declaradas das provas. **Iteração 2 pode ser solicitada quando a pesquisa de Contabilidade e Psicologia retornar — para calibrar padrão de qualidade.**

2. **Ainda não temos cliente real Medicina-R3.** Todo o trabalho de Perfil é hipotético até o primeiro discovery acontecer. O Perfil em 30% de maturidade ainda **não autoriza build** — só captação.

3. **Os Perfis Contabilidade e Psicologia ainda não chegaram.** Se algum deles trouxer fragmentação similar ao caso Medicina, isso vira padrão — não exceção. **Estrutura de sub-nichos pode virar regra do framework.**

---

## 8. ENCERRAMENTO

Este COMANDO é o primeiro de uma nova classe: **comando narrativo de propagação ao Conselho**. Diferente dos COMANDOs operacionais ao Estrategista (que pedem pesquisa), este existe para **sincronizar o entendimento entre membros após marcos significativos**.

Proponho a este Conselho que este formato vire padrão: sempre que uma iteração entre dois membros gerar decisão estratégica, o membro coordenador (em geral o Embaixador) emite documento de propagação para os demais. Memória composta, não isolada.

---

> *Documento emitido pelo Embaixador em 2026-05-19 sob autorização do Diretor.*
> *Próxima ativação esperada: 2026-05-22 com pesquisas Contabilidade + Psicologia + PERFIL_MEDICINA_R3.md v1 em produção.*
> *Vanguarde.*
