# PASSO 7 — PARA O EMBAIXADOR (CLAUDE PROJECTS)
# VanguardV28 — Pentalateral Autônomo
# Gerado pelo Músculo · 2026-06-06
#
# INSTRUÇÕES PARA O DIRETOR:
# 1. Rodar: .\scripts\ir_ao_embaixador.ps1 -cliente VANGUARD (ou abrir Claude Projects manualmente)
# 2. Subir em Knowledge: DIRETRIZ_GEMINI_V28.txt (output do Gemini) — antes de colar SEÇÃO D
# 3. Colar no chat a SEÇÃO D abaixo, com G-1 a G-5 e N-1 a N-5 preenchidos após receber Gemini e NotebookLM
# 4. Aguardar resposta do Embaixador → colar output completo no Claude Code

---

## PROTOCOLO ANTI-DEFICIÊNCIAS DO EMBAIXADOR

**Neste loop o sujeito é Eduardo como fundador — não um cliente externo.**
As deficiências do Embaixador se aplicam com lens ajustado:

**Deficiência 1 — Viés de Afinidade**
O Embaixador pode suavizar alertas sobre padrões operacionais de Eduardo por afinidade com o Diretor.
Contra-ataque: ao emitir ALERTA sobre comportamento do fundador, citar evidência da MEMORIA_EMBAIXADOR — não intuição.

**Deficiência 2 — Excesso de Otimismo de Engajamento**
O Embaixador pode interpretar entusiasmo do Diretor com automação como disposição real de largar controle.
Contra-ataque: entusiasmo declarado ≠ comportamento operacional. Citar o que Eduardo FEZ, não o que disse que faria.

**Deficiência 3 — Generalização de Perfil**
Não aplicar padrões de outros fundadores a Eduardo sem evidência explícita da MEMORIA_EMBAIXADOR.

**Deficiência 4 — Omissão de Flags Desconfortáveis**
O Embaixador deve responder diretamente: "Qual é o sinal mais preocupante sobre a disposição real de Eduardo de operar como deliberador puro?"

**Deficiência 7 — Temperatura Simples**
Neste loop: temperatura = prontidão operacional do fundador para delegar, não temperatura de cliente.
```
TEMPERATURA_PONDERADA (Eduardo como fundador):
  Disposição de delegar: [BAIXA / MODERADA / ALTA / TOTAL]
  Tendência (vs. loop anterior): [↑ subindo / → estável / ↓ caindo]
  Contexto de resistência: [pontos específicos onde Eduardo ancora controle]
  Score composto: [0-10]
  Alerta se score < 6: [RISCO DE V28 SER SUBUTILIZADO]
```

---

## CABEÇALHO DA ATIVAÇÃO

```
ATIVAÇÃO DO EMBAIXADOR — VANGUARD IAH (loop interno)
Data: 2026-06-06
Loop atual: VanguardV28 | Fase: REAÇÃO AO PENTALATERAL
Última ativação: [DATA DA ÚLTIMA SESSÃO COM EMBAIXADOR]

--- ELO DO CICLO ATUAL ---
DIRETRIZ em processo: DIRETRIZ_GEMINI_V28.txt
Skill a ser gerada pelo Auditor: vanguard-v28.md
Gate atual: Decisão de arquitetura de daemon — nenhum candidato pré-aprovado
```

---

## CONTEXTO DO PROJETO

**Sistema:** Vanguard IAH — o próprio Pentalateral
**Loop:** VanguardV28 — Pentalateral Autônomo
**Objetivo do loop:** Eduardo passa de operador para deliberador puro

**Estado operacional atual:**
- 7 workflows n8n ativos no EasyPanel (W-1 a W-7) — cloud 24/7
- session_start/close com 9 gates automatizados
- sync_guard com 5 pares de documentos monitorados (VERDE)
- 5 pontos de intervenção manual ainda existentes (Eduardo ainda opera)

**Prontidão operacional do fundador (avaliação do Músculo):**
Eduardo demonstra alta disposição declarada para delegar. Comportamento operacional real: ainda aciona manualmente a maioria dos loops. V28 testa se essa disposição se converte em comportamento.

**SCOPE-WATCH abertos (riscos de escopo que Eduardo pode expandir):**
- [SCOPE-WATCH-V28-01] Eduardo pode querer o daemon tomando decisões, não só montando briefing — isso inverte a natureza do Pentalateral
- [SCOPE-WATCH-V28-02] "Investigar daemon" pode virar "build de daemon" sem decisão formal de arquitetura

**CHURN-WATCH (risco de o V28 não ser adotado):**
- [CHURN-WATCH-V28-01] Eduardo aprova V28 mas continua operando manualmente por hábito — o sistema existe mas não é usado
- [CHURN-WATCH-V28-02] Daemon gera alertas demais → Eduardo começa a ignorar → sistema perde credibilidade

---

## SEÇÃO D — REAÇÃO AO PENTALATERAL (P-031)

> Colar esta seção no chat do Embaixador após preencher G-1 a G-5 e N-1 a N-5.

```
Embaixador, reação ao ciclo VanguardV28 do Pentalateral IAH.

Neste loop o sujeito é a Vanguard IAH como empresa — não um cliente externo.
Sua lente: Eduardo como fundador. O que seu padrão comportamental real diz sobre
a viabilidade do que o Conselho está propondo?

CONTEXTO DO CICLO:
- DIRETRIZ em execução: DIRETRIZ_GEMINI_V28.txt (subida em Knowledge)
- Skill que o Músculo vai executar: /vanguard-v28
- Prioridade principal da Skill: arquitetura de daemon 24/7 + signal classifier
- O que está fora do escopo: daemon que toma decisões sem gate do Diretor

[M-1 a M-5] — IDEIAS DO MÚSCULO:

[M-1] Signal Classifier: Taxonomia antes do Daemon
Definir formalmente os 3 tipos de sinal antes de qualquer build:
[AUTO-RESOLVE], [DELIBERAR], [INFORMAR]. Daemon sem classifier = ruído ou silêncio.

[M-2] Loop Trigger Autônomo via n8n + Claude API
ChurnWatch + dias sem loop → n8n chama Claude API Haiku → pre-drafta esqueleto
do PASSO3. Eduardo valida rascunho, não monta do zero.

[M-3] FONTES_DE_VERDADE 2.0: de Documentos para Estados
Extensão do sync_guard atual para monitorar ESTADOS (loop_fase_atual,
ultimo_contato, gates vencidos) — não apenas hashes de arquivos.

[M-4] NotebookLM 1-Tap via Telegram
n8n detecta mudança em NOTEBOOKLM_FONTES/ → envia Telegram com checklist de
Wipe & Sync em 3 passos. Eduardo executa, não lembra de executar.

[M-5] Daemon como Chief of Staff, não como Diretor
Daemon não decide — monta briefing. Se gate pendente + 24h sem sessão → Telegram
com contexto pronto + "tempo estimado: 20 min". Eduardo decide quando, não se.

[G-1 a G-5] — IDEIAS DO ESTRATEGISTA (GEMINI):

[G-1] Falsa Falha Programada [CONTRA-INTUITIVO]
Injeção aleatória e documentada de um erro não-crítico no WIP_BOARD para testar se
o State Guard e o Chief of Staff detectam e formatam o alerta corretamente. Valida
a malha de detecção antes que um erro silencioso real corrompa o banco de inteligência.

[G-2] Deliberação por Timeout Controlado [CONTRA-INTUITIVO]
Sinais classificados como [DELIBERAR-BAIXO-RISCO] assumem resposta "NÃO/MANTER" se
não houver veredito do Diretor em 24h. Evita que inércia administrativa trave
ramificações não-críticas. Log explícito: "Resolução Autônoma por Inatividade".

[G-3] Inversão de Alimentação do Auditor
Em vez do Músculo empurrar dados para o NotebookLM, script extrai hash dos documentos
e n8n verifica integridade. Se defasado, n8n fornece payload exato no Telegram para
copiar/colar. Transforma compilação de fontes em ação mecânica de 1 toque.

[G-4] Trancamento Semântico de Contexto
Chief of Staff Daemon gera assinatura (hash) do PASSO3 no momento do pre-draft. Se
assinatura for alterada fora do fluxo aprovado, o loop é bloqueado. Previne derivas
silenciosas do Diretor ou corrupções na edição antes da submissão ao Gemini.

[G-5] Classificador Dinâmico em Shadow Mode
Antes de autorizar intervenção ativa, o classificador n8n roda em modo sombra
enviando tags previstas para log separado que Eduardo revisa no final do dia.
Calibração de tolerância de ruído sem risco de silenciar ou interromper incorretamente.

[N-1 a N-5] — IDEIAS DO AUDITOR (NOTEBOOKLM):

[N-1] Fallback-as-Code: nó final inativo em cada workflow n8n contém os 3 passos
manuais de fallback. Script varre API n8n e recompila MAINTENANCE_COST.md
automaticamente. Resolve P-110 de forma estrutural — impossível esquecer.

[N-2] Auditoria de Briefing Reverso: W-8 injeta 1 pergunta aleatória do
INTELLIGENCE_LEDGER no briefing diário — combate amnésia humana do Diretor.

[N-3] Shadow Classifier Log: Signal Classifier roda em modo sombra etiquetando
eventos com [SHADOW-RESOLVE] sem bloqueá-los. Eduardo audita a lógica antes de
confiar plenamente na IA para silenciar o Telegram. Alinhado com G-5 do Gemini.

[N-4] Sync Forçado Pós-Veredito: W-7 dispara Cloudflare Tunnel para git pull
imediato na máquina local após veredito no Telegram. Elimina risco de sobrescrever
veredito assíncrono dado no celular.

[N-5] Métrica de Fadiga Cognitiva: Músculo monitora prompts curtos em sequência
("ok", "vai", "faz") — sinaliza Fadiga do Diretor e sugere session_close para
proteger integridade das decisões contra vereditos dados por cansaço.

---

PEDIDO AO EMBAIXADOR — QUATRO PARTES OBRIGATÓRIAS:

PARTE 1 — FILTRO DE REALIDADE (15 IDEIAS — OBRIGATÓRIO)
Reagir individualmente a CADA uma das 15 ideias (M-1 a M-5 + G-1 a G-5 + N-1 a N-5).
Nenhuma omitida. Sequência: M-1 → M-5 → G-1 → G-5 → N-1 → N-5.

Lente deste loop: não "o cliente usaria?" — mas "Eduardo REALMENTE faria isso?
Baseado no comportamento observado, não no que ele diz que vai fazer."

Para cada ideia:
  [M/G/N]-[N]: [NOME DA IDEIA]
  Reação: [CONFIRMA / EXPANDE / ALERTA]
  Evidência comportamental de Eduardo: [o que Eduardo fez/disse — não o que declarou querer]
  Severidade (apenas ALERTA): [ALTO / CRÍTICO]

PARTE 2 — ANÁLISE INOVADORA
- Qual é o maior risco comportamental de Eduardo neste ciclo?
- O que o Músculo e o Gemini não estão vendo sobre como Eduardo realmente opera?
- Há algo no padrão do fundador que torna o V28 mais difícil do que parece?

PARTE 3 — INTELIGÊNCIA DE MERCADO
O que a decisão de autonomizar o Pentalateral revela sobre o posicionamento de
mercado da Vanguard — não sobre Eduardo individualmente:
- Padrão de mercado: outros venture builders autônomos seguem este modelo?
- Diferencial vendável: o Pentalateral Autônomo é argumento de venda para novos clientes?
- Risco de produto: ao automatizar demais, a Vanguard perde o diferencial humano?
- Modelo de escala: com o daemon, quantos projetos simultâneos o sistema suporta?

PARTE 4 — DECISOES.json (schema v1.1)
Decisões formais deste ciclo que exigem veredito do Diretor:

{
  "schema_version": "1.1",
  "cliente": "VANGUARD",
  "loop": 28,
  "projeto_label": "VanguardV28 — Pentalateral Autonomo",
  "data_decisoes": "2026-06-06",
  "hypercare_ativo": false,
  "vereditos": [
    {
      "id": "D1",
      "titulo": "Arquitetura do daemon: n8n+API / processo dedicado / hibrido",
      "urgencia": "ALTA",
      "situacao": "Tres opcoes identificadas — nenhuma pre-aprovada. Decisao define escopo do V28.",
      "artefato_editavel": false,
      "requer_uso_confirmado": false,
      "resumo_para_cliente": false,
      "opcoes": [
        {"valor": "A", "label": "n8n + Claude API (extensao do que ja existe)", "acoes": ["log_apenas"]},
        {"valor": "B", "label": "Processo dedicado no EasyPanel (novo servico)", "acoes": ["log_apenas"]},
        {"valor": "C", "label": "Hibrido: n8n orquestra, processo dedicado pensa", "acoes": ["log_apenas"]}
      ]
    },
    {
      "id": "D2",
      "titulo": "Signal Classifier: pré-requisito ou calibrar em producao?",
      "urgencia": "ALTA",
      "situacao": "M-1 defende que o classifier é pré-requisito. Gemini pode divergir.",
      "artefato_editavel": false,
      "requer_uso_confirmado": false,
      "resumo_para_cliente": false,
      "opcoes": [
        {"valor": "A", "label": "Classifier primeiro, daemon depois (M-1)", "acoes": ["log_apenas"]},
        {"valor": "B", "label": "Build daemon agora, calibrar em producao", "acoes": ["log_apenas"]}
      ]
    },
    {
      "id": "D3",
      "titulo": "Escopo do V28: design + 1 workflow novo ou arquitetura completa?",
      "urgencia": "MEDIA",
      "situacao": "V28 pode ser design+decisao ou build completo. Define quantas sessoes.",
      "artefato_editavel": false,
      "requer_uso_confirmado": false,
      "resumo_para_cliente": false,
      "opcoes": [
        {"valor": "A", "label": "V28 = design + signal classifier + 1 workflow novo", "acoes": ["log_apenas"]},
        {"valor": "B", "label": "V28 = arquitetura completa do daemon (3-4 sessoes)", "acoes": ["log_apenas"]}
      ]
    }
  ]
}
```

---

## FORMATO OBRIGATÓRIO DA RESPOSTA DO EMBAIXADOR

```
BLOCO 1 — TEMPERATURA_PONDERADA (Eduardo como fundador)
  Disposição de delegar: [BAIXA / MODERADA / ALTA / TOTAL]
  Tendência vs. loop anterior: [subindo / estável / caindo]
  Pontos de resistência: [onde Eduardo ancora controle — específico]
  Score 0-10: [N]
  Alerta se score < 6: [RISCO DE V28 SER SUBUTILIZADO]

BLOCO 2 — HIPÓTESES ATIVAS SOBRE O FUNDADOR
  Para cada hipótese: CONFIRMADA / REFUTADA / PENDENTE + evidência de 1 linha

BLOCO 3 — COMPORTAMENTO DO FUNDADOR (3 pontos obrigatórios)
  O que Eduardo fez que era esperado para este perfil de fundador:
  O que Eduardo fez que foi surpresa (divergiu do padrão):
  O que Eduardo NÃO fez que deveria ter feito:

BLOCO 4 — WATCHDOG
  [SCOPE-WATCH] ativos: [listar]
  [CHURN-WATCH] ativos: [listar]
  Próxima intervenção recomendada:

BLOCO 5 — [E-1 a E-5] IDEIAS EXCLUSIVAS DO EMBAIXADOR
  Perspectiva exclusiva — não síntese das ideias dos outros membros.
  Lente: o que o comportamento real de Eduardo como fundador revela
  que nenhum dos outros membros consegue ver.

BLOCO 6 — INTELIGÊNCIA DE MERCADO (VENTURE BUILDER AUTÔNOMO)
  Padrão de mercado: outros builders autônomos fazem isso?
  Diferencial vendável: o Pentalateral Autônomo é pitch para o próximo cliente?
  Risco de produto: automatizar demais pode descaracterizar o modelo?
  Capacidade de escala: com daemon, quantos projetos simultâneos?

BLOCO 7 — PRÓXIMA AÇÃO RECOMENDADA
  [AÇÃO] — [QUEM] — [PRAZO]
  Razão: [por que esta ação agora]
```

---

## VALIDAÇÃO ANTES DE FECHAR A SESSÃO DO EMBAIXADOR

| Item | Critério |
|---|---|
| [E-1 a E-5] foram geradas? | Sim — perspectiva exclusiva do Embaixador |
| Todas as 15 ideias receberam reação individual? | Sim — M+G+N completos |
| SCOPE-WATCH-V28 atualizado? | Sim |
| Temperatura do fundador declarada com evidência? | Sim |
| DECISOES.json gerado (D1, D2, D3)? | Obrigatório ao fechar SEÇÃO D |

---

*Músculo · Pentalateral IAH · 2026-06-06*
*VanguardV28 — Pentalateral Autônomo*
*Preencher G-1 a G-5 e N-1 a N-5 antes de enviar ao Embaixador*
