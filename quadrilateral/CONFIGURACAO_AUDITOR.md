# CONFIGURAÇÃO DO AUDITOR — Pentalateral IAH
**Decisão:** quando usar Claude API vs NotebookLM como Auditor
**Versão:** 1.0 · 2026-05-15
**Origem:** Deliberação V25 — divergência G1 resolvida pelo Diretor Eduardo

---

> **Por que este documento existe:**
> O Pentalateral tem dois Auditores disponíveis: NotebookLM (interface visual, 300 fontes)
> e Claude API via `POST /auditor/gerar-skill` (raciocínio superior, automatizável).
> Não são concorrentes — são ferramentas para contextos diferentes.
> Este documento elimina a ambiguidade sobre qual usar em qual situação.

---

## CRITÉRIOS DE ESCOLHA — TABELA DE DECISÃO

| Critério | NotebookLM | Claude API (`/auditor/gerar-skill`) |
|----------|-----------|--------------------------------------|
| **Volume de fontes** | Até 300 (pagas) | Limitado pelo contexto (~200K tokens) |
| **Tipo de saída** | Citações precisas com referência | Análise estratégica com raciocínio |
| **Velocidade** | Manual (upload + prompt) | Automatizável via API |
| **Grounding** | Estrito — só fala das fontes | Flexível — pode usar conhecimento de treinamento |
| **Integração no loop** | Fora do loop automático | Dentro do loop (chama e recebe Skill) |
| **Custo por chamada** | Incluído no plano pago | ~$0.10–0.30 (Sonnet) por Skill gerada |
| **Raciocínio sobre histórico** | Recupera e cita | Analisa, cruza e conclui |
| **Detecção de contradições** | Fraca (cita trechos) | Forte (raciocina sobre o conjunto) |

---

## QUANDO USAR CADA UM

### Usar NotebookLM quando:

**1. Sessões de referência histórica intensa**
Você quer navegar por 20+ MEMORIAs de versões anteriores e extrair padrões específicos. O NotebookLM indexa tudo e você pode fazer perguntas como "em qual versão o scanner foi movido para backend?".

**2. Auditoria de conformidade com as 7 Leis Soberanas**
Você quer verificar se a DIRETRIZ contradiz alguma lei específica citando o texto exato. O grounding estrito do NotebookLM garante que a citação é real — não inferida.

**3. Discovery de módulos reutilizáveis**
Você quer saber exatamente quais arquivos de projetos anteriores podem ser reaproveitados, com localização exata. O NotebookLM cita `backend/burn_rate_shield.js linha 47` — o Claude API diz "há algo parecido nos projetos anteriores".

**4. Sessões exploratórias sem urgência**
Você tem 20 minutos, quer fazer perguntas abertas sobre o histórico e não precisa de Skill automatizada. Interface visual é mais cômoda.

---

### Usar Claude API (`POST /auditor/gerar-skill`) quando:

**1. Fase 2 automatizada no loop do Pentalateral**
Você recebeu a DIRETRIZ do Gemini e quer a Skill sem troca de ferramenta. Um `curl` ou chamada Python entrega a Skill estruturada e pronta para o Músculo. Zero copy-paste entre abas.

**2. Decisões que exigem raciocínio cruzado**
A DIRETRIZ do Gemini propõe algo que pode contradizer decisões de 3 versões diferentes. O Claude API cruza tudo e conclui — o NotebookLM cita cada versão separadamente sem integrar.

**3. Múltiplos projetos em paralelo**
Com 3+ clientes ativos, manter 3 notebooks separados no NotebookLM é gerenciável, mas chamar `POST /auditor/gerar-skill?projeto=cliente-x` é mais limpo e rastreável.

**4. Integração com CI/CD ou automações**
O `session_open.py` e o `session_close.py` podem chamar a API do Auditor automaticamente. O NotebookLM não tem API pública — requer intervenção manual.

---

## FLUXO RECOMENDADO POR CAMADA DE PROJETO

```
CAMADA 1 — MVP (1–5 dias, primeiro projeto):
  → Pular Auditor completamente
  → Sem histórico = sem valor do Auditor
  → Ir direto: Gemini → Músculo

CAMADA 2 — Produto (2+ iterações de um mesmo cliente):
  → NotebookLM: carregar BRIEFING + DIRETRIZ + MEMORIA V1
  → Objetivo: encontrar módulos reutilizáveis de V1 para V2
  → Claude API: opcional (se preferir automação)

CAMADA 3+ — Plataforma / Ecossistema (histórico rico):
  → Claude API como default (automação do loop)
  → NotebookLM para sessões exploratórias de referência
  → Os dois podem coexistir no mesmo projeto

PROJETOS INTERNOS DA VANGUARD (ex: a própria metodologia):
  → Claude API (este chat) é o Auditor
  → NotebookLM para referência quando necessário
  → INTELLIGENCE_LEDGER.md gerado automaticamente pelo /ledger/exportar
```

---

## COMO CHAMAR O AUDITOR VIA API

```bash
# Exemplo com curl
curl -X POST http://localhost:8765/auditor/gerar-skill \
  -H "Content-Type: application/json" \
  -d '{
    "projeto": "nome-do-projeto",
    "cliente": "Nome do Cliente",
    "iteracao": "V2",
    "diretriz_gemini": "[COLAR AQUI A DIRETRIZ COMPLETA DO GEMINI]",
    "memorias_anteriores": ["[CONTEUDO DA MEMORIA V1]"],
    "stack_tecnica": "FastAPI + Supabase + Next.js",
    "maior_risco": "Integração com Stripe ainda não testada em produção",
    "sessao_id": "V2-cliente-nome"
  }'

# A resposta contém:
# - skill_markdown: pronto para salvar em .claude/skills/[projeto]-v2.md
# - auditoria_coerencia: resumo das contradições encontradas
# - padroes_sucesso / padroes_falha: do histórico
# - alertas_criticos: com severidade
# - cinco_ideias_auditor: perspectiva do sócio
# - principios_aplicados: quais P-XXX foram usados na análise
```

```python
# Exemplo com Python (no session_close.py ou em scripts próprios)
import httpx

resp = httpx.post("http://localhost:8765/auditor/gerar-skill", json={
    "projeto": "cliente-x",
    "cliente": "Valdece",
    "iteracao": "V3",
    "diretriz_gemini": diretriz_texto,
    "memorias_anteriores": [memoria_v1, memoria_v2],
})
skill = resp.json()

# Salvar a Skill gerada
with open(f".claude/skills/cliente-x-v3.md", "w") as f:
    f.write(skill["skill_markdown"])
```

---

## CUSTO ESTIMADO POR PROJETO (Claude API como Auditor)

| Cenário | Chamadas/mês | Custo estimado |
|---------|-------------|----------------|
| 1 projeto, 3 iterações | 3 | ~$0.30–0.90 |
| 3 projetos simultâneos | 9 | ~$0.90–2.70 |
| 5 projetos + 2 iterações cada | 10 | ~$1.00–3.00 |

O custo do Auditor via API é irrelevante no contexto dos projetos. O gargalo é o tempo do Diretor, não o custo de tokens.

---

## VERSÃO E HISTÓRICO

| Versão | Data | O que mudou |
|--------|------|-------------|
| 1.0 | 2026-05-15 | Criação — divergência G1 da V25 resolvida |

---

*CONFIGURACAO_AUDITOR · Pentalateral IAH · V1.0*
*Atualizar quando o NotebookLM lançar API pública ou quando Claude API mudar de modelo*
