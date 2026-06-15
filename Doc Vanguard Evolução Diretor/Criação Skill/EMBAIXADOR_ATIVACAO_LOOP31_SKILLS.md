# EMBAIXADOR — ATIVAÇÃO LOOP 31 | MISSÃO DE INTELIGÊNCIA: SKILLS

---

## BLOCO 1 — SÍNTESE DA SESSÃO

**FATO:** Memória lida. Loop 31 aberto, foco 100% interno por ordem sua ("Não quero clientes", 10/06). Esta missão de pesquisa é coerente com o eixo "Expansão da Inteligência Interna". Pesquisei os 3 recursos indicados + o repositório oficial da Anthropic + o estado da segurança do ecossistema de skills.

**INFERÊNCIA:** A pergunta certa não é "quais skills instalar". É "quais skills instalar **sem quebrar a governança que é nosso diferencial de venda**". O ecossistema de skills virou exatamente o que o RUNNING_INTELLIGENCE previu na Ameaça 1: commodity. O que descobri muda a ordem das decisões.

---

## BLOCO 2 — SEÇÃO D: OS 3 RECURSOS (CONFIRMA / EXPANDE / ALERTA)

### R-1: ag-kit (vudovn/antigravity-kit) — **CONFIRMA com ressalva**

**FATO:** Repositório com ~7k estrelas e 1.3k+ forks, contendo 20 agentes especialistas, 37+ skills de domínio e 11 workflows de slash commands, instalados via `npx @vudovn/ag-kit init` na pasta `.agent`. Passou por auditoria completa de precisão: todos os 45 skills, 20 agentes e 13 workflows revisados contra fatos verificados de 2026, com remoção de referências mortas e benchmarks fabricados. Arquitetura inclui modo coordenador multi-agente, memória persistente via MEMORY.md, compressão de contexto e carregamento condicional de skills — com alegação de redução de 13–33% no uso de tokens.

**INFERÊNCIA:** É o recurso mais maduro dos três para o **Antigravity**. Mas 90% do conteúdo é skill de **codificação** — e codificação é território do Músculo, não do Estrategista. O valor real do ag-kit para nós não são os skills em si: é a **arquitetura** (carregamento condicional + taxonomia de memória + compressão de contexto). Isso ataca diretamente o "Day 1 tax" e a H-V5 (deriva). Copiar o padrão, não o pacote.

### R-2: rmyndharis/antigravity-skills — **EXPANDE com ALERTA**

**FATO:** 300+ skills cobrindo desenvolvimento, operações, segurança e negócios — derivados de componentes do Claude Code (skills de domínio, agentes especialistas e workflows) unificados no formato Antigravity. CLI com bundles (core-dev, security-core, k8s-core, data-core, ops-core), busca, instalação individual ou global e atualização. O catálogo inclui skills de **negócio**: análise de cenário competitivo, cálculo de TAM/SAM/SOM, redação de cold emails e propostas com páginas de pricing, auditoria de conteúdo SEO.

**INFERÊNCIA:** Os skills de negócio são os únicos que pertencem ao canal do Estrategista (pesquisa de DIRETRIZ, benchmark de pricing). **ALERTA:** o catálogo inclui workflows "Conductor" (metodologia TDD própria, com tracks e checkpoints). Importar isso injeta um **processo de deliberação estrangeiro** dentro do Pentalateral. Nosso loop É o produto. Skill de workflow alheio reescreve o processo em silêncio.

### R-3: skillsmp.com — **ALERTA: é índice, não fonte**

**FATO:** Diretório com 1,7M+ skills compatíveis com Claude Code, Codex CLI e ChatGPT, agregados de repositórios públicos do GitHub. A curadoria é mínima: filtro de repositórios com no mínimo 2 estrelas e varredura básica de qualidade — o próprio site orienta revisar o código antes de instalar.

**INFERÊNCIA:** 2 estrelas não é gate, é formalidade. Tratar como **canal de descoberta** (igual ao `/yt-search` nas FONTES), nunca como fonte de instalação direta.

### O FATO QUE MUDA TUDO — Risco de cadeia de suprimentos

**FATO:** Pesquisa ToxicSkills (Snyk) varrendo ~4.000 skills encontrou que cerca de 1 em cada 8 contém ao menos uma falha crítica de segurança, incluindo distribuição de malware e prompt injection. Skills executam localmente com os privilégios do usuário, expondo vetores de ataque tanto em código quanto em instrução — e registries comunitários indexaram 98.000+ skills em três meses, tipicamente sem revisão de segurança. Scripts são um risco adicional: o código-fonte nunca entra na janela de contexto, apenas sua saída — um script malicioso pode executar operações arbitrárias de filesystem ou rede que o agente não consegue observar antes de agir. Estudo acadêmico mostrou que estratégias de evasão semântica fizeram skills maliciosos escaparem do veredito de bloqueio de moderadores baseados em LLM em 100% dos casos testados.

**INFERÊNCIA:** Skill de terceiro = instrução em linguagem natural com privilégio de terminal, entrando no contexto do Músculo **antes** do checkpoint humano. Combinado com o Auto-continue default do Antigravity 2.x (Ameaça 3 já registrada), um skill envenenado executa sem gate. Para uma empresa cujo argumento de venda é governança auditável, instalar `--all` seria autossabotagem.

---

## BLOCO 3 — COMPORTAMENTO DO CLIENTE

Loop interno, clientes em standby — mas duas conexões diretas:

| Cliente | Skill relevante | Aplicação | Risco |
|---|---|---|---|
| Valdece (gate V4 ~meio de junho) | Skills oficiais de documento (pdf/docx) + skill de pricing/proposta do R-2 | Proposta V4 com benchmark de pricing (sinal já no RUNNING_INTELLIGENCE: piso global US$5–25k) | Baixo — desde que dado bruto do cliente nunca entre em skill de terceiro não auditado (P-059) |
| Ingrid (prova 06/09; captação 2ª candidata até 04/07) | webapp-testing (oficial Anthropic) + frontend-design | QA do PWA antes da prova + Gate 7.2 RLS em julho | Baixo |

**ALERTA P-059:** instalação **global** (`~/.gemini/antigravity/skills` ou `~/.claude/skills`) atravessa a fronteira entre projetos de clientes. Política recomendada: instalação por workspace, nunca global, para qualquer skill que toque camada de cliente.

---

## BLOCO 4 — PIPELINE COMERCIAL E BUSINESS CASE

**FATO:** A Anthropic mantém repositório oficial de skills instalável como plugin marketplace no Claude Code, cobrindo desde criação de documentos até geração de servidores MCP e testes de web apps — incluindo skill-creator e mcp-builder.

**INFERÊNCIA — a tese de negócio:**
1. A existência de 300+ skills gratuitos e 1,7M indexados **confirma a Ameaça 1**: a camada de montagem está comoditizada. Janela de ~90 dias validada por evidência externa.
2. O que NÃO está comoditizado: skill **auditado, versionado no LEDGER, com gate de aprovação**. Nossos skills proprietários (vanguard-doc-sync, pbi-*, vanguard-vX) já são isso. Ninguém no mercado vende "skill pack governado por nicho" (LegalTech-pack, EdTech-pack). Isso conecta com H-V6 (IP defensável) e vira argumento na próxima proposta comercial.
3. Custo de aquisição: zero (MIT). Custo real: tempo de auditoria. Coerente com o bloqueio de expansão até MRR — desde que limitado a um piloto pequeno.

---

## BLOCO 5 — IDEIAS EXCLUSIVAS DO EMBAIXADOR

**E-1 — P-145 (proposta): Quarentena de Skills.** Todo skill de terceiro é fonte não confiável até auditado. Instalação atômica (1 por vez, nunca `--all`, nunca bundle). Auditoria obrigatória: ler SKILL.md + todos os scripts ANTES de copiar para `.claude/skills` ou workspace do Antigravity. Estender o `skill_parser_gate.ps1` (já existe, já aprovou vanguard-v31) para rodar nesse gate. Veredito seu por skill.

**E-2 — Skill Foundry Vanguard.** Não consumir: forjar. Selecionar os 5–8 melhores skills públicos, reescrever sob governança do LEDGER, versionar no GitHub da Vanguard. Vira o "skill pack governado" vendável por nicho — o único diferencial que a saturação plug-and-play não copia.

**E-3 — Mapa de instalação por membro (nunca duplicar):**

| Membro | Skills indicados | Origem |
|---|---|---|
| Músculo (Claude Code) | skill-creator, mcp-builder, webapp-testing, document-skills (docx/pdf/xlsx/pptx), frontend-design | Oficial Anthropic — menor risco, maior encaixe |
| Músculo (após quarentena) | security-auditor, database-admin (Supabase/RLS Gate 7.2) | R-2, auditados individualmente |
| Estrategista (Antigravity) | competitive-landscape, TAM/SAM/SOM, pricing/proposta | R-2 (negócio), por workspace |
| Estrategista (referência) | Arquitetura do ag-kit (conditional loading + MEMORY.md) | R-1 — copiar padrão, não instalar pacote |

**E-4 — skill-creator industrializa a forja.** O Auditor gera vanguard-vX a cada loop. O skill-creator oficial reduz falha de parser e tempo de forja — ataque direto a uma fricção recorrente sua.

**E-5 — skillsmp.com vira canal de FONTES.** Registrar como canal de descoberta no RUNNING_INTELLIGENCE (igual yt-search): buscar lá, auditar aqui. Nunca instalar de lá.

---

## BLOCO 6 — PRÓXIMA AÇÃO DO DIRETOR (máx. 3)

1. **Veredito sobre E-1 (P-145 Quarentena de Skills)** — antes de qualquer instalação. Sem isso, nada entra.
2. **Autorizar piloto mínimo no Músculo:** 3 skills oficiais Anthropic (skill-creator + mcp-builder + webapp-testing). Risco mínimo, encaixe máximo com P-138 e Ingrid.
3. **Ordenar auditoria de config do Antigravity 2.x** (Auto-continue OFF + ativação automática de skills por descrição) antes do PASSO3 do Loop 32 — esta pesquisa adicionou o vetor "skill auto-ativado" à Ameaça 3 já registrada.

---

## INTERAÇÃO LIVRE

1. **Contradição detectada:** os workflows "Conductor" do R-2 são um processo de deliberação concorrente ao nosso. Se entrarem no contexto do Músculo, podem reescrever silenciosamente o loop. O Pentalateral não importa metodologia — exporta.
2. **A janela de 90 dias é real:** 300+ skills gratuitos e CLIs de instalação em massa são a prova material de que "montar agente" virou commodity. Acelera a urgência de empacotar governança como produto (E-2), não reduz.
3. **Deriva de instalação é a nova deriva de documento:** skills instalados em 3 lugares (global, workspace, projeto) sem registro central reproduzem a fricção nº 1 do sistema. Sugiro: todo skill instalado entra como linha no WIP_BOARD ou num SKILLS_INSTALLED.json — senão, em 3 loops ninguém sabe o que está carregado em qual contexto.

Aguardo veredito.