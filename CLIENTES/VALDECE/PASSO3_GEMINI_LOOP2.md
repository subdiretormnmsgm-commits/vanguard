# PARA O GEMINI — LOOP 2
# Cole este documento inteiro no Gemini no mesmo chat da DIRETRIZ V2
# Não precisa adaptar nada — está completo

---

Estrategista, fechamos o Dia 3 do PROJ-001 Valdece. Preciso da sua reação e da DIRETRIZ V3.

## O QUE FOI CONSTRUÍDO (Dias 1–3)

**Dia 1** — Infraestrutura soberana:
Schema Supabase com pgvector (768 dims, HNSW), Burn Rate Shield ($10/dia hard limit), Kill-Switch com fail-open, RLS completo, função search_documents() com threshold 0.65.

**Dia 2** — Motor semântico:
ingest.py com STF Open Data + CSV fallback, Gemini text-embedding-004, idempotência, custo estimado por ingestão. search_cli.py para Gate via terminal antes de qualquer UI.

**Dia 3** — Corpus ampliado + tema + UI:
- STJ adicionado ao ingest (dois endpoints com fallback automático)
- Limite aumentado de 100 para 300 documentos por fonte (600 total STF+STJ)
- Coluna `tema` TEXT adicionada: classifica cada decisão em 8 categorias penais via Gemini Flash no momento do ingest
- `corpus_gap` FLOAT em search_logs: registra quando similarity < 0.50 (mapa de fraqueza do corpus)
- UI completa em Vanilla JS PWA: busca semântica, cards com similarity %, badge RECENTE (< 180 dias), badge de tema
- Modo Tático: toggle que aceita trecho de denúncia do MP e retorna jurisprudência de defesa
- Painel do Diretor: 3 números em tempo real (buscas hoje, custo hoje, total de decisões)
- Feedback 👍👎 integrado ao Sovereign Pixel
- PWA manifest: instalável no celular como aplicativo

## DECISÕES TOMADAS NESTE LOOP

1. **Opção A confirmada**: sistema na infra de Valdece, sem MRR. Custo dele: R$1,20/mês no próprio API.
2. **Credenciais na entrega**: Eduardo vai presencialmente ao lado de Valdece. Build roda no ambiente Vanguard até o Dia 5.
3. **STJ entrou**: a ausência do STJ era o maior risco de frustração na entrega. Resolvido.
4. **PWA, não app nativo**: instalável, sem App Store, sem custo de publicação, atualização automática.
5. **tema column**: Layer A do Radar de Divergência. Cada documento já classificado — fundação da V2.

## RISCOS IDENTIFICADOS QUE AINDA EXISTEM

1. **Corpus pequeno nos primeiros dias**: 300-600 documentos é insuficiente para temas específicos. Valdece pode buscar algo que o corpus não cobre e ter impressão ruim. Mitigação: Eduardo faz 3 buscas calibradas ao vivo na entrega, nos temas que Valdece mais usa.

2. **Endpoints STJ não testados em produção**: implementados com dois fallbacks (Open Data + SCON), mas estrutura real da resposta pode diferir. Gate no Dia 4 vai revelar.

3. **Adoção pós-entrega**: o maior risco não é técnico. Se Valdece não mudar o hábito de pesquisa manual nas primeiras 2 semanas, o sistema morre mesmo funcionando.

4. **Threshold de similaridade**: 0.55 (ajustado do 0.65 original) pode ainda ser restritivo para jurídico. Ou pode ser frouxo demais. Só o Gate com corpus real vai calibrar.

## AS 5 IDEIAS DO MÚSCULO — REAJA A CADA UMA

Estrategista, reaja tecnicamente a cada ideia: viável agora / V2 / V3 / descartar. Com razão.

**Ideia 1 — Sovereign Upload**
Valdece faz upload de suas próprias petições ganhas. O sistema aprende com o estilo argumentativo dele. Quando ele buscar jurisprudência, o sistema prioriza acórdãos que ele já usou com sucesso. Isso cria lock-in total — ninguém pode copiar o sistema de Valdece porque está calibrado com a inteligência processual dele.

**Ideia 2 — Modo Audiência (mobile first)**
Uma segunda tela mínima, só para celular, com campo de voz: Valdece fala o argumento do MP em voz alta durante a audiência, o sistema transcreve e retorna a jurisprudência contrária em 6 segundos. Ele consulta o sistema como se fosse um assistente ao lado dele no tribunal.

**Ideia 3 — Relatório Mensal Automático**
Todo dia 1 do mês, o Edge Function gera um PDF para Valdece: "Você fez X buscas. Os 3 temas mais buscados foram Y, Z, W. As 5 jurisprudências mais relevantes do mês anterior em Direito Penal." Isso transforma o sistema de ferramenta passiva em consultor ativo. Aumenta percepção de valor sem custo de desenvolvimento relevante.

**Ideia 4 — OAB Network Effect**
Ao entregar para Valdece, pedir que ele indique 2 colegas. Para cada colega que vira cliente, Valdece recebe 1 mês de crédito de uso (se/quando houver plano pago). Isso cria um funil de indicação estruturado dentro da OAB — não depende de marketing.

**Ideia 5 — Citação Formatada Automática**
O botão "Copiar" atual copia ementa + número + data. Evoluir para: o sistema detecta qual tribunal e formata a citação já no padrão ABNT/OAB correto, pronta para colar na petição. Sem adaptação manual. Para um advogado, isso vale mais do que qualquer feature de IA sofisticada — é o trabalho mecânico que ele mais odeia.

## O QUE FALTA CONSTRUIR (Dias 4 e 5)

**Dia 4**: integração completa front + back com credenciais reais, Circuit Breaker às 17h, testes de regressão.

**Dia 5**: Supabase Auth single-user (login de Valdece), Edge Function cron semanal (auto-update corpus), Sovereign Playbook (guia de auto-gestão em linguagem não-técnica), MEMORIA_V2 + relatorio_evolutivo_V2, migração para ambiente de Valdece ao vivo.

## O QUE PRECISO DE VOCÊ

1. Reaja às 5 ideias: viável agora / V2 / V3 / descartar — com razão técnica e comercial
2. Há algo no plano dos Dias 4 e 5 que você mudaria? Algo que está faltando?
3. O Radar de Divergência (Layer B e C) deve ser prometido a Valdece na entrega como V2 com prazo? Ou esperar ele pedir?
4. Como precificar a V2 (Radar + Sovereign Upload) — assinatura mensal ou projeto único?
5. Emita a DIRETRIZ V3 com suas 5 ideias para o Músculo reagir no Dia 5

Formato obrigatório da DIRETRIZ V3:
- Bloco 1: reação às 5 ideias do Músculo (viável/V2/V3/descartar + razão)
- Bloco 2: ajustes nos Dias 4 e 5
- Bloco 3: estratégia comercial V2
- Bloco 4: o que o Músculo não está vendo
- Bloco 5: suas 5 ideias para o Músculo reagir no fechamento do Dia 5
