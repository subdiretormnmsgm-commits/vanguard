# SKILL_PROTOCOLO_VALDECE_V2.md
**Projeto:** Jurisprudência Semântica Valdece | **Fase:** Dias 3, 4 e 5 | **Stack:** Vanilla JS + Supabase pgvector + Gemini embedding-004

## CONTEXTO DO PROJETO
O cliente (Valdece) precisa reduzir 20h/mês de pesquisa manual [21]. O motor de busca (Dias 1 e 2) está em pé. O risco de colapso agora é o "Abismo do Corpus": se a matemática vetorial não entender o juridiquês de Direito Penal, a UI não servirá para nada [1]. Foco cirúrgico no *FIRE Event*: busca semântica por trechos que retorna acórdãos coesos [22].

## [CONEXÃO HISTÓRICA] (REUTILIZAR)
* **Burn Rate Shield (V15-V23):** Implementar hard-limit no `.env` para a API do Gemini. Teto de US$ 10/dia [13, 23, 24].
* **Módulo Kill-Switch Soberano (V6-V23):** Trava vinculada ao pagamento do setup. Degradará para modo somente-leitura se houver inadimplência futura na manutenção [23, 25].

## [PADRÃO DE SUCESSO]
* **Lotes Pequenos / "Mágico de Oz":** Validar a qualidade dos *embeddings* exclusivamente pelo Terminal (CLI) antes de construir o Frontend. Se o terminal trouxer resultados ricos, o motor funciona [13, 14, 26].
* **Corpus Fechado:** Alimentar o banco vetorial apenas com um lote limpo de JSON/CSV contendo decisões-chave [3, 13, 18].

## [PADRÃO DE FALHA]
* **Anti-Padrão (Violação do P-003):** Tentar fazer web scraping em tempo real de tribunais (STF/STJ) para buscar dados novos. Vai estourar o prazo e gerar bloqueios de IP [10, 12, 13].
* **UI Prematura:** Codificar a interface Vanilla JS/PWA antes de ter certeza de que o `text-embedding-004` devolve os acórdãos corretos no console [3, 13].

## [PERSPECTIVA DO SÓCIO CONSULTOR]
Sócio-Arquiteto, afaste-se do "teatro do sucesso" [27]. O cliente não se importa com a beleza do seu código Vanilla JS, ele quer sua sexta-feira de volta. O seu gargalo não é o frontend, é a ingestão e fatiamento (*chunking*) dos dados [28]. Resolva a matemática dos vetores hoje (Dia 3) ou o projeto morre. Esqueça features periféricas.

## SEQUÊNCIA DE BUILD (DIAS 3-4-5)
* **Dia 3 (O Teste de Fogo):** Ingestão de dados no `pgvector` e busca via Terminal (CLI). O Diretor testará 5 queries reais criminais. O Músculo só avança se a CLI for aprovada.
* **Dia 4 (A Casca):** Integração com o Vanilla JS. Construir apenas: Barra de Busca → Match Score → Card de Resultado → Botão "Copiar Tese". Aplique o *Circuit Breaker*: se algo agarrar, corte a feature. O prazo não se move [20].
* **Dia 5 (O Handoff):** Fechamento de Autenticação Básica (Tenant Zero) [18]. Geração do Sovereign Playbook [29]. Trava do repositório.

## 🚨 ALERTAS CRÍTICOS
* **[P0] ALERTA DE CUSTO:** Custo da API de Embeddings do Gemini. Sem a trava do Burn Rate Shield, o teste inicial consumirá a margem do projeto [3, 13].
* **[P0] ALERTA PRAZO:** Não haverá tolerância para estourar o Dia 5 [20].

## O QUE NÃO CONSTRUIR NESTA ENTREGA
* Integração com WhatsApp (Hermes/Sentinel) — Motivo: Retenção é problema da Camada 2 [5].
* Interface Multi-tenant — Motivo: O V1 é "Tenant Zero". Contas de advogados parceiros serão geradas manualmente pelo banco de dados [18].
* Resumos Dinâmicos com Gemini Pro — Motivo: Consome limite de API e escopo. O V1 apenas "retorna" a jurisprudência, não "sintetiza" teses [5].

## [PARA O SKILL_PROTOCOLO_VANGUARD] 
**Promoção Universal:** Em projetos de Inteligência Artificial baseada em LLM/Embeddings, institui-se a Regra "CLI First para IA". É estritamente proibido iniciar a construção do Frontend sem que o *core* semântico tenha sido validado por um teste isolado via terminal.
