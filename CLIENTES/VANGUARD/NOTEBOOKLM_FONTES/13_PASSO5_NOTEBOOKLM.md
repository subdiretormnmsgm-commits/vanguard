# PASSO 5 — AUDITOR · VANGUARD UNIVERSAL
# Sessão: 2026-06-07 · Loop 28 · Consulta Especial: Descoberta da Skill /notebooklm
# COMO USAR: rodar .\scripts\preparar_notebooklm_projeto.ps1 -cliente VANGUARD
#             arrastar fontes → no chat colar apenas: "Ler 13_PASSO5_NOTEBOOKLM.md e gerar a Skill."

---

## PROTOCOLO ANTI-ALUCINAÇÃO — ATIVAR ANTES DE QUALQUER ANÁLISE

Auditor, o Pentalateral IAH mapeou 6 deficiências nativas do seu modelo. Auto-aplique:

- **Regra do Nutricionista:** dê peso máximo a SKILL_PROTOCOLO v6.8 e ao LEDGER (P-120 é o mais recente). Se qualquer sugestão contradiz decisão documentada nesses arquivos, a decisão documentada prevalece.
- **Proibição de Análise Genérica:** cada afirmação deve citar: número do princípio, versão do documento, ou padrão observado no histórico. Genérico = inválido.
- **Tensão Ativa:** sua função é auditar, não validar. Se as M-1 a M-5 do Músculo violam algum princípio do LEDGER — diga, com evidência.
- **Filtro de Recência:** P-120 (2026-06-07) é o princípio mais recente sobre automação. Prevalece sobre qualquer outro.
- **MANIFESTO_DE_FONTES:** declare quais documentos você tem e o que ficou de fora antes de analisar.

---

## CONTEXTO DA CONSULTA

**Sistema:** Pentalateral IAH — Vanguard Tech (projeto interno Loop 28)
**Data:** 2026-06-07
**Evento:** Descoberta da skill `/notebooklm` — automação de browser via Claude in Chrome

**O que aconteceu:**
O Embaixador (Claude Projects) descobriu que a extensão Claude in Chrome permite controlar o NotebookLM programaticamente. A skill `.claude/skills/notebooklm.md` encapsula 4 ações: ler/extrair info, adicionar fontes, gerar Studio outputs (Audio Overview, Infográfico, Slides, FAQ), criar notebooks. Isso significa que qualquer sócio do Pentalateral com acesso ao Chrome pode acionar o Auditor sem que o Diretor transporte informação manualmente.

**P-120 inscrito no LEDGER (2026-06-07):**
Embaixador pode acionar o Auditor programaticamente via Claude in Chrome. Fallback manual: abrir notebooklm.google.com (1 passo — P-110 cumprido). Alertas P-072/P-110/P-060/P-074 verificados — todos VERDE.

**Estado atual do ciclo (Loop 28 — Vanguard):**
- Gemini: PENDENTE (próximo elo a acionar)
- NotebookLM: OK (loops anteriores)
- Embaixador: OK
- Músculo: OK

---

## IDEIAS DO MÚSCULO — [M-1 a M-5]

**[M-1] `/gemini` — Fechar o elo mais crítico do loop**
O Músculo prepara o PASSO3 e aciona o Gemini via Claude in Chrome sem o Diretor abrir e colar manualmente. O Diretor só valida a DIRETRIZ antes de continuar. Elimina o gargalo de "janela de 20 minutos do Diretor" que paralisa o loop.
Impacto estimado: loop que hoje leva 2-3 dias (esperando disponibilidade do Diretor) pode fechar em horas.

**[M-2] `/whatsapp` — ChurnWatch autônomo de última milha**
ChurnWatch alerta via Telegram → Embaixador gera mensagem → skill `/whatsapp` envia via WhatsApp Web. Zero ação do Diretor para o check-in de cliente.
Risco: WhatsApp Web muda UI com frequência — fragilidade maior que /notebooklm.

**[M-3] Passo 9.5 — Skill Evolutiva pós-loop**
Com /notebooklm, o Embaixador pode gerar uma segunda Skill APÓS as 25 ideias do loop — capturando o aprendizado do ciclo inteiro. Skill Inicial filtra o Músculo. Skill Evolutiva fecha o loop mais inteligente. Cada loop deixa uma Skill mais rica para o próximo.

**[M-4] Pentalateral Semi-Autônomo como diferencial de venda**
Quando o Diretor puder dizer "o loop roda sem você abrir Gemini ou NotebookLM manualmente" — isso é argumento de venda do modelo IAH. A automação interna vira prova de capacidade para futuros clientes enterprise.

**[M-5] Verificar marketplace Claude in Chrome por outras skills**
O Embaixador encontrou /notebooklm no marketplace. Possivelmente existem: /gemini, /gmail, /google-drive, /youtube. Antes de construir skills custom, verificar o que já existe — instalação é minutos, não horas de build.

---

## MISSÃO PARA O AUDITOR

Com base no histórico completo dos projetos Vanguard, responda:

**PARTE 1 — AUDITORIA DE COERÊNCIA**
As M-1 a M-5 acima contradizem algo já decidido no LEDGER (P-001 a P-120) ou no SKILL_PROTOCOLO v6.8? Há princípios que tornam alguma dessas ideias arriscada ou inviável como proposta?

**PARTE 2 — CONEXÃO HISTÓRICA**
O que o histórico dos projetos Ingrid, Valdece e Vanguard revela sobre automações que funcionaram e automações que falharam? Cite loops e versões específicos.

**PARTE 3 — SKILL DO AUDITOR**
Nome: `.claude/skills/vanguard-v29.md`
Gerar nos 4 blocos obrigatórios:
```
## [AUDITORIA DE COERENCIA]
## [CONEXAO HISTORICA]
## [PADRAO DE SUCESSO/FALHA]
## [PERSPECTIVA DO SOCIO]
```

**PARTE 4 — [N-1 a N-5] SUAS 5 IDEIAS DISRUPTIVAS**
O que o Músculo, o Gemini e o Embaixador não estão vendo sobre automação de browser no Pentalateral? Para cada ideia: o que é, impacto estimado, e uma pergunta direta para o Diretor validar.

---

## INSTRUÇÃO FINAL AO DIRETOR (pós-output do Auditor)

Antes de sair do NotebookLM:
- [ ] Salvar PARTES 1+2+4 em: `CLIENTES/VANGUARD/HISTORICO/AUDITOR_LOOP_V29_VANGUARD.md`
- [ ] Salvar PARTE 3 (Skill) em: `.claude/skills/vanguard-v29.md`
- [ ] Rodar: `.\scripts\skill_parser_gate.ps1 -skill ".claude\skills\vanguard-v29.md"`
- [ ] Colar [N-1 a N-5] no PASSO7_EMBAIXADOR.md antes de ir ao Embaixador
