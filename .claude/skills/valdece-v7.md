SKILL — JURISPRUDÊNCIA SEMÂNTICA VALDECE — V7.0
Gerada por: NotebookLM (Auditor / Sócio Consultor)
Pentalateral IAH — Loop 7: V3 Migration, Badges & Infra Soberana
════════════════════════════════════════════════════════════════════════

[AUDITORIA DE COERENCIA]
· **P-023 Resolvido:** O contrato foi formalmente assinado [cite: 441, 445]. O escopo da V3 está autorizado legalmente.
· **Princípios Ativos Obrigatórios:** O Músculo deve operar sob [P-041] (Cena de Sucesso), [P-042] (Garantia Soberana), [P-043] (DFD antes de nicho), [P-044] (Releitura da cena), e [P-046] (Contrato formaliza a evolução) [cite: 431].
· **Conflito Evitado:** O Estrategista recomendou bloquear rotinas de upload ou scraping no ciclo atual [cite: 775]. Confirmo. O [P-003] veta web scraping sem acordo, e o "Sovereign Upload" pertence comercialmente à V2 (Upsell) [cite: 777].
· **Vetos do LEDGER Ativos:** O **HV-1** (Chave de API exposta) reincidiu no Loop 6, estourando a cota free [cite: 402]. A implementação da Edge Function no Dia 1 deste build não é opcional, é sanção de segurança [cite: 772].

[CONEXAO HISTORICA]
· **Loops 1-6:** O histórico provou que o "Mágico de Oz Gate" via CLI salvou o projeto de um *corpus gap* prematuro [cite: 250]. O Gate P-038 validou a stack Vanilla JS + Supabase + Gemini com 12/12 verdes (similaridade 0.67–0.818) [cite: 399, 400]. 
· **Decisões Fixadas:** Opção A (Soberania do Cliente, infra própria) [cite: 1139]. O Valdece assumirá os ~R$ 1,20/mês diretos na conta Google dele.
· **Dívida Histórica (HV-1):** Em sessões passadas de MVP Vanilla JS (V1-V5), credenciais expostas no client-side causaram suspensões de contas de testes [cite: 78, 126, 336]. A migração atual para Edge Functions é a única proteção canônica.

[PADRAO DE SUCESSO/FALHA]
· **Padrão de Sucesso:** A entrega do "Protocolo de Garantia Soberana" com métricas numéricas concretas destrói objeções de *vendor lock-in* (P-042) [cite: 833, 1157]. A formatação ABNT NBR 6023:2018 gerou alto valor percebido [cite: 1166].
· **Padrão de Falha:** Alterar schemas (ALTER TABLE) em bases com dados vivos sem dry-run destrói o banco em produção [cite: 1325]. O Downtime na re-ingestão, relatado pela Diretriz V6, quebra o threshold 0.67 se houver erro matemático nas dimensões [cite: 1191].
· **Sequência de Build (V3) e Gates Verificáveis:**
  1. **Edge Function (HV-1 Fix):** Código migrado. *Gate:* Chamada cURL local retorna payload sem expor a API Key. Tempo: 3,5h [cite: 772, 775].
  2. **Schema & Re-ingestão (Dry-run):** `ALTER TABLE` para os 4 campos (data_dje, repercussao_geral, recurso_repetitivo, turma). *Gate:* Os 61 acórdãos atualizados sem perda do index HNSW.
  3. **Badges Vinculantes UI:** Integração do "● VINCULANTE" e citação com DJe. *Gate:* Validação visual na interface PWA responsiva. Tempo: 2,5h [cite: 772].
  4. **Migração Soberana (sa-east-1):** *Gate:* Banco provisionado na conta do cliente, log sem erros e P-038 aprovado com latência re-testada. Tempo: 4h [cite: 772].

[PERSPECTIVA DO SOCIO]
· **O que os outros não veem:** Músculo e Estrategista focaram nas *features* V3 e na migração, mas ignoraram a logística burocrática. A migração de infraestrutura (Opção A) requer que o Valdece aprove o billing no Google Cloud Console com o cartão dele *antes* de testarmos a Edge Function no Supabase dele [cite: 778]. Sem isso, a refatoração trava no deploy [cite: 1285].
· **Discordância Fundamentada:** Discordo da premissa de que a latência para a API do Gemini será catastrófica desde o sa-east-1. Os testes passados demonstraram que o gargalo em RAG não é o ping DNS, mas a dimensão do chunk na conversão vetorial. Contudo, em respeito ao rigor do projeto, exijo que o Músculo logue e compare a latência `us-east-1` vs `sa-east-1` na primeira query.
· **Instrução Obrigatória ao Músculo:** Ao deliberar sobre cada prioridade ([G-1 a G-5]), use estritamente os 7 pontos: Certo → Diverge → Decisão → Enhancement → Custo → Impacto → Ação [cite: 1135].

[O QUE NÃO CONSTRUIR]
· Nenhuma UI ou script para "Sovereign Upload" (Upload de PDFs do cliente) [cite: 777].
· Nenhuma lógica complexa de Radar de Divergência (comparativo STF/STJ cruzado) [cite: 1196].
· Exportação direta para .docx.
*(Todas as funcionalidades listadas são escopo explícito da V2 para Upsell High-Ticket - P-046 [cite: 414, 1196])*