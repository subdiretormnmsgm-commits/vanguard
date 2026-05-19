════════════════════════════════════════════════════════════
SKILL — JURISPRUDÊNCIA SEMÂNTICA VALDECE — V1
Complemento do Embaixador ao Auditor
Gerado: 2026-05-19 | Fonte: Análise Embaixador PROJ-001 V2
════════════════════════════════════════════════════════════

CONTEXTO
Cliente: Valdece | Advogado criminalista autônomo | OAB-DF
Camada: 1 (MVP soberano) | Stack: Supabase + Gemini + Vanilla JS
Problema: Busca manual STF/STJ consome horas — especialmente em audiências
Objetivo V1: Motor semântico funcionando, gate aprovado, demo encantadora
Estado atual: Gate P-038 12/12 verde · Deploy Netlify ativo · Demo 2026-05-20

[CONEXÃO HISTÓRICA — Para o Músculo]
burn_rate_shield.js: CLIENTES/VALDECE/backend/ — reutilizar diretamente
kill_switch.js: mesma pasta — ativo e testado
gate_stj.py: backend/ — validado via CLI com 12 queries, 12 verdes
seed_demo.py: corpus population — rodado com 61/61 confirmados
search_cli.py: interface de teste CLI — validada e aprovada

[PADRÃO DE SUCESSO]
Gate antes de demo → elimina risco de falha na primeira impressão (P-038)
Corpus testado com queries do nicho real (não genéricas) → resultado confiável
Sovereign Playbook no handoff → elimina objeção de dependência técnica
Soberania total infra cliente → P-008: cliente vira canal de distribuição ativo
Deploy público (Netlify) antes da demo → encantamento começa antes do presencial

[PADRÃO DE FALHA — baseado em DIRETRIZ V3 e fricções do build]
Cron Job sem try/catch blindado → custo no API do cliente pode disparar sem aviso
Features de V2 prometidas antes do contrato assinado → scope creep e expectativa inflada
Explicar o sistema antes de mostrar o resultado → impacto da demo reduzido
Preencher o silêncio enquanto o resultado aparece → o silêncio é aliado

[PERSPECTIVA DO EMBAIXADOR — o que o Auditor e o Músculo não veem]

· Funciona sistematicamente em clientes de nicho profissional:
  Demonstrar a cena que o cliente descreveu no discovery — não as features.
  Valdece descreveu "júri em 20 minutos". A demo começa por essa cena.
  O cliente fecha o contrato mentalmente quando vê a sua própria situação na tela.

· Falha sistematicamente:
  Jargão técnico (Supabase, pgvector, threshold) com clientes não-técnicos.
  Eduardo ajudar antes do momento de busca autônoma do Valdece (H-2).

· Diferencial deste projeto:
  O corpus_gap (DIRETRIZ V3) é o fechador de negócios da V2.
  O Músculo construiu uma métrica; o Gemini transformou em argumento comercial.
  Valdece não sabe que o corpus_gap existe — quando Eduardo apresentar
  "os 12 temas que o sistema não cobriu ainda", isso é o argumento mais forte
  para a compra da V2.

· Blind spot Músculo e Gemini:
  A demo não termina quando o sistema funciona.
  Termina quando Valdece digita a própria query sem ajuda e encontra o resultado.
  O momento de virada é H-2: ele digitando, não Eduardo demonstrando.
  Qualquer ajuda de Eduardo antes desse momento reduz o impacto.

· Roteiro da demo (confirmado e testado):
  Abertura: "Você me disse que precisava do precedente antes do juiz. Vamos fazer isso."
  Busca 1 e 2: Eduardo conduz — silêncio total após digitar
  Busca 3: Eduardo mostra citação ABNT com 1 clique + modo preciso/amplo
  Busca 4: Valdece digita sozinho — Eduardo não toca no teclado
  Se encontrar → silêncio → ele fecha o contrato mentalmente
  Sovereign Playbook: "Se eu sumir, você opera em 3 passos. Sem me ligar."
  Contrato: "O sistema é seu. Isso aqui só formaliza."

QUERIES DA DEMO (testadas e aprovadas — ctrl+C prontas)
  Tema 1 → "homicídio qualificado tribunal do júri excesso de linguagem pronúncia"
           → STF HC 188888 sim=0.818 (PRIMEIRO resultado = IMPACTO MÁXIMO)
  Tema 2 → "roubo com arma de fogo dosimetria pena aumento proporcional"
           → STJ AgRg HC 765432 sim=0.792
  Tema 3 → "corrupção peculato lavagem de dinheiro servidor público administração"
           → STF AP 470 sim=0.780
  Coringa → "habeas corpus constrangimento ilegal prisão preventiva"
           → sim=0.804 (maior similaridade do corpus)

CALENDÁRIO COMERCIAL
  Demo presencial:  2026-05-20 (amanhã)
  Contrato:         2026-05-20 (aguarda demo)
  Sentinel Report:  2026-06-02 (14 dias pós-entrega)
  Pitch V2:         2026-06-19 (30 dias pós-entrega ou corpus ≥ 500)
  Lead OAB:         monitorar na demo — gatilho: Valdece mencionar colega

ALERTAS CRÍTICOS
· Demo sem a query que Valdece digita sozinho = janela de encantamento perdida [ALTO]
· Corpus_gap não apresentado na demo = argumento de V2 perdido [ALTO]
· Features de V2 prometidas antes da assinatura = scope creep [MÉDIO]

O QUE NÃO CONSTRUIR AGORA
· Sovereign Upload — requer gestão de PDF e UI documental. V2 obrigatória.
· Modo Audiência Voice — latência inaceitável em fórum. V3 ou descartada.
· Relatório Mensal Automático — sem MRR, não há fatura a justificar. V2.
· Export DOCX — lib adicional, escopo silencioso. Avaliar pós-contrato.
· Telemetry Heartbeat — requer consentimento explícito. Risco de confiança.

[PARA O SKILL_PROTOCOLO_VANGUARD]
· Gate de validação semântica como artefato formal de entrega
  → Aplicável a todo sistema de busca IA por nicho profissional (P-042)

· Discovery P2 (cena de sucesso) como critério de aceitação de build
  → Aplicável a todo projeto cliente de qualquer camada (P-041)

· Corpus_gap como fechador comercial de V2
  → Aplicável a todo sistema de busca com corpus limitado no MVP

· Sovereign Playbook como argumento anti-dependência antes do contrato
  → Aplicável a todo cliente de nicho profissional não-técnico (P-013 expandido)

· Demo estruturada em torno da cena do cliente — não das features
  → Aplicável a todo projeto onde o cliente descreveu situação específica

· Deploy público antes da demo (Netlify/Vercel) para encantamento antecipado
  → Aplicável a MVPs de interface web em projetos Camada 1
════════════════════════════════════════════════════════════
