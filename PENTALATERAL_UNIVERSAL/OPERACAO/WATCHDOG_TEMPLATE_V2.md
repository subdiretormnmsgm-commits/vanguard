# WATCHDOG TEMPLATE V2 — RITUAL DE FECHAMENTO DE SESSAO
> Pentalateral IAH · Versao 2.0 · 2026-05-29
> Emitido pelo Embaixador apos Verificacao Sistemica Final (10 VERDE / 2 AMARELO / 0 VERMELHO)
> Substitui WATCHDOG_TEMPLATE.md para o ritual de fechamento. O Watchdog de abertura permanece em TEMPLATES/.

---

## CAMADA 1 — DIRETRIZ (automático · via session_close.ps1)

Executado automaticamente pelo script. Eduardo nao precisa agir.

- session_close.ps1 roda os 9 gates sequenciais
- Gates 1 e 5 sao BLOQUEANTES (exit 1)
- Gate 6.5 gera PASSO3 do proximo loop (apenas quando todos os 4 socios = OK)
- Gate 8 envia e-mail + Telegram
- Gate 9 gera PAINEL_ATIVIDADES por projeto
- Gate 9.5 exibe ALERTAS DE GARGALO + COUNTDOWN DE GATES

---

## CAMADA 2 — MUSCULO (automatico · via scripts)

[ ] Salvar deliberacao em HISTORICO (P-048)
    -> CLIENTES/[CLIENTE]/HISTORICO/DELIBERACAO_LOOP_[N]_[CLIENTE].md

[ ] Verificar artefatos do loop anterior (P-045)
    -> MEMORIA_V[N-1]_[CLIENTE].md + relatorio_evolutivo_V[N-1]_[CLIENTE].md existem?
    -> Se nao: emitir BLOQUEIO antes de qualquer proxima acao

[ ] Atualizar WIP_BOARD.json com estado atual do loop

[ ] Registrar NOVOS pendentes abertos nesta sessao em PENDENTES.md
    -> Nao apenas marcar [x] nas concluidas -- registrar o que ficou aberto
    -> Formato obrigatorio: "- [ITEM (DD-MM-YYYY dia-da-semana)] descricao"

[ ] Marcar [x] em PENDENTES.md para tarefas concluidas (P-048)

[ ] Rodar email_fechamento.ps1 (P-011 / P-017)
    -> Credenciais em alert_config.ps1 -- nunca recriar sem instrucao do Diretor

[ ] Gerar PAINEL_ATIVIDADES via generate_protocolo_encerramento.ps1 (P-066)
    -> Destino fixo: Claude Project "Embaixador -- Diretor"

---

## ALERTAS DE GARGALO — verificar antes de fechar

Exibidos automaticamente via session_close.ps1 Gate 9.5 se condicao for verdadeira.
Funciona para QUALQUER projeto -- usa projetosEmBuild dinamico do WIP_BOARD.

[ ] ChurnWatch_Vanguard registrado no Task Scheduler?
    -> Se nao: "CHURN-WATCH INATIVO -- clientes sem monitoramento autonomo"
    -> Aplica-se: GLOBAL (nao por projeto)

[ ] Para CADA projeto ativo: PASSO3_GEMINI.md tem placeholder [MUSCULO:]?
    -> Se sim: "[PROJETO] PASSO3 com placeholder -- Gemini recebera instrucao vazia (P-090)"
    -> Verificar com: foreach ($proj in $projetosEmBuild) { ... }

[ ] Para CADA projeto ativo: MEMORIA_V[N]_[cliente].md existe no HISTORICO/?
    -> Se nao: "[PROJETO] Artefatos do loop ausentes -- NotebookLM vai misturar versoes (P-045)"

[ ] decisoes_watcher.log tem conteudo (watcher rodando)?
    -> Se nao: "Watcher parado -- Painel nao abre automaticamente"
    -> Aplica-se: GLOBAL

[ ] Para CADA projeto ativo: SOBERANA_EMBAIXADOR.flag ativo?
    -> Se sim: "[PROJETO] P-067 suprimida -- confirmar se Embaixador reagiu"

Silencio quando todos OK -- sem ruido desnecessario.

---

## COUNTDOWN DE GATES POR CLIENTE — exibido no fechamento

Gerado automaticamente a partir do WIP_BOARD.json -- funciona para QUALQUER projeto.
Exibir apenas gates a <= 7 dias. Gates distantes: silencio.
Projetos sem gates_programados: ignorar sem erro.

Exemplo de output (projetos como ilustracao -- nao hardcoded):

  GATES EM ALERTA -- [PROJETO]
    Dia 18 - Streak com risco real funcional         +3d (01-06-2026 segunda-feira)
    Dia 21 - Termometro de aprovacao ativo           +6d (04-06-2026 quinta-feira)

  GATES EM ALERTA -- [OUTRO PROJETO]
    Sentinel Report - Resumo mensal entregue         +4d (02-06-2026 terca-feira)

Implementado em session_close.ps1 -- Gate 9.5 (apos PAINEL, antes do POS-GATE).
Projeto novo entra automaticamente -- basta criar gates_programados no WIP_BOARD.

---

## VERIFICACOES CONDICIONAIS — frequencia de verificacao (P-032/2026-05-29)

Executar conforme o gatilho -- nao a cada sessao:

  SE esta sessao teve BUILD significativo (novo feature ou deploy):
  -> TESTE_PROCESSO_COMPLETO.md -- Bloco A (5 min)
     Local: PENTALATERAL_UNIVERSAL/OPERACAO/TESTE_PROCESSO_COMPLETO.md
     Gates: PASSO3 placeholder, versao de artefatos, timing P-089

  SE session_close exibiu "CHECK-UP SISTEMICO RECOMENDADO" (a cada 3 loops):
  -> COMANDO_VERIFICACAO_SISTEMICA_FINAL.md completo (20 min)
     Local: PENTALATERAL_UNIVERSAL/OPERACAO/COMANDO_VERIFICACAO_SISTEMICA_FINAL.md
     Apos concluir: rodar reset_checkup.ps1

  SE session_start detectou projeto em PRE-QUALIFICACAO:
  -> TESTE_PROCESSO_COMPLETO.md completo (40 min)
     Confirmar VERDE antes do primeiro loop do novo projeto

---

## ACOES HUMANAS INSUBSTITUIVEIS — limites reais do sistema

Estas 5 acoes nao podem ser automatizadas por limitacao de API.
Sao o unico trabalho manual obrigatorio do Diretor por loop.

| Acao | Por que nao automatiza | Tempo |
|---|---|---|
| Arrastar 4 arquivos ao Gemini | Gemini nao tem API de upload | 30s |
| Salvar Skill em NOTEBOOKLM_DROP | NotebookLM nao tem API | 30s |
| Clicar nas opcoes do Painel HTML | Deliberacao e humana por design | 2-5 min |
| Upload do PAINEL ao Embaixador | Claude Projects sem API de upload | 30s |
| Upload MEMORIA + LEDGER ao Claude Projects | Claude Projects sem API de upload | 1 min |

Gate 9B (session_close) lista quais arquivos fazer upload e em qual prioridade.
CRITICO = obrigatorio antes de ir ao Embaixador. ALTO = mesma sessao. MEDIO = pode aguardar.

Total de trabalho manual insubstituivel por loop: ~5-7 minutos.
Todo o resto detecta, alerta, bloqueia ou executa automaticamente.

---

## VERIFICACAO DE INTEGRIDADE — antes de fechar

  LEMBRETE DE LOOP aparece antes da AGENDA DO DIA?  SIM / NAO (registrar)
  MEMORIA_EMBAIXADOR.md atualizada?                  SIM / NAO (registrar)
  LOG_CLIENTE subido no NotebookLM?                  SIM / NAO (registrar)
  DELIBERACAO_LOOP_[N].md salva no HISTORICO?        SIM / NAO (registrar)
  Novos pendentes registrados em PENDENTES.md?       SIM / NAO (registrar)
  email_fechamento.ps1 rodou?                        SIM / NAO (registrar)
  PAINEL_ATIVIDADES enviado ao Embaixador -- Diretor? SIM / NAO (registrar)
  Alertas de gargalo verificados?                    SIM / NAO (registrar)
  Countdown de gates exibido?                        SIM / NAO (registrar)
  Claude Projects sincronizado (MEMORIA + LEDGER)?   SIM / NAO (Gate 9B lista automaticamente)

Dez SIM = sessao fechada com integridade.
Qualquer NAO = pendencia aberta -> registrar em PENDENTES.md antes de fechar.

---

## REGRA DE OURO

Se o Musculo nao rodou os scripts -> declarar quais etapas ficaram abertas.
Loop sem MEMORIA + relatorio no HISTORICO = loop fantasma (P-045). Proximo loop bloqueado.

---

## PRINCIPIO ARQUITETURAL CENTRAL

Toda automatacao e UNIVERSAL -- nao apenas INGRID e VALDECE.
Usar Get-ProjetosAtivos ou $projetosEmBuild dinamico em vez de lista hardcoded.
Tratar ausencia de campos no WIP_BOARD graciosamente -- if (-not $campo) { continue }.
Projeto novo entra automaticamente ao ser adicionado ao WIP_BOARD -- zero configuracao extra.
