---
name: embaixador-encerramento-v1
description: "Invocar ao encerrar qualquer sessao — upload dos arquivos de contexto ao Claude Projects do Embaixador + solicitacao de BLOCO 0. Unico por sessao, independente do cliente ativo. Requer claude-projects-remote-v1 para a camada tecnica."
---

SKILL: embaixador-encerramento-v1.md
Camada: Pentalateral IAH — Gate de Encerramento (Universal) | Loop: toda sessao | Dependencia: claude-projects-remote-v1

[AUDITORIA DE COERENCIA]
O encerramento de sessao e unico — acontece uma vez ao fim de qualquer sessao, independente do cliente ativo. O destino e sempre o projeto principal "Embaixador - Diretor" (ID: 019e4c70-7e31-75d4-a568-cbb1077fb439, conta subdiretor.mnmsgm@gmail.com). Coerencia com P-114: o Embaixador precisa dos documentos atualizados para gerar o BLOCO 0 que o Diretor colara na proxima abertura. Coerencia com P-032: MEMORIA_EMBAIXADOR do cliente ativo deve estar atualizada ANTES do encerramento (gate 6B do session_close.ps1 verifica). Coerencia com P-110: arquivos locais sao a fonte canonica — Claude Projects recebe copias de leitura. NUNCA solicitar BLOCO 0 em HTML ou artefato — leva mais de 5 min e trava o fechamento (decisao do Diretor 2026-06-14). Esta skill define O QUE enviar; a camada tecnica (como enviar) esta em claude-projects-remote-v1.

[CONEXAO HISTORICA]
Primeiro encerramento remoto validado: 2026-06-14, Loop 33 V2 (LEDGER P-114). Arquivos enviados: 5 universais + 2 especificos do cliente ativo VANGUARD (MEMORIA_EMBAIXADOR_VANGUARD + 16_VANGUARD_TIMELINE). Embaixador confirmou recebimento em 1 linha — comportamento correto de ENCERRAMENTO (BLOCO 0 completo so e gerado ao ouvir "abrir sessao"). Licao critica: HTML artefato travou por mais de 5 min sem resposta — texto simples sempre. Refs: INTELLIGENCE_LEDGER.md P-114/P-032, PENDENTES.md gate 6B, session_close.ps1 MEMORIA_EMBAIXADOR_VANGUARD.md.

[PADRAO DE SUCESSO/FALHA]
SUCESSO VALIDADO — Upload 5 arquivos universais + arquivos do cliente ativo em uma unica chamada browser_file_upload. Validado 2026-06-14 (~30s para 7 arquivos).
SUCESSO VALIDADO — BLOCO 0 em texto simples: Embaixador responde em ~60s com semaforo + contexto + acoes do Diretor.
SUCESSO VALIDADO — Excluir todos os arquivos antigos ANTES do upload: Claude Projects nao sobrescreve, empilha. Versoes mistas corrompem o contexto do Embaixador.
FALHA (BLOQUEANTE) — BLOCO 0 em HTML ou artefato: Embaixador fica "Trabalhando..." por mais de 5 min sem resposta visivel. Interromper e re-solicitar em texto simples.
FALHA — Encerrar sem atualizar MEMORIA_EMBAIXADOR: gate 6B do session_close.ps1 bloqueia (P-032 violado). Atualizar a MEMORIA do cliente ativo antes de iniciar o encerramento remoto.
GATE APRENDIDO — Embaixador confirma em 1 linha ao receber mensagem de encerramento: isso e correto. Solicitar BLOCO 0 explicitamente com a frase padrao abaixo.

[PERSPECTIVA DO SOCIO]
Como Socio-Consultor, o encerramento e o momento mais critico para a memoria persistente do sistema. O Embaixador e o unico membro com contexto entre sessoes (P-031) — se os arquivos enviados estiverem desatualizados ou incompletos, o BLOCO 0 da proxima sessao sera baseado em informacao antiga. Recomendacoes: (1) verificar que session_close.ps1 rodou e gerou PAINEL + CONTEXTO com DATA DE HOJE antes de iniciar o upload (gate critico — arquivos com data anterior sao enviados silenciosamente); (2) incluir sempre os arquivos especificos do cliente ativo — consultar embaixador-passo7-[cliente]-v1 para a lista; (3) confirmar upload via snapshot antes de enviar a mensagem. IDEIA DISRUPTIVA: integrar o encerramento remoto diretamente ao session_close.ps1 como ultimo gate automatico — Musculo executa o ciclo completo sem que o Diretor precise lembrar de invocar a skill. PROPONHO adicionar como item [musculo] no PENDENTES.

---

## ARQUIVOS DO ENCERRAMENTO (7 fixos — toda sessao)

1. PROTOCOLOS_ENCERRAMENTO\PAINEL_ATIVIDADES_[YYYY-MM-DD].md       — gerado por session_close
2. PROTOCOLOS_ENCERRAMENTO\CONTEXTO_SESSAO_DIRETOR_[YYYY-MM-DD].md — gerado por session_close
3. CLIENTES\WIP_BOARD.json
4. INTELLIGENCE_LEDGER.md                                           — raiz
5. PENDENTES.md                                                     — raiz
6. CLIENTES\VANGUARD\CLAUDE_PROJECT\16_VANGUARD_TIMELINE.md        — ATENCAO: nao em NOTEBOOKLM_FONTES
7. CLIENTES\VANGUARD\CLAUDE_PROJECT\MEMORIA_EMBAIXADOR_VANGUARD.md

GATE: verificar com Glob os paths 6 e 7 antes de cada upload — path errado causa ENOENT silencioso.

### Projeto destino
URL: https://claude.ai/project/019e4c70-7e31-75d4-a568-cbb1077fb439
Conta: subdiretor.mnmsgm@gmail.com

## TEMPLATE CANONICO DE ENCERRAMENTO

Formato obrigatorio (adaptar data, loop, tema e listas):

ENCERRAMENTO DE SESSAO — [DD-MM-YYYY] ([dia-da-semana]) Loop [N] V[X] — [tema da sessao]
ENTREGAS DESTA SESSAO:
* [entrega 1 — o que foi feito + impacto]
* [entrega 2]
FICOU NO AR:
* [MUSCULO] [pendente] — [contexto]
* [DIRETOR] [pendente] — [contexto + deadline se houver]
PROXIMA SESSAO: [objetivo em 1 frase]

[solicitacao de BLOCO 0 — ver abaixo]

## SOLICITACAO DE BLOCO 0 (texto simples — NUNCA HTML)
Regra: pedir em texto simples sempre — HTML leva mais de 5 min sem resposta (decisao Diretor 2026-06-14).

Frase padrao:
"Leia os arquivos e gere o BLOCO 0 em texto simples (sem HTML, sem artefato):
— BLOCO 0: paragrafo de 3-5 linhas com o que ficou, o que o Musculo ataca primeiro e alertas criticos
— Semaforo de projetos (1 linha cada: VANGUARD / INGRID / VALDECE)
— Contexto da ultima sessao (3 linhas max.)
— Padrao detectado (so se aparecer em 2+ sessoes)
— Inconsistencias abertas
— Maximo 3 acoes do Diretor para esta semana"