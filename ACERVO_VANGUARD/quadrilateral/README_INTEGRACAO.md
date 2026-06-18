# PENTALATERAL IAH — Sistema de Autonomia

## O que foi implementado (3 alavancas)

### Alavanca 1 — LEDGER como estado vivo (`api/ledger.py`)
Substitui o `INTELLIGENCE_LEDGER.md` estático por estado JSON persistido.
- 10 princípios da V24 pré-carregados
- Fricções registradas atomicamente
- Hard/Soft Vetos gerenciados via API
- Exporta `INTELLIGENCE_LEDGER.md` atualizado sob demanda

### Alavanca 2 — Auditor automatizado (`api/auditor.py` + `api/main.py`)
Substitui o copy-paste Gemini → NotebookLM → Skill por uma chamada de API.
- POST `/auditor/gerar-skill` recebe DIRETRIZ do Gemini, retorna Skill estruturada
- Usa Claude Sonnet como Auditor com princípios do LEDGER injetados no contexto
- Registra fricções automaticamente se Skill inválida

### Alavanca 3 — CI/CD Hook real (`github_workflows/deploy_guard.yml`)
Ativa o hook que o ALERTA_CONFLITO.md documentou mas nunca colocou em produção.
- Verifica `ledger_state.json` antes de qualquer deploy
- Hard Veto ativo → exit 1, deploy bloqueado
- Fallback para `ALERTA_CONFLITO.md` legado (compatibilidade)

## Instalação

```bash
pip install fastapi uvicorn anthropic python-dotenv httpx

# Copiar para o repositório da Vanguard
cp -r api/ scripts/ tests/ seu-repositorio/
cp github_workflows/deploy_guard.yml seu-repositorio/.github/workflows/
```

## Uso diário

```bash
# Iniciar a API (roda em background)
uvicorn api.main:app --port 8765 &

# Fase 2 automatizada (substitui NotebookLM)
curl -X POST http://localhost:8765/auditor/gerar-skill \
  -H "Content-Type: application/json" \
  -d '{"projeto":"vanguard","cliente":"cliente-x","iteracao":"V25","diretriz_gemini":"..."}'

# Fechar sessão (ritual obrigatório)
python scripts/session_close.py --sessao "V25-cliente-x" --projeto vanguard

# Verificar vetos antes de deploy
python scripts/veto.py listar

# Ativar Hard Veto
python scripts/veto.py ativar --tipo HV-4 --projeto vanguard --motivo "Dívida P0 ativa"

# Resolver com override do Diretor
python scripts/veto.py resolver --tipo HV-4 --projeto vanguard \
  --override "OVERRIDE: aceito risco. Eduardo. 2026-05-15"

# Exportar LEDGER atualizado
curl http://localhost:8765/ledger/exportar > INTELLIGENCE_LEDGER.md
```

## Variáveis de ambiente necessárias

```
ANTHROPIC_API_KEY=sk-ant-...   # para o Auditor (Fase 2)
LEDGER_PATH=ledger_state.json  # opcional, default: ledger_state.json na raiz
```

## Rodar testes

```bash
pytest tests/test_pentalateral.py -v
```
