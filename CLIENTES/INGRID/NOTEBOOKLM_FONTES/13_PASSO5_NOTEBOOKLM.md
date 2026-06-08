# PASSO 5 — AUDITOR · INGRID — Loop 9
# Sessão: 2026-06-07 · Consulta Especial: Impacto da Skill /notebooklm + Preparação Loop 9
# COMO USAR: rodar .\scripts\preparar_notebooklm_projeto.ps1 -cliente INGRID
#             arrastar fontes → no chat colar apenas: "Ler 13_PASSO5_NOTEBOOKLM.md e gerar a Skill."

---

## PROTOCOLO ANTI-ALUCINAÇÃO — ATIVAR ANTES DE QUALQUER ANÁLISE

- **Regra do Nutricionista:** dê peso máximo a ingrid-v8.md (Skill mais recente), MEMORIA_EMBAIXADOR_INGRID e DELIBERACAO_LOOP_V8_INGRID. Decisões documentadas nesses arquivos prevalecem.
- **Proibição de Análise Genérica:** cada afirmação sobre Ingrid deve citar evidência das fontes carregadas — comportamento observado, dado de uso, ou decisão de loop específico.
- **Tensão Ativa:** se alguma M-1 a M-5 é irrelevante para Ingrid ou adiciona complexidade desnecessária — diga explicitamente.
- **MANIFESTO_DE_FONTES:** declare quais documentos você tem sobre Ingrid e o que ficou de fora.

---

## CONTEXTO DO PROJETO INGRID

**Cliente:** Ingrid (PROJ-002) · EdTech — Concurso Público Sedes-DF · Cargo 202 (Quadrix)
**Status:** Loop 8 CONCLUÍDO · RETAINER ativo
**Próximo:** Loop 9 — Gate 7.2 RLS + captação 2ª candidata antes de 04-07-2026
**Prova do cliente:** 2026-09-06 (Sedes-DF)
**Último contato:** 2026-06-04 · Temperatura: QUENTE ("gostou muito da ferramenta")
**Banco de questões:** 460 validadas — meta: 1000+
**Pendentes:** D5 (link demo bloqueado até 2ª usuária) · D6 (semente E-4) · Gate 7.2 RLS (julho 2026)
**Meta:** R$97/mês × 500 usuárias = R$194.000 no ciclo Sedes-DF 2026

---

## O QUE MUDOU (2026-06-07)

A skill `/notebooklm` permite automação do Auditor sem upload manual. Para Ingrid:

1. **Preparação de Loop 9 mais rápida:** Músculo alimenta o Auditor automaticamente — sem Eduardo arrastar 17 arquivos.
2. **Passo 9.5 possível:** Skill Evolutiva com dados reais de uso (Supabase: questões mais erradas, heatmap, tempo de sessão) gerada pelo Embaixador via /notebooklm após as 25 ideias.
3. **Ciclo mais curto entre loops:** sem gargalo de disponibilidade do Diretor — Loop 9 começa quando o gate abrir.

---

## IDEIAS DO MÚSCULO — [M-1 a M-5] FILTRADAS PARA INGRID

**[M-1] `/gemini` aplicado a Ingrid**
PASSO3 do Loop 9 preparado e enviado ao Gemini via Chrome automaticamente. Eduardo só valida a DIRETRIZ.

**[M-2] `/whatsapp` para check-in com Ingrid**
ChurnWatch threshold = 3 dias. Mensagem automática via WhatsApp Web quando Ingrid não responde. Zero cópia manual do Eduardo.

**[M-3] Skill Evolutiva Ingrid — Passo 9.5**
Após Loop 9: Embaixador alimenta o Auditor com dados reais do Supabase + comportamento de Ingrid na prova (2026-09-06). Skill do Loop 10 parte de dados de desempenho real — não hipóteses.

**[M-4] Argumento para captação da 2ª candidata**
Demonstrar que o sistema aprende entre loops com dados de Ingrid. Diferencial vs. ferramenta genérica de concurso.

**[M-5] Questão do dia via WhatsApp Web**
1 questão/dia enviada automaticamente via WhatsApp. Se Ingrid responde, SM-2 atualiza. Estudo sem abrir o app — resolve engajamento passivo.

---

## MISSÃO PARA O AUDITOR

**PARTE 1 — AUDITORIA DE COERÊNCIA**
As M-1 a M-5 contradizem alguma decisão de loop anterior de Ingrid? Alguma feature foi descartada por razão ainda válida?

**PARTE 2 — CONEXÃO HISTÓRICA**
Com base nos Loops 1-8 de Ingrid: o que funcionou em engajamento? O que falhou? Como o comportamento dela se relaciona com as ideias acima?

**PARTE 3 — SKILL DO AUDITOR**
Nome: `.claude/skills/ingrid-v9.md`
```
## [AUDITORIA DE COERENCIA]
## [CONEXAO HISTORICA]
## [PADRAO DE SUCESSO/FALHA]
## [PERSPECTIVA DO SOCIO]
```
`[PERSPECTIVA DO SOCIO]` deve incluir: o que Ingrid provavelmente sente ao saber que o sistema envia questões via WhatsApp automaticamente.

**PARTE 4 — [N-1 a N-5] SUAS 5 IDEIAS DISRUPTIVAS**
O que você vê no histórico de Ingrid que o Músculo não está considerando? Especialmente: riscos de automação para usuário não-técnico.

---

## INSTRUÇÃO FINAL AO DIRETOR

- [ ] Salvar PARTES 1+2+4 em: `CLIENTES/INGRID/HISTORICO/AUDITOR_LOOP_V9_INGRID.md`
- [ ] Salvar PARTE 3 em: `.claude/skills/ingrid-v9.md`
- [ ] Rodar: `.\scripts\skill_parser_gate.ps1 -skill ".claude\skills\ingrid-v9.md"`
- [ ] Colar [N-1 a N-5] no PASSO7_EMBAIXADOR.md (Ingrid) antes de ir ao Embaixador
