SKILL — JURISPRUDÊNCIA SEMÂNTICA VALDECE — V6.0
Gerada por: NotebookLM (Auditor / Sócio Consultor)
Pentalateral IAH — Loop 6: Assinatura & Blueprint V3
════════════════════════════════════════════════════════════════════════

[CONTEXTO DO PROJETO]
· Status: V1 Concluído (commit 9709649) | Contrato PENDENTE.
· Princípios Ativos: P-023, P-041, P-042, P-044, P-046.
· Teto do V1: Ementa completa + UF Badge + Boost monocrático entregues.
· Pendente V3 (Pós-Contrato): data_dje, repercussao_geral, recurso_repetitivo, turma.
· Stack: Vanilla JS + Supabase pgvector + gemini-embedding-001 (768 dims).
· Corpus: 61 acórdãos · threshold 0.67 (Precisa) / 0.45 (Ampla) · top 3.

[AUDITORIA DE COERENCIA]
· Contradição detectada: Músculo entregou 3 melhorias sem contrato assinado — viola P-023.
· Risco real: "fábrica de favores" — cada entrega sem contrato enfraquece posição comercial.
· Filtro Embaixador: perfil "Coautor Soberano" detectado — não propor mensalidade R$900 (vetado).
· Re-ingestão V3 sem dry-run = risco de gap temporário no corpus (threshold pode cair).
· Diretriz V6 acerta ao priorizar contrato antes de qualquer build V3.

[CONEXAO HISTORICA]
· P-023: Build sem contrato gera scope creep e perda de margem.
· P-042: "Protocolo de Garantia Soberana" (Gate P-038, 12/12 verde) é o gatilho de fechamento.
· P-046: Contrato formaliza ciclo de evolução — feedback durante teste = comprometimento, não bloqueante.
· Padrão histórico Vanguard: demos no computador do Diretor matam sentimento de posse do cliente.

[PADRAO DE SUCESSO/FALHA]
SUCESSO:
· Conversão em contrato: Eduardo apresenta melhorias de hoje como prova de "Parceria Oficial".
· Gate V3: Badge "VINCULANTE" como diferencial irreproduzível frente ao Jusbrasil.
· Silêncio de 10s após demo — deixar Valdece operar sozinho, não narrar.

FALHA:
· Escopo Silencioso em Loop: Músculo codar campos V3 antes da assinatura.
· Downtime de re-ingestão: migração de schema sem dry-run causa perda do threshold 0.67.
· Demo no computador do Eduardo (não no do Valdece) — histórico mostra que mata encantamento.

[PERSPECTIVA DO SOCIO]
· O sistema já provou valor. O próximo passo é formalização financeira, não engenharia.
· Instrução ao Músculo: usar 7 pontos (Certo→Diverge→Decisão→Enhancement→Custo→Impacto→Ação).
· Instrução ao Diretor: ir ao campo — o Músculo aguarda o contrato assinado para desbloquear V3.
· DFD Contabilidade deve começar em paralelo como shadow task — não paralisar a fábrica pós-handoff.

[BLUEPRINT MIGRATION V3 (POS-ASSINATURA)]
1. SQL: ALTER TABLE ADD COLUMN (data_dje date, repercussao_geral boolean, recurso_repetitivo boolean, turma text).
2. Ingest: atualizar ingest.py para capturar metadados vinculantes + dry-run antes de substituir corpus.
3. UI: badges "● VINCULANTE" e "● REPETITIVO" no card-header.
4. ABNT: atualizar buildCopyText() com data_dje quando disponível.

[ALERTAS CRITICOS]
· [CRITICO] Escopo V3: BLOQUEADO até contrato assinado — sem exceção.
· [ALTO] RLS exposta: chave Gemini no frontend — P1 pós-contrato (migrar para Edge Function).
· [MEDIO] 10_MEMORIA_RECENTE e 11_RELATORIO_EVOLUTIVO nas FONTES ainda são V1 (maio/13).

[O QUE NAO CONSTRUIR]
· Nada de data_dje, repercussao_geral, recurso_repetitivo nesta sessão.
· Não propor mensalidade R$900 — modelo Opção A definido (infra do Valdece, sem MRR).
· Não fazer demo no computador do Eduardo.

[PARA O SKILL_PROTOCOLO_VANGUARD]
· P-046: contrato formaliza ciclo de evolução, não produto finalizado — padrão replicável em todo nicho.
· Dry-run de re-ingestão antes de substituir corpus em produção — prevenção de gap percebido pelo cliente.