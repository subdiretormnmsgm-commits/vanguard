# Perfil de Nicho — LegalTech Penal
> Ativo proprietário Vanguard Tech · Acumulado via projetos reais
> Primeira entrada: PROJ-001 Valdece · 2026-05-18
> Atualizar ao fechar cada projeto de advogado no mesmo nicho

---

## Identificação do Nicho

**Nicho:** LegalTech — Direito Penal (Defesa Criminal)  
**Perfil base:** Advogado criminalista autônomo ou pequeno escritório  
**Produto construído:** Copiloto de Defesa Criminal — busca semântica em jurisprudência + geração de peças  
**Referência de campo:** Valdece (PROJ-001) — advogado penal com 15+ anos de experiência

---

## Perfil do Cliente

### Dados demográficos e operacionais

| Variável | Dado observado | Fonte |
|---|---|---|
| Faixa etária | 40–55 anos | Valdece + perfil típico de penal autônomo |
| Modelo de trabalho | Autônomo ou sócio de escritório pequeno (1–3 pessoas) | PROJ-001 |
| Volume de processos | 20–60 processos ativos simultâneos | Estimativa de campo |
| Relação com tecnologia | Usa WhatsApp profissionalmente, mas não ferramentas jurídicas avançadas | PROJ-001 |
| Dor de tempo | Pesquisa de jurisprudência = 2–5h por peça complexa | PROJ-001 |
| Assistente | Raramente tem (custo) — faz sozinho ou com estagiário | Inferido |

### Comportamento com o produto

| Variável | O que foi observado | Implicação para o produto |
|---|---|---|
| **Onboarding** | Não tolera configuração técnica — quer usar em 10 minutos | Sem .env, sem chave, sem instalação — tudo pronto |
| **Sessão típica** | Consulta pontual durante preparação de peça | Interface de busca rápida — não painel de gestão |
| **Definição de valor** | "Me poupou 3 horas nessa peça" | Métrica de sucesso = tempo economizado por peça |
| **Gatilho de pagamento** | Sentir que economizou em uma peça o que pagou no mês | Pitch: "R$X/mês — menos que uma hora do seu tempo" |
| **Resistência de preço** | Teto receptivo ainda não confirmado em campo | A confirmar com Valdece no pitch de V2 |
| **Compartilhamento** | Pode mostrar para colega do escritório | Risco de licença compartilhada — endereçar no contrato |

### Dores mapeadas em campo (PROJ-001)

| Dor | Como o cliente descreveu | Nível de urgência |
|---|---|---|
| Pesquisa jurisprudencial lenta | "Preciso de um Google melhor" | CRÍTICA — motivação de compra |
| Peças repetitivas sem memória | Não tem histórico de argumentos vencedores | ALTA |
| Custo de assistente | Não tem recurso para contratar | ALTA |
| Insegurança sobre novidades do STF/STJ | "Às vezes perco decisão nova relevante" | MÉDIA |

### O que o advogado NÃO quer ouvir no pitch

| O que evitar | Por que não funciona |
|---|---|
| "Inteligência artificial" sozinho | Gera ceticismo — "IA erra, não posso arriscar a defesa do cliente" |
| Jargão técnico (LLM, embedding, vector) | Não tem referência — cria desconfiança |
| "Substitui o advogado" | Rejeição imediata — ameaça à identidade profissional |
| Dashboard com muitos indicadores | Quer resultado, não gestão |

### O que o advogado QUER ouvir

| Argumento que funciona | Por que funciona |
|---|---|
| "É como ter um estagiário que nunca cansa" | Analogia familiar, não ameaçadora |
| "Você faz a decisão — a ferramenta faz a pesquisa" | Preserva a autoridade do advogado |
| "Já testei com 3 casos reais — aqui está o resultado" | Evidência antes de abstração |
| Demonstração ao vivo com caso real | Ver funcionando > qualquer explicação |

---

## Inteligência Comercial

### Precificação

| Produto | Valor | Gatilho |
|---|---|---|
| Piloto | R$0 (ou R$5.000 setup) | Demonstração presencial com caso real |
| SaaS mensal V2 | A definir — teto receptivo pendente | Valdece usar por 30 dias e verbalizar economia de tempo |
| Upsell: escritório | R$X × N usuários | Valdece mencionar colega ou sócio |

**Argumento anti-objeção de preço:** "Uma hora do seu tempo num caso complexo vale mais do que um mês de assinatura."

### Pipeline de referência

**Gatilho passivo:** Valdece mencionar colega advogado com problema similar → registrar como lead imediato.  
**Gatilho ativo (Gate pós-30 dias):** "Valdece, você conhece outro advogado penal que perde tempo com pesquisa como você perdia?"

---

## Dados Técnicos do Sistema (PROJ-001 — Gate P-038 — 2026-05-19)

| Parâmetro | Valor validado | Notas |
|---|---|---|
| Corpus inicial | 61 acórdãos reais STF/STJ | 22 temas cobertos |
| Threshold aprovado | sim ≥ 0.67 | Menor aprovado: 0.672; maior: 0.818 |
| Latência servidor US | 2.1–3.4s | Servidor sa-east-1 → estimativa < 1.5s |
| Top resultados | 3 | Padrão do gate — expansível para 5 em V2 |
| Modelo de embedding | gemini-embedding-001 | outputDimensionality=768 |
| Stack | Supabase pgvector + Gemini + Vanilla JS | SECURITY DEFINER + RLS |
| Deploy | Netlify (frontend) + Supabase US (corpus) | Migrar para sa-east-1 pós-contrato |
| Gate resultado | 12/12 verde (P-038) | Executado 2026-05-19 |

### Queries de Demo Aprovadas (Gate P-038)

| Query | sim | Latência |
|---|---|---|
| "homicídio qualificado tribunal do júri excesso de linguagem pronúncia" | 0.818 | ~2.1s |
| "roubo com arma de fogo dosimetria pena aumento proporcional" | 0.792 | ~2.3s |
| "corrupção peculato lavagem de dinheiro servidor público administração" | 0.780 | ~2.5s |
| "habeas corpus constrangimento ilegal prisão preventiva" (coringa) | 0.804 | ~2.2s |

---

## Padrões de Sucesso Confirmados

*(PROJ-001 Valdece — 2026-05-19)*

- ✅ **Gate de validação antes da demo** → elimina risco de falha na primeira impressão (P-042). Executado com 12 queries, 12 verdes. Demo previsível.
- ✅ **Corpus_gap documentado** → argumento matemático irrefutável de V2. "Os 22 temas cobertos de 60+ no STJ" é a venda da V2 pronta na entrega da V1.
- ✅ **OFFBOARDING_RUNBOOK como argumento comercial** → "Se você quiser nos demitir em 30 minutos, você pode" destrói a objeção de dependência.
- ✅ **Opção A (soberania total)** → cliente não se sente preso → tende a ser canal de indicação (P-008).
- ✅ **Deploy Netlify (link antecipado)** → encantamento pré-demo, cliente acessa antes da reunião.

---

## Padrões de Falha Confirmados

*(PROJ-001 Valdece — 2026-05-19)*

- ⚠️ **STF/STJ APIs abertas sem fallback** → 403/202 durante o build (P-056). Solução: corpus estático inicial de acórdãos + Circuit Breaker.
- ⚠️ **Discovery sem cena de sucesso (P2)** → build otimiza para threshold/embedding, não para o momento de alívio do cliente (P-041, P-044). O distanciamento do PROJ-001 nasceu aqui.
- ⚠️ **Cron job sem try/catch blindado** → risco de drenar cota Gemini na conta do cliente.
- ⚠️ **Servidor Supabase fora do país** → latência de 600ms+ destrói o efeito uau na demo presencial.

---

## Inteligência Comercial Atualizada

### Precificação Validada

| Produto | Valor | Status |
|---|---|---|
| Setup V1 (MVP soberano) | R$5.000–9.500 | Valdece: R$5.000 (first-mover discount) |
| Manutenção opcional | R$350/mês | Sentinel Report + monitoramento de endpoints |
| Setup V2 (Sovereign Upload + Radar) | R$8.500–12.000 | Gatilho: 30 dias ou corpus ≥ 500 |
| Replicação para 2º cliente do nicho | R$9.500–14.000 | Gate validado + boilerplate pronto |

**Zero Churn cláusula:** não incluir no contrato. Testar modelo de uso real por 30 dias primeiro.

### Estratégia de Indicação — "Crédito de Expansão entre Pares"

Abordagem no Dia 15 pós-entrega:

> *"Valdece, o seu sistema está isolado na sua infraestrutura. Se você indicar dois colegas criminalistas que fechem o próprio Cérebro Soberano conosco, absorvemos o custo de engenharia e instalamos o módulo de Radar de Divergência ou fazemos a expansão de corpus sem cobrar nada."*

Transformar o cliente em guardião do produto, que promove para ampliar o poder da própria ferramenta.

### Pipeline de Referência

**Gatilho passivo:** Valdece mencionar colega com problema similar → registrar no WIP_BOARD como lead qualificado com `cena_provavel` preenchida.  
**Gatilho ativo (Dia 15):** "Crédito de Expansão entre Pares" — apresentar formalmente.  
**Acesso OAB-DF:** ~50 advogados criminalistas na rede direta do Valdece.

---

## V2 Natural — LegalTech Penal

| Feature | Gatilho | Preço |
|---|---|---|
| Sovereign Upload (PDF petições próprias) | corpus ≥ 500 docs ou 30 dias de uso | R$8.500–12.000 |
| Radar de Divergência (alertar jurisprudência nova) | cliente verbalizar "perco decisão nova" | Incluso no V2 |
| Busca por Processo (número CNJ) | demanda espontânea do cliente | V3 |

---

## Próximo cliente no nicho

**Quando Vanguard prospectar o 2º cliente LegalTech-Penal:**
- Usar este perfil para personalizar o pitch em 5 minutos
- Comparar com o perfil do Valdece — o que difere, o que confirma
- Atualizar este documento após cada projeto no nicho

---

## Histórico de atualizações

| Data | O que mudou | Projeto |
|---|---|---|
| 2026-05-18 | Criação inicial com dados PROJ-001 Valdece | Valdece |
| 2026-05-19 | Dados reais do Gate P-038 · Padrões de sucesso/falha confirmados · Pricing validado · Estratégia "Crédito de Expansão entre Pares" · V2 Natural documentado | Valdece |

---

*LEGALTECH_PENAL.md — Vanguard Tech · QUADRILATERAL_UNIVERSAL/PERFIS_NICHO/*  
*Ativo proprietário — acumulado via projetos reais · Não é teoria de mercado*
