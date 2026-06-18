# VAULT SOBERANO — F4: Normalização Markdown (.txt → .md onde é prosa)

> Gerado: 2026-06-17 (quarta-feira) | Insumo: inventário de `.txt` rastreados + mapa de referências de script.
> **STATUS: AGUARDANDO VEREDITO BLOCO A BLOCO (C2).** Nada é convertido/movido sem SIM do Diretor.
> **Tudo via `git mv` (rename, conteúdo idêntico, reversível).** Zero edição de conteúdo nesta fase.

---

## 0. DECISÃO DE ESCOPO — F4 É NARROW (consultor-first, recomendação do Músculo)

"100% Markdown" **não pode ser aplicado a todos os `.txt`**. A varredura provou que muitos `.txt` são
**dados/config/template lidos por scripts** — convertê-los quebra automação. F4 converte **apenas prosa**
em áreas ativas, onde `.md` dá ganho real (render, link `[[ ]]`, futuro Detector de Deriva).

**NUNCA converter (dados/config/ingestão — confirmado por referência de script):**
- `.claude/hooks/protected_paths.txt` (lido pelos guards de firewall) · `requirements.txt`/`LICENSE.txt`
- `scripts/.filter_expressions.txt`, `.gemini_prompt_b64.txt`, `.w10_id.txt`, `rclone_secrets_exclude.txt`, `logs/*`, `msgs/*`
- `PENTALATERAL_UNIVERSAL/TEMPLATES/*` (`briefing_labels`, `passo3_template`, `sintese_conselho`, `gerar_artefato*`) — payloads de gerador
- `PENTALATERAL_UNIVERSAL/NOTEBOOKLM_BASE/07_WIP_BOARD.txt` + `08_ANALISE_SOCIO_ATUAL.txt` — sincronizados + MANIFEST_DOCS + ingestão NotebookLM
- `PENTALATERAL_UNIVERSAL/INTELLIGENCE_HUB/**` (`.gemini_raw_response`, CONTEUDO/, PIPELINE/) — conteúdo/dados gerados

**DIFERIR (arquival/cliente — fora da F4):**
- `CONSELHO/**` e `PENTALATERAL_UNIVERSAL/VANGUARD_HISTORICO/**` (~40 `.txt` de DIRETRIZ/MEMORIA/relatório históricos) — prosa, mas arquival; converter é churn sem ganho funcional. Opt-in futuro se o Detector exigir.
- `CLIENTES/**` — P-059, território exclusivo da F5. `ACERVO_VANGUARD/**` e `_ARQUIVO/**` — já consolidados.

---

## 1. LISTA NUMERADA — VEREDITO SIM/NÃO (responder por bloco)

### BLOCO G — GAP DA F3: 6 prosa soltos na raiz → relocar + `.md` (★ pulados na F3 por acento)
> Estes escaparam do inventário F3 (git escapou o acento → regex falhou no `.txt"`). São prosa de
> contexto/estratégia da Vanguard. Proposta: `git mv` para `CONTEXTO_DIRETOR/` **e** trocar extensão p/ `.md`.
> (sanitizo nomes: removo `# ` inicial e normalizo espaços)
1. `# CONTEXTO COMPLETO PARA O ESTRATEGISTA — VanguardV28.txt` → `CONTEXTO_DIRETOR/CONTEXTO_ESTRATEGISTA_VanguardV28.md`
2. `Análises Usuais do Diretor.txt` → `CONTEXTO_DIRETOR/Analises_Usuais_do_Diretor.md`
3. `Diretor, isso é histórico..txt` → `CONTEXTO_DIRETOR/Diretor_isso_e_historico.md`
4. `Hermes — como funciona na prática.txt` → `CONTEXTO_DIRETOR/Hermes_como_funciona_na_pratica.md`
5. `LOOP  — VANGUARD COMO EMPRESA.txt` → `CONTEXTO_DIRETOR/LOOP_VANGUARD_COMO_EMPRESA.md`
6. `O NOVO LOOPING DA VANGUARD — V27.txt` → `CONTEXTO_DIRETOR/O_NOVO_LOOPING_DA_VANGUARD_V27.md`

### BLOCO H — CONTEXTO_DIRETOR/ existentes: prosa `.txt` → `.md`
7. `FLUXO_PROCESSO_DIRETOR.txt` → `.md`
8. `Frases Diretor.txt` → `Frases_Diretor.md`
9. `Documentos Claude Projects.txt` → `Documentos_Claude_Projects.md`
10. `Neural Sentinel site explicar depois.txt` → `Neural_Sentinel_site_explicar_depois.md`
    - **KEEP `.txt` (recomendo NÃO converter):** `Task Scheduler.txt` e `.claudeignore.txt` — rascunhos curtos, ganho nulo.

### BLOCO I — docs/n8n/ prosa `.txt` → `.md`
11. `docs/n8n/N8N.txt` → `docs/n8n/N8N.md`
12. `docs/n8n/N8N 2.txt` → `docs/n8n/N8N_2.md`
13. `docs/n8n/QUADRO COMPLETO N8N.txt` → `docs/n8n/QUADRO_COMPLETO_N8N.md`

### BLOCO J — DIFERIR formalmente (decisão de você)
14. Converter o cluster histórico `CONSELHO/**` + `VANGUARD_HISTORICO/**` (~40 `.txt`) para `.md`?
    - **Recomendação: NÃO agora.** Arquival; churn de ~40 renames sem ganho funcional. Reabrir só se o Detector de Deriva (F7) precisar deles em markdown. Responda **14-NÃO** para diferir (default) ou **14-SIM** para incluir.

---

## 2. O QUE *NÃO* SE TOCA (firewall desta fase)
- Toda a lista "NUNCA converter" da Seção 0 (dados/config/template/ingestão).
- `CLIENTES/**` (P-059/F5) · `Doc Vanguard Evolução Diretor/` (C5) · `.git/`.
- Conteúdo dos arquivos: F4 é **só extensão/nome**. Reescrita de conteúdo markdown (cabeçalhos, etc.) não entra aqui.

---

## 3. SEQUÊNCIA DE EXECUÇÃO PÓS-VEREDITO
1. `git mv` item a item, só o aprovado, com log origem→destino.
2. Re-rodar `vault_audit.ps1` → confirmar redução de `.txt` de prosa em áreas ativas.
3. Commit `refactor(vault): F4 markdown -- prosa .txt -> .md [veredito ...]` (sem [RESOLVE:] — guarda-chuva #11 fecha na F7).
4. Próximo: F5 (sync + adaptação contextual por cliente — gate P-059, proposta dedicada).

---

**Gate BLOQUEANTE:** nenhuma linha da Seção 1 executa sem o seu SIM. F4 é deliberadamente pequena: a maioria dos `.txt` permanece `.txt` por razão técnica.
