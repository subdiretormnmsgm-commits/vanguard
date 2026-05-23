# Design Spec — Intelligence Compounding Engine (V24)
**Data:** 2026-05-12
**Versão:** 1.0
**Aprovado por:** Diretor Eduardo

---

## Objetivo

Transformar o Pentalateral IAH num organismo que acumula inteligência por sessão — não por versão. Cada decisão, fricção e princípio descoberto vira conhecimento permanente e reutilizável na próxima sessão.

## Problema

As 23 versões aprenderam, mas o aprendizado ficou preso no formato errado: MEMORIAs descrevem *o que foi feito*, não *o princípio que foi descoberto*. O ciclo de aprendizado tem lag de semanas (uma versão inteira). A inteligência não compõe — acumula linearmente.

## Arquitetura — Abordagem Híbrida

**Camada humana:** `INTELLIGENCE_LEDGER.md` — legível, auditável, versionado no git
**Camada programática:** `knowledge_graph.json` — alimenta scripts, GUT, briefing matinal

## Artefatos a Criar

| Artefato | Localização | Responsável por atualizar |
|---|---|---|
| `INTELLIGENCE_LEDGER.md` | raiz do projeto | Músculo — durante e após cada sessão |
| `knowledge_graph.json` | raiz do projeto | Músculo — ao fechar cada sessão |
| Constituição de Processo | `AVISO_ARQUITETO.md` | Músculo — Hard/Soft Vetos |
| Template `CONSELHO_SESSAO` | `PENTALATERAL_UNIVERSAL/TEMPLATES/` | Diretor — antes de sessões complexas |
| Shadow Architect section | `MEMORANDO_PENTALATERAL_UNIVERSAL.md` | Músculo — seção nova no PLANO DE BUILD |

## Eventos Capturados por Sessão

```
[FRICÇÃO]    → ALERTA emitido, P0 criado, escopo mudou, estimativa vs real >50%
[PRINCÍPIO]  → padrão extraído de decisão real — o "porquê" por trás do "o quê"
[SOMBRA]     → análise adversarial de Plano de Build (Shadow Architect)
[DERIVA]     → sessão divergiu de princípio ativo do LEDGER
[INTENÇÃO]   → intenção real detectada vs. intenção declarada pelo Diretor
```

## Constituição de Processo

### Hard Veto (bloqueia execução — override explícito obrigatório)
1. Credencial hardcoded no código
2. Violação LGPD — PII sem consentimento auditável
3. Custo acima de `BURN_RATE_DAILY_LIMIT` sem aprovação do Diretor
4. Dívida P0 ativa sem plano de resolução na sessão atual
5. Breaking change em sistema com cliente ativo sem kill-switch

### Soft Veto (flag + 1 sessão de cooling)
1. Stack nova sem inventário de soluções existentes
2. Feature que contradiz princípio ativo no LEDGER
3. Acumulação de >3 dívidas P1 no mesmo componente

### Protocolo de Override
```
DIRETOR OVERRIDE — [categoria de veto]
Aceito o risco de [X] porque [Y].
Consequência esperada documentada: [Z].
```

## As 5 Sementes

| Semente | Gatilho | Grava no LEDGER |
|---|---|---|
| **Friction Log** | ALERTA emitido, P0, mudança de escopo | `[FRICÇÃO]` + princípio extraído |
| **Skill-Drift** | Início de sessão — lê 3 entradas recentes | `[DERIVA]` se divergir de princípio ativo |
| **Shadow Architect** | Todo PLANO DE BUILD | `[SOMBRA]` — blast radius + hardest fix |
| **Synchronous Council** | `CONSELHO_SESSAO_[date].md` lido antes de deliberar | enriquece `[INTENÇÃO]` |
| **Multimodal Intent** | Toda nova instrução do Diretor | `[INTENÇÃO]` declarada vs. histórica |

## Fluxo de Sessão com o Sistema Ativo

```
INÍCIO DE SESSÃO
  → Músculo lê INTELLIGENCE_LEDGER.md (últimas 3 entradas)
  → Skill-Drift check: sessão alinha com princípios ativos?
  → Se CONSELHO_SESSAO_[date].md existe: ler antes de deliberar

DURANTE SESSÃO
  → Toda instrução do Diretor: Multimodal Intent check
  → Todo Plano de Build: Shadow Architect section obrigatória
  → Toda fricção: gravar no LEDGER imediatamente

FIM DE SESSÃO
  → Extrair princípios das fricções da sessão
  → Atualizar INTELLIGENCE_LEDGER.md
  → Atualizar knowledge_graph.json
  → Skill files afetados recebem referência ao novo princípio
```

## Critério de Sucesso

- Após 5 sessões: pelo menos 5 princípios ativos no LEDGER derivados de fricções reais
- Após 10 sessões: o Músculo referencia princípios do LEDGER antes de deliberar, sem ser solicitado
- Após 20 sessões: o Skill-Drift detecta divergências antes de Eduardo precisar corrigir
