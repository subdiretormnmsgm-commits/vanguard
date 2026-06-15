SKILL: vanguard-v28.md
Camada: Sistema Interno | Loop: VanguardV28 | Stack: Claude Code + n8n + Claude API

### [AUDITORIA DE COERÊNCIA]
A DIRETRIZ V28 do Gemini acerta estrategicamente mas esbarra em nossos firewalls constitucionais:
* **DIRETRIZ vs LEDGER:** A proposta de "Chief of Staff Daemon (W-8)" orquestrado via n8n e Claude API respeita de forma exemplar o princípio **P-001** (Claude Code ≠ Daemon Autônomo). O W-8 não "decide"; ele formata, cumprindo rigorosamente o **P-112** (n8n opera no Grau 1 como pré-processador).
* **W-1 a W-7 Existentes:** O workflow W-1 já faz check-ins de hora em hora. A V28 deve sobrepor/substituir o W-1 pelo novo W-8 para evitar sombreamento e sobrecarga de notificações irrelevantes.
* **[ALERTA VETO]:** A DIRETRIZ exige a construção do W-8 e Signal Classifier, mas falhou ao não exigir a documentação de emergência. Isso **VIOLA O P-110**. É expressamente proibido ativar a V28 sem antes registrar o *fallback manual (≤ 3 passos)* no `MAINTENANCE_COST.md`. 

### [CONEXÃO HISTÓRICA]
O que o histórico da V26/V27 provou é que a automação em nuvem via n8n traz uptime 24/7 sem onerar o terminal do Diretor. 
* **Decisões Fixadas:** A V28 não pode quebrar o **P-109** (O Notion e o Telegram são *OUTPUT ONLY*; o Git é a fonte de verdade). Também deve respeitar o **P-102**: os scripts locais diários (`briefing_diario.ps1`) não podem ser deletados enquanto o n8n não acumular 30 dias de estabilidade.
* **Padrões de Falha:** As V11 e V12 ensinaram-nos que *automação sem auditoria é caixa preta*. Se o Signal Classifier começar a dar "Auto-Resolve" em alertas críticos por uma regex defeituosa (Falsa Segurança), o Diretor ficará cego. Todo erro abafado pelo n8n precisa ser logado silenciosamente no Supabase.

### [PADRÃO DE SUCESSO/FALHA]
* **O que funcionou (V26/V27):** O envio de payloads JSON perfeitamente estruturados e enxutos via webhooks, garantindo a separação limpa de responsabilidades (W-3 e W-4). O Diretor recebe pacotes prontos para Veredito.
* **O que NÃO construir no V28 (Lista Nominal de Proibições):**
  1. NÃO construir loops locais iterativos `while(true)` em Node ou PowerShell para simular daemons.
  2. NÃO construir integrações onde o n8n altere ou faça "write" em arquivos Markdown de estratégia sem validação humana.
  3. NÃO acoplar Agentes Autônomos em LangChain externos. 
  4. NÃO remover o `briefing_diario.ps1` local.
* **O Ponto Cego (O que Músculo/Estrategista não veem):** O risco do desync assíncrono. Se o W-8 raspa o GitHub às 7:00 da manhã, mas o Diretor codou localmente até as 03:00 e não fez o `git push`, o briefing do n8n estará mentindo e apagará o contexto do trabalho da madrugada. O *State Guard* é a única salvação para essa latência.

### [PERSPECTIVA DO SÓCIO]
* **O sistema está pronto para o 3º cliente?** NÃO, a menos que o *Signal Classifier* seja implementado. Com três clientes ativos no mesmo cluster de infra, os logs e alertas iriam saturar a atenção do Diretor, inviabilizando a tomada de Veredito (fadiga de alerta - P-075). A V28 é o pré-requisito da escala.
* **O n8n cria dependência não mapeada?** SIM. Ao delegar o "Briefing" ao n8n, se o EasyPanel cair, a Vanguard sofre amnésia e o Diretor começa a sessão às cegas. O n8n é o nosso sistema nervoso central; ele não pode operar sem um *runbook* de suporte à vida documentado.
* **Filtro Externo (Visão de Mercado):** Um fundador que comprasse esta metodologia diria: *"Por que a máquina esconde erros de mim sem me mostrar o lixo?"* O comprador exigiria uma tabela "Shadow Log" para revisar os eventos silenciados no final do mês.

---

- CASCATA DELTA V27: (O que o MAPA atual ignora)
  1. **P-112**: Graus de autonomia definidos para o n8n.
  2. **P-113**: `CONTEXTO_SESSAO_DIRETOR` gerado para mitigar custo invisível.
  3. **P-114**: Bloco 0 do Embaixador injetado no Onboarding.
  4. **P-115**: Ação proativa obrigatória do Músculo no DEPENDENCY_MAP.
  5. **P-097**: `testar_gates_criticos.ps1` com testes de regressão exit 1.
  6. **P-099**: `ping_supabase_universal.ps1` no task scheduler.
  7. **P-109**: Regra explícita de OUTPUT ONLY para o Notion.
  8. **P-030**: `P030_AUTOMACAO_CONTINUA.md` (renomeado no LEDGER).

- RISCO SISTÊMICO TOP 3:
  1. `[RISCO_PRECOCE] Amnésia Sistêmica por Queda do n8n (Violação P-110/P-055):` Delegar contexto ao daemon em nuvem gera ponto único de falha. Sem fallbacks documentados até 3 passos para o W-8, o sistema para de se comunicar com o Diretor. (Evidência: Exigência do P-110 para o W-7).
  2. `[RISCO_PRECOCE] Deriva de Estado entre Nuvem e Disco (Violação P-072/P-084):` Se a nuvem (n8n) ler os repositórios sem considerar o estado físico atual (WIP_BOARD modificado, mas não commitado), o sistema fornece inputs adulterados para deliberação. (Evidência: P-084 - reprocessamento incorreto).
  3. `[RISCO_PRECOCE] Colapso por Surdez Automática:` Um Classificador de Sinais via Regex pode gerar *falsos negativos* em alertas de banco de dados. Um banco corrompido que não chama a atenção do Diretor afunda o sistema silenciosamente. (Evidência: V10 Fortress IA Firefighter).

- PRÓXIMAS AÇÕES DO MÚSCULO:
  1. Construir e testar o workflow do *Signal Classifier* no n8n. Adicionar obrigatoriamente um nó que loga no Supabase (`silenced_signals_log`) tudo o que for "Auto-Resolved".
  2. Construir o *W-8 Chief of Staff Daemon* e conectá-lo à Claude API para formatação de Grau 1. Substituir progressivamente os hooks do W-1.
  3. Desenvolver e acoplar o script *State Guard* no `session_start.ps1` para disparar `exit 1` em caso de incompatibilidade temporal de arquivos de sessão.
  4. Atualizar imediatamente o arquivo `MAINTENANCE_COST.md`, detalhando fallbacks de 3 passos ou menos para o Signal Classifier e W-8.
  5. Atualizar a arquitetura no `MAPA_SISTEMA_OPERACIONAL_V2.md` com as 8 lacunas listadas na Cascata Delta V27 e executar propagação.
```