════════════════════════════════════════════════════════════
SKILL — JURISPRUDÊNCIA SEMÂNTICA VALDECE — V1
Gerada por: NotebookLM (Auditor) | Data: 2026-05-13
════════════════════════════════════════════════════════════

CONTEXTO:
Cliente: Valdece (Advogado autônomo, Direito Penal).
Camada: 1 (MVP — 5 dias).
Stack: Supabase pgvector + Gemini Embeddings + Next.js PWA.
Problema: Busca manual por palavras-chave consome horas e não interpreta raciocínio jurídico.
Objetivo V1: Entregar busca semântica por trechos de texto em um corpus limpo,
resultando na primeira venda real (R$5.000 + 20% MRR) e convertendo a economia
de 20h/mês do cliente no nosso "Ativo de Prova Real".

[CONEXÃO HISTÓRICA]
· Módulo Burn Rate Shield (§21): Reutilizar a trava de V15–V23 para limitar
  os custos diários da API do Gemini.
· Módulo Kill-Switch: Reutilizar lógica (V6–V23) no Supabase Auth para
  rebaixar acessos no caso de inadimplência no fee de manutenção.
· Módulo Sovereign Pixel (Lei 1): Injetar a telemetria já homologada para
  monitorar a retenção no "FIRE Event".

[PADRÃO DE SUCESSO]
· Lotes Pequenos e Implantação Contínua (Lean): Fazer entregas diárias pequenas
  e validar o backend isoladamente antes da UI.
· Freemium by Design (Lei 7): Inserir botões inativos de futuras features
  ("Sumário Automático", "Alerta de Nova Jurisprudência") para gerar desejo
  de upgrade nas Camadas 2 e 3.

[PADRÃO DE FALHA]
· Anti-Padrão (Violação P-003): Scrapers em tempo real do STF/STJ geram
  atrasos críticos e violam a inteligência da V24. PROIBIDO.
· UI prematura: Criar o Frontend antes de confirmar via Terminal que os vetores
  acertam a semântica processual do Direito Penal.

[PERSPECTIVA DO SÓCIO CONSULTOR]
· Funciona sistematicamente: Limitar o escopo ao FIRE Event mapeado —
  buscar e copiar acórdãos. Todo o resto é distração em 5 dias.
· Falha sistematicamente: Gastar tempo com PDFs de formatação complexa e OCR quebrado.
· Diferencial deste projeto: Estamos construindo um "Ativo de Setor" disfarçado
  de ferramenta. Os dados no pgvector valem mais que a aplicação.
· Abordagem recomendada: Teste o pipeline de RAG no terminal primeiro
  (Teste "Mágico de Oz"). Se os resultados trouxerem acórdãos coesos,
  avance para envelopar com PWA.
· Blind spot Gemini/Claude: Custos não dimensionados da API de Embeddings.
  R$5k é o teto vitalício recebido pelo V1 — sem orçamento para nuvem
  descontrolada. Token Rate Shield é OBRIGATÓRIO antes de qualquer código.

SEQUÊNCIA DE BUILD (5 dias)
Dia 1: Infraestrutura & Leis Soberanas — Supabase, Auth, Burn Rate Shield no .env
Dia 2: Motor Semântico (Backend) — Corpus de 100 acórdãos limpos + teste CLI
Dia 3: Interface PWA — Search Bar → Resultados por score → Botão Copy
Dia 4: Integração & Circuit Breaker — Fusão Back+Front. Se não aterrissar, cortar features. Prazo não move.
Dia 5: Peak-End Gate & Handoff — Sovereign Playbook para Valdece + PDCA (MEMORIA + RELATÓRIO)

ALERTAS CRÍTICOS
· ALERTA P0 — CUSTO: Hard-limit da API Gemini (máx $10/dia). Bloqueio automático se violado.
· ALERTA P0 — PRAZO: 5 dias é o contrato. Se cair, nossa premissa comercial desaba.

O QUE NÃO CONSTRUIR AGORA
· Stripe / Módulo de Pagamento — razão: pagamento único; SaaS é Camada 2/3
· Dashboard Multi-Tenant Admin — razão: Valdece aprova manualmente via Supabase (Tenant Zero)
· Web Scrapers STF/STJ — razão: ingestão imprevisível; dados devem vir de JSON/CSV pré-limpo

[PARA O SKILL_PROTOCOLO_VANGUARD]
Padrões universais a absorver no modelo portátil ao fechar o projeto:
· P-006 universal: projetos com valor abaixo de 10–25% do ROI anual gerado
  exigem contrapartida (equity/MRR) para compensar a margem
· Em soluções IA, Token Rate Shield precede o código — custo computacional
  não pode virar passivo do projeto
════════════════════════════════════════════════════════════
