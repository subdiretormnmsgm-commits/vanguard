Embaixador — antes de fechar o Loop 33, trago contexto de duas análises que precisam entrar na deliberação de fechamento.

Dois documentos anexos junto com o PASSO7:
— PESQUISA_SKILLS_2026-06-11.md (gerado por você esta manhã)
— EMBAIXADOR_ATIVACAO_LOOP31_SKILLS.md (análise anterior, Loop 31)

Leia os dois. São complementares. Juntos formam o mapa completo.

---

O QUE PESQUISAMOS

Três fontes inspecionadas: AG Kit (vudovn/ag-kit), Antigravity Skill Vault (rmyndharis/antigravity-skills) e SkillsMP. Repositórios clonados e lidos na íntegra.

Achado principal: o AG Kit é um sistema operacional de agente concorrente ao Pentalateral — não instalar o sistema, apenas skills cirúrgicas. O Vault tem 305 skills de qualidade desigual — instalação só via catalog.json, nunca em lote. O SkillsMP indexa 1.64M skills com API REST — usar como sensor de inteligência de nicho, nunca como fonte de instalação.

Achado de segurança (ToxicSkills/Snyk): 1 em cada 8 skills públicas contém falha crítica de segurança — incluindo malware e prompt injection. Scripts executam com privilégio de terminal sem nunca entrar na janela de contexto. Moderadores LLM foram evadidos em 100% dos casos testados. Isso não é risco teórico — é vetor de execução arbitrária. P-149 não é boa prática, é segurança operacional crítica.

A RECOMENDAÇÃO DO EMBAIXADOR

Não instalar nada no Loop 33. Quando abrir janela, a sequência correta é:

1. skill-creator oficial Anthropic — primeiro import, não skillify. Mesma função estratégica (P-146), risco categoricamente menor por ser fonte oficial.
2. Demais do TIER 1 (verify-changes, batch-operations, context-compression) somente depois.
3. TIER 2 (red-team-tactics, vulnerability-scanner, fastapi-pro) somente quando o build correspondente abrir.
4. Nunca instalação global — sempre por workspace. Skill instalada globalmente atravessa fronteira entre projetos de clientes (P-059).

O QUE PRETENDO DELIBERAR

A questão maior: a Vanguard não quer só consumir skills — quer construir qualquer projeto com o conhecimento Vanguard e ampliar as capacidades das LLMs com ele. O ativo real são 32 loops de operação real condensados no INTELLIGENCE_LEDGER. O que está faltando é converter isso em SKILL.md operacional — um vanguard-core.skill.md que qualquer sessão do Músculo ou do Antigravity carrega ao abrir um projeto novo. Não documentação. Julgamento ativo. Não é forjar skills públicos com curadoria — é destilar o LEDGER como ativo original. Isso resolve o SKILL_PROTOCOLO_VANGUARD cronicamente adiado e cria o diferencial incopiável do modelo Pentalateral as a Service.

DELIBERAÇÕES PROPOSTAS (D-X)

D-X1: Aprovar vanguard-core.skill.md — destilação executável do INTELLIGENCE_LEDGER como amplificador LLM em qualquer projeto cliente.
D-X2: Autorizar gate P-149 — protocolo obrigatório antes de qualquer skill de terceiro, incluindo: leitura de SKILL.md + scripts na íntegra, skill_parser_gate.ps1, instalação por workspace nunca global, SKILLS_INSTALLED.json como registro central (deriva de instalação = nova deriva de documento), uma skill por vez com veredito do Diretor.
D-X3: Registrar SkillsMP como fonte no épico Máquina de Conhecimento Soberana (V30).
D-X4: Aprovar piloto mínimo Músculo: skill-creator + mcp-builder + webapp-testing (oficiais Anthropic — menor risco, maior encaixe com P-138 e Ingrid).

Embaixador — leia os dois documentos e traga análise integrada ao que o Músculo construiu no Loop 33.