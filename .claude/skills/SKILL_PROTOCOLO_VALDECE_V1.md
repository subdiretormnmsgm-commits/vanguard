# SKILL_PROTOCOLO_VALDECE_V1.md
**Projeto:** Jurisprudência Semântica Valdece | **Camada:** 1 (MVP) | **Prazo:** 5 Dias

## ⚠️ AXIOMAS DO PROJETO (HARD VETOS)
1. **O Gargalo é o Dado:** É TERMINANTEMENTE PROIBIDO criar web scrapers ou processadores complexos de PDF nesta iteração [cite: 434, 451]. O banco vetorial será alimentado EXCLUSIVAMENTE por um arquivo estático (JSON/CSV) com 100 acórdãos de Direito Penal fornecidos pelo Diretor.
2. **Foco no Terminal Antes da UI:** Valide a lógica do `pgvector` e do `Gemini Embeddings` via terminal antes de perder horas otimizando componentes do Next.js. O "FIRE Event" é a precisão semântica, não a estética.

## 🏗️ ARQUITETURA TÉCNICA RESTRITA
* **Backend & DB:** Supabase (PostgreSQL + extensão `pgvector` + Supabase Auth) [cite: 444, 451].
* **IA/Embeddings:** API do Gemini (`text-embedding-004`) para a vetorização em português jurídico [cite: 444, 451].
* **Frontend:** Next.js (com Partial Pre-Rendering se aplicável) + shadcn/ui minimalista (Barra de busca → Resultados → Botão Copiar) [cite: 444, 450].
* **Deployment:** Vercel [cite: 444].

## 🛡️ MÓDULO 0: INJEÇÕES SOBERANAS (AS 7 LEIS)
Atenção, Sócio-Arquiteto: você não escreverá a funcionalidade de busca sem antes blindar a infraestrutura executando a Constituição da IAH Factory [cite: 351, 458].

* **LEI 5 (A Mais Crítica) — BURN RATE SHIELD:** Implemente proteção no `.env` e no código para que os custos da API do Gemini e do Supabase não ultrapassem **$10/dia**. Crie um middleware/alerta que trave as chamadas se esse limite for atingido [cite: 445, 451]. O projeto custou R$ 5.000; se os embeddings saírem do controle, teremos prejuízo [cite: 427, 434].
* **LEI 1 — Sovereign Pixel:** Integre rastreamento básico para medir o tempo gasto nas buscas [cite: 352].
* **LEI 2 — Compliance LGPD:** Aceite de cookies para a PWA desde o início [cite: 353].
* **LEI 3 — Vendedor Silencioso (Sentinel):** Configure `sentinel_config.json` definindo o `success_event` como a cópia de um acórdão retornado pela busca [cite: 354, 559].
* **LEI 4 — Sovereign Playbook:** Reserve o tempo do Dia 5 para gerar o PDF ensinando o Valdece a operar e buscar na ferramenta [cite: 356, 357].
* **LEI 6 — Kill-Switch:** Deixe a trava do Supabase Auth pronta para o caso de inadimplência nas mensalidades de manutenção combinadas [cite: 360, 361].
* **LEI 7 — Freemium by Design:** Coloque botões inativos (greyed-out) para "Alerta de Nova Jurisprudência" ou "Sumário Automático" para gerar gatilho de upsell para as futuras V2/V3 [cite: 362, 363, 441].

## 🎯 PRÓXIMO PASSO DO MÚSCULO:
Gere o seu **Plano de Build** baseado nesta Skill e apresente o **CARD DE VEREDITO BINÁRIO** [cite: 149, 169] confirmando sua adesão a estas leis antes de iniciar o *Módulo 0*.