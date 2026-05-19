════════════════════════════════════════════════════════════════════════
SKILL A — JURISPRUDÊNCIA SEMÂNTICA VALDECE — V1
Gerada por: NotebookLM (Auditor / Sócio Consultor)
Versão: Consolidada — duas sessões do Auditor + análise do Músculo
════════════════════════════════════════════════════════════════════════
CONTEXTO: Valdece / Camada 1 / Stack Supabase+Gemini+Vanilla JS
          / Problema: busca manual STF/STJ / Objetivo: MVP soberano

[AUDITORIA DE COERÊNCIA]
· DIRETRIZ V3 vs histórico: Confirma a premissa de "velocidade verificável". O distanciamento (otimizar para métrica intrínseca em vez da cena do cliente) repete o risco histórico "Museu Tecnológico" — sistema impecável, emocionalmente irrelevante para o cliente.
· Contradições identificadas: O Músculo inseriu "Manutenção Soberana" sem aprovação (Escopo Silencioso / FALHA-PROCESSO-2026-05-16-B). Corrigido para Opção A.
· Riscos ignorados por Gemini e Músculo: (1) Latência do Supabase nos EUA (~600ms de ping) destrói o "Efeito Uau" durante o nervosismo da demo. (2) Chave API do Gemini exposta no Vanilla JS — extraível pelo console do navegador.

[CONEXÃO HISTÓRICA — Para o Músculo]
· [Mágico de Oz Gate / search_cli.py] — originado em V12, provado no Dia 2 — salvou o build testando no terminal antes de construir o PWA.
· [Burn Rate Shield] — originado em V15 — obrigatório para travar o custo de API do Gemini na conta do cliente.
· P-056: STF/STJ APIs abertas falharam (403/202) — resolvido com semente estática de 20 acórdãos. Não confiar em endpoints de terceiros sem Circuit Breaker.

[PADRÃO DE SUCESSO]
· Executar Gate P-038 (12 queries testadas no CLI) antes do handoff → resultado: demo previsível e "janela de encantamento" garantida.
· Fechar o contrato com corpus_gap documentado → argumento matemático de V2 (Sovereign Upload) já pronto no Dia 1 pós-entrega.

[PADRÃO DE FALHA]
· Dependência de APIs de terceiros (STF/STJ) ao vivo — razão: scraping falhou (P-056). Dados proprietários ou sementes estáticas são a única forma de respeitar o prazo de 5 dias.
· Otimizar exaustivamente threshold e latência antes que o cliente sinta o sistema — o Músculo constrói o motor; o cliente compra a viagem (P-044).
· Escopo Silencioso: adicionar feature não aprovada durante o build — cria dívida técnica mascarada e gera distanciamento da cena do cliente.

[PERSPECTIVA DO SÓCIO CONSULTOR]
· Funciona sistematicamente: Garantir que a primeira interação do cliente seja com a "cena de dor" dele descrita no discovery (P-041). A demo não demonstra features — reproduz o momento de alívio.
· Falha sistematicamente: Focar em métrica de máquina (sim ≥ 0.67, latência ms, dimensões de embedding) ignorando a cena humana que o cliente imaginou no discovery.
· Diferencial deste projeto: Cliente opera Opção A — ele não aluga, ele possui. O corpus_gap será a isca irreversível para vender a V2 (Sovereign Upload).
· Abordagem recomendada: Assinatura no Dia da demo, ancorada na economia de 20h/mês, com agendamento do Sentinel Report para 14 dias após entrega.
· Blind spot Gemini/Músculo: Exposição da chave API do Gemini no Vanilla JS (Sequestro de Token) + latência de 600ms do servidor US. Ambos endereçados pós-contrato.

SEQUÊNCIA DE BUILD — DIAS 4 E 5
Dia 4: Circuit Breaker para STJ/STF, citação ABNT automática, interface final integrada.
Dia 5: Supabase Auth (single-user), try/catch no cron job de auto-update, seed_demo.py na conta do cliente, Sovereign Playbook, migração de banco para sa-east-1 (latência), DEMO.

ALERTAS CRÍTICOS
· [CRÍTICO] Falha silenciosa no cron job — Pode drenar limite do Gemini na conta do cliente se não for contido por try/catch blindado.
· [CRÍTICO] Chave API do Gemini exposta no front-end Vanilla JS — configurar RLS restrito no Supabase; proxy reverso é V2 pós-contrato.
· [ALTO] Latência do Supabase nos EUA (~600ms) — migrar para sa-east-1 pós-contrato. Para a demo: usar queries com sim > 0.78 + latência documentada no gate.

O QUE NÃO CONSTRUIR AGORA
· RAG Completo (Drafting de Petições) — V2, moeda de troca para upsell.
· Sovereign Upload (Upload de PDFs nativos) — V2, isca principal do Sentinel Report.
· Proxy reverso completo — V2 pós-contrato; RLS existente é proteção suficiente para a demo.

[PARA O SKILL_PROTOCOLO_VANGUARD]
· A cena de sucesso deve ser a primeira impressão do produto entregue (P-041).
· O Gate de validação é o "Protocolo de Garantia Soberana" — entregue fisicamente ao cliente como artefato do contrato (P-042).
· Corpus_gap como SLA comercial do Sentinel Report — não métrica técnica.
════════════════════════════════════════════════════════════════════════
Salvo em: CLIENTES/VALDECE/SKILL_AUDITOR_VALDECE_V1.md
Versão consolidada: 2026-05-19 | Duas sessões Auditor + Músculo
════════════════════════════════════════════════════════════════════════
