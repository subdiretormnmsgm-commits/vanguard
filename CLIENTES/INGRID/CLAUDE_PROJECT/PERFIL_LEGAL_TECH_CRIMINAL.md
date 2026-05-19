# PERFIL DE NICHO — LEGAL-TECH-CRIMINAL
## Advogado criminalista que litiga sob pressão de tempo
> **Status:** PILOTO — baseado em cliente real (PROJ-001 Valdece) com build entregue, sem 30 dias de uso real ainda.
> **Maturidade:** 50% consolidado — 50% extrapolado.
> **Guardião:** Embaixador. **Validador:** Auditor.
> **Criado em:** 2026-05-18 · **Versão:** v1
>
> **AVISO:** este documento é trade secret da Vanguard Tech. Não circular externamente. Não citar em propostas comerciais.

---

## ARQUÉTIPO DO CLIENTE

### Quem é
Homem ou mulher entre 35 e 60 anos, advogado criminalista (Direito Penal/Processo Penal) atuando individualmente ou em pequeno escritório (até 5 advogados). Atende defesas em júri, tráfico, crimes contra patrimônio, organização criminosa. Tem entre 8 e 25 anos de carreira. Vive de honorários — não de salário fixo. Já consolidou autoridade técnica local mas está pressionado por concorrência, velocidade dos tribunais e custo crescente das ferramentas de pesquisa.

### Como ele pensa sobre a profissão
Não como ofício — como exercício de soberania. Precisa controlar o próprio fluxo de trabalho. Desconfia de plataforma com mensalidade alta que cria dependência. Lê doutrina nos fins de semana. Tem orgulho de citações ABNT corretas.

### O que ele não vai dizer mas é verdade
Sente que o Westlaw e o JusBrasil Premium estão ficando inacessíveis para escritório pequeno (R$ 1.500 a R$ 3.000/mês). Sente também que o Google Acadêmico e o site do STJ não substituem — entregam volume sem precisão. Está em uma zona desconfortável: ferramenta cara que ele não quer pagar, ferramenta grátis que não serve. Quer algo dele, no controle dele.

---

## TRÊS VETORES DO PERFIL

### Vetor Comportamental

**Padrão de uso esperado:**
- Uso pontual, intenso, sob pressão. Não é uso diário sustentado — é "júri amanhã, preciso de X jurisprudência agora".
- Sessões podem durar de 5 minutos (busca específica) a 2 horas (preparação de sustentação oral).
- Lê resultado com rigor analítico — não engole resumo, quer ver o acórdão original ou a citação verbatim.
- Reporta defeito como questão técnica formal — não pede ajuda, descreve o problema.
- **Compara constantemente com referências de mercado** — Westlaw, JusBrasil, Juris+, Lexis. Comparação não é fricção, é validação. Ele quer saber se o produto é "o tipo de coisa que aquele produto é, mas dele".

**Gatilhos de engajamento:**
- Velocidade de retorno na busca — sub-3 segundos é o que parece "profissional", acima de 8 é "amador".
- Citação automática em ABNT NBR 6023 sem precisar reformatar manualmente.
- Resultado que mostra contexto, não só ementa — parágrafo do acórdão, com link para inteiro teor.
- Soberania técnica explícita — corpus na infra dele, não em SaaS do fornecedor.

**Gatilhos de abandono:**
- Mensalidade percebida como "vínculo permanente" sem ativo proprietário gerado.
- Ferramenta cair em momento crítico (sessão de júri, prazo de recurso).
- Resultado com baixa precisão — entrega o errado em busca específica = quebra de confiança imediata.
- Necessidade de aprender ferramenta complexa antes de poder usar.

**Padrão emocional:**
- Reservado com a ferramenta nas primeiras semanas — testa antes de incorporar ao fluxo real.
- Recomenda para colegas se a ferramenta o fez parecer mais profissional em um caso específico.
- Não é entusiasta — é validador. Elogio dele significa adoção; silêncio dele significa observação.

---

### Vetor Comercial

**Como ele tomou a decisão de procurar uma ferramenta personalizada:**
**Buscou ativamente.** Diferentemente do EdTech, este perfil sabe que precisa, sabe o que precisa, e sabe que o mercado atual não entrega. A entrada do cliente acontece por ligação direta ou indicação de colega, não por marketing.

**Sensibilidade a preço:**
- Plataformas referência: Westlaw (R$3.000/mês), JusBrasil Premium (R$1.500/mês), Lexis (R$2.000/mês).
- Aceita projeto único alto: **R$ 2.500 a R$ 18.000** (caso Valdece fechou em R$5.000 com contrapartida — abaixo do mercado por escolha estratégica).
- Rejeita mensalidade que ele percebe como "aluguel". Aceita mensalidade pequena de manutenção (R$200-500/mês) se justificada por API/infra real, não margem.
- Argumento de venda que ele aceita: "É seu, fica com você, atualiza sozinho, custa R$ X de API por mês."
- Argumento que ele rejeita: pacote SaaS com mensalidade próxima de R$1.000/mês com features que ele não vai usar.

**Janela ideal de pitch:**
Imediato — quando ele relata o problema, o pitch deve seguir. Não há janela de aquecimento como no EdTech. Cliente legal-tech qualificado decide rápido: GO ou no-go em 1 reunião.

**Sinal que indica disposição de pagar:**
Pergunta sobre prazo e entrega. *"Em quanto tempo fica pronto?"* — sinal de decisão tomada. Antes disso, está validando capacidade técnica.

**Argumento anti-objeção mais forte:**
*"Com o melhor sistema possível, ele será nossa propaganda."* — apela ao orgulho técnico-profissional. Cliente do nicho vira vendedor ativo se for bem servido (P-008).

---

### Vetor Técnico

**Plataforma obrigatória:** Aplicação web responsiva (desktop primeiro, mobile secundário). Diferente do EdTech, este cliente trabalha em estação de trabalho — múltiplos monitores, abas paralelas, copy-paste constante.

**Restrições críticas:**
- **Soberania técnica desde o Dia 0.** Infra na conta do cliente, não na conta do fornecedor. OFFBOARDING_RUNBOOK obrigatório (P-013).
- **Tempo de busca: < 3 segundos.** Acima disso, percepção de "amador".
- **Citação ABNT NBR 6023 nativa.** Não opcional. Não plugin. Nativa.
- **Threshold de busca configurável** (precisa/ampla). Cliente quer controle, não automatismo.
- **Caching agressivo de buscas recentes.** O advogado refaz a mesma busca 5x por dia em casos diferentes.
- **Histórico de buscas persistente** — vira insumo dele para argumentação posterior.

**Stack mínima validada:**
- Frontend: aplicação web responsiva (HTML/CSS/JS funcional, sem framework pesado).
- Backend: Supabase (na conta do cliente).
- Busca: embeddings + busca vetorial + reranking semântico.
- Fonte de dados: STJ Open Data + STF Open Data + outros tribunais por demanda. **Nunca scraping** (P-003).
- Custo operacional comprovado: ~R$ 1,20/mês de API na infra do cliente.

**Métricas técnicas que importam para este perfil:**
- `tempo_resposta_busca_ms` — sub-3s é referência.
- `precisão_busca_específica` — quando ele busca número de processo ou tese específica, deve retornar o documento certo.
- `cobertura_jurisprudência_atual` — quantos dias de atraso na atualização. Mais de 7 = problema.
- `volume_buscas_mensais` — define se a manutenção R$ X/mês está sustentando uso real.

**Features que NÃO entram no MVP deste perfil:**
- Geração automática de peças jurídicas (cliente tem orgulho profissional na própria redação).
- Análise preditiva de resultado de processo (cliente desconfia profundamente de "previsão").
- Integração com CRM jurídico (Astrea, Projuris) — distrai do uso, adiciona complexidade.
- Mobile como interface primária (desktop é a estação de combate).

**Features que vão aparecer na V2 deste perfil:**
- Sovereign Upload — cliente sobe acórdão próprio e indexa no corpus dele.
- Radar de Divergência — alerta quando jurisprudência muda em tribunal específico.
- Citação em DOCX direto para Word — não copy-paste manual.

---

## DIFERENCIAÇÃO ESTRUTURAL VS. EDTECH-CONCURSO

| Eixo | Legal-Tech-Criminal | EdTech-Concurso | Implicação para Vanguard |
|---|---|---|---|
| Motivação | Soberania profissional | Aspiracional (mudança de vida) | Tom de venda oposto |
| Modo de decisão | Validação técnica analítica | Confiança emocional | Pitch oposto: dado x história |
| Disposição a pagar | Projeto único alto + manutenção mínima | Mensalidade contínua baixa | Modelo de receita oposto |
| Ritmo de uso | Pontual sob pressão | Diário sustentado | Engenharia oposta (carga vs. continuidade) |
| Pipeline | Indicação rápida por orgulho técnico | Indicação lenta por identificação emocional | Estratégia comercial oposta |
| Plataforma | Desktop primeiro | Mobile-first | Stack oposta de UI |
| Comparação com concorrência | Necessária e bem-vinda | Diluidora se prematura | Posicionamento oposto |

**Princípio derivado:** Tratar estes dois Perfis como variantes do mesmo arquétipo (\"cliente\") seria o erro estratégico mais caro da Vanguard. São arquétipos ortogonais — moats independentes, com economias unitárias diferentes, com cadências de processo diferentes.

---

## HIPÓTESES EM TESTE — O QUE AINDA PRECISA SER VALIDADO

| ID | Hipótese | Como validar |
|---|---|---|
| H-NICHO-L1 | Advogado criminalista vira vendedor ativo após 60 dias de uso satisfatório | Capturar indicações espontâneas pós-entrega Valdece (a partir de 2026-07-19) |
| H-NICHO-L2 | Manutenção em R$300-500/mês é aceita; acima de R$700/mês cliente prefere absorver internamente | Testar pricing na V2 do Valdece |
| H-NICHO-L3 | Perfil escala dentro do mesmo escritório (sócio → outros sócios) mais rápido que entre escritórios | Acompanhar uso Valdece e perguntar sobre uso por outros |
| H-NICHO-L4 | Advogados de outras áreas (cível, trabalhista) podem ter Perfil derivado mas não idêntico | Não atender outras áreas como mesmo Perfil — construir derivado |
| H-NICHO-L5 | Cliente que aceita SaaS puro neste perfil é exceção, não regra | Monitorar quantos dos próximos 3 leads aceitam mensalidade vs. exigem infra própria |

---

## SINAIS DE ALERTA — QUANDO ESTE PERFIL NÃO É O CERTO

- Advogado que pede "ferramenta tudo-em-um" → quer plataforma grande, não solução cirúrgica.
- Advogado de grande banca (>20 advogados) → tem orçamento de TI corporativa, decisão é por comitê, ciclo de venda é trimestral.
- Advogado júnior (menos de 3 anos de carreira) → ainda não consolidou método próprio, pode mudar de preferência rápido.
- Cliente que negocia abaixo de R$2.000 → ROI da Vanguard fica negativo, recusar.
- Cliente que pede prazo abaixo de 5 dias para MVP → impossível atender com qualidade, recusar.

---

## EVIDÊNCIA DE CAMPO — CLIENTE DE REFERÊNCIA

**Cliente:** PROJ-001 Valdece (anonimizar em uso interno; remover em uso externo)
**Área:** Direito Penal (defesa criminal)
**GUT Score no qualificação:** 75 (G:5 · U:5 · T:3)
**Valor fechado:** R$ 5.000 (mercado: R$ 12-18k — aceitação com contrapartida)
**Modelo de entrega:** Opção A — infraestrutura do cliente, sem MRR vinculado, R$ 1,20/mês de API
**Data de discovery:** 2026-05-12
**Build:** Dias 1-4 (commits ef3f1cd, 996b40d, 18c617f, e9afb36)
**Entrega presencial agendada:** 2026-05-19
**Pipeline V2 mapeado:** R$ 8.500-12.000 (Sovereign Upload + Radar de Divergência + Citação DOCX)

**Fala verbatim de referência (Diretor sobre o cliente):**
*"Tudo o que for gravado nesse nosso primeiro projeto é primordial."*

**O que esse cliente já provou:**
- P-006 — precificação por ROI funciona como filtro.
- P-008 — primeiro cliente de nicho é canal de distribuição, não fonte de MRR.
- P-013 — soberania técnica desde o Dia 0 é diferencial real para este perfil.

**Próximas validações pendentes:**
- Reação ao onboarding técnico presencial (2026-05-19).
- Uso real consecutivo por 30 dias.
- Indicação espontânea para colegas de escritório.

---

## TEMPLATE DE ONBOARDING PARA CLIENTE NOVO DESTE PERFIL

1. **Discovery por ligação telefônica** — 30-45 min, foco em dor específica e processo de trabalho atual.
2. **Qualificação GUT** — score mínimo 70 para avançar.
3. **Cálculo de ROI do cliente** (P-006) — horas perdidas × valor/hora × 12 = referência de preço justo.
4. **Apresentação de Opção A** (sovereign) **vs. Opção B** (SaaS no fornecedor) — cliente escolhe. Maioria escolhe A.
5. **Contrato com cláusula de soberania** — corpus migra para infra do cliente no handoff.
6. **Build em 5 dias com Magico de Oz Gate Dia 2** — CLI valida busca semântica antes de qualquer UI.
7. **Entrega presencial obrigatória** — onboarding técnico face-a-face acelera adoção.
8. **OFFBOARDING_RUNBOOK** entregue junto com a aplicação — autonomia explícita.

**Tempo total de onboarding esperado para 2º cliente do nicho:** 7-10 dias (vs. 5 dias forçados do piloto Valdece com slip).

---

## ECONOMIA DO PERFIL — POR QUE ELE VALE

**Investimento na primeira cliente (Valdece):** ~5 dias de build + entrega presencial + tempo do Conselho.
**Receita direta:** R$ 5.000.
**O que a primeira cliente ENTREGOU como ativo:** este Perfil + pipeline de busca STF/STJ reaproveitável + corpus de jurisprudência criminal indexado + módulo ABNT NBR 6023.
**Receita potencial dos próximos 10 clientes:** 10 × R$ 8.000 (média projeto único) + 10 × R$ 300/mês manutenção × 12 meses = **R$ 116.000/ano** com onboarding ~50% mais rápido.
**Receita potencial em adjacências (advogado cível, trabalhista, tributário com Perfis derivados):** mercado de ~150.000 advogados ativos no Brasil que se encaixam no perfil "escritório pequeno, autônomo, sensível a preço". Apenas 1% = 1.500 clientes potenciais.

---

## PROTOCOLO DE ATUALIZAÇÃO DESTE PERFIL

- Embaixador atualiza após cada cliente novo do nicho concluir onboarding técnico.
- Auditor valida coerência com P-006, P-008, P-013.
- Diretor aprova mudanças no teto de preço ou ajustes de modelo (Opção A vs. B).
- Versionar em v2, v3 a cada revisão maior.

---

> *Princípio P-039 aplicado: este documento é inferência sustentada por fatos da CAMADA_FATOS do PROJ-001 Valdece.*
> *Princípio derivado: este Perfil é ortogonal ao EdTech-Concurso. Não confundir, não unificar.*
