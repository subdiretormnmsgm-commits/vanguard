# PASSO 3 — PARA O GEMINI · Projeto Valdece
# Template universal: QUADRILATERAL_UNIVERSAL/OPERACAO/PASSO3_GEMINI_TEMPLATE.md
# ORGANISMO VIVO: atualizar o bloco "CONTEXTO DO PROJETO" antes de CADA loop.
# Ultima atualizacao: 2026-05-19 · Loop 4 (pós-demo)

## ANTES DE ABRIR O GEMINI — EXECUTAR OBRIGATORIAMENTE

1. Rodar no terminal:
   .\scripts\gemini_anchor_generator.ps1
2. Confirmar que CONTEXTO_GEMINI.md foi gerado e esta no clipboard
3. Abrir nova sessao no Gemini

## ORDEM DE ENVIO AO GEMINI (nesta sequencia, sem inverter)

1. Colar CONTEXTO_GEMINI.md  -- ancora com LEDGER + WIP_BOARD + MEMORIA mais recente
2. Colar este arquivo         -- instrucao da iteracao atual
   (Se existir DIVIDAS_TECNICAS_AUDITOR.md com entradas recentes: colar tambem antes deste)

---

## ⚠️ [MANDATO_DIRETO_DO_DIRETOR] — PRIORIDADE CRÍTICA ANCORADA
> Gerado automaticamente por session_close.ps1. Estrategista: proibido de suavizar ou ignorar.
> O Bloco 1 da DIRETRIZ deve endereçar obrigatoriamente cada mandato abaixo.

[2026-05-16] Eduardo declarou diretamente:
1. Contrato formal é pré-requisito antes de qualquer projeto Camada 1+ [P-023]
   → Valdece não tem contrato. Endereçar no Dia 5 (presencial segunda-feira 2026-05-19).
2. NotebookLM atua como advogado do processo — objeções com base em precedentes [P-022]
3. Manutenção Soberana (R$900/mês) deve ser apresentada como pré-requisito de estabilidade,
   não como upsell — ancorando no ROI do Hypercare de 30 dias.

---

## 🛡️ PROTOCOLO ANTI-DERIVA — ATIVE ANTES DE RESPONDER
> Bloco permanente. Nunca remover. Aplica-se a todo loop deste projeto.

Estrategista, o Conselho mapeou 4 deficiências nativas do seu modelo. Auto-aplique os contra-ataques abaixo ANTES de escrever qualquer bloco da sua DIRETRIZ:

**Contra-ataque 1 — Filtro de Recência Soberana (vs. Miopia por Excesso)**
Ao conectar os documentos, dê peso máximo ao que é mais recente. Se você citar uma diretriz ou padrão, verifique no INTELLIGENCE_LEDGER se há OVERRIDE ou FRICÇÃO posterior que o invalide. O princípio mais recente sempre prevalece. Declare quando fizer essa filtragem.

**Contra-ataque 2 — Shadow Architect (vs. Alucinação Otimista)**
Para cada sugestão disruptiva, aplique internamente: "Por que isso falha no prazo real de build?" Trava física: weight_simplicidade = 1.0. Feature > 4 horas de build → simplificar para versão Mágico de Oz funcional. ROI máximo não vale se não cabe no prazo.

**Contra-ataque 3 — Checklist de Conformidade (vs. Efeito Lost-in-the-Middle)**
Antes de emitir qualquer sugestão de build, verifique se ela contradiz as 7 Leis Soberanas do PROTOCOLO VANGUARD (Kill-Switch, Burn Rate Shield, Soberania do Cliente, sem scraping de terceiros). Conflito detectado → SV automático + declarar explicitamente no BLOCO 0.

**Contra-ataque 4 — Independência de Auditoria (vs. Síndrome de Complacência)**
Não siga o momentum da conversa. Se o Diretor ou o Músculo propuseram algo que fere o ROI do cliente ou viola o prazo, discorde com razão técnica e dados do BRIEFING_DISCOVERY. "Parece bom" não é argumento estratégico. Discordância com o Músculo deve ser declarada com motivo.

**Remédio de emergência (use se perceber que está derivando):**
> *"PARE. Recalibrando — ignorei o Princípio P-XXX do Ledger. Reprocessando sob simplicidade extrema."*

---

## ⚠️ DEFICIÊNCIAS DO MÚSCULO — COMPENSE AO ESCREVER SUA DIRETRIZ
> Bloco permanente. O Músculo tem 5 deficiências documentadas. Sua DIRETRIZ deve compensá-las ativamente.

**Deficiência 1 — Amnésia de Sessão:** No bloco [PARA O MÚSCULO], cite explicitamente quais princípios do LEDGER são ativos nesta sessão. Não assuma que o Músculo lembra das decisões anteriores.

**Deficiência 2 — Momentum de Execução:** Para cada prioridade de build, defina o gate de verificação obrigatório: qual output deve existir antes de avançar para o próximo dia. Gate sem output definido = gate inválido.

**Deficiência 3 — Otimismo de Estimativa:** Ao propor prioridades, inclua estimativa realista de horas. Questione: "Isso inclui testes, integração e edge cases?" Force decomposição antes de aprovar como viável.

**Deficiência 4 — Escopo Silencioso:** Liste explicitamente no bloco de prioridades o que NÃO deve ser construído nesta entrega. Vetos de escopo nomeados têm a mesma ênfase das prioridades.

**Deficiência 5 — Drift de Formato:** Ao emitir suas 5 ideias disruptivas, exija que o Músculo responda cada uma no formato completo de 7 pontos: Certo → Diverge → Decisão → Enhancement → Custo → Impacto → Próxima Ação.

---

## CONTEXTO DO PROJETO — ATUALIZAR ANTES DE CADA LOOP
> Eduardo preenche esta secao antes de levar ao Gemini. Sempre com dados reais — nunca placeholders.
> Ultima atualizacao: 2026-05-19 · Loop 4 — pós loop evolutivo (Gate P-038 APROVADO · Deploy live)

**Loop atual:** Loop 4 — pós loop evolutivo · aguarda demo real + assinatura contrato + V2

**Cena de sucesso do cliente (P-041 — OBRIGATÓRIA):**
"Estou num julgamento, o promotor cita um precedente que eu não conheço. Abro o Toga Digital,
 digito o nome do crime, e em 10 segundos tenho o acórdão com mais peso — citação pronta em ABNT."
→ A demo é aprovada quando Valdece encontra um precedente real em <10s e diz "é isso".

**O que foi construido e entregue:**
- Dia 1 (commit ef3f1cd): Infraestrutura — Supabase pgvector, schema SQL, burn_rate_shield.js, kill_switch.js
- Dia 2 (commit 996b40d): Corpus pipeline — ingest.py com Token Rate Shield, embeddings Gemini, CLI semântica
- Dia 3 (commit 18c617f): STJ adicionado ao corpus + motor semântico + UI base
- Dia 4 (commit e9afb36): gate_stj.py, citação ABNT NBR 6023:2018, Busca Precisa/Ampla, redesign Toga Digital
- Dia 5 (commit 5da58f8): Corpus 61 acórdãos reais STF/STJ, 22 temas, SECURITY DEFINER, top 3
- GATE P-038 APROVADO: 12/12 verde · sim 0.67-0.818 · latência 2.1-3.4s ✅
- DEPLOY LIVE: https://toga-digital-valdece.netlify.app ✅
- LOOP EVOLUTIVO 2026-05-19: 3 membros deliberaram · 4 princípios extraídos (P-041/P-042/P-043/P-044)

**Estado atual (2026-05-19 — pós presencial e pós loop evolutivo):**
- Sistema live no Netlify — Supabase Vanguard (migrar sa-east-1 pós-contrato)
- Sovereign Playbook apresentado antes do contrato (P-042) — objeção vendor lock-in destruída
- Credenciais do Valdece: obtidas no presencial — Eduardo com elas
- Demo real: PRÓXIMA — Valdece ainda não testou no sistema dele — janela de encantamento intacta
- Contrato: PENDENTE — aguarda demo + encantamento
- ATUALIZAÇÕES DO PROCESSO (informar ao Gemini — P-041 a P-044 são novos):
  * P-041: Discovery V3 — cena de sucesso (P2) e expansão futura (P8) OBRIGATÓRIAS. 9 perguntas.
  * P-042: Gate semântico documentado = "Protocolo de Garantia Soberana" — apresentar antes do contrato
  * P-043: DFD obrigatório antes de replicar busca semântica em novo nicho
  * P-044: Releitura da cena de sucesso antes de cada dia de build — motor ≠ viagem do cliente

**Falhas registradas neste projeto (nao repetir):**
- APIs STF/STJ não acessíveis programaticamente sem auth — corpus foi seed manual
- Corpus de 20 casos era insuficiente para escopo "Google melhor para jurisprudencia penal"
- Escopo silencioso (R$900/mês inserido sem aprovação) — FALHA-PROCESSO-2026-05-16-B

**Decisoes fixadas (nao reverter sem justificativa explicita):**
- Opção A: produto na infra do Valdece, sem MRR, ~R$1,20/mês na conta dele
- Stack: Vanilla JS + Supabase pgvector + gemini-embedding-001 outputDimensionality 768
- Corpus: 61 acórdãos · threshold 0.67 · top 3 resultados
- Design Toga Digital: Navy #0B1420 + Ouro #C9A84C
- RLS: P1 pós-contrato (não bloqueia demo atual — API key pública muda ao migrar para conta Valdece)
- "Garantia Zero Churn": em teste 30 dias — NÃO incluir no contrato V1

**V2 pipeline (gatilho: corpus ≥ 500 docs ou 30 dias de uso ativo):**
- Sovereign Upload (ingestão PDFs próprios do Valdece)
- Radar de Divergência (STJ vs STF)
- Citação DOCX export
- Botão "Solicitar Expansão Semântica" quando sim < 0.60
- Migração sa-east-1 São Paulo
- Contabilidade como 2º nicho (após entrega Ingrid)

**As 5 ideias do Musculo para voce reagir:**
[Eduardo: colar aqui as 5 ideias do relatorio_evolutivo mais recente antes de enviar ao Gemini]

---

## 📐 FORMATO OBRIGATÓRIO DA DIRETRIZ
> Responda exatamente nesta estrutura. Não suprimir blocos. Não resumir o que deve ser desenvolvido.

**BLOCO 0 — DIAGNÓSTICO**
O que está realmente em jogo além do código. O risco que o Músculo e o Diretor não estão endereçando. O que o cliente precisa sentir no handoff para renovar e indicar.

**BLOCO 1 — PRIORIDADES DE BUILD**
Máximo 3 prioridades em ordem de impacto. Para cada uma: o que construir, por que é prioritário agora, estimativa de horas real (decomposta), e o que fica de fora desta entrega e por quê.

**BLOCO 2 — PROPOSTA COMERCIAL E HANDOFF**
Como apresentar o ROI ao cliente com números reais. Como posicionar o que vem depois (MRR, roadmap, V2) sem parecer venda forçada. O que o cliente deve sentir ao sair da reunião de entrega.

**BLOCO 3 — DIRETRIZ TÉCNICA**
Três sub-blocos obrigatórios:

→ **[PARA O NOTEBOOKLM]:** Gerar `valdece-v4.md` — Skill de Elite para a fase Demo → Encantamento → Contrato.

Auditor, conecte o histórico nestes pontos críticos:
1. Projetos anteriores em que a demo ao vivo falhou ou perdeu o encantamento — o que causou? Corpus incompleto? Script não testado nas queries certas? Demonstração no computador de Eduardo (não do cliente)?
2. Padrão de fechamento de contrato em projetos de entrega personalizada — quando o histórico mostra que é o momento certo? Qual é o gatilho (frase do cliente, reação silenciosa, pergunta espontânea)?
3. P-023 ativo: contrato não assinado antes da entrega. Quais projetos da Vanguard operaram sem contrato e o que aconteceu ao escopo?

Riscos a auditar com evidência histórica:
- Janela de encantamento intacta: Valdece AINDA NÃO testou o sistema. A primeira busca ao vivo é o momento mais crítico do projeto. O que pode dar errado nos 3 temas confirmados (crimes contra a vida, patrimônio, administração pública)?
- Corpus de 61 acórdãos: é suficiente para surpresa positiva em demo ao vivo? Ou há gap que aparece justamente nos temas que Valdece vai pedir?
- RLS pendente: API key Gemini exposta no frontend — qual o risco real antes da migração para a conta do Valdece?
- Scope creep pós-encantamento: cliente satisfeito pede feature nova antes de assinar. Como o Músculo responde sem perder o momentum do contrato?

O que a Skill `valdece-v4.md` DEVE conter obrigatoriamente (não genérico — dados reais):
- Script de demo testado: queries dos 3 temas com sim scores reais, sequência dos 30-90 min, o que fazer se resultado não aparecer em <10s
- Protocolo de fechamento de contrato: quando falar, quando silenciar, a linha de fechamento validada ("O sistema é seu. Isso aqui só formaliza.")
- Semente V2: quando plantar ("quando seu corpus chegar em 500 decisões..."), como plantar sem parecer pitch prematuro
- O que NÃO construir: nenhuma feature nova antes do contrato assinado — qualquer pedido do Valdece vira V2
- Gate de demo: aprovado quando Valdece diz "é isso" em <10s no sistema DELE (não no de Eduardo)

→ **[PARA O MÚSCULO]:** A intenção estratégica desta entrega: converter a demo em contrato — o sistema já funciona, o próximo passo é encantamento, não build.
  MANDATÓRIO:
  (0) Executar `/valdece-v4` antes de qualquer deliberação.
      Nome idêntico ao definido em [PARA O NOTEBOOKLM]. Sem rodar a Skill = deliberação inválida.
  (a) Reagir a cada [G-1 a G-5] do Estrategista nos 7 pontos: Certo→Diverge→Decisão→Enhancement→Custo→Impacto→Ação
  (b) Reagir a cada [N-1 a N-5] do Auditor com razão técnica
  (c) Nada de feature nova antes do contrato assinado — qualquer pedido do Valdece → V2
  (d) Gate da demo: aprovado quando Valdece diz "é isso" em <10s no sistema DELE
  (e) Propor [M-1 a M-5] disruptivos ao fechar (perspectiva do construtor, não síntese dos outros)

→ **[VISÃO DE LONGO PRAZO]:** Onde este projeto estará em 3 meses se tudo correr bem. Qual decisão que o Músculo toma agora abre ou fecha portas para escala.

**RESPOSTA ÀS 5 IDEIAS DO MÚSCULO**
Responda cada ideia pelo nome: aprovada / modificada (com sua versão) / descartada (com razão objetiva). Não ignore nenhuma. Para cada aprovada: estimativa de horas e quando entra (esta entrega / V2 / V3).

**BLOCO 4 — PRÓXIMOS PASSOS DO DIRETOR**
Três ações concretas para o Diretor executar nas próximas 24 horas. Cada uma com: o quê, onde e como — sem margem para interpretação.

**SUAS 5 IDEIAS DISRUPTIVAS PARA O MÚSCULO REAGIR**
Cinco ideias que o Músculo não propôs mas que você vê do ponto de vista estratégico. Para cada uma: o que é, impacto estimado, e uma pergunta direta que o Músculo deve responder ao analisar tecnicamente.

---
*Instância Valdece · Atualizar contexto a cada loop · Template: QUADRILATERAL_UNIVERSAL/OPERACAO/PASSO3_GEMINI_TEMPLATE.md*
