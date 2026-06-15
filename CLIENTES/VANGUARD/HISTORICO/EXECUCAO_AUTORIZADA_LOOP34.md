# EXECUÇÃO AUTORIZADA — LOOP 34 — formalização do Conselho

> Vereditos do Diretor em 2026-06-15 (madrugada). Roteiro cirúrgico para execução com cabeça fresca (~15min).
> Razão de adiar: quase 5h acordado foi a fonte dos códigos errados de hoje; CLAUDE.md é a constituição mestra — não se edita exausto.

---

## VEREDITOS REGISTRADOS (todos do Diretor, 2026-06-15)

- **V1 — APROVADO ("Sim"):** Conselho **6→8 MEMBROS** (Projetista 7º + Embaixador Digital 8º, em Freeze D1:A) + **Detector de Deriva = INSTRUMENTO COADJUVANTE** (não-membro, read-only, não delibera, não vota). NÃO é 6→9.
- **V2 — APROVADO ("Corrija"):** corrigir os 5 descompassos D1–D5 no SYSTEM_PROMPT_DETECTOR_DERIVA.md + na skill doc-drift-audit.md.
- **V3 — APROVADO:** os 3 system prompts migram de `Doc Vanguard Evolução Diretor/Sócios/` → `PENTALATERAL_UNIVERSAL/CONSELHO/`.
- **V4 — AUTORIZAÇÃO P-098:** "AUTORIZO SOBRESCREVER CLAUDE.md" — criar `.musculo_autorizacao.flag` com "CLAUDE.md" na hora da edição.

---

## ROTEIRO DE EXECUÇÃO (próxima sessão — ordem)

1. **Criar** `PENTALATERAL_UNIVERSAL/CONSELHO/`; **copiar** para lá os 3 system prompts (PROJETISTA, EMBAIXADOR_DIGITAL, DETECTOR_DERIVA) de `Doc Vanguard Evolução Diretor/Sócios/`. Surface ao Diretor antes de remover os originais da pasta exclusiva.
2. **Corrigir no SYSTEM_PROMPT_DETECTOR_DERIVA.md:**
   - **D1** régua → raiz canônica `./INTELLIGENCE_LEDGER.md` (P-171), não `PENTALATERAL_UNIVERSAL/INTELLIGENCE_LEDGER.md`.
   - **D2** destino da nota → reconciliar `_pending/` com o real `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/PENDING_REVIEW.md` (P-124).
   - **D3** path dos system prompts → `PENTALATERAL_UNIVERSAL/CONSELHO/` (já corrige após passo 1).
   - **D4** "78 princípios" → dinâmico ("contar P-XXX ativos no LEDGER"; hoje >172).
   - **D5** relação com a skill: ver passo 3.
3. **Editar doc-drift-audit.md:** unificar 1 Detector com 2 MODOS — (a) temporal/hash/propagação (skill atual) + (b) semântico/princípios (system prompt). Reconcilia D5.
4. **CLAUDE.md (flag P-098):** SISTEMA "5 atores" → **"Conselho de 8 membros + instrumentos"**; adicionar Projetista 7º, Embaixador Digital 8º (Freeze), Detector de Deriva como **instrumento coadjuvante (não-membro)**. ⚠️ NÃO alterar "25 ideias/ciclo" sem deliberar — Detector não delibera; se Projetista/Embaixador Digital deliberam é decisão à parte.
5. **DEPENDENCY_MAP.json:** adicionar os 3 system prompts + a skill + CLAUDE_PROJECT_INSTRUCAO; ordem_conselho coerente com CLAUDE.md.
6. **sync** `sync_vanguard_docs.ps1` + verificar hash.
7. **Auto-auditoria:** rodar o próprio Detector (doc-drift-audit, modo M'X-3) sobre a formalização recém-feita — o ator audita o próprio nascimento.

---

## O QUE FICOU FALTANDO DESTE LOOP (vai para o próximo — desenho já pronto)

A intenção pedia CONSTRUIR as capacidades dos 3 sócios + **atividades agendadas**. Não foi entregue. Mecanismo anti-recorrência desenhado no LEDGER_INBOX (P-174 gate intenção→entrega · P-175 definição de pronto de ator · P-176 sócio propõe atividade agendável · P-177 loop entrega delta, não BAU). O "próximo loop" será curto porque o desenho já existe.
