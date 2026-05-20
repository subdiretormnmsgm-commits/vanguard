════════════════════════════════════════════════════════════════════════
SKILL B — BUSCA SEMÂNTICA POR NICHO PROFISSIONAL — TEMPLATE UNIVERSAL
Gerada por: NotebookLM (Auditor / Sócio Consultor)
Baseada em: PROJ-001 Valdece (case fundacional)
Versão: Consolidada — duas sessões do Auditor + análise do Músculo
════════════════════════════════════════════════════════════════════════
CONTEXTO GENÉRICO
Nicho: [PREENCHER POR PROJETO] | Tribunal/Base: [PREENCHER]
Stack: Supabase pgvector + Gemini Embeddings + Vanilla JS/PWA
Camada: 1 (MVP soberano) | Prazo padrão: 5 dias
Modelo de entrega: Opção A — infra na conta do cliente

[DISCOVERY — 8 PERGUNTAS OBRIGATÓRIAS]
P1: Dor com custo mensurável — [exemplo do nicho]
P2: Cena de sucesso — [exemplo do nicho] ← OBRIGATÓRIA (P-041)
P3: Quem usa e como — [perfil técnico típico do nicho]
P4: O que existe hoje — [ferramentas típicas do nicho]
P5: O que não pode quebrar — [criticidade típica do nicho]
P6: Escopo e limites — [o que o nicho tipicamente quer excluir]
P7: Investimento e urgência — [faixa de valor por nicho]
P8: Expansão futura — [V2 natural do nicho] ← OBRIGATÓRIA

[GATE DE VALIDAÇÃO — ESTRUTURA PADRÃO]
Executar ANTES da demo com o cliente:
· Área 1: [área principal do nicho] — queries tipo: [exemplos]
· Área 2: [área secundária] — queries tipo: [exemplos]
· Área 3: [área terciária] — queries tipo: [exemplos]
· Coringa 1: [query de maior sim histórico do nicho]
· Coringa 2: [query de menor latência histórica]
Threshold aprovação: sim ≥ 0.67 | Latência alvo: < 3s | Top: 3
Artefato: GATE_[NICHO]_[DATA].md — entregue ao cliente no handoff como "Protocolo de Garantia Soberana"

[CORPUS MÍNIMO VIÁVEL POR NICHO]
· [nicho]: [N] documentos estáticos (JSON/CSV) pré-limpos
· [M] temas
· fonte: [origem dos dados — PROIBIDO web scraping ao vivo (P-003). Dados próprios do cliente ou bases públicas consolidadas]

[PADRÃO DE SUCESSO — UNIVERSAL]
· Gate CLI de similaridade executado antes da demo (P-042) → elimina risco de falha na primeira impressão.
· Demo abre reproduzindo a cena do cliente (P-041) → eleva taxa de conversão; o cliente vê o problema dele resolvido, não uma feature.
· Sovereign Playbook apresentado antes da assinatura de contrato → destrói o medo de vendor lock-in antes que ele surja.
· Corpus_gap documentado no handoff → argumento matemático irreversível para venda da V2.

[PADRÃO DE FALHA — UNIVERSAL]
· APIs abertas de terceiros em produção sem Circuit Breaker → paralisa o projeto na primeira falha de endpoint.
· Cron job de atualização automática sem try/catch blindado → custo incontrolável na conta do cliente.
· Construir focado em "métrica de máquina" (threshold, latência, embedding) ignorando a "cena humana" que o cliente imaginou no discovery (P-044).
· Prometer features de V2 antes do contrato assinado → scope creep e canibalização do upsell.

[SEQUÊNCIA DE BUILD — 5 DIAS — PADRÃO]
Dia 1: Schema Supabase na região local do cliente (sa-east-1) + pgvector + Burn Rate Shield + Kill Switch.
Dia 2: Pipeline de ingestão agnóstico (ingest_config_[nicho].json) + CLI de teste (search_cli.py) + gate_runner.py parametrizável.
Dia 3: Gate semântico com dados do nicho real (Mágico de Oz Gate) + UI core + citação/formato padrão do nicho.
Dia 4: Busca precisa/ampla + interface final + Circuit Breaker da fonte de dados principal.
Dia 5: Auth single-user + Edge Function cron blindada + seed_demo.py na conta do cliente + Gate P-040 final + Sovereign Playbook + migração de banco + DEMO.

[ARTEFATOS ENTREGÁVEIS — TODO PROJETO]
· seed_demo.py — população inicial do corpus (parametrizado por nicho).
· search_cli.py — validação de queries pré-demo.
· gate_runner.py — script agnóstico: lê queries_[nicho].json → gera GATE_[NICHO]_[DATA].md automaticamente.
· GATE_[NICHO]_[DATA].md — resultado do gate documentado como SLA de entrega.
· OFFBOARDING_RUNBOOK.md — desvinculação em 4 passos, 30 minutos.
· Sovereign Playbook — manual de operação autônoma para o cliente.
· SENTINEL_REPORT template — relatório de ROI disparado 14 dias pós-entrega.

[V2 NATURAL POR NICHO]
· Contabilidade: Scanner Tributário proprietário + integração com obrigações acessórias + alertas de mudança legislativa.
· LegalTech-Criminal: Sovereign Upload (PDF de peças próprias) + Radar de Divergência Judicial.
· Médico: Upload de protocolos proprietários + alertas de atualização de guidelines.
· Psicologia: Base de publicações curadas + matriz diagnóstico-terapêutica.
Gatilho universal de venda: corpus ≥ 500 docs ou 30 dias de uso ativo.
Pricing universal V2: R$8.500–12.000 (projeto único) + R$350/mês Sentinel Report + auditoria.

[SENTINEL REPORT — ESTRUTURA PADRÃO — 14 DIAS PÓS-ENTREGA]
Seção 1: Buscas realizadas (total + por área)
Seção 2: Temas com melhor resultado (sim ≥ 0.70)
Seção 3: Temas sem resultado adequado (corpus_gap) ← argumento irreversível para V2
Seção 4: Economia de tempo estimada (buscas x custo da hora manual do profissional)
Entrega: WhatsApp (texto + screenshot) para perfil não-técnico; PDF formal para perfil enterprise.

[ALERTAS CRÍTICOS — UNIVERSAIS]
· [CRÍTICO] Falácia da Homogeneidade dos Nichos (P-043): nunca inicie um novo nicho sem mapear (1) fonte dos dados (pública/proprietária/fragmentada), (2) taxa de obsolescência, (3) restrições éticas/legais, (4) estrutura semântica consolidada ou volátil.
· [CRÍTICO] Supabase em servidor fora do país alvo (US-East vs sa-east-1): latência de 600ms+ destrói a percepção de IA rápida e mágica na demo.
· [ALTO] Chaves de API de LLM expostas em Vanilla JS client-side: blindar com RLS restrito no Supabase; proxy reverso como artefato de V2.
· [ALTO] Demo sem o momento de "busca autônoma" conduzida pelo cliente (H-2): momento em que Eduardo não toca no teclado.

[PARA O SKILL_PROTOCOLO_VANGUARD]
· Discovery P2 (cena de sucesso) e P8 (expansão futura) — obrigatórias em todo projeto (P-041).
· Gate de validação semântica empacotado como "Protocolo de Garantia Soberana" — artefato contratual (P-042).
· Corpus_gap convertido em SLA comercial do Sentinel Report — não métrica técnica.
· Demo ancorada na cena de tensão do cliente — nunca nas features do sistema (P-044).
· Modelo Opção A como padrão para o "Cliente 0" de cada nicho (P-008).
· Web scraping ao vivo proibido como fonte de corpus (P-003) — sempre dados proprietários ou bases consolidadas estáticas.

[5 IDEIAS DISRUPTIVAS DO AUDITOR — CONSOLIDADAS]
1. [Segurança Soberana]: Proxy reverso obrigatório pós-contrato para blindar chaves de API expostas em Vanilla JS. RLS existente é proteção mínima; Edge Function de embedding é o padrão de V2.
2. [Infraestrutura como Código]: vanguard-niche-boilerplate com scripts CLI que provisionam Supabase inteiro (tabelas + pgvector + permissões + sa-east-1) com um comando. Nova instância em 1 hora, não 1 dia.
3. [Foco em Contabilidade como 2º nicho]: dor análoga ao Direito (densidade textual de legislação + pressão de prazo + alto custo do erro). Reaproveitamento de 80% do código do Valdece. LGPD menos restritiva que Medicina.
4. [Botão Expansão Semântica]: quando sim < 0.60, UI exibe "Este assunto ainda não está no seu ecossistema privado. Deseja solicitar expansão?" O cliente alimenta o corpus_gap e vende a V2 para si mesmo.
5. [Modelo Intel Inside]: arquivar benchmarks de latência, taxa de erro e custo real por nicho em VANGUARD_SECTOR_ASSETS.md. Em 3 nichos, transformar em "Bíblia de Consultoria Técnica" licenciável para outras agências (Camada 5 — Licenciamento Vanguard).

════════════════════════════════════════════════════════════════════════
Salvo em: QUADRILATERAL_UNIVERSAL/TEMPLATES/SKILL_BUSCA_SEMANTICA_NICHO_V1.md
Versão consolidada: 2026-05-19 | Duas sessões Auditor + Músculo
════════════════════════════════════════════════════════════════════════
