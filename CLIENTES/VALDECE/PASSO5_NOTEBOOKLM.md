# PASSO 5 — AUDITOR · VALDECE — Loop 8 (Preparação)
# Sessão: 2026-06-07 · Consulta Especial: Impacto da Skill /notebooklm + Hypercare
# COMO USAR: rodar .\scripts\preparar_notebooklm_projeto.ps1 -cliente VALDECE
#             arrastar fontes → no chat colar apenas: "Ler 13_PASSO5_NOTEBOOKLM.md e gerar a Skill."

---

## PROTOCOLO ANTI-ALUCINAÇÃO — ATIVAR ANTES DE QUALQUER ANÁLISE

- **Regra do Nutricionista:** dê peso máximo a valdece-v7.md (Skill Loop 7), MEMORIA_EMBAIXADOR_VALDECE e Sentinel Report de 2026-06-04. Decisões documentadas nesses arquivos prevalecem.
- **Proibição de Análise Genérica:** cada afirmação sobre Valdece deve citar evidência do corpus — comportamento real do cliente, corpus jurídico (61 acórdãos), ou decisão de loop específico.
- **Tensão Ativa:** Valdece está em Hypercare (término: 18-06-2026). Qualquer proposta que adicione complexidade antes do fim do Hypercare é risco de churn — sinalizar obrigatoriamente.
- **MANIFESTO_DE_FONTES:** declare quais documentos você tem sobre Valdece e o que ficou de fora.

---

## CONTEXTO DO PROJETO VALDECE

**Cliente:** Valdece (PROJ-001) · LegalTech — Direito Penal (busca jurisprudência STF/STJ)
**Status:** HYPERCARE — até 18-06-2026 · Loop 7 CONCLUÍDO · V3 em produção
**Deploy:** https://toga-digital-valdece.netlify.app (desde 2026-05-19)
**Último contato:** 2026-06-04 · Sentinel: VERDE · Supabase pause resolvido
**Corpus:** 61 acórdãos, 22 temas, threshold 0.45 — VERDE

**Próximo loop (Loop 8):** gate = uso ativo ≥ 500 docs OU 30 dias pós-entrega (2026-06-18)
**Pipeline V2:** Sovereign Upload + Radar de Divergência + Citação DOCX
**Pricing V2:** R$8.500-12.000 + R$300/mês manutenção

---

## O QUE MUDOU (2026-06-07)

A skill `/notebooklm` permite automação do Auditor sem upload manual. Para Valdece:

1. **Preparação do Loop 8 sem fricção:** quando o Sentinel confirmar uso ativo, Músculo alimenta o Auditor automaticamente com corpus, Sentinel Report e comportamento de uso.
2. **Sovereign Upload integrado ao Auditor (V2):** quando Valdece subir novos acórdãos, o sistema alimenta o Auditor automaticamente — corpus do cliente treina o sistema de busca.
3. **Hypercare monitorado:** o Embaixador pode consultar o notebook de Valdece via /notebooklm para verificar crescimento do corpus — sem depender de resposta do Valdece.

---

## IDEIAS DO MÚSCULO — [M-1 a M-5] FILTRADAS PARA VALDECE

**[M-1] `/gemini` aplicado ao Loop 8 de Valdece**
PASSO3 (DIRETRIZ V8) preparado e enviado ao Gemini via Chrome quando o gate de uso ativo abrir. Eduardo não precisa "lembrar de ir ao Gemini" — o gate dispara automaticamente.

**[M-2] `/whatsapp` para monitoramento de Hypercare**
Se o Sentinel detectar inatividade (corpus não crescendo, usuário sem login em 3 dias), mensagem de check-in enviada via WhatsApp automaticamente. Eduardo não monitora manualmente.

**[M-3] Sovereign Upload integrado ao ciclo do Auditor (Passo 9.5)**
Quando Valdece subir acórdãos via V2, o Auditor recebe automaticamente via /notebooklm. Corpus do cliente = input contínuo do próximo loop. Ciclo que aprende com o uso (P-111).

**[M-4] Case Valdece para segundo cliente LegalTech**
Com automação via /notebooklm + Sovereign Upload, argumento de venda sobe: "o sistema aprende com seus próprios acórdãos". P-108: case real + nova capacidade = teto de preço R$7.500-9.000.

**[M-5] Radar de Divergência com análise histórica do Auditor**
Quando o Radar detectar contradição entre dois acórdãos, o Auditor é acionado via /notebooklm para analisar o padrão histórico STF/STJ. Valdece recebe não só "há divergência" mas "o STJ mudou de posição em X".

---

## MISSÃO PARA O AUDITOR

**PARTE 1 — AUDITORIA DE COERÊNCIA**
As M-1 a M-5 contradizem alguma decisão de loop anterior de Valdece? O Hypercare impõe limitações que inviabilizam alguma dessas ideias agora? Algo foi descartado nos Loops 1-7 que ressurge aqui?

**PARTE 2 — CONEXÃO HISTÓRICA**
Com base nos Loops 1-7 de Valdece: qual foi o padrão de engajamento dele? Como ele reage a novas features durante uso ativo? O que a trajetória do corpus (61 acórdãos, 22 temas) revela sobre adoção?

**PARTE 3 — SKILL DO AUDITOR**
Nome: `.claude/skills/valdece-v8.md`
```
## [AUDITORIA DE COERENCIA]
## [CONEXAO HISTORICA]
## [PADRAO DE SUCESSO/FALHA]
## [PERSPECTIVA DO SOCIO]
```
`[PERSPECTIVA DO SOCIO]` deve incluir: risco de comunicar automações ao Valdece durante Hypercare — pode soar como "ainda está incompleto"?

**PARTE 4 — [N-1 a N-5] SUAS 5 IDEIAS DISRUPTIVAS**
O que você vê no histórico de Valdece que o Músculo não está considerando? Especialmente: como perfil LegalTech-Penal reage a dependência de automação em ferramenta de trabalho crítico?

---

## INSTRUÇÃO FINAL AO DIRETOR

- [ ] Salvar PARTES 1+2+4 em: `CLIENTES/VALDECE/HISTORICO/AUDITOR_LOOP_V8_VALDECE.md`
- [ ] Salvar PARTE 3 em: `.claude/skills/valdece-v8.md`
- [ ] Rodar: `.\scripts\skill_parser_gate.ps1 -skill ".claude\skills\valdece-v8.md"`
- [ ] Colar [N-1 a N-5] no PASSO7_EMBAIXADOR.md (Valdece) antes de ir ao Embaixador
