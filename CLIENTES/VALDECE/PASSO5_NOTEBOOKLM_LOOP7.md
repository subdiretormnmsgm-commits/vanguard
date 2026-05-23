# PASSO 5 — AUDITOR (NOTEBOOKLM) · PROJETO VALDECE · LOOP 7
> Pentalateral IAH — Camada Permanente: não editar blocos de protocolo.
> Criado pelo Músculo em 2026-05-23 (Loop 7 / Reingest concluído / Badges + Edge Function + Migração)

---

## ANTES DE IR AO NOTEBOOKLM — checklist obrigatório

```
[ ] 1. DIRETRIZ_GEMINI V7 recebida e salva como CLIENTES\VALDECE\NOTEBOOKLM_FONTES\12_DIRETRIZ_GEMINI_V7.txt
[ ] 2. Rodar: .\scripts\preparar_notebooklm_projeto.ps1 -cliente VALDECE
[ ] 3. Explorer abre automaticamente — Ctrl+A → arrastar TUDO ao NotebookLM
[ ] 4. Fazer Wipe & Sync das fontes (apagar antigas antes de subir as novas)
[ ] 5. Colar o COMANDO CURTO no chat
```

> Sem o Wipe & Sync, o Auditor mistura contexto do Loop 6 com o Loop 7.

---

## COMANDO CURTO — colar no chat do NotebookLM

```
Auditor, você opera no Pentalateral IAH — 5 membros ativos: Diretor, Músculo, Estrategista, Auditor e Embaixador. O Embaixador (Claude Projects) acompanha o cliente Valdece em tempo real — suas hipóteses estão em 14_MEMORIA_EMBAIXADOR.md, use como filtro de realidade antes de validar qualquer sugestão. Leia o arquivo 13_PASSO5_NOTEBOOKLM.md das fontes carregadas detalhadamente e execute todas as instruções contidas nele. Leia também a DIRETRIZ do Estrategista no arquivo 12_DIRETRIZ_GEMINI_V7.txt e incorpore as solicitações do bloco [PARA O NOTEBOOKLM] ao gerar a Skill. Missão principal: gerar a Skill valdece-v7.md — o Músculo não inicia o Loop 7 sem ela.
```

---

## PROTOCOLO ANTI-ALUCINAÇÃO

| Deficiência | Gatilho de Alerta |
|---|---|
| Amnésia de Contexto | Tratar o projeto como Dia 1 sem MEMORIA |
| Alucinação Estrutural (P-007) | Skill com blocos genéricos sem dados reais do Toga Digital |
| Síndrome do Yes-Man | Validar a DIRETRIZ sem questionar HV-1 ou risco de downtime na migração |
| Lost-in-the-Middle | Ignorar que HV-1 esgotou quota 2x — Edge Function não é opcional |

---

## COMPENSAÇÃO DAS DEFICIÊNCIAS DO MÚSCULO

1. **Amnésia de Sessão** → listar P-038, P-041, P-042, P-043, P-046 e HV-1 na Skill
2. **Momentum de Execução** → gates verificáveis por dia — output real, não declarado
3. **Otimismo de Estimativa** → migração Supabase + Edge Function têm risco de downtime — decompose
4. **Escopo Silencioso** → listar o que NÃO construir no V3 (sem Sovereign Upload ainda)
5. **Drift de Formato** → exigir 7 pontos de deliberação; sem formato = deliberação rejeitada

---

## CONTEXTO DO PROJETO

**Cliente:** Valdece (advogado criminalista — Toga Digital)
**Nicho:** Legal Tech · Direito Penal
**Stack:** Supabase pgvector + Gemini embeddings + Netlify · ingest.py
**Loop:** #7 — Badges Vinculantes + Edge Function (HV-1) + Migração conta Valdece

**Gates aprovados até Loop 6:**
- P-038: 12/12 queries verdes · sim 0.67-0.818 · latência 2.1-3.4s
- Deploy Netlify: https://toga-digital-valdece.netlify.app LIVE
- Contrato: ASSINADO R$5k · 2026-05-19

**Estado atualizado (2026-05-23):**
- Reingest **CONCLUÍDO** — 61/61 acórdãos com data_dje, repercussao_geral, recurso_repetitivo, turma
- sql/v3_migration.sql aplicado no Supabase Vanguard
- Bloqueantes restantes: badges no frontend + Edge Function (HV-1) + migração conta Valdece

**Restrições ativas (VETO absoluto):**
- P-038: gate 12/12 queries antes de qualquer migração para conta Valdece
- HV-1: chave Gemini FORA do frontend — Edge Function obrigatória no V3
- P-043: DFD obrigatório antes de proposta para novo nicho (Contabilidade)

**Missão do Auditor neste loop:**
> "Auditor, você recebeu a DIRETRIZ V7 para o Loop 7 do Projeto Valdece.
> O Músculo vai deliberar e construir os badges VINCULANTE/REPETITIVO,
> a Edge Function para embeddings e a migração da infraestrutura para a conta do Valdece.
> Sua missão: auditar cruzando com o histórico real.
> Identifique: (1) risco de downtime na migração Supabase, (2) se HV-1 está definitivamente resolvido,
> (3) o que o Estrategista pode estar subestimando no escopo da Edge Function.
> Verifique: reingest foi validado com dados reais? Badges dependem de campos que existem agora."

---

## MISSÃO CRÍTICA — GERAR A SKILL valdece-v7.md

**Nome exato: `valdece-v7.md`**

Skill sem os 4 blocos com dados reais = Skill rejeitada pelo `skill_parser_gate.ps1`.

---

## FORMATO OBRIGATÓRIO DA SKILL (4 partes)

```
PARTE 1 — AUDITORIA DE COERÊNCIA
  A DIRETRIZ contradiz algo já construído nos Loops 1-6?
  Verificar especificamente:
    - HV-1: chave Gemini ainda está no frontend?
    - P-038: gate 12/12 está aprovado para migração?
    - Reingest: 61/61 campos preenchidos (validar no PASSO3 atualizado)?
    - Contrato: o que está e o que não está no escopo de R$5k?

PARTE 2 — PERSPECTIVA DO SÓCIO CONSULTOR
  O que funciona (citar loop + resultado).
  O que falha (citar loop + razão documentada).
  Risco central: downtime durante migração Supabase.
  O que Gemini e Músculo não estão vendo.

PARTE 3 — A SKILL (copiável para .claude/skills/valdece-v7.md)
  Incluir obrigatoriamente:
    - Contexto: Toga Digital, 61 acórdãos, 22 temas, stack Supabase+Gemini
    - Decisões fixadas: P-038, HV-1, P-041, P-043, P-046
    - Sequência de build Dia 6 com gates verificáveis
    - O que NÃO construir neste loop
    - Alertas: HV-1, downtime risk, gate migração

PARTE 4 — 5 IDEIAS DISRUPTIVAS DO AUDITOR
  Baseadas em histórico documental dos Loops 1-6.
  Não repetir ideias do Gemini ou do Músculo.
```

---

## COMO CARREGAR AS FONTES

```powershell
.\scripts\preparar_notebooklm_projeto.ps1 -cliente VALDECE
```

Ctrl+A → arrastar TUDO → Wipe & Sync → colar COMANDO CURTO.

## AO RECEBER A SKILL

```
☐ Copiar PARTES 1 + 2 + 4 → salvar em CLIENTES\VALDECE\HISTORICO\AUDITOR_LOOP_7_VALDECE.md
☐ Copiar PARTE 3 → salvar em .claude\skills\valdece-v7.md
☐ Rodar: .\scripts\skill_parser_gate.ps1 -skill ".claude\skills\valdece-v7.md"
☐ Se APROVADO → trazer Skill + DIRETRIZ + [E-1 a E-5] ao Músculo
```
