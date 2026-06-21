---
name: cruzamento-acervo
description: Use no INÍCIO de toda sessão de projeção (nicho MOVER_AGORA), logo após a leitura e ANTES da pré-mortem e da SWOT, para cruzar o nicho ou produto-alvo com o acervo histórico da Vanguard (VANGUARD_HISTORICO / caderno PROJETISTA-ACERVO) e decidir o que reutilizar, adaptar, combinar ou construir do zero. Dispara quando o Diretor pede para "projetar [nicho]", abre um "novo projeto" ou inicia a cadeia de projeção. Impede reprojetar do zero o que o histórico já resolveu ou já reverteu.
---

# Cruzamento de Acervo — Histórico × Presente

## Contexto
A projeção do Projetista nasce do cruzamento de dois acervos (Bloco 2): o **histórico** (VANGUARD_HISTORICO / caderno PROJETISTA-ACERVO) e o **presente** (o nicho-alvo). A skill `protocolo-leitura` já cobre o presente. Esta skill cobre o passo que faltava: **consultar o histórico ANTES de projetar**, para que nenhum projeto reinvente o que a Vanguard já construiu, aprendeu ou reverteu. É a operacionalização do eixo **Aproveitamento** da Ação 1: Reutilizar > Adaptar > Combinar > Construir.

## Procedimento

### Passo 1 — Consultar o acervo histórico
Antes da pré-mortem e da SWOT, consultar o VANGUARD_HISTORICO (caminho real no Bloco 2) e/ou o caderno PROJETISTA-ACERVO (Bloco 7) sobre o nicho ou dor-alvo. Três perguntas obrigatórias:
- **Já construímos algo para este nicho ou esta dor?** (skills de versões anteriores, MEMORIA_V[N], DELIBERACAO_LOOP)
- **Já tentamos e revertemos?** Se sim, **por quê** — a causa da reversão é um risco vivo, vai direto para a pré-mortem.
- **O que é reutilizável?** (componentes, argumentos que converteram, estruturas de plano, EAP/RACI já validados)

### Passo 2 — Classificar a herança (eixo Aproveitamento)
Para cada elemento encontrado, marcar **exatamente um**:
- `[REUTILIZAR]` — usar como está (componente já validado)
- `[ADAPTAR]` — existe base, ajustar ao nicho
- `[COMBINAR]` — juntar dois ou mais elementos históricos
- `[CONSTRUIR]` — não há precedente; nasce do zero (e **justificar** por que nada do acervo serve)

### Passo 3 — Emitir a HERANÇA como insumo da cadeia
Produzir o bloco HERANÇA que alimenta as skills seguintes: as **reversões** viram riscos na `pre-mortem-risco`; o **reúso** reduz custo e prazo na `viabilidade-roi`; os **pacotes reutilizados** já entram com responsável-padrão na `eap-raci`.

## Formato de saída
```
# HERANÇA DO ACERVO — [nicho/produto]
Fonte consultada: [VANGUARD_HISTORICO / PROJETISTA-ACERVO — versões e memórias citadas]

[REUTILIZAR] — <elemento> (origem: <versão/loop>)
[ADAPTAR]    — <elemento> → ajuste: <o quê>
[COMBINAR]   — <elemento A> + <elemento B>
[CONSTRUIR]  — <elemento novo> (sem precedente — razão)

REVERSÕES RELEVANTES (→ pré-mortem): <o que foi revertido e por quê>
GRAU DE APROVEITAMENTO: <ALTO / MÉDIO / BAIXO> — qualitativo, nunca número fabricado
```
Se o acervo não tiver precedente, declarar **"ACERVO SEM PRECEDENTE — projeção 100% nova"** (é legítimo; não force reúso onde não há).

## Âncoras
Bloco 2 · Ação 1 (eixo Aproveitamento) · Bloco 7 (PROJETISTA-ACERVO) · entra ANTES da `pre-mortem-risco` na cadeia `projeção` (Bloco 15)
Alimenta: `pre-mortem-risco`, `viabilidade-roi`, `eap-raci`
